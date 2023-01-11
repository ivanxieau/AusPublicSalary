library(tidyverse)
library(dplyr)
library(rvest)
library(RCurl)
library(pander)
library(MASS) 
library(reshape2) 
library(reshape) 

# Reads all Salary Comparison CSV files in GitHub.

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/ACTPS%20EA%20Salaries.csv" 
ACT_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/APS%20Remuneration%20Data.csv" 
Cwth_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/NSWPS%20Award%20Salaries.csv" 
NSW_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/VPS%20EA%20Salaries.csv" 
Vic_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/QPS%20CA%20Salaries.csv" 
Qld_df <- read_csv(url(urlfile))


# I need to melt/cast the data since the dates go out -> this way but something isn't working, check code.


ACT_df1 <- melt(ACT_df, id.vars =  c("Grade", "Classification", "Jurisdiction")) 

print(ACT_df1) 


