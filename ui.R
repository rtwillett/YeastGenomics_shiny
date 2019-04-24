fluidPage(
  includeCSS("style.css"),  # Importing CSS file for page style code
  headerPanel("Yeast Transcriptomics Profiler"), # This needs work. Allows style to be applies to heading but makes the page title HTML code
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
    HTML("<br><br><hr><font size='2'>Ryan Willett, 2019</font><br><font size='1'>Powered by Shiny</font>")
  ), 
  
  mainPanel(tabsetPanel(
    tabPanel("Gene Expression",  # Volcano plot
             fluidRow(column(
               12, plotOutput("volcano")
               )), 
              fluidRow(column(
                12, div(id = "description", 
                HTML("<p class = 'redtext'>Genes of interest selected by the user threshold cutoffs appear in red.</p>"), 
                HTML("<p>Mean gene expression levels of each gene is plotted versus thep-value of their difference in expression 
                     gene between experimental conditions</p>"), 
                HTML("<p><u>X-axis:</u> Difference in gene expression level. Positive values indicate higher levels of expression 
                     compared to control <br>(2-fold expression change = 1)</p>"), 
                HTML("<p><u>Y-axis:</u> Negative log10 transformation of the p-value. Higher values indicate a greater degree of 
                     significance.</p>")
                ))
              )),
    tabPanel("Cluster Analysis",  # Heatmap output
             fluidRow(column(
               12, d3heatmapOutput("heatmap")
             )),
             fluidRow(column(
               12, div(id = "description", 
                 HTML("<p>This heatmap show the expression of each gene across replicate samples in the same experiment. The green 
                      and red color indicate expression levels higher and lower than the mean, respectively. </p>"), 
                 HTML("<p><u>X-axis:</u> Gene name</p>"), 
                 HTML("<p><u>Y-axis:</u> Sample Name</p>"), 
                 HTML("<p><i>I will soon implement a panel that displays a table displaying the sample name and the experimental 
                      condition.</i></p>")
             ))
             )),
    tabPanel("Gene List",  # Table of genes 
             tableOutput("top_siggenes_table")), 
    tabPanel("Background Information", 
             div(id = "description", 
                 
                 h3("About the dataset"), 
                 p("This is a dataset containing the gene transcription information for >6000 genes from 92 samples for >20 
                   experimental conditions. For the scope of this project, I decided to focus on 52 samples from 8 different 
                   conditions, groups into 4 'experiments'. These data were collected from a RNAseq next generation sequencing 
                   (NGS) workflow and normalized across sets to reads of each gene per million total reads of mRNA."),
                 
                 h3("Questions"),
                 p("The function of biological systems are crucially linked to the expression of mRNA and proteins from their 
                   genes - both which genes and the number of those gene products shape the biochemistry of the organism. This 
                   project is a tool to allow visualization of gene expression data and downloading of significant genes based on 
                   a user-defined threshold cutoff of T-test p-value and gene expression change."), 
                 p("Experimental comparisons include:"),
                 tags$ul(tags$li("Yeast grown at normal temperature and yeast grown at colder temperature (15C)"), 
                    tags$li("Yeast grown at normal temperature and yeast grown at high temperature (37C)"),
                    tags$li("Yeast grown with either glucose or ethanol as a carbon source"), 
                    tags$li("Wildtype (control) yeast strains or yeast strains optimized for biofuel production")
                    ),
                 
                 h3("Functionality"), 
                 p("In this project, I sought to produce a tool that will read in the normalize RNA expression data and visualize 
                   the significance and gene expression change using a visualization called a volcano plot. Secondly, the variance 
                   between the samples are measured using hierarchical clustering and plotted with a heatmap matrix to show the 
                   level of expression of each gene across the samples. Finally, the user may view a table of the genes selected by 
                   the threshold they have set and these may be downloaded as a CSV file with a button at the bottom of the 
                   sidebar."),
                 
                 h3("Extensible"),
                 p("This project was also chosen because it will be easily extensible with the webscraping and machine learning segments 
                   of the class.")
                 
                 )
                 )
  ))
  )
)
