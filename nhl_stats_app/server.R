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
      labs(title = 'Forward and more ice time, more points!', 
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
      geom_point(color = team_and_color[input$possession_team]) +
      labs(title = 'Corsi Rates Per 60 (5-on-5)',
           x = 'Corsi For Per 60',
           y = 'Corsi Against Per 60') +
      scale_x_continuous(limits = c(40, 75)) +
      scale_y_continuous(limits = c(40, 75)) +
      geom_vline(xintercept = x_int) +
      geom_hline(yintercept = y_int) +
      annotate('text', x = 75, y = 75, label = 'Fun') +
      annotate('text', x = 40, y = 75, label = 'Bad') +
      annotate('text', x = 75, y = 40, label = 'Good') +
      annotate('text', x = 40, y = 40, label = 'Dull')
    
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
      geom_point(color = 'salmon') +
      labs(title = 'Comparing Goals to Expected Goals',
           x = 'xG',
           y = 'Goals')
    
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
    
    output$xGoals_Goals_scatter <- renderPlotly({
      
      x_int1 <- nhl_stats %>% 
        filter(season == input$goals_season,
               situation == '5on5') %>% 
        summarize(mean(xGoals_per60)) %>% 
        unlist()
      
      y_int1 <- nhl_stats %>% 
        filter(season == input$goals_season,
               situation == '5on5') %>% 
        summarize(mean(goals_per_60)) %>% 
        unlist()
      
      GxG60 <- nhl_stats %>% 
        filter(season == input$goals_season,
               team_name == input$xgoals_team,
               situation == '5on5') %>% 
        select(name, team_name, goals_per_60, xGoals_per60) %>% 
        ggplot(aes(x = xGoals_per60, y = goals_per_60,
                   label = name)) + 
        geom_point(color = team_and_color[input$xgoals_team]) +
        labs(title = 'xGoals Per 60 and Goals Per 60',
             x = 'xGoals Per 60',
             y = 'Goals Per 60') +
        scale_x_continuous(limits = c(-0.25, 1.5)) +
        scale_y_continuous(limits = c(-0.25, 4)) +
        geom_vline(xintercept = x_int1) +
        geom_hline(yintercept = y_int1) +
        annotate('text', x = 1.25, y = 4, label = 'Good') +
        annotate('text', x = 0, y = 4, label = 'Finisher/Lucky') +
        annotate('text', x = 0, y = 0, label = 'Bad') +
        annotate('text', x = 1.25, y = 0, label = 'No Finish/Unlucky')
      
      ggplotly(GxG60, tooltip = c('x', 'y', 'name'))
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
        geom_point(color = team_and_color[input$xgoals_team]) +
        scale_x_continuous(limits = c(0, 6)) +
        scale_y_continuous(limits = c(0, 6)) +
        geom_vline(xintercept = x_int) +
        geom_hline(yintercept = y_int) +
        annotate('text', x = 6, y = 6, label = 'Fun') +
        annotate('text', x = 0, y = 6, label = 'Bad') +
        annotate('text', x = 6, y = 0, label = 'Good') +
        annotate('text', x = 0, y = 0, label = 'Dull')
      
      ggplotly(xG60scatter, tooltip = c('x', 'y', 'label', 'text'))
      
    })
    
    output$player1_plot <- renderPlot({
      nhl_stats %>% 
        select(name, goals_for_per60, xGoals_per60, corsi_for_per60, 
               xGoals_against_per60, corsi_against_per60) %>% 
        mutate(
          across(
            c(goals_for_per60, xGoals_per60, corsi_for_per60, 
                 xGoals_against_per60, corsi_against_per60),
          scale)) %>% 
        filter(name == input$player1) %>% 
        ggplot() + 
        geom_col()
    })
})
