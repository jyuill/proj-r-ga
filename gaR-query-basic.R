### GA API QUery with googleAnalyticsR pkg
### allows for use of API v4
### https://cran.r-project.org/web/packages/googleAnalyticsR/googleAnalyticsR.pdf
### https://cran.r-project.org/web/packages/googleAnalyticsR/vignettes/googleAnalyticsR.html

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

googleAuthR::gar_auth()

account_list <- google_analytics_account_list()

## pick a profile with data to query
## if you know the row of the viewId
ga_id <- account_list[23,'viewId']
## if you know the viewid
ga_id <- account_list %>% filter(viewId=="85175041") %>% select(viewId)
## if you know the name of the view
ga_id <- account_list %>% filter(viewName=="01 SWBF") %>% select(viewId)
## if you know the general name of view and want to search
## filter for rows, find viewid or name and use one of the commands above
ga_idsearch <- account_list %>% filter(grepl("FIFA",viewName))

### simplest query API v4
ga_data <- google_analytics_4(ga_id,
                              date_range = c("2016-06-01","2016-06-02"),
                              dimensions=c('source','medium'),
                              metrics = c('sessions','bounces'))

### query 2: creating variables outside query for ease of use/reuse
start <- "2016-06-15"
end <- "2016-06-21"

metrics <- c("sessions","bounces","bounceRate")
dimensions <- c("date","medium")

gadata <- google_analytics(id = ga_id,
                           start=start, end=end,
                           metrics = metrics,
                           dimensions = dimensions,
                           max=150) ## default max=100


### query 3: creating lists of possible variables for reference
start <- "2016-06-15"
end <- "2016-06-15"

## metrics
sess <- "sessions"
pv <- "pageviews"
upv <- "uniquePageviews"
bounces <- "bounces"
br <- "bounceRate"

metrics <- c(pv, upv)

## dimensions
dt <- "date"
yr <- "year"
mth <- "month"
med <- "medium"
pg <- "pagePath"

dimensions <- c(dt,pg)

gadata <- google_analytics(id = ga_id,
                           start=start, end=end,
                           metrics = metrics,
                           dimensions = dimensions,
                           max=150) ## default max=100

### query 4: filters
start <- "2016-06-15"
end <- "2016-06-15"

## metrics
sess <- "sessions"
pv <- "pageviews"
upv <- "uniquePageviews"
bounces <- "bounces"
br <- "bounceRate"

metrics <- c(sess)

## create filters on metrics
mf <- met_filter(sess, "GREATER_THAN", 10)
#mf2 <- met_filter("sessions", "GREATER", 2)

## dimensions
dt <- "date"
yr <- "year"
mth <- "month"
med <- "medium"
src <- "source"
pg <- "pagePath"

dimensions <- c(dt,src)

## create filters on dimensions
df <- dim_filter(src,"BEGINS_WITH","e",not=FALSE)
df2 <- dim_filter("source","BEGINS_WITH","ea",not = TRUE)

## construct filter objects
# fcd <- filter_clause_ga4(list(df, df2), operator = "AND")
# fcm <- filter_clause_ga4(list(mf, mf2), operator = "AND")
fcm <- filter_clause_ga4(list(mf))
fcd <- filter_clause_ga4(list(df,df2),operator = "AND")

gadata <- google_analytics(id = ga_id,
                           start=start, end=end,
                           metrics = metrics,
                           dimensions = dimensions,
                           #met_filters = fcm,
                           dim_filters = fcd,
                           max=150) ## default max=100


## create filters on metrics
mf <- met_filter("bounces", "GREATER_THAN", 0)
mf2 <- met_filter("sessions", "GREATER", 2)
## create filters on dimensions
df <- dim_filter("source","BEGINS_WITH","1",not = TRUE)
df2 <- dim_filter("source","BEGINS_WITH","a",not = TRUE)
## construct filter objects
fc2 <- filter_clause_ga4(list(df, df2), operator = "AND")
fc <- filter_clause_ga4(list(mf, mf2), operator = "AND")
## make v4 request
ga_data1 <- google_analytics_4(ga_id,
                               date_range = c("2016-06-20","2016-06-21"),
                               dimensions=c('source','medium'),
                               metrics = c('sessions','bounces'),
                               met_filters = fc,
                               dim_filters = fc2,
                               filtersExpression = "ga:source!=(direct)")
