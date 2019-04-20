fluidPage(
  titlePanel("Yeast Transcriptomics Browser"),
  sidebarLayout(sidebarPanel(
    selectizeInput(
      inputId = "selected",
      label = "Select Genomics Dataset",
      choices = choices
    ),
    sliderInput("slider_pval", label=h3("P-Value Threshold"), min=0.0001, max=0.1, value = 0.05), 
    sliderInput("slider_expression", label=h3("Fold Gene Expression Change Threshold"), min=1, max=10, value = 2)
  ), 
  
  mainPanel(tabsetPanel(
    #tabPanel("Background"), 
    tabPanel("Gene Expression",
             fluidRow(column(
               12, plotOutput("volcano")
             )), #column(5,textOutput("selected_text")) ),
             fluidRow(column(
               12, d3heatmapOutput("heatmap")
             ))),
    tabPanel("Gene List",
             tableOutput("top_siggenes_table"))
  ))
  ))
 

# 
# shinyUI(dashboardPage(skin = "green",
#   dashboardHeader(title = "Yeast Transcriptomics Browser"), 
#   
#   dashboardSidebar(
#     img(src="yeast.png", width = "100%"),
#     sidebarMenu(
#       menuItem("Background", tabName = "bg", icon = icon("bg")), 
#       menuItem("Gene Expression", tabName = "expression", icon = icon("expression")), 
#       menuItem("Cluster Analysis", tabName = "cluster", icon = icon("cluster"))
#     ), 
#     selectizeInput("selected", 
#                    "Select Genomics Dataset", 
#                    choices) #, choice1
#   ), 
#   
#   dashboardBody(
#     tabItems(
#       tabItem(tabName = "bg"), 
#       tabItem(tabName = "expression", 
#               fluidRow(
#                 plotOutput("volcano")
#               )), 
#       tabItem(tabName = "cluster", 
#               fluidRow(
#                 plotOutput("cluster")
#               ))
#     )
#   )
#   )
