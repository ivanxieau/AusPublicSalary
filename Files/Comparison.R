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
urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/Salaries.csv" 
Salaries <- read_csv(url(urlfile))
urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/ABS_Pay_Data.csv"
Occp <- read_csv(url(urlfile))
urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/Daily_CPI_Inflator.csv" 
CPI <- read_csv(url(urlfile))

# Melt ABS dataframe
Occp <- melt(Occp, id = c("Code", "Occupation", "Date"))
Occp <- na.omit(Occp)

write.csv(Occp, "C:\\Users\\ivanx\\Desktop\\O.csv", row.names=FALSE)

# Clean CPI dataframe
CPI$Date <- as.Date(CPI$Date, "%d/%m/%Y")

# Combining PS Salaries and CPI dataframes
Salaries <- left_join(Salaries, CPI, by = "Date")
Salaries <- subset(Salaries, select = -c(Grade, SAdj_CPI_Index, Daily_CPI))
Salaries$Inflator <- as.numeric(gsub("%","",Salaries$Inflator))
Salaries$Inflator <- as.numeric(Salaries$Inflator/100)
Salaries <- Salaries %>% mutate(Salary_Real = Salary * (1 + Inflator/100))

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


print(PS_Summ)
print(Oc_Summ)
