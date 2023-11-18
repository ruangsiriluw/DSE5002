#####  Loading libraries 


library(stringr)
library(lubridate)
library(dplyr)
library(ggplot2)

####### Load csv file in df and subsetting "US" company location and job title 

project_df <- read.csv("Week_3/Project1/r project data.csv")

####### Checking data and turn some col into factor to check categories
project_df$company_location <- factor(project_df$company_location)


#####  Filter only data scientist-related job title
project_df$job_title <- factor(project_df$job_title)
datasci_all_df <- project_df[grep('Scien', project_df$job_title, ignore.case = TRUE), ]
summary(datasci_all_df$job_title)



###### sub-setting df for US-based company only into another df
us_location_df <- subset(datasci_all_df, company_location == "US")
str(us_location_df)
us_location_df$job_title <- factor(USArrests$job_title) 



test$job_title <- factor(test$job_title)

summary(test$job_title)

ggplot(project_df)+
  geom_boxplot(aes(work_year, salary_in_usd, color = experience_level))








  
## Test boxplot
ggplot(data = us_data_sci_df, aes(work_year, salary_in_usd,
                                  color = experience_level)) +
  geom_boxplot() 

##-------- xy scatter with linear regresssion method, but data points are too few
ggplot(data = us_data_sci_df, aes(remote_ratio, salary_in_usd,
                                  color = experience_level)) +
  geom_point() +
  geom_smooth(method = lm)

##--------------







