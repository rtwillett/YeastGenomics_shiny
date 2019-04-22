shinyServer(function(input, output){
  
  # Loading of the expression dataset based on the InputSelector choice
  expr_data <- reactive({
    switch(
      input$selected,
      "Wildtype vs Biofuel Strain" = read.csv("./data/expression_biofuel.csv", stringsAsFactors = F),
      "Normal vs High Temperature" = read.csv("./data/expression_high.csv", stringsAsFactors = F),
      "Normal vs Low Temperature" = read.csv("./data/expression_low.csv", stringsAsFactors = F),
      "Glucose vs Ethanol Carbon Source" = read.csv("./data/expression_carbon.csv", stringsAsFactors = F)
    )
  }) 
  
  # Assignment of the control condition based on the InputSelector choice
  input1 <- reactive({
    switch(
      input$selected,
      "Wildtype vs Biofuel Strain" = input_wt,
      "Normal vs High Temperature" = input_30C,
      "Normal vs Low Temperature" = input_30C,
      "Glucose vs Ethanol Carbon Source" = input_glucose
    )
  })
  
  # Assignment of the other experimental condition based on the InputSelector choice
  input2 <- reactive({
    switch(
      input$selected,
      "Wildtype vs Biofuel Strain" = input_biofuel,
      "Normal vs High Temperature" = input_37C,
      "Normal vs Low Temperature" = input_15C,
      "Glucose vs Ethanol Carbon Source" = input_ethanol
    )
  })
  
  # Plotting the gene expression volcano plot from the selected dataset
  t <- theme_classic()
  plot_colors <- scale_color_manual(values = c("black", "red", "green"))
  
  s_pval <- reactive({as.numeric(input$slider_pval)})
  s_expr <- reactive({as.numeric(input$slider_expression)})
  
  # Assigns a flag for group coloring based on threshold sliders in UI. Plots scatter plot.
  output$volcano <- renderPlot(expr_data() %>% 
    mutate(col_flag = ifelse(((l2fc>=log2(s_expr()) | l2fc<=-log2(s_expr())) & neg_pL10 > -1*log10(s_pval())),1,0)) %>% 
    ggplot(aes(x=l2fc, y=neg_pL10, col=as.factor(col_flag))) + t + 
    geom_point(size=0.2) +
    plot_colors +
      labs(
        x = "log2 Fold Change in Gene Expression",
        y = "-log10(p-value)",
        title = "Expression Differences of Significantly Expressed Genes",
        caption = "Genes of interest appear in red"
      ) +
    guides(col=F) # Removes the legend
  )
  
  # Assigns a flag based on the input thresholds and filters based on that flag (NAs removed). 
  # Removes the strange flag "__alignment_not_unique" (not a gene), and converts the gene df column to a vector
  sig_genes1 <- reactive({ expr_data() %>% 
    mutate(col_flag = ifelse(((l2fc>=log2(s_expr()) | l2fc<=-log2(s_expr())) & neg_pL10 > -1*log10(s_pval())),1,0)) %>% 
    filter(col_flag == 1 & !is.na(fold.change)) %>% 
    select(-col_flag) %>% filter(genes != "__alignment_not_unique") %>% select(genes) %>% .[,"genes"]
  })
    
  # The original dataset (with replicates is subset based using the significant gene vector from above as the column slice basis)
  # Dataset is converted to a matrix for use in the heatmap below.
  sig_data <- reactive({ data %>% filter(primary == input1() | primary == input2()) %>% 
    select(ID, sig_genes1()) %>% column_to_rownames("ID") %>% as.matrix()
  })
    
  # The matrix of significantly expressed genes from above is plotted as a heatmap and run dendrograms using the interactive d3 library
  output$heatmap <- renderD3heatmap({
    d3heatmap(sig_data(), scale = "column", colors="RdYlGn")
  }) 
  
  # Filters the data based on the input slider inputs, as above for the volcano plot and assigns that to a variable
  sig_genes2 <- reactive({
    expr_data() %>% 
      mutate(col_flag = ifelse(((l2fc>=log2(s_expr()) | l2fc<=-log2(s_expr())) & neg_pL10 > -1*log10(s_pval())),1,0)) %>%
      filter(col_flag == 1 & !is.na(fold.change)) %>% 
      select(-col_flag, -l2fc, -neg_pL10) %>% rename(P_Value = pstats, Fold_Expression_Change = fold.change) %>% arrange(desc(Fold_Expression_Change))
  })
  
  # The filtered gene data dataframe from directly above is provided to the user as a table
  output$top_siggenes_table <- renderTable({
    sig_genes2()})
  
  
  # Server side of the download button to save the data for the genes that have been selected by the user
  output$downloadSet <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    }, 
    content =  function(file){
      write.csv(sig_genes(), file, row.names=F)
    })
}
)
