library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)
library(DT)
library(ggimage)

nhl_stats <- read_csv('data/nhlstats.csv')

team_stats <- read_csv('data/teams_stats.csv')

team_and_color <- nhl_stats %>% 
  select(team_name, team_color) %>% 
  unique() %>% 
  deframe()

player_info <- c('name', 'position', 'team')

possession <- c('onIce_corsiPercentage', 'onIce_fenwickPercentage')

goals_stats <- c('goals', 'xGoals', 'goals_above_expected', 'goals_per60', 'xGoals_per60')

team_scoring_rates <- c('OnIce_F_xGoals', 'OffIce_F_xGoals', 'onIce_xGoalsPercentage', 'offIce_xGoalsPercentage')
