### General space for working things out, creating examples, etc
### Based on:
## 1. authorizing GA API access
## 2. running one or more queries to have data available

ggplot(ga_data,aes(x=pageviews))+geom_histogram()+theme_bw()
