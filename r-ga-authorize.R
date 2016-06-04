### R + GOOGLE ANALYTICS: AUTHORIZING
#### Using RGA Package developed by Artem Klevtsov
#### Other packages are available - this is the most robust and current one I have found
#### for accesing various GA APIs
#### manual: https://cran.r-project.org/web/packages/RGA/RGA.pdf 
#### Github: https://github.com/artemklevtsov/RGA 

#### This file assumes basic knowledge of R - how to get/install packages, etc
#### Also assumes basic familiarity with Google Analytics and GA API.
#### v3 documentation: https://developers.google.com/analytics/devguides/reporting/core/v3/

## 1. AUTHORIZE - Get credentials
## Need to get Google API CLIENT.ID and CLIENT SECRET
## to authorize use of API by requesting access to your account via browser 
## best way is with client.id and client secret
## Go to Google Developers Console and either set up credentials (if not already set up) or grab existing credentials
## A. Set up credentials - if needed, otherwise skip to B.
##   1. Go to Google Developers Console > Create or Select a Project
##   2. Enabled APIs > Enable Analytics API (if not already - else, skip to B.)
##   3. 'Credentials' (left menu) > Create credentials > OAuth client ID
##   4. Select 'Other' and provide name > client.id and client.secret will be provided > copy/paste in the code below
##   - use instructions below to retrieve in future, if necessary
## B. Find client.id / client.secret:
##   1. Go to Google Developers Console > Select Project
##   2. Credentials (left menu) > click on item in list
##   3. Copy/paste client.id and client secret in-line below

## 2. load RGA
library(RGA)
## 3. authorize with client.id and client secret
ga_token <- authorize(client.id="[YOUR CLIENT.ID HERE]",
                      client.secret="[YOUR CLIENT SECRET HERE]")

## 4. Get list of GA accounts / propreties / views associated with credentials
## to confirm correct data access
ga_profiles <- list_profiles()

#### READY TO GO!
##### RUN QUERIES AND ANALYZE DATA IN OTHER FILES
