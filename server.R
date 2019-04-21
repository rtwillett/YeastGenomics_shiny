shinyServer(function(input, output){

  t <- theme_classic()
  plot_colors <- scale_color_manual(values = c("black", "red", "green"))
  
  # n1 <- 0.05
  # n2 <- 2
  
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
  
  # sigs_hm <- reactive({
  #   
  #   top_sig_genes <- expr_data %>% 
  #     mutate(col_flag = ifelse(((l2fc>=log2(s_expr()) | l2fc<=-log2(s_expr())) & neg_pL10 > -1*log10(s_pval())),1,0)) %>% 
  #     filter(col_flag == 1 & !is.na(fold.change)) %>% 
  #     select(-col_flag) %>% 
  #     arrange(desc(fold.change)) %>% 
  #     slice(-101:-(n()-101)) #Return the highest 100 and lowest 100 gene expression changes
  #   
  #   hm_d <- data %>% filter(primary == input1 | primary == input2) %>% select(-primary) %>% t() %>% as.data.frame()
  #   colnames(hm_d) <- as.character(unlist(hm_d[1, ]))
  #   hm_d <- hm_d[-1, ]
  #   hm_d <- hm_d %>% rownames_to_column("genes")
  #   
  #   sigs <- top_sig_genes[, 1, drop = F]
  #   sigs_join <- merge(sigs, hm_d, by = "genes")
  #   sigs_join <- sigs_join %>% column_to_rownames("genes") %>% as.matrix()
  #   sigs_join <- apply(sigs_join, 2, as.numeric) # Converting character matrix to numeric matrix for heatmap calculation
  # })
  
  output$heatmap <- renderD3heatmap({
    d3heatmap(sigs_join, scale = "row", colors="RdYlGn")
  }) 
  
  sig_genes <- reactive({
    expr_data %>% 
      mutate(col_flag = ifelse(((l2fc>=log2(s_expr()) | l2fc<=-log2(s_expr())) & neg_pL10 > -1*log10(s_pval())),1,0)) %>%
      filter(col_flag == 1 & !is.na(fold.change)) %>% 
      select(-col_flag)
  })
  
  output$top_siggenes_table <- renderTable({
    sig_genes()})
  
  
  output$downloadSet <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    }, 
    content =  function(file){
      write.csv(sig_genes(), file, row.names=F)
    })
}
)
