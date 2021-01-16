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
                         h5("For this reason, you'll often see analysts focus on player performance at 5-on-5 rather than highlighting success while on the powerplay. Throughout the rest of this site, you can assume all the data is focused on play at 5-on-5 unless otherwise stated.")
                ),
                tabPanel('Possession - Corsi',
                         h2('Possession'),
                         h5("Puck possession is highly regarded when evaluating a team's performance—but why? Teams that tend to have control of the puck tend control the game. In the context of analytics, possession leads to more shots on goal and ultimately more goals. The NHL does not provide true possession via player and puck tracking, so how let's explore how this is possible"),
                         h3('Corsi'),
                         h5("One of the first widely adopted possession metrics is called Corsi and it utilizes shot attempts as a proxy for possession. In order to calculate this in the context of a single game, you add up all the shot attempts by Team A and divide that by the sum of the shot attempts from both teams. Likewise, you can do this with individual players by adding up all the shots their team took while they were on the ice and dividing that by the sum of all the shots taken by both teams while that player was on the ice."),
                         selectInput('corsi_season',
                                     'Select Season:',
                                     choices = unique(nhl_stats$season),
                                     selected = '2019'),
                         sliderInput('corsi_icetime',
                                     'Ice Time (seconds)',
                                     min = 1000,
                                     max = 90000,
                                     value = 22000),
                         DTOutput("corsiTable"),
                         h5("So what does Corsi really mean? Looking at the table above (assuming you've kept the default selections), you'll find Brendan Gallagher at the top of the leaderboard. A Corsi percentage of 60% says that his team generated 60% of the shot attempts while he was on the ice."),
                         h3("Corsi's shortcomings"),
                         h5("While possession and shot attempts are logical to measure, they don't paint the full picture. We can likely agree that you'd rather be a team that is consistently outshooting it's opponents, but that doesn't matter if your shot attempts miss the net, are blocked, or are low quality chances (such as a slap shot from center ice). For this reason, Corsi isn't the strongest predictor of future goals. This is evident in the visualization below when comparing Corsi Percentage to goals."),
                         plotlyOutput('corsi_team_plot'),
                ),
                tabPanel('Possession - Fenwick',
                         h3('Fenwick'),
                         h5("To improve on Corsi, another possession based statistic was developed called Fenwick. The only difference between the two is that Corsi calculates all shot attempts (including those that are blocked by a defending player or that miss the goal completely), whereas Fenwick only calculates unblocked shots that reach the net. With this adjustment, Fenwick considers shot quality (as in they must reach the goal) but does not quantify the quality of each individual shot."),
                         selectInput('fenwick_season',
                                     'Select Season:',
                                     choices = unique(nhl_stats$season),
                                     selected = '2019'),
                         sliderInput('fenwick_icetime',
                                     'Ice Time (seconds)',
                                     min = 1000,
                                     max = 90000,
                                     value = 22000),
                         DTOutput('fenwickTable'),
                ),
                tabPanel('Expected Goals',
                          plotlyOutput('goals_plot'),
                          DTOutput("goalsTable")),
                tabPanel('Player Comparison',
                          DTOutput("shot_qualityTable"))
            )
        )
    )
))