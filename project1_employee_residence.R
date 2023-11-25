################################################################################
################################################################################

library(ggplot2)
library(dplyr)
library(lubridate)

project1_df <- read.csv("Project1/r project data.csv")

####### Checking data, change some col into factor to reorder values and plot
salary_df <- project1_df %>%
  mutate_at(vars('company_location', 'work_year', 'experience_level', 'company_size')
            , as.factor) %>%
  mutate(experience_level = factor(experience_level, levels = c('EN', 'MI', 'SE', 'EX')),
         company_size = factor(company_size, levels = c('S', 'M', 'L')))

################################################################################
################################################################################

#### Subseting df to remove unnecessary cols of salary and currency and grab only FT

salary_ft_df <- subset(salary_df, employment_type == "FT")
salary_ft_df <- select(salary_ft_df, -c('salary', 'salary_currency'))



### Add columns, breaking codes for country + add continent in a table and join to the main df
###  For company location and residence
library(countrycode)

company_loc <- data.frame(company_location = unique(salary_ft_df$company_location))

company_loc <- company_loc %>%
  mutate(
    comp_country = countrycode(sourcevar = company_location, origin = 'iso2c', 
                            destination = 'continent'),
    comp_continent = countrycode(sourcevar = company_location, origin = 'iso2c', 
                               destination = 'country.name')
  )

salary_ft_df <- salary_ft_df %>%
  left_join(company_loc, by = 'company_location')

empl_res <- data.frame(employee_residence = unique(salary_ft_df$employee_residence))

empl_res <- empl_res %>%
  mutate(
    empl_continent = countrycode(sourcevar = employee_residence, origin = 'iso2c', 
                            destination = 'continent'),
    empl_country = countrycode(sourcevar = employee_residence, origin = 'iso2c', 
                               destination = 'country.name')
  )
salary_ft_df <- salary_ft_df %>%
  left_join(empl_res, by = 'employee_residence')

####  REORDER empl_country column:
salary_ft_df <- salary_ft_df[, c(1:7, 14, 13, 8:9, 11,12, 10)]

##############################################################################
##############################################################################

# Sepearate between US vs Non-US employee residence to get statistics

salary_us_res <- subset(salary_ft_df, employee_residence == "US")
salary_nonus_res <- subset(salary_ft_df, employee_residence != "US")

salary_us_res_stat <- salary_us_res %>%
  group_by(experience_level) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())

#####  Get summary salary range data table
library(gt)
salary_us_res_stat_gt <- gt(salary_us_res_stat) %>%
  fmt_currency(columns = 2:6, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of all US employee residence by experience level") %>%
  cols_label(
    experience_level = 'Experience Level',
    q25 = 'Q1 25%',
    median = 'Median',
    q75 = 'Q3 75%',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
  ) %>%
  tab_footnote(
    footnote = "EN: Entry-level, MI: Mid-level, SE: Senior-level, EX: Executive-level/Director",
    locations = cells_column_labels(columns = 'experience_level')
  )
salary_us_res_stat_gt
gtsave(salary_us_res_stat_gt, "salary_us_res_stat_gt.png")


### Boxplot of this





