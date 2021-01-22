shinyServer(function(input, output) {
  
  output$traditionalTable <- renderDT({

        nhl_stats %>% 
            filter(season == input$trad_season, 
                   situation == input$trad_situation) %>% 
            select(name, position, team, goals, primary_assists, secondary_assists, points) %>% 
        arrange(desc(points))
  })

  output$points_toi_plot <- renderPlotly({
    
    points_icetime_scatter <- nhl_stats %>% 
      filter(season == input$trad_season, 
             situation == input$trad_situation) %>% 
      select(name, position, icetime, points) %>% 
      mutate(position = case_when(
        position == 'C' ~ 'Center',
      position == 'R' ~ 'Right Wing',
      position == 'L' ~ 'Left Wing',
      position == 'D' ~ 'Defenseman'
      )) %>% 
      ggplot(aes(x = icetime, y = points, text = name)) + 
      geom_point(aes(color = position)) +
      labs(title = 'More ice time, more points!', 
           x = 'Ice Time (Minutes)',
           y = 'Points')
    
    ggplotly(points_icetime_scatter, tooltip = c('text', 'x', 'y'))
  })  
  
   output$points_situation_plot <- renderPlotly({
  
     top_points <- nhl_stats %>% 
       filter(season == input$trad_season) %>% 
       arrange(desc(points)) %>% 
       head(10) %>% 
       pull(name)
     
     points_sit_plot <- nhl_stats %>%
       filter(season == input$trad_season,
              situation != 'all',
              name %in% top_points) %>%
       select(name, points, situation) %>%
       ggplot(aes(x = factor(name, levels = rev(top_points)), y = points)) +
       geom_col(aes(fill = factor(situation, levels = c('4on5', 'other', '5on4','5on5')))) +
       scale_fill_brewer(palette = 'Blues') +
       labs(title = 'Powerplay inflates point totals',
            x = NULL,
            y = 'Points',
            fill = 'Situation') +
       coord_flip()
     
     ggplotly(points_sit_plot, tooltip = c('points'))
  })
  
  
  output$corsiTable <- renderDT({
      
      nhl_stats %>% 
        filter(season == input$corsi_season, 
               situation == '5on5',
               icetime >= input$corsi_icetime) %>% 
        select(name, position, team, corsi_for, corsi_against, corsi_percentage) %>% 
        arrange(desc(corsi_percentage))
  })
  
  output$corsi_per60_scatter <- renderPlotly({
  
    x_int <- nhl_stats %>% 
      filter(season == input$corsi_season,
             situation == '5on5') %>% 
      summarize(mean(corsi_for_per60)) %>% 
      unlist()
    
    y_int <- nhl_stats %>% 
      filter(season == input$corsi_season,
             situation == '5on5') %>% 
      summarize(mean(corsi_against_per60)) %>% 
      unlist()
    
    cp60 <- nhl_stats %>% 
      filter(season == input$corsi_season, 
             situation == '5on5',
             icetime >= input$corsi_icetime,
             team_name == input$possession_team) %>%
      select(name, team, corsi_for_per60, corsi_against_per60) %>% 
      ggplot(aes(x = corsi_for_per60, y = corsi_against_per60,
                 label = name, 
                 text = team)) +
      geom_point() +
      geom_vline(xintercept = x_int) +
      geom_hline(yintercept = y_int)
    
    ggplotly(cp60, tooltip = c('x', 'y', 'label', 'text'))
  })
  
  output$corsi_team_plot <- renderPlotly({
    
    corsi_goaldiff_by_team <- team_stats %>%
      filter(situation == 'all',
             season != '2019') %>% 
      select(team, season, corsiPercentage, goalDiff) %>% 
      ggplot(aes(x = corsiPercentage, y = goalDiff, 
                 label = team, 
                 text = season)) +
      geom_point() 
    
    ggplotly(corsi_goaldiff_by_team, tooltip = c('label', 'text', 'x', 'y'))
  })  
    
  output$goals_plot <- renderPlotly({
    
    xG_goals_by_team <- nhl_stats %>% 
      filter(season == input$goals_season, 
             situation == '5on5') %>% 
      group_by(team) %>% 
      summarise(team_xG = sum(xGoals),
                team_goals = sum(goals)) %>% 
      ungroup() %>% 
      select(team, team_xG, team_goals) %>% 
      ggplot(aes(x = team_xG, y = team_goals, text = team)) + 
      geom_point()
    
    #look for y = x line
    
    ggplotly(xG_goals_by_team, tooltip = c('text', 'x', 'y'))
  })
  
    output$goalsTable <- renderDT({
      
      nhl_stats %>% 
        filter(season == input$goals_season,
               situation == '5on5') %>% 
        select(name, position, team, goals, xGoals, goals_above_expected, 
               xGoals_for, xGoals_against, xGoals_for_per60, 
               xGoals_against_per60) %>% 
        arrange(desc(xGoals))
    })
    
    output$xGoals_per60_scatter <- renderPlotly({
      
      x_int <- nhl_stats %>% 
        filter(season == input$goals_season,
               situation == '5on5') %>% 
        summarize(mean(xGoals_for_per60)) %>% 
        unlist()
      
      y_int <- nhl_stats %>% 
        filter(season == input$goals_season,
               situation == '5on5') %>% 
        summarize(mean(xGoals_against_per60)) %>% 
        unlist()
      
      xG60scatter <- nhl_stats %>% 
        filter(season == input$goals_season,
               team_name == input$xgoals_team,
               situation == '5on5') %>%
        select(name, team_name, xGoals_for_per60, xGoals_against_per60, team_color) %>% 
        ggplot(aes(x = xGoals_for_per60, y = xGoals_against_per60,
                   label = name, 
                   text = team_name)) +
        labs(title = 'Expected Goals Per 60 (5-on-5)',
             x = 'xGoals For Per 60',
             y = 'xGoals Against Per 60') +
        geom_point() +
        geom_vline(xintercept = x_int) +
        geom_hline(yintercept = y_int)
      
      ggplotly(xG60scatter, tooltip = c('x', 'y', 'label', 'text'))
      
    })
})
