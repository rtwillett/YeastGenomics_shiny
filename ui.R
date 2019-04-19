shinyUI(dashboardPage(skin = "green",
  dashboardHeader(title = "Yeast Transcriptomics Browser"), 
  
  dashboardSidebar(
    img(src="yeast.png", width = "100%"),
    sidebarMenu(
      menuItem("Background", tabName = "bg", icon = icon("bg")), 
      menuItem("Gene Expression", tabName = "expression", icon = icon("expression"))
    ), 
    selectizeInput("selected", 
                   "Select Genomics Dataset", choice #, choice1
    ),
    selectizeInput("selected", 
                   "Select Genomics Dataset", choice #, choice1
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