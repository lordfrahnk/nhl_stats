shinyServer(function(input, output) {
  
  output$traditionalTable <- renderDT({

        nhl_stats %>% 
            filter(season == input$trad_season, 
                   situation == input$trad_situation) %>% 
            select(player_info, traditional_stats) %>% 
        arrange(desc(points))

    })

  output$points_toi_plot <- renderPlotly({
    
    points_icetime_scatter <- nhl_stats %>% 
      filter(season == input$trad_season, 
             situation == input$trad_situation) %>% 
      select(name, position, icetime, points) %>% 
      ggplot(aes(x = icetime, y = points, text = name)) + 
      geom_point(aes(color = position))
    
    ggplotly(points_icetime_scatter, tooltip = c('text', 'x', 'y'))
    
  })  
  
   output$pp_points_plot <- renderPlot({
  
     top_points <- nhl_stats %>% 
       filter(season == input$trad_season) %>% 
       arrange(desc(points)) %>% 
       head(10) %>% 
       pull(name)
     
     nhl_stats %>%
       filter(season == input$trad_season,
              situation != 'all',
              name %in% top_points) %>%
       select(name, points, situation) %>%
       ggplot(aes(x = name, y = points)) +
       geom_col(aes(fill = situation)) +
       coord_flip()

  })
  
  output$corsi_team_plot <- renderPlotly({
    
    corsi_goals_by_team <- nhl_stats %>%
      filter(situation == '5on5') %>% 
      group_by(team, season) %>% 
      summarise(team_corsi_average = mean(onIce_corsiPercentage),
                team_goals = sum(goals)) %>% 
      ungroup() %>% 
      select(team, season, team_corsi_average, team_goals) %>% 
    ggplot(aes(x = team_corsi_average, y = team_goals, label = team, text = season)) + 
    geom_point()
  
  ggplotly(corsi_goals_by_team, tooltip = c('label', 'text', 'x', 'y'))
      
    
  })  
  
  output$corsiTable <- renderDT({
      
      nhl_stats %>% 
        filter(season == input$corsi_season, 
               situation == '5on5',
               icetime >= input$corsi_icetime) %>% 
        select(player_info, possession, -onIce_fenwickPercentage, -offIce_fenwickPercentage) %>% 
        arrange(desc(onIce_corsiPercentage))
      
    })
  
  output$fenwickTable <- renderDT({
    
    nhl_stats %>% 
      filter(season == input$fenwick_season, 
             situation == '5on5',
             icetime >= input$fenwick_icetime) %>% 
      select(player_info, possession, -onIce_corsiPercentage, -offIce_corsiPercentage) %>% 
      arrange(desc(onIce_fenwickPercentage))
    
  })
    
  output$goals_plot <- renderPlotly({
    
    xG_goals_by_team <- nhl_stats %>% 
      filter(season == input$season, 
             situation == input$situation) %>% 
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
        filter(season == input$season,
               situation == input$situation) %>% 
        select(player_info, goals_stats) %>% 
        arrange(desc(xGoals))
    })
    
    output$shot_qualityTable <- renderDT({
      
      nhl_stats %>% 
        filter(season == input$season,
               situation == input$situation) %>% 
        select(player_info, shot_quality) %>% 
        arrange(desc(shotAttempts))
    })
})
