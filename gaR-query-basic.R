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

### simplest query
gadata <- google_analytics(id = ga_id,
                           start="2016-06-01", end="2016-06-02",
                           metrics = c("sessions", "bounceRate"),
                           dimensions = c("source", "medium"),
                           max=150) ## default max=100

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





