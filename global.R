library(shiny)
library(tidyverse)
library(ggplot2)
library(dendextend)
library(ape)
library(d3heatmap)

# Upload files that are needed for the visualization
data <- read.csv("./data/yeast_raw.csv", stringsAsFactors = F, header = T)
#data_means <- read.csv("./data/yeast_means.csv", stringsAsFactors = F, header = T, row.names=1)
#expr_data <- read.csv("./data/expression_data.csv", stringsAsFactors = F)

# Labels for input selector choices
choices <-  c("Normal vs High Temperature", "Normal vs Low Temperature", "Glucose vs Ethanol Carbon Source", "Wildtype vs Biofuel Strain")

#Global variables (labels for the inputs)

input_wt <- "wildtype" # Control label
input_biofuel <- "Biofuel.Production.Strain" # Biofuel generation strain samples

input_15C <- "15 deg" # RNA samples collected from yeast grown at 15C (low temperature) 
input_30C <- "30 deg" # RNA samples collected from yeast grown at ideal temperature 
input_37C <- "37 deg" # RNA samples colelcted from yeast grown at 37C (high temperature)

input_ethanol <- "Ethanol" # RNA samples collected from yeast grown in media with ethanol as the primary carbon source
input_glucose <- "Glucose" # RNA samples collected from yeast grown in media with glucose at the primary carbon source