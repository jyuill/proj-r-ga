##### PREFERRED: USE googleanalyticsR package - example files gaR...
####### leverages API v4 and other newer features

### R + GOOGLE ANALYTICS: QUERY
#### Using RGA Package developed by Artem Klevtsov
#### THIS FILE ASSUMES AUTHORIZATION HAS ALREADY BEEN DONE
#### Refer to r-ga-authorize (or similar) for authorization process

library(dplyr) # for dataset manipulation
library(ggplot2) # for datavisualization
# if list of profiles not already retrieved
ga_profiles <- list_profiles()
# reduce list to most relevant columns
ga_profilecols <- select(ga_profiles,id,webPropertyId,name,websiteUrl)

### Queries are performed using GA View number
### Find desired view(S):
## find Views by UA number, based on partial number:
views <- filter(ga_profilecols,grepl("1059",webPropertyId,ignore.case=TRUE))
## find Views by partial View name:
search <- "main" # can use regex
views <- filter(ga_profilecols,grepl(search,name,ignore.case = TRUE ))

## Select View name for easy recognition
## either provide name directly, or use coordinates in views tbl
viewname <- as.character(views[1,3]) # [row,column]
#viewname <- "[desired view name]"
idnum <- views[1,1]
# get view id from first column of ga_profilecols table, based on view name
idrow <- filter(ga_profilecols,name==viewname)
idnum <- as.character(idrow[1,1])

# SET DATES: start and end dates
startdate <- "2016-05-01"
enddate <- "2016-05-31"

## SELECT METRICS to use - see complete Dimensions & Metrics:
## https://developers.google.com/analytics/devguides/reporting/core/dimsmets 
## general list of common metrics
users <- "ga:users"
sess <- "ga:sessions"
pv <- "ga:pageviews"
upv <- "ga:pageviews"
newvisits <- "ga:newVisits"
bounces <- "ga:bounces"
avgtos <- "ga:avgTimeOnSite"
eventt <- "ga:totalEvents"
eventu <- "ga:uniqueEvents"
## combine as desired
metrics <- paste(c(users,sess,pv,avgtos),collapse=",")

## SELECT DIMENSIONS
## general list
gadate <- "ga:date"
pages <- "ga:pagePath"
gahour <- "ga:hour"
## combine as desired
dimensions <- paste(c(gadate))

## APPLY FILTERS


#### QUERY GA
## get GA report data
## Example: general stats by date
ga_data <- get_ga(idnum2, start.date = startdate, end.date = enddate,
                  metrics = metrics,
                  dimensions = dimensions,
                  segment="",
                  filters="",)
ga_data$view <- viewname # add view name to data set for clarity

## Quick table of totals using dplyr
ga_data %>% summarize(uttl=sum(users),
                      sttl=sum(sessions),
                      pvttl=sum(pageviews))
## Quick chart of users using ggplot
ggplot(ga_data,aes(x=date,y=users))+geom_line()+theme_bw()

## Example: pageviews by page for period
metrics <- paste(c(pv,bounces),collapse=",")
dimensions <- paste(c(pages))
pages <- get_ga(idnum2, start.date = startdate, end.date = enddate,
                  metrics = metrics,
                  dimensions = dimensions,
                  segment="",
                  filters="",)
pages$view <- viewname # add view name to data set for clarity

