library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)

nhl_stats <- read_csv('data/nhlstats.csv')

player_info <- c('name', 'position', 'team', 'season', 'situation', 'games_played', 'icetime')

traditional_stats <- c('goals', 'primaryAssists', 'secondaryAssists', 'points', 'penalties', 'penaltyMinutes')

possession <- c('onIce_corsiPercentage', 'offIce_corsiPercentage', 'onIce_fenwickPercentage', 'offIce_fenwickPercentage')

goals_stats <- c('goals', 'xGoals', 'goals_above_expected', 'goals_per60', 'xGoals_per60', 'reboundGoals_Percentage')

team_scoring_rates <- c('OnIce_F_xGoals', 'OffIce_F_xGoals', 'onIce_xGoalsPercentage', 'offIce_xGoalsPercentage')

shot_quality <- c('shotAttempts', 'shotsOnGoal', 'rebounds', 'lowDangerShots', 'lowDangerShots_Percentage', 'lowDangerGoals', 'lowDangerGoals_Percentage', 'mediumDangerShots', 'mediumDangerShots_Percentage', 'mediumDangerGoals', 'mediumDangerGoals_Percentage', 'highDangerShots', 'highDangerShots_Percentage', 'highDangerGoals', 'highDangerGoals_Percentage')
