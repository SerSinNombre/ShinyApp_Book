library(shiny)
library(plotly)

shinyUI(fluidPage(
  titlePanel("Choosing a new Book"),
    sidebarLayout(
      sidebarPanel (
        wellPanel(
          h2("Description", align = "center"),
          p("This app will help you to choose a book based on different criteria. It uses a database from Google Books compiled by Yussef (2019) and available at https://www.kaggle.com/bilalyussef/google-books-dataset. The price of the books is presented in SAR (i.e., Saudi riyal)."),
          
          h2("Instructions", align = "center"),
          p("To use this app:"),
          p("1. Options: Using the sliders select the values that you prefer for a book. You can modify the minimum and the maximum value. Selecting an author and a genre is optional."),
          p("2. Results-plot: Here you can see a plot with the books that fufill your criteria. Put the cursor over the points to see the title and author of the books.If you want to change the plotted variables select the y and x variable under it."),
          p("3. Results-plot: Here you can see a table with the books that fufill your criteria."),
          p("4. Results-Summary: Here a table summarizing price, rating and number of pages of the selected book is presented")
        )
      ),
    mainPanel(
     tabsetPanel(type="tabs",
          tabPanel("Options",
                   wellPanel(
                     h2("Options", align = "center"),
                     sliderInput("Rating","Prefered rating",0,5,value=c(4,5),step=0.5),
                     sliderInput("Voters","Number of opinions",0,1000,value=c(100,1000),step=10),
                     sliderInput("Price","Price range",0,900,value=c(0,200),step=10),
                     sliderInput("Page_count","Prefered number of pages",1,4600,value=c(100,500),step=10),
                     sliderInput("Year","Publishing date",1986,2019,value=c(1986,2014),step=1),
                     
                     selectInput("Author", "Select an author (optional)",c("All",levels_au)),
                     selectInput("Genre", "Select a genre (optional)",c("All",levels_g)),
                   )),
          tabPanel("Results-Plot",
                   h4("Plot", align = "center"),
                   plotlyOutput('plot1'),
                   wellPanel(
                     selectInput("xvar", "X-axis variable",
                                 c("price","voters","rating","page_count","year"), selected = "price"),
                     selectInput("yvar", "Y-axis variable",
                                 c("price","voters","rating","page_count","year") ,selected = "rating"))),
          tabPanel("Results-Table",
                   h4("Available books", align = "center"),
                   dataTableOutput('table1')),
          tabPanel("Results-Summary",
                   wellPanel(
                     h4("Summary of books' characteristics", align = "center"),
                     dataTableOutput('table2'))),
       
     ))

    )
  )
)