### GA API Query with googleAnalyticsR pkg - Page data for date range
### allows for use of API v4
### https://cran.r-project.org/web/packages/googleAnalyticsR/googleAnalyticsR.pdf
### https://cran.r-project.org/web/packages/googleAnalyticsR/vignettes/googleAnalyticsR.html
### http://code.markedmondson.me/googleAnalyticsR/index.html 

library(googleAuthR)
library(googleAnalyticsR)
library(dplyr)

### Set gar_auth() options for credentials
### Stored separately to avoid exposing in Github
### Run separate file with actual credentials
## options("googleAuthR.client_id" = "your clientid")
## options("googleAuthR.client_secret" = "your secret")
## options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/analytics",
##                                          "https://www.googleapis.com/auth/analytics.readonly"))

options("googleAuthR.client_id"=Sys.getenv("GA_CLIENT_ID"))
options("googleAouthR.client_secret"=Sys.getenv("GA_CLIENT_SECRET"))
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/analytics",
                                          "https://www.googleapis.com/auth/analytics.readonly"))

googleAuthR::gar_auth() ## will work without above options, but better for API quotas 

account_list <- ga_account_list()

## SELECT VIEW

ga_id <- account_list %>% filter(viewName=="1BC Beer Main") %>% select(viewId)


### query: filtering and ordering results
start <- "2018-06-01"
end <- "2018-11-30"

## metrics
sess <- "sessions"
pv <- "pageviews"
upv <- "uniquePageviews"
ent <- "entrances"
bounces <- "bounces"
br <- "bounceRate"
exit <- "exits"

metrics <- c(pv,upv,ent,bounces,exit)

## create filters on metrics
mf <- met_filter(pv, "GREATER_THAN", 20)
#mf2 <- met_filter("sessions", "GREATER", 2)

## dimensions
dt <- "date"
yr <- "year"
mth <- "month"
med <- "medium"
src <- "source"
pg <- "pagePath"

dimensions <- c(pg)

## create filters on dimensions
df <- dim_filter(pg,"REGEX","brewery",not=FALSE)
#df2 <- dim_filter("source","BEGINS_WITH","ea",not = TRUE)

## construct filter objects
# fcd <- filter_clause_ga4(list(df, df2), operator = "AND")
# fcm <- filter_clause_ga4(list(mf, mf2), operator = "AND")
fcm <- filter_clause_ga4(list(mf))
fcd <- filter_clause_ga4(list(df))

## construct order type object in format of example:
# order_type(field, sort_order = c("ASCENDING", "DESCENDING"),
#            orderType = c("VALUE", "DELTA", "SMART", "HISTOGRAM_BUCKET",
#                          "DIMENSION_AS_INTEGER"))

ord <- order_type(pv, sort_order="DESCENDING", orderType="VALUE")

ga_data <- google_analytics(ga_id,
                              date_range = c(start,end),
                              metrics=metrics,
                              dimensions=dimensions,
                              met_filters=fcm,
                              dim_filters=fcd,
                              order=ord,
                              max=10000)

### filter out undesirables
ga_data <- ga_data %>%
  filter(!grepl("error",pagePath))


vname <- account_list %>% filter(viewId==as.character(ga_id)) %>% select(viewName)
vname <- gsub(" ", "-", vname, fixed = TRUE)
fname <- paste(vname,"_pgs_",start,"_",end,".csv",sep="")
write.csv(ga_data,fname,row.names=FALSE)

