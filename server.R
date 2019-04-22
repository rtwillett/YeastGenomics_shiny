shinyServer(function(input, output){

  t <- theme_classic()
  plot_colors <- scale_color_manual(values = c("black", "red", "green"))
  
  s_pval <- reactive({as.numeric(input$slider_pval)})
  s_expr <- reactive({as.numeric(input$slider_expression)})
  
  output$volcano <- renderPlot(expr_data %>% 
    mutate(col_flag = ifelse(((l2fc>=log2(s_expr()) | l2fc<=-log2(s_expr())) & neg_pL10 > -1*log10(s_pval())),1,0)) %>% 
    ggplot(aes(x=l2fc, y=neg_pL10, col=as.factor(col_flag))) + t + 
    geom_point(size=0.2) +
    plot_colors +
    #scale_y_continuous(trans = "log2") +
      labs(
        x = "log2 Fold Change in Gene Expression",
        y = "-log10(p-value)",
        title = "Expression Differences of Significantly Expressed Genes",
        caption = "Genes of interest appear in red"
      ) +
    guides(col=F) # Removes the legend
  )
  
  sig_genes1 <- reactive({ expr_data %>% 
    mutate(col_flag = ifelse(((l2fc>=log2(s_expr()) | l2fc<=-log2(s_expr())) & neg_pL10 > -1*log10(s_pval())),1,0)) %>% 
    filter(col_flag == 1 & !is.na(fold.change)) %>% 
    select(-col_flag) %>% filter(genes != "__alignment_not_unique") %>% select(genes) %>% .[,"genes"]
  })
    
  sig_data <- reactive({ data %>% filter(primary == input1 | primary == input2) %>% 
    select(ID, sig_genes1()) %>% column_to_rownames("ID") %>% as.matrix()
  })
    
  output$heatmap <- renderD3heatmap({
    d3heatmap(sig_data(), scale = "column", colors="RdYlGn")
  }) 
  
  sig_genes2 <- reactive({
    expr_data %>% 
      mutate(col_flag = ifelse(((l2fc>=log2(s_expr()) | l2fc<=-log2(s_expr())) & neg_pL10 > -1*log10(s_pval())),1,0)) %>%
      filter(col_flag == 1 & !is.na(fold.change)) %>% 
      select(-col_flag)
  })
  
  output$top_siggenes_table <- renderTable({
    sig_genes2()})
  
  
  output$downloadSet <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    }, 
    content =  function(file){
      write.csv(sig_genes(), file, row.names=F)
    })
}
)
