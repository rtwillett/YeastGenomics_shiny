library(shiny)
library(tidyverse)
library(ggplot2)
library(dendextend)
library(ape)
library(d3heatmap)

# Upload files that are needed for the visualization
data <- read.csv("./data/yeast_raw.csv", stringsAsFactors = F, header = T)
#data_means <- read.csv("./data/yeast_means.csv", stringsAsFactors = F, header = T, row.names=1)
expr_data <- read.csv("./data/expression_data.csv", stringsAsFactors = F)

# Global variables
choices = unique(data$primary)

input1 <- "wildtype"
input2 <- "Biofuel.Production.Strain"
