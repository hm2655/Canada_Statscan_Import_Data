## STAT CAN DATABSE SCRAP ##
rm(list=ls())
library(rvest)
province<-c("1", "10", "11", "12", "13", "24", "35")
cum_canada<-data.frame()
for( i in 1:length(province))
{
    url<-paste("http://www5.statcan.gc.ca/cimt-cicm/topNCountries-pays?lang=eng&getSectionId()=0&dataTransformation=0&refYr=2016&refMonth=1&freq=12&countryId=0&getUsaState()=0&provId=",
             province[i],
             "&retrieve=Retrieve&country=null&tradeType=3&topNDefault=250&monthStr=null&chapterId=27&arrayId=0&sectionLabel=&scaleValue=0&scaleQuantity=0&commodityId=270900", 
             sep="")
  print(url)
  data<-read_html(url) %>% html_node(xpath='//*[@id="wb-main-in"]/div[2]/table') %>% html_table(fill=TRUE)
  colnames(data)<-data[1,]
  data$Province<-province[i]
  data<-data[-1,]
  data<-data[-1,]
  data<-data[-1,]
  try(assign(paste("province_number:", i, sep=""), read_html(url) %>% html_node(xpath='//*[@id="wb-main-in"]/div[2]/table') %>% html_table(fill=TRUE)))
  cum_canada<-rbind(cum_canada,data)
}
