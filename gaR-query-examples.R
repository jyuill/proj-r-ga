### GA API QUery EXAMPLES with googleAnalyticsR pkg
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

googleAuthR::gar_auth() ## will work without above options, but better for API quotas 

account_list <- google_analytics_account_list()

## pick a profile with data to query
## if you want to view account list and maybe copy a reference for use in one of the options below
view(account_list)
## if you know the row of the viewId
ga_id <- account_list[3,'viewId']
## if you know the viewid
ga_id <- account_list %>% filter(viewId=="6571219") %>% select(viewId)
## if you know the name of the view
ga_id <- account_list %>% filter(viewName=="1BC Beer Main") %>% select(viewId)
## if you know the general name of view and want to search
## filter for rows, find viewid or name and use one of the commands above
ga_idsearch <- account_list %>% filter(grepl("BC Beer",viewName))


### query 1: simplest query API v4
ga_data <- google_analytics_4(ga_id,
                              date_range = c("2016-10-01","2016-10-10"),
                              dimensions=c('source','medium'),
                              metrics = c('sessions','bounces'))

### query 2: creating variables outside query for ease of use/reuse
start <- "2016-06-15"
end <- "2016-06-21"

metrics <- c("sessions","bounces","bounceRate")
dimensions <- c("date","medium")

ga_data <- google_analytics_4(ga_id,
                              date_range = c(start,end),
                              metrics=metrics,
                              dimensions=dimensions)

### query 3: creating lists of possible variables for reference
start <- "2016-10-10"
end <- "2016-10-10"

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

ga_data <- google_analytics_4(ga_id,
                              date_range = c(start,end),
                              metrics=metrics,
                              dimensions=dimensions)


### query 4: filters
start <- "2016-06-15"
end <- "2016-06-15"

## metrics
sess <- "sessions"
pv <- "pageviews"
upv <- "uniquePageviews"
ent <- "entrances"
bounces <- "bounces"
br <- "bounceRate"
exit <- "exits"

metrics <- c(pv,upv,bounces)

## create filters on metrics
mf <- met_filter(pv, "GREATER_THAN", 2)
#mf2 <- met_filter("sessions", "GREATER", 2)

## dimensions
dt <- "date"
yr <- "year"
mth <- "month"
med <- "medium"
src <- "source"
pg <- "pagePath"

dimensions <- c(dt,pg)

## create filters on dimensions
df <- dim_filter(pg,"REGEX","brewery",not=FALSE)
#df2 <- dim_filter("source","BEGINS_WITH","brew",not = TRUE)

## construct filter objects
# fcd <- filter_clause_ga4(list(df, df2), operator = "AND")
# fcm <- filter_clause_ga4(list(mf, mf2), operator = "AND")
fcm <- filter_clause_ga4(list(mf))
fcd <- filter_clause_ga4(list(df))

ga_data <- google_analytics_4(ga_id,
                              date_range = c(start,end),
                              metrics=metrics,
                              dimensions=dimensions,
                              met_filters=fcm,
                              dim_filters=fcd)


####### FILTER EXAMPLE: create filters on mutliple metrics and dimensions
# mf <- met_filter("bounces", "GREATER_THAN", 0)
# mf2 <- met_filter("sessions", "GREATER", 2)
# ## create filters on dimensions
# df <- dim_filter("source","BEGINS_WITH","1",not = TRUE)
# df2 <- dim_filter("source","BEGINS_WITH","a",not = TRUE)
# ## construct filter objects
# fc2 <- filter_clause_ga4(list(df, df2), operator = "AND")
# fc <- filter_clause_ga4(list(mf, mf2), operator = "AND")
######## END OF EXAMPLE CODE

### query 5: ordering results - single parameter
start <- "2016-06-15"
end <- "2016-06-15"

## metrics
sess <- "sessions"
pv <- "pageviews"
upv <- "uniquePageviews"
ent <- "entrances"
bounces <- "bounces"
br <- "bounceRate"
exit <- "exits"

metrics <- c(pv,upv,bounces)

## create filters on metrics
mf <- met_filter(pv, "GREATER_THAN", 1)
#mf2 <- met_filter("sessions", "GREATER", 2)

## dimensions
dt <- "date"
yr <- "year"
mth <- "month"
med <- "medium"
src <- "source"
pg <- "pagePath"

dimensions <- c(dt,pg)

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

ga_data <- google_analytics_4(ga_id,
                              date_range = c(start,end),
                              metrics=metrics,
                              dimensions=dimensions,
                              met_filters=fcm,
                              dim_filters=fcd,
                              order=ord)


