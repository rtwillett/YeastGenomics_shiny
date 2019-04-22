fluidPage(
  includeCSS("style.css"),  # Importing CSS file for page style code
  headerPanel(p(id="top", "Yeast Transcriptomics Profiler")), # This needs work. Allows style to be applies to heading but makes the page title HTML code
  sidebarLayout(sidebarPanel(
    selectInput( #Selector widget
      inputId = "selected",
      label = "Select Genomics Dataset",
      choices = choices
    ),
    hr(),
    # Threshold slider widgets 
    sliderInput("slider_pval", label=h3("P-Value Threshold"), min=0.00001, max=0.05, value = 0.05), 
    sliderInput("slider_expression", label=h3("Fold Gene Expression Change Threshold (Up/Down)"), min=1, max=10, value = 2), 
    hr(), 
    downloadButton("downloadSet", "Download Gene List"), 
    HTML("<br><br><br><hr><br><font size='2'>Ryan Willett, 2019</font><br><font size='1'>Powered by Shiny</font>")
  ), 
  
  mainPanel(tabsetPanel(
    tabPanel("Gene Expression",  # Volcano plot
             fluidRow(column(
               12, plotOutput("volcano")
             ))),
    tabPanel("Cluster Analysis",  # Heatmap output
             fluidRow(column(
               12, d3heatmapOutput("heatmap")
             ))),
    tabPanel("Gene List",  # Table of genes 
             tableOutput("top_siggenes_table"))
  ))
  )
)
