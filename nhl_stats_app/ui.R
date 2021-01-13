# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel('NHL Stats'),

    # Sidebar with a slider input for number of bins
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

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel('Traditional', 
                         plotlyOutput('points_plot'),
                         tableOutput("traditionalTable")),
                 tabPanel('Possession',
                          tableOutput("possessionTable")),
                 tabPanel('Goals',
                          tableOutput("goalsTable")),
                 tabPanel('Shot Quality',
                          tableOutput("shot_qualityTable"))
            )
        )
    )
))