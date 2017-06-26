## STAT CAN DATABSE SCRAP ##
rm(list=ls())
library(rvest)
library(httr)

province<-c("1","10", "11", "12", "13", "24","35","46", "47", "48", "59", "60", "61","62")
cum_canada<-data.frame()
proxy.string<-use_proxy("http://prox-hou-pri.woodmac.com", port=8080)

for( i in 1:length(province))
{
  url<-paste("http://www5.statcan.gc.ca/cimt-cicm/topNCountries-pays?lang=eng&getSectionId()=0&dataTransformation=0&refYr=2016&refMonth=1&freq=12&countryId=0&getUsaState()=0&provId=",
             province[i],
             "&retrieve=Retrieve&country=null&tradeType=3&topNDefault=250&monthStr=null&chapterId=27&arrayId=0&sectionLabel=&scaleValue=0&scaleQuantity=0&commodityId=270900", 
             sep="")
  session<-html_session(url, proxy.string)
  print(url)
  Sys.sleep(15)
  try(data<-read_html(session) %>% html_node(xpath='//*[@id="wb-main-in"]/div[2]/table') %>% html_table(fill=TRUE))
  data$Province<-province[i]
  assign(paste("province_number:",province[i], sep=""), data)
  cum_canada<-rbind(cum_canada,data)
}

## CLEAN THE DATA FRAME OF TEXT ##
for( i in 1:nrow(cum_canada))
{
  if(grepl('[a-zA-Z]',cum_canada[i,1]))
  {
    cum_canada<-cum_canada[-i,]
  }
}

## DOWNLOAD US SPECIFIC DATA ## 
province<-c("1","10", "11", "12", "13", "24","35","46", "47", "48", "59", "60", "61","62")
cum_canada_us<-data.frame()
for( i in 1:length(province))
{
  
  url_us<-paste("http://www5.statcan.gc.ca/cimt-cicm/topNStatesCommodities-marchandises?lang=eng&chapterId=27&sectionId=0&sectionLabel=&refMonth=1&refYr=2016&freq=12&countryId=9&usaState=1002&provId=",
                province[i],
                "&dataTransformation=0&commodityId=270900&arrayId=9900027&topNDefault=250&tradeType=3&monthStr=January", 
                sep="")

  session<-html_session(url_us, proxy.string)
  print(url_us)
  Sys.sleep(15)
  try(data_us<-read_html(session) %>% html_node(xpath='//*[@id="wb-main-in"]/div[2]/table') %>% html_table(fill=TRUE))
  data_us$Province<-province[i]
  assign(paste("us_data_province_number:",province[i], sep=""), data_us)
  cum_canada_us<-rbind(cum_canada_us,data_us)
}

## CLEAN THE DATA FRAME OF TEXT ##
for( i in 1:nrow(cum_canada_us))
{
  if(grepl('[a-zA-Z]',cum_canada_us[i,1]))
  {
    cum_canada_us<-cum_canada_us[-i,]
  }
}

# for( i in  1:nrow(cum_canada_us))
# {
#   if(grepl('[a-zA-Z]', cum_canada_us[i,1]))
#   {
#     cum_canada_us<-cum_canada_us[-i,]
#   }
# }
