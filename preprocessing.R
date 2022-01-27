##Preprocessing

#Source: https://www.kaggle.com/bilalyussef/google-books-dataset
googleBooks<-data.frame(read.csv(file="google_books_1299.csv",header=TRUE))
#Data is prepared to be evaluated
##The year is extracted from the data
ddd<-Sys.setlocale("LC_TIME", "English")
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
googleBooks$author<-trimws(googleBooks$author)

googleBooks<-as.data.frame(googleBooks)

write.csv(googleBooks,"google_books_1299_pp.csv", row.names = FALSE)
