shinyServer(function(input, output) {

  output$points_plot <- renderPlotly({
    
    points_icetime_scatter <- nhl_stats %>% 
      filter(season == input$season, 
            situation == input$situation) %>% 
            select(name, position, icetime, points) %>% 
            ggplot(aes(x = icetime, y = points, text = name)) + 
      geom_point(aes(color = position))
    
    ggplotly(points_icetime_scatter, tooltip = c('text', 'x', 'y'))
      
  })  
  
  output$traditionalTable <- renderTable({

        nhl_stats %>% 
            filter(season == input$season, 
                   situation == input$situation) %>% 
            select(player_info, traditional_stats) %>% 
        arrange(desc(points)) %>% 
        head(25)

    })

    output$possessionTable <- renderTable({
      
      nhl_stats %>% 
        filter(season == input$season, 
               situation == input$situation) %>% 
        select(player_info, possession) %>% 
        arrange(desc(onIce_corsiPercentage)) %>% 
        head(25)
      
    })
    
    output$goalsTable <- renderTable({
      
      nhl_stats %>% 
        filter(season == input$season,
               situation == input$situation) %>% 
        select(player_info, goals_stats) %>% 
        arrange(desc(xGoals)) %>% 
        head(25)
    })
    
    output$shot_qualityTable <- renderTable({
      
      nhl_stats %>% 
        filter(season == input$season,
               situation == input$situation) %>% 
        select(player_info, shot_quality) %>% 
        arrange(desc(shotAttempts)) %>% 
        head(25)
    })
})
