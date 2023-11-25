#####  Loading libraries 

library(stringr)
library(lubridate)
library(dplyr)
library(ggplot2)
library(scales)

####### Load csv file in df 

project_df <- read.csv("Project1/r project data.csv")

####### Checking data and turn some col into factor to check categories
project_df$company_location <- factor(project_df$company_location)
project_df$work_year <- as.character(project_df$work_year)
project_df$experience_level <- factor(project_df$experience_level, 
                                        levels = c('EN', 'MI', 'SE', 'EX'))


#////////////////Working only "data scientist-related" job title of all
project_df$job_title <- factor(project_df$job_title)
datasci_all_df <- project_df[grepl('Scien', project_df$job_title, ignore.case = TRUE) & 
                               grepl('Data', project_df$job_title, ignore.case = TRUE),  ]

levels(datasci_all_df$job_title)

##### Looking across DS title by experience

us_all_datasc_sum <- datasci_all_df %>%
  group_by(job_title, experience_level, work_year) %>%
  summarize(avg_sal_yr = mean(salary_in_usd))
print(us_all_datasc_sum)


#/////////Boxplot to see salary from all Data-Sci related title by exp level / year
datasci_all_df %>%
  ggplot(aes(x = work_year, y = salary_in_usd, color = experience_level)) +
  geom_boxplot() +
  facet_grid(. ~ experience_level) +
  labs(title = 'Salary per year of all data scientist-related titles with different experience levels',
       x = 'Work Year', y = 'Salary (USD)', col = 'Experience: ') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(hjust = 0.5), 
        legend.text = element_text(size = 10),
        legend.position = 'top') +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level', 'Executive-level')) +
  geom_point(alpha = 0.5)

 

#/////////////////////////////////////////////////////////////////////////////


###### sub-setting df for 'US-location' only 'data scientist' into another df
us_datasc_df <- subset(datasci_all_df, company_location == "US" & job_title == "Data Scientist")

# Make work_year into character so that it will graph solid year
us_datasc_df$work_year = as.character(us_datasc_df$work_year)
print(us_datasc_df)

# Check level of experiences:  only has 3 level EN, MI, SE
us_datasc_df$experience_level <- factor(us_datasc_df$experience_level, 
                                        levels = c('EN', 'MI', 'SE', 'EX'))


us_datasc_df %>%
  ggplot(aes(x = work_year, y = salary_in_usd, color = experience_level)) +
  geom_boxplot()+
  geom_jitter(alpha = 0.7) +
  facet_grid(.~experience_level)


### Getting quantile from US Data Scientist only, per company size and exp level

quant_us_datasc <- us_datasc_df %>%
  group_by(experience_level, company_size) %>%
  summarise(
    q25_usd = quantile(salary_in_usd, 0.25),
    median_usd = quantile(salary_in_usd, 0.5),
    q75_usd = quantile(salary_in_usd, 0.75)
  )
write.csv(quant_us_datasc_exp, 'quantile us data scientist experience.csv')



######### Quantile regardless of company size
quant_us_datasc_exp <- us_datasc_df %>%
  group_by(experience_level) %>%
  summarise(
    q25_usd = quantile(salary_in_usd, 0.25),
    median_usd = quantile(salary_in_usd, 0.5),
    q75_usd = quantile(salary_in_usd, 0.75)
  )


print(quant_us_datasc)







######  Summary of Mean DONOT USE yet #########
us_datasc_summary <- us_datasc_df %>%
  group_by(experience_level, work_year) %>%
  summarize(avg_sal_yr = mean(salary_in_usd))
################################################



levels(us_datasc_df$experience_level)

summary(us_datasc_df)

ggplot(project_df) +
  geom_boxplot(aes(x = work_year, y = salary_in_usd, color = experience_level)) +
  scale_fill_manual()
  facet_grid(.~experience_level) 









  
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







