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
  
  # output$pp_points_plot <- renderPlot({
  #   
  #   nhl_stats %>% 
  #     filter(season == input$trad_season,
  #            situation != 'all') %>% 
  #     select(name, points, situation) %>% 
  #     head(40) %>% #each player has 4 situations so 40 will provide the top 10
  #     ggplot(aes(x = name, y = points)) + 
  #     geom_col(aes(fill = situation)) +
  #     coord_flip()
    
  })  
  
  output$possession_indiv <- renderPlotly({
    
    corsi_goals_indiv <- nhl_stats %>% 
      filter(season == input$season,
             situation == input$situation,
             icetime > 8000) %>% 
      select(name, position, onIce_corsiPercentage, goals) %>% 
      ggplot(aes(x = onIce_corsiPercentage, y = goals, text = name)) +
      geom_point(aes(color = position))
    
    ggplotly(corsi_goals_indiv, tooltip = c('text', 'x', 'y'))
  })
  
  output$possession_plot <- renderPlotly({
    
    corsi_goals_by_team <- nhl_stats %>% 
      filter(season == input$season, 
             situation == input$situation) %>% 
      group_by(team) %>% 
      summarise(team_corsi_average = mean(onIce_corsiPercentage),
                team_goals = sum(goals)) %>% 
      ungroup() %>% 
      select(team, team_corsi_average, team_goals) %>% 
    ggplot(aes(x = team_corsi_average, y = team_goals, text = team)) + 
    geom_point()
  
  ggplotly(corsi_goals_by_team, tooltip = c('text', 'x', 'y'))
      
    
  })  
  
  output$possessionTable <- renderDT({
      
      nhl_stats %>% 
        filter(season == input$season, 
               situation == input$situation) %>% 
        select(player_info, possession) %>% 
        arrange(desc(onIce_corsiPercentage))
      
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
