library(tidyverse)

# Makes a list of all Salary Comparison files in GitHub.
df <-
  data_frame(files = list.files(path = "./yourfilepath",    
                                pattern = "csv", 
                                full.names = T)) %>%
  mutate(dfs = map(files, read_csv, skip = 25)) %>%       
  unnest() %>% 
  mutate(cities = str_replace_all(files, "./yourfilepath/", ""),
         cities = str_replace_all(cities, ".csv", ""))