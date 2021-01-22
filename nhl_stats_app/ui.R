shinyUI(
    navbarPage(
      'NHL Statistics',
      tabPanel('Intro & Glossary',
               h1('Introduction'),
               p('Welcome to NHL Stats by...'),
               h2('Glossary'),
               br(),
               h4("On-Ice Situations"),
               p(strong("5-on-5"),": the player's team and the opposing team has five skaters on the ice. This is the most common on-ice situation."),
               p(strong("5-on-4"),": the player's team has five skaters and the opposing team has four due to committing a penalty. Commonly referred to as the 'Power Play'."),
               p(strong("4-on-5"),": the player's team has four skaters on the ice due to committing a penalty. The opposing team has five skaters. Commonly referred to as the 'Penalty Kill'."),
               p(strong("Other"),": all other situations such as 5-on-3, 4-on-4, or 6-on-5 due to pulling the goalie."),
               p(strong("All"),": every game situation possible."),
               br(),
               h4("Traditional Statistics"),
               p(strong("Goals"),": the number of goals the player scored."),
               p(strong("Primary Assists"),": the number of direct passes or rebounds created that led to a goal by a teammate."),
               p(strong("Secondary Assists"),": the number of passes or rebounds created that led to a teammate's primary assist on a goal."),
               p(strong("Points"),": the sum of a player's goals, primary assists, and secondary assists."),
               br(),
               h4("Possession"),
               p(strong("Corsi For"),": the number of shot attempts the player's team took while they were on the ice."),
               p(strong("Corsi Against"),": the number of shot attempts the opposing team took while the player was on the ice."),
               p(strong("Corsi Percentage"),": Corsi For divided by the total number of shots taken by both teams while the player was on the ice"),
               p(strong("Fenwick For"),": the number of unblocked shot attempts the player's team took while they were on the ice."),
               p(strong("Fenwick Against"),": the number of unblocked shot attempts the opposing team took while the player was on the ice."),
               p(strong("Fenwick Percentage"),": Fenwick For divided by the total number of unblocked shots taken by both teams while the player was on the ice"),
               br(),
               h4("Expected Goals"),
               p(strong("Expected Goals (xGoals)"),": the probablility of an unblocked shot becoming a goal after considering variables such as distance from the net, the angle of the shot, etc.
                 For more information about the variables included in determining xG: visit ",a("http://moneypuck.com/about.htm#shotModel")),
               p(strong("Goals Above Expected"),": the number of goals a player has scored minus their expected goals."),
               p(strong("xG For"),": the sum of the xG probabilities of each unblocked shot the player's team took while they were on the ice."),
               p(strong("xG Against"),": the sum of the xG probabilities of each unblocked shot the opposing team took while the player was on the ice."),
               br(),
               h4("Per 60 Metrics"),
               p("In order to account for ice time and calculate efficiency, per 60 metrics are often utilized. Corsi Per 60, for example, is the number of shot attempts taken by a player's team while on the ice divided by their ice time and then multiplied by 60. 
                 To say this a different way, the calculation will always be:"),
                 p(em("(stat ÷ ice time) · 60")),
               h3("Ice Time and Position"),
               h5("As previously mentioned, points on their own lack context. For example, let's consider ice time and position by player."),
               plotlyOutput('points_toi_plot'),
               h5("There are two main takeaways from this visualization. 
                            First, ice time and points are positively correlated, so you can expect those who play the most will have the most points.
                            Also, there are distinct groups when looking at this by position. 
                            Does it make sense to determine a defenseman's worth to point production when their primary role is to prevent goals?"),
               h3("Corsi/Fenwick shortcomings"),
               h5("We can likely agree that you'd rather be a team that is consistently outshooting it's opponents, but that doesn't matter if your shot attempts miss the net, are blocked, or are low quality chances (such as a slap shot from center ice). 
                            Possession is more challenging to isolate for individual impact because hockey is a team game.
                            For this reason, Corsi and Fenwick aren't the strongest predictor of individual successes, but it can provide some insight as to a player's general on ice impact. 
                            Shot based metrics are useful, but they will not be as impactful as goal related metrics when examining individual or team success."),
               plotlyOutput('goals_plot')),
      tabPanel('Points',
               h2('Points'),
               h5("In hockey, like most sports, traditional statistics are often the most utilized and referenced by broadcasters and fans. 
                            Goals, assists, and points are quantifiable—they're easy to point out and observe. You can explore the NHL's points leaders over the 
                            last 3 seasons using the drop down boxes below."), 
               splitLayout(cellWidths = c('25%', '25%'), 
                           selectInput('trad_season',
                                       'Select a season:',
                                       choices = unique(nhl_stats$season),
                                       selected = '2019'),
                           selectInput('trad_situation',
                                       'Select a situation:',
                                       choices = unique(nhl_stats$situation),
                                       selected = 'all')),
               br(),
               br(),
               DTOutput("traditionalTable"),
               h3("Points by Situation"),
               h5("All the tables and visualizations above show points accumulated at all situations. 
                            Beyond that, look at how many points the leading scorers generate during different game situations."),
               plotlyOutput('points_situation_plot'),
               h5("Those with high point production often receive a big boost to their numbers from ice time during the power play. 
                         For this reason, you'll often see analysts reference player performance at 5-on-5 rather than highlighting success while their team has a man-advantage. 
                            Throughout the rest of this site, you can assume all the data is focused on play at 5-on-5 unless otherwise stated.")
      ),
      tabPanel('Possession',
               h2('Possession'),
               h5("Puck possession is often referenced when evaluating a team's performance—but why? In theory, teams that tend to have control of the puck tend control the game. 
                            The NHL does not provide true possession via player and puck tracking, so how let's explore how this is possible"),
               h3('Corsi'),
               h5("One of the first widely adopted possession metrics is called Corsi and it utilizes shot attempts as a proxy for possession. 
                            In order to calculate this in the context of a single game, you add up all the shot attempts by Team A and divide that by the 
                            sum of the shot attempts from both teams. Likewise, you can do this with individual players by adding up all the shots their 
                            team took while they were on the ice and dividing that by the sum of all the shots taken by both teams while that player was on the ice."),
               h3('Fenwick'),
               h5("Like Corsi, Fenwick, is another possession based statistic centered around shot attempts. 
                         The key difference is Fenwick only factors in unblocked shots whereas Corsi calculates all shot attempts.
                         Fenwick begins to considers shot quality (as in they must not be blocked by a defending player) but does not quantify the quality of each shot individually.
                            of each individual shot."),
               splitLayout(cellWidths = c('25%', '40%'),
               selectInput('corsi_season',
                           'Select a season:',
                           choices = unique(nhl_stats$season),
                           selected = '2019'),
               sliderInput('corsi_icetime',
                           'Ice Time (Minutes)',
                           min = 100,
                           max = 1500,
                           value = 500)),
               DTOutput("corsiTable"),
               selectInput("possession_team",
                           'Select a team:',
                           choices = unique(nhl_stats$team_name),
                           selected = 'Anaheim Ducks'),
               plotlyOutput('corsi_per60_scatter'),
               plotlyOutput('corsi_team_plot'),
      ),
      tabPanel('Expected Goals',
               h3('Expected Goals'),
               h5("As we learned from the possession statistics, goals are king when it comes to determining success. However, we can use shot quality (rather than quantity) to predict future goals. This is where expected goals (xG) comes into play."),
               selectInput('goals_season',
                           'Select Season:',
                           choices = unique(nhl_stats$season),
                           selected = '2019'),
               DTOutput("goalsTable"),
               selectInput('xgoals_team',
                           'Select a team:',
                           choices = unique(nhl_stats$team_name),
                           selected = 'Anaheim Ducks'),
               h3("Goals vs expected goals"),
               plotlyOutput('xGoals_per60_scatter'),
               
      ),
      tabPanel('Player Comparison',
               DTOutput("shot_qualityTable"))
    )
)







