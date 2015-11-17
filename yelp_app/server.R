library(shiny)
library(data.table)
library(dplyr)
library(ggplot2)
library(rCharts)
library(scales)
library(RColorBrewer)
library(tm)
library(wordcloud)


# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Define state list based on selection
  list.state <- reactive ({
    
    if(input$region==1) ({
      statelist <- c("AZ","CA","NV")
    }) else if(input$region==2) ({
      statelist <- c("IL","PA","WI")
    }) else if(input$region==3) ({
      statelist <- c("NC","SC","WA")
    }) else if(input$region==4) ({
      statelist <- c("EDH","ELN","FIF","KHL","MLN","SCB")
    }) else if(input$region==5) ({
      statelist <- c("ON","QC")
    }) else ({
      statelist <- c("BW")
    })
    statelist
  })
  
  # Define function to filter selected states
  filterstate <- function(x) {
    result <- x[(x$state %in% list.state()),]
  }
  
  # Filter data based on inputs
  df.selected <- reactive({
    
    if(input$airport==TRUE & input$hotel==TRUE & input$restaurant==TRUE) ({
      
      sdf <- filterstate(df)
      
    }) else if(input$airport==FALSE & input$hotel==FALSE & input$restaurant==TRUE) ({
      
      noairport <- excludeairport(df)
      noall <- excludehotel(noairport)
      sdf <- filterstate(noall)
      
    }) else if(input$airport==FALSE & input$hotel==TRUE & input$restaurant==FALSE) ({
      
      noairport <- excludeairport(df)
      noall <- excluderestaurant(noairport)
      sdf <- filterstate(noall)
      
    }) else if(input$airport==TRUE & input$hotel==FALSE & input$restaurant==FALSE) ({
      
      nohotel <- excludehotel(df)
      noall <- excluderestaurant(nohotel)
      sdf <- filterstate(noall)
      
    }) else if(input$airport==TRUE & input$hotel==TRUE & input$restaurant==FALSE) ({
      
      norestaurant <- excluderestaurant(df)
      sdf <- filterstate(norestaurant)
      
    }) else if(input$airport==TRUE & input$hotel==FALSE & input$restaurant==TRUE) ({
      
      nohotel <- excludehotel(df)
      sdf <- filterstate(nohotel)
      
    }) else if(input$airport==FALSE & input$hotel==TRUE & input$restaurant==TRUE) ({
      
      noairport <- excludeairport(df)
      sdf <- filterstate(noairport)
      
    }) else if(input$airport==FALSE & input$hotel==FALSE & input$restaurant==FALSE) ({
      
      noairport <- excludeairport(df)
      nohotel <- excludehotel(noairport)
      noall <- excluderestaurant(nohotel)
      sdf <- filterstate(noall)
      
    })
    
    
    sdf
    
  })
  
  # Define datasets for use in plotting charts
  dt.region <- reactive({
    
    rdt <- aggregate(checkin_count~state+day, data=df.selected(), sum, na.rm=TRUE)
    rdt
    
  })
  
  dt.business <- reactive({
    
    bdt <- aggregate(checkin_count~business_id+name, data=df.selected(), sum, na.rm=TRUE)
    s.bdt <- arrange(bdt, desc(checkin_count))
    s.bdt[,2:3]
    
  })
  
  df.top <- reactive({
    
    tdf <- subset(df.selected(), df.selected()$checkin_count > quantile(df.selected()$checkin_count, prob = 1-input$pct/100))
    tdf
  })
  
  # Create charts based on selected data
  output$regionchart <- renderChart({
    
    p1 <- nPlot(checkin_count~day, group='state', data=dt.region(), type='multiBarChart')
    p1$addParams(dom = 'regionchart')
    # p1$chart(margin = list(left = 100))
    # p1$chart(color = brewer.pal(6, "Set2"))
    p1$yAxis(tickFormat = "#!d3.format(',')!#")
    p1$yAxis(axisLabel = "No. of Checkins", width=62)
    return(p1)
    
  })
  
  output$topchart <- renderChart({
    
    p2 <- nPlot(checkin_count~name, data=dt.business()[1:10,], type = 'multiBarHorizontalChart')
    p2$chart(showControls = F)
    p2$addParams(dom = 'topchart')
    p2$chart(margin = list(left = 250))
    p2$chart(color = brewer.pal(3, "Set2"))
    p2$chart(showLegend = FALSE)
    p2$yAxis(tickFormat = "#!d3.format(',')!#")
    p2$yAxis(axisLabel = "No. of Checkins")
    return(p2)
    
  })
  
  output$boxplot <- renderPlot({
    
    pl <- ggplot(data = dt.region(),
                 aes_string(x="state",
                            y="checkin_count",
                            fill="state")
    )
    
    pl + geom_boxplot() + theme_bw() + xlab("State") + ylab("No. of Checkins") +
      scale_fill_brewer(palette="Set2") +
      scale_y_continuous(name="No. of Checkins", labels=comma) +
      theme(legend.position="none") 
  })
  
  # Define Term Matrix Document
  cat.terms <- reactive ({
    
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        
        cat <- Corpus(VectorSource(df.top()$categories))
        cat <- tm_map(cat, content_transformer(removePunctuation))
        cat <- tm_map(cat, content_transformer(tolower))
        cat <- tm_map(cat, content_transformer(stripWhitespace))
        cat.tdm <- TermDocumentMatrix(cat)
        cat.tdm <- sort(rowSums(as.matrix(cat.tdm)),decreasing=TRUE)
        cat.terms <- data.frame(word = names(cat.tdm),freq=cat.tdm)
        cat.terms
        
      })
    })
  })
  
  attr.terms <- reactive ({
    
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        
        attr <- Corpus(VectorSource(df.top()$attributes))
        attr.tdm <- TermDocumentMatrix(attr)
        attr.tdm <- sort(rowSums(as.matrix(attr.tdm)),decreasing=TRUE)
        attr.terms <- data.frame(word = names(attr.tdm),freq=attr.tdm)
        attr.terms
        
      })
    })
  })
  
  output$catcloud <- renderPlot({
    
    wordcloud(words = cat.terms()$word, freq = cat.terms()$freq, scale=c(4,0.5), 
              min.freq = 1, max.words=100, random.order=FALSE, rot.per=0.35, 
              colors=brewer.pal(10, "Paired"))
    
  })
  
  output$attrcloud <- renderPlot({
    
    wordcloud(words = attr.terms()$word, freq = attr.terms()$freq, scale=c(2,0.25), 
              min.freq = 1, max.words=100, random.order=FALSE, rot.per=0.2,
              colors=brewer.pal(10, "Paired"))
    
  })
  
  # Render data table and create download handler
  output$table <- renderDataTable(
    #{df.selected()[,c(4,5,2,3)]}, options = list(searching = FALSE, pageLength = 50))
    {dt.business()}, options = list(searching = FALSE, pageLength = 50))
  
})