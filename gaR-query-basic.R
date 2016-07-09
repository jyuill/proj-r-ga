### GA API QUery with googleAnalyticsR pkg
### allows for use of API v4
### https://cran.r-project.org/web/packages/googleAnalyticsR/googleAnalyticsR.pdf
### https://cran.r-project.org/web/packages/googleAnalyticsR/vignettes/googleAnalyticsR.html

library(googleAuthR)
library(googleAnalyticsR)
library(dplyr)

options("googleAuthR.client_id" = "553048728025-tel41p2njvq0afl561lg2et405l433mv.apps.googleusercontent.com")
options("googleAuthR.client_secret" = "wAr4nbY83-xcwu5f17ZiuB-h")
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/analytics",
                                          "https://www.googleapis.com/auth/analytics.readonly"))

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

gadata <- google_analytics(id = ga_id,
                           start="2016-06-01", end="2016-06-02",
                           metrics = c("sessions", "bounceRate"),
                           dimensions = c("source", "medium"),
                           max=150)



