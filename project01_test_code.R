#####  Loading libraries 


library(stringr)
library(lubridate)
library(forcats)
library(dplyr)
library(ggplot2)

####### Load csv file in df and subsetting "US" company location and job title 
###### "data scientist" into another df for US and data scientist only df

project_df <- read.csv("Week_3/Project1/r project data.csv")

project_df$company_location <- factor(project_df$company_location)
project_df$job_title <- factor(project_df$job_title)
project_df$work_year <- factor(project_df$work_year)

str(project_df)

us_data_sci_df <- subset(project_df, company_location == "US" & job_title == "Data Scientist")
summary (us_data_sci_df)



ggplot(data = us_data_sci_df, aes(work_year, salary_in_usd,
                                  color = experience_level)) +
  geom_jitter() +

  
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







