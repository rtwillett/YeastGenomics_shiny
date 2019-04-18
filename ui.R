shinyUI(dashboardPage(skin = "green",
  dashboardHeader(title = "Yeast Transcriptomics Browser"), 
  
  dashboardSidebar(
    sidebarUserPanel(tags$div("Yeast genomics datasets were derived from RNAseq NGS workflows. The normalization method used was reads per million"),
                     ),
    img(src="yeast.png", width = "100%"),
    sidebarMenu(
      menuItem("Background", tabName = "bg", icon = icon("bg")), 
      menuItem("Gene Expression", tabName = "expression", icon = icon("expression"))
    ), 
    selectizeInput("selected", 
                   "Select Genotype to Compare with Wildtype", choice #, choice1
    )
  ), 
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "bg"), 
      tabItem(tabName = "expression")
    )
  )
  )
)