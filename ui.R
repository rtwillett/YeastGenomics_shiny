fluidPage(
  includeCSS("style.css"),
  headerPanel(p(id="top", "Yeast Transcriptomics Browser")),
  sidebarLayout(sidebarPanel(
    selectizeInput(
      inputId = "selected",
      label = "Select Genomics Dataset",
      choices = choices
    ),
    hr(), 
    sliderInput("slider_pval", label=h3("P-Value Threshold"), min=0.00001, max=0.05, value = 0.05), 
    sliderInput("slider_expression", label=h3("Fold Gene Expression Change Threshold (Up/Down)"), min=1, max=10, value = 2), 
    hr(), 
    downloadButton("downloadSet", "Download Gene List")
  ), 
  
  mainPanel(tabsetPanel(
    #tabPanel("Background"), 
    tabPanel("Gene Expression",
             fluidRow(column(
               12, plotOutput("volcano")
             ))),
    tabPanel("Cluster Analysis", 
             fluidRow(column(
               12, d3heatmapOutput("heatmap")
             ))),
    tabPanel("Gene List",
             tableOutput("top_siggenes_table"))
  ))
  )
)
