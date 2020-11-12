library(data.table)
library(leaflet)
library(tidyverse)
library(lubridate)
library(httr)
library(data.table)
library(dplyr)
library(readr)
library(ggplot2)
library(tidytext)

afterfire <- GET(
  "https://aqs.epa.gov/data/api/qaOnePointQcRawData/byState?email=test@aqs.api&key=test&param=42401,42101&bdate=20181108&edate=20181125&state=06")

beforefire2017 <- GET(
  "https://aqs.epa.gov/data/api/qaOnePointQcRawData/byState?email=test@aqs.api&key=test&param=42401,42101&bdate=20171108&edate=20171125&state=06")
beforefire2016 <- GET(
  "https://aqs.epa.gov/data/api/qaOnePointQcRawData/byState?email=test@aqs.api&key=test&param=42401,42101&bdate=20161108&edate=20161125&state=06")
beforefire2015 <- GET(
  "https://aqs.epa.gov/data/api/qaOnePointQcRawData/byState?email=test@aqs.api&key=test&param=42401,42101&bdate=20151108&edate=20151125&state=06")
beforefire2014 <- GET(
  "https://aqs.epa.gov/data/api/qaOnePointQcRawData/byState?email=test@aqs.api&key=test&param=42401,42101&bdate=20141108&edate=20141125&state=06")
beforefire2013 <- GET(
  "https://aqs.epa.gov/data/api/qaOnePointQcRawData/byState?email=test@aqs.api&key=test&param=42401,42101&bdate=20131108&edate=20131125&state=06")

afterfire <- httr::content(afterfire)
beforefire2013 <- httr::content(beforefire2013)
beforefire2014 <- httr::content(beforefire2014)
beforefire2015 <- httr::content(beforefire2015)
beforefire2016 <- httr::content(beforefire2016)
beforefire2017 <- httr::content(beforefire2017)

afterfire<-afterfire$Data
afterfire <- rbindlist(afterfire)
#This is very important to transfer NULL to NA, it takes me lots of time to fix it.
dtafter <-data.table(afterfire)

beforefire2013<-beforefire2013$Data
beforefire2013 <- rbindlist(beforefire2013)
dtbeforefire2013 <-data.table(beforefire2013)

beforefire2014<-beforefire2014$Data
beforefire2014 <- rbindlist(beforefire2014)
dtbeforefire2014 <-data.table(beforefire2014)

beforefire2015<-beforefire2015$Data
beforefire2015 <- rbindlist(beforefire2015)
dtbeforefire2015 <-data.table(beforefire2015)

beforefire2016<-beforefire2016$Data
beforefire2016 <- rbindlist(beforefire2016)
dtbeforefire2016 <-data.table(beforefire2016)

beforefire2017<-beforefire2017$Data
beforefire2017 <- rbindlist(beforefire2017)
dtbeforefire2017 <-data.table(beforefire2017)


data1<-rbind(dtbeforefire2013,dtafter)
data1<-rbind(dtbeforefire2014,data1)
data1<-rbind(dtbeforefire2015,data1)
data1<-rbind(dtbeforefire2016,data1)
data1<-rbind(dtbeforefire2017,data1)




table(data1$parameter)

summary(data1$latitude)
summary(data1$longitude)

data_s<-data1[parameter=="Sulfur dioxide"]
summary(data_s$monitor_concentration)
data_c<-data1[parameter=="Carbon monoxide"]
summary(data_c$monitor_concentration)

head(data_c[,sort(-monitor_concentration)],100)
data_a<-head(data_c[order(-monitor_concentration)],100)
data_a[,.(county,site_address,assessment_date,monitor_concentration)]




data_c<-data_c[,year:=substr(assessment_date,1,4)]
data_s<-data_s[,year:=substr(assessment_date,1,4)]

data_c<-data_c[year=="2013"|year=="2014"|year=="2015"|year=="2016"|year=="2017",year:="Previous years"]
data_s<-data_s[year=="2013"|year=="2014"|year=="2015"|year=="2016"|year=="2017",year:="Previous years"]

data_c<-data_c[,date:=ymd(assessment_date)]
data_s<-data_s[,date:=ymd(assessment_date)]

data_c<-data_c[,Date:=substr(assessment_date,6,10)]
data_s<-data_s[,Date:=substr(assessment_date,6,10)]














