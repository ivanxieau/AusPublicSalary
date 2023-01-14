library(tidyverse)
library(padr)
library(priceR)
library(lubridate)
library(RCurl)
library(pander)
library(MASS)
library(reshape)
library(reshape2)

# Read all comparison files from GitHub.
urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/PS_Salaries.csv" 
PS_Sal <- read_csv(url(urlfile))
urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/ABS_Salaries.csv"
ABS_Sal <- read_csv(url(urlfile))
urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/Daily_CPI_Inflator.csv" 
CPI <- read_csv(url(urlfile))

# Convert ABS Salaries from weekly to annual
ABS_Sal$Salary <- as.numeric(ABS_Sal$Salary/7*365.25)

# Cleaning and combining dataframes
CPI$Date <- as.Date(CPI$Date, "%d/%m/%Y")
PS_Sal <- subset(PS_Sal, select = -c(Grade))
Salaries <- rbind(PS_Sal, ABS_Sal)
Salaries$Date <- as.Date(Salaries$Date, "%d/%m/%Y")
Salaries <- left_join(Salaries, CPI, by = "Date")
Salaries <- subset(Salaries, select = -c(SAdj_CPI_Index, Daily_CPI))
Salaries$Inflator <- as.numeric(gsub("%","",Salaries$Inflator))
Salaries$Inflator <- as.numeric(Salaries$Inflator/100)
Salaries <- Salaries %>% mutate(Salary_Real = Salary * (1 + Inflator/100))

# Summarise PS Salaries by Min, Max and Mean for each unique class./juris./date
Salaries <- Salaries %>% 
  group_by(Occ_Class, Jurisdiction, Date) %>%
  summarize(Min = min(Salary_Real),
            Max = max(Salary_Real),
            Mean = mean(Salary_Real))

# Clean and print final dataframes
Salaries <- na.omit(Salaries)

