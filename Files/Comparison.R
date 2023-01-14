library(tidyverse)
library(padr)
library(priceR)
library(lubridate)
library(RCurl)
library(pander)
library(MASS)
library(reshape)
library(reshape2)

# Read all Salary Comparison CSV files in GitHub.

urlfile ="XXXX" 
Salaries <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/ABS_Pay_Data.csv"
Occp <- read_csv(url(urlfile))

urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/Daily_CPI_Inflator.csv" 
CPI <- read_csv(url(urlfile))

# Melt ABS dataframe
Occp <- melt(Occp, id = c("Code", "Occupation", "Date"))

# Clean CPI dataframe
CPI$Date <- as.Date(CPI$Date, "%d/%m/%Y")

# Combining PS Salaries and CPI dataframes
PS_Salaries <- left_join(PS_Salaries, CPI, by = "Date")
PS_Salaries <- subset(PS_Salaries, select = -c(Grade, SAdj_CPI_Index, Daily_CPI))
PS_Salaries$Inflator <- as.numeric(gsub("%","",PS_Salaries$Inflator))
PS_Salaries$Inflator <- as.numeric(PS_Salaries$Inflator/100)
PS_Salaries <- PS_Salaries %>% mutate(Salary_Real = Salary * (1 + Inflator/100))

# Combining Occupation and CPI dataframes, convert weekly to annual salaries
Occp <- left_join(Occp, CPI, by = "Date")
Occp <- subset(Occp, select = -c(SAdj_CPI_Index, Daily_CPI))
colnames(Occp)[4] ="Pay_Setting"
colnames(Occp)[5] ="Earnings"
Occp$Earnings <- as.numeric(Occp$Earnings/7*365.25)
Occp$Inflator <- as.numeric(gsub("%","",Occp$Inflator))
Occp$Inflator <- as.numeric(Occp$Inflator/100)
Occp <- Occp %>% mutate(Salary_Real = Earnings * (1 + Inflator/100))

# Summarise PS Salaries by Min, Max and Mean for each unique class./juris./date
PS_Summ <- PS_Salaries %>% 
  group_by(Classification, Jurisdiction, Date) %>%
  summarize(Min = min(Salary_Real),
            Max = max(Salary_Real),
            Mean = mean(Salary_Real))

# Clean and print final dataframes
PS_Summ <- na.omit(PS_Summ)
Oc_Summ <- na.omit(Occp)

print(PS_Summ)
print(Oc_Summ)
