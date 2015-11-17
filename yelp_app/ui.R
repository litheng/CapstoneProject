library(shiny)
require(rCharts)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel(
      list(tags$head(tags$style()),
           HTML('<div style="background-color:Linen; padding:15px">              
                  <p style="color:Chocolate"><img src="icon_checkin.png", height="30px"/>&nbsp&nbspYelp: Business Checkin Data</p>
                </div>' )
      )
    ),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with 2 inputs
      sidebarPanel(
        selectInput("region", label = h5("Select Region"), 
                    choices = list("United States (West)"=1, "United States (Midwest)"=2, "United States (South)"=3, "United Kingdom"=4, "Canada"=5, "Germany"=6),
                    selected = 1),
        
        h5("Business Category Options"),
        checkboxInput("airport", "Include Airports", TRUE),
        checkboxInput("hotel", "Include Hotels", TRUE),
        checkboxInput("restaurant", "Include Restaurants", TRUE),
        
        hr(),
        helpText("Data Source: Yelp")
      ),
      
      # Main Panel
      mainPanel(
        tabsetPanel(
          
          # Plot
          tabPanel(p(icon("bar-chart"), "Chart"),
                   br(),
                   h4("Number of Checkins by Day"),
                   showOutput("regionchart", "nvd3"),
                   h4("Top 10 Businesses by Checkins"),
                   showOutput("topchart", "nvd3"),
                   h4("Checkins by State"),
                   #                    div(class='row-fluid',
                   #                        div(class='span6',
                   plotOutput("boxplot")
                   #                        )
                   #                    )
          ),
          
          # Word Cloud
          tabPanel(p(icon("cloud"), "Word Cloud"),
                   br(),
                   fluidRow(
                     column(5, div(style="color:grey; float:right;",
                                   sliderInput("pct",
                                               h5("Percent of businesses to include"),
                                               min = 1,  max = 50, value = 1))),
                     column(1, div(style="float:bottom;",
                                   actionButton("update", "Refresh")))
                   ),
                   h4("Category Terms of Top Businesses"),
                   plotOutput("catcloud", width="auto"),
                   h4("Attributes of Top Businesses"),
                   plotOutput("attrcloud", width="auto")
          ),
          
          # Data 
          tabPanel(p(icon("table"), "Data"),
                   dataTableOutput(outputId="table")
          ),
          
          # About
          tabPanel(p(icon("info-circle"), "About"),
                   includeHTML("about.html") 
          )
        )
      )
    )
  )
)
