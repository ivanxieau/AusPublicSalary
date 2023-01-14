library(tidyverse)
library(padr)
library(lubridate)
library(RCurl)
library(pander)
library(MASS)
library(reshape)
library(reshape2)

# Read all Salary Comparison CSV files in GitHub.
urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/APS%20Remuneration%20Data.csv" 
Cwth_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/NSWPS%20Award%20Salaries.csv" 
NSW_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/VPS%20EA%20Salaries.csv" 
Vic_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/QPS%20CA%20Salaries.csv" 
Qld_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/WACS-A%20Salaries.csv" 
WA_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/SAPS%20EA%20Salaries.csv" 
SA_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/TSS%20WA%20Salaries.csv" 
Tas_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/ACTPS%20EA%20Salaries.csv" 
ACT_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/NTPS%20EA%20Salaries.csv" 
NT_df <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/PublicSector_Australia/main/Salary%20Agreements/CPI.csv" 
CPI <- read_csv(url(urlfile))

# Melt dataframes
Cwth_df <- melt(Cwth_df, id = c("Grade", "Classification", "Jurisdiction"))
NSW_df <- melt(NSW_df, id = c("Grade", "Classification", "Jurisdiction"))
Vic_df <- melt(Vic_df, id = c("Grade", "Classification", "Jurisdiction"))
Qld_df <- melt(Qld_df, id = c("Grade", "Classification", "Jurisdiction"))
WA_df <- melt(WA_df, id = c("Grade", "Classification", "Jurisdiction"))
SA_df <- melt(SA_df, id = c("Grade", "Classification", "Jurisdiction"))
Tas_df <- melt(Tas_df, id = c("Grade", "Classification", "Jurisdiction"))
ACT_df <- melt(ACT_df, id = c("Grade", "Classification", "Jurisdiction"))
NT_df <- melt(NT_df, id = c("Grade", "Classification", "Jurisdiction"))

# Combine dataframes
Salaries <- rbind(Cwth_df, NSW_df, Vic_df, Qld_df, WA_df, SA_df, Tas_df, ACT_df, NT_df)

# Clean Salaries dataframe
Salaries$Date <- as.Date(Salaries$variable, "%d/%m/%Y")
colnames(Salaries)[5] ="Salary"
Salaries <- subset(Salaries, select = -c(variable))

# Clean CPI dataframe (Converting data types, insert missing months, creating new Monthly CPI variable)
