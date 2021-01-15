shinyUI(fluidPage(

    titlePanel('NHL Stats'),

    sidebarLayout(
        sidebarPanel(
            selectInput('season',
                        'Select a season:',
                        choices = unique(nhl_stats$season),
                        selected = '2019'),
            selectInput('situation',
                        'Select a situation:',
                        choices = unique(nhl_stats$situation),
                        selected = '5on5')
        ),

        mainPanel(
            tabsetPanel(
                tabPanel('Traditional',
                         h2('Traditional Statistics'),
                         h5("In hockey, like most sports, traditional statistics are often the most utilized and referenced by broadcasters and fans. Goals, assists, and points are quantifiable—they're easy to point out and observe."), 
                         selectInput('trad_season',
                                     'Select a season:',
                                     choices = unique(nhl_stats$season),
                                     selected = '2019'),
                         selectInput('trad_situation',
                                     'Select a situation:',
                                     choices = unique(nhl_stats$situation),
                                     selected = 'all'),
                         DTOutput("traditionalTable"),
                         h5("While traditional statistics are easy to understand, they lack context. For example, let's examine the same information from the table above but consider each player's ice time and position."),
                         plotlyOutput('points_toi_plot'),
                         h5("Beyond ice time and position, it's often hard to see the impact of play outside of 5-on-5 hockey. Look at how many points the leading scorers generate while on the powerplay."),
                         plotOutput('pp_points_plot'),
                         ),
                 tabPanel('Possession',
                          plotlyOutput('possession_indiv'),
                          plotlyOutput('possession_plot'),
                          DTOutput("possessionTable")),
                 tabPanel('Goals',
                          plotlyOutput('goals_plot'),
                          DTOutput("goalsTable")),
                 tabPanel('Shot Quality',
                          DTOutput("shot_qualityTable"))
            )
        )
    )
))