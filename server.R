library(shiny);library(dplyr);library(tidyr);library(plotly)

#Source: https://www.kaggle.com/bilalyussef/google-books-dataset
googleBooks<-data.frame(read.csv(file="google_books_1299.csv",header=TRUE))
#Data is prepared to be evaluated
##The year is extracted from the data
date_p<-as.Date(googleBooks$published_date,format="%b %d, %Y")
date_p<-as.numeric(format(date_p,format="%Y"))
googleBooks$year<-date_p
##Books without year of publication are discarted
googleBooks<-googleBooks[!(is.na(googleBooks$year)),1:length(googleBooks)]
##NA values are replace in "generes" by "none", in "rating" by "-1", and in "voters by "0".
googleBooks$generes[is.na(googleBooks$generes)]<-"none"
googleBooks$rating[is.na(googleBooks$rating)]<--1

googleBooks$voters<-as.numeric(googleBooks$voters)
googleBooks$voters[is.na(googleBooks$voters)]<-0

#For each listed gender of every book a new column is created
generes_s<-data.frame(googleBooks$generes) %>% separate(googleBooks.generes,c("G1","G2","G3","G4","G5","G6"),",")
googleBooks$G1<-trimws(generes_s$G1)
googleBooks$G2<-trimws(generes_s$G2)
googleBooks$G3<-trimws(generes_s$G3)
googleBooks$G4<-trimws(generes_s$G4)
googleBooks$G5<-trimws(generes_s$G5)
googleBooks$G6<-trimws(generes_s$G6)

#Vectors for genres and authors are created to be used as options in the app
levels_g<-levels(as.factor(trimws(c(generes_s$G1,generes_s$G2,generes_s$G3,generes_s$G4,generes_s$G5,generes_s$G6))))

googleBooks$author<-trimws(googleBooks$author)
levels_au<-levels(as.factor(trimws(googleBooks$author)))

shinyServer(
  function(input, output) {
    # This is a reactive function to filter the data according to the user preferences
    books<-reactive({
      
      minrating <- as.numeric(input$Rating[1])
      maxrating <- as.numeric(input$Rating[2])
      minvoters <- as.numeric(input$Voters[1])
      maxvoters <- as.numeric(input$Year[2])
      minprice <- as.numeric(input$Price[1])
      maxprice <- as.numeric(input$Price[2])
      minpage_count <- as.numeric(input$Page_count[1])
      maxpage_count <- as.numeric(input$Page_count[2])
      minyear <- as.numeric(input$Year[1])
      maxyear <- as.numeric(input$Year[2])
      
      bk <- googleBooks %>%
        filter(
          rating >= minrating,
          rating <= maxrating,
          voters >= minvoters,
          voters <= maxvoters,
          price >= minprice,
          price <= maxprice,
          page_count >= minpage_count,
          page_count <= maxpage_count,
          year >= minyear,
          year <= maxyear
        )
      #Filter by author (optional)
      if(input$Author!="All"){
        Author<-input$Author
        bk<-bk%>%filter(author==Author)
      }
      #Filter by genre (optional)
      if(input$Genre!="All"){
        Genre<-input$Genre
        bk<-bk%>%filter(G1==Genre | G2==Genre| G3==Genre| G4==Genre| G5==Genre| G6==Genre)
      }    
      bk <- as.data.frame(bk)
      bk<-bk[c("title","author","rating","voters","price","page_count","ISBN",
               "published_date","year")]
      bk<-distinct(bk)

    })
    
    # This is the function to present the books that pass the established conditions
    
    output$plot1 <- renderPlotly({
      
      xvar_name <- input$xvar
      yvar_name <- input$yvar
      
      
      Books<-books()
      Books$xx <- Books[[input$xvar]]
      Books$yy<- Books[[input$yvar]]
      
      
      plot1<-plot_ly(data=Books,
                     x = ~xx,y = ~yy,type = "scatter",mode = "markers",
                     text=~paste("Title :", title,
                                  "<br> Author :", author)
      )
      plot1<-plot1%>%layout(
              xaxis = list(title = xvar_name,color = '#2a47af'),
              yaxis = list(title=yvar_name,color='#2a47af'),
              paper_bgcolor='#f8f8f9',
              plot_bgcolor='#f4f4f5',
              title = list(text='<b> Available books </b>'))
      
    })
    
    # Outputs with the results
    output$table1 <- renderDataTable({books()[c("title","author","price","rating","published_date")]})
    output$table2 <- renderDataTable({summary(books()[c("price","rating","page_count")])},
                                     options = list(searching = FALSE,
                                                    Info=FALSE,
                                                    lengthChange = FALSE,
                                                    paging = FALSE,
                                                    language = list(lengthMenu = "_MENU_")))
    
  }
)

