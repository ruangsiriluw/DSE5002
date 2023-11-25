
#####  Loading libraries 


library(stringr)
library(lubridate)
library(forcats)
library(dplyr)
library(ggplot2)

####### Load csv file in df and subsetting US company location info into 
###### another df for US only df

project_df <- read.csv("Week_3/Project1/r project data.csv")

project_df$company_location <- factor(project_df$company_location)
us_location_df <- project_df[project_df$company_location == "US", ]


##### Subsetting job title to focus only data scientist title with in US

us_location_df$job_title <- factor(us_location_df$job_title)
summary(us_location_df$job_title)

us_data_sci_df <- us_location_df[us_location_df$job_title == "Data Scientist", ]

ggplot(us_location_df, aes(x=company_size, y=salary_in_usd, 
                           col=experience_level)) + 
  geom_point()



