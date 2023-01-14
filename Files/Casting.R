library(tidyverse)

# Read all comparison files from GitHub.
urlfile ="https://raw.githubusercontent.com/ivanxieau/Australian_Public_Sector/main/Files/Combined_Salaries.csv" 
Salary <- read_csv(url(urlfile))

Salary$Date <- as.Date(Salary$Date, "%d/%m/%Y")

Salary <- cast(Salary, Date ~ Occupation, mean, value = 'Salary')

write.csv(Salary, "C:\\Users\\ivanx\\Documents\\Github\\Australian Public Sector\\Files\\Combined_Salaries.csv", row.names=FALSE)