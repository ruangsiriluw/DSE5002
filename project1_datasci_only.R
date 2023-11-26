################################################################################
################################################################################


library(stringr)
library(dplyr)
library(ggplot2)
library(scales)
library(lubridate)
library(gt)


project1_df <- read.csv("Project1/r project data.csv")

####### Checking data, change some col into factor to reorder values and plot
salary_df <- project1_df %>%
  mutate_at(vars('company_location', 'experience_level', 'company_size')
            , as.factor) %>%
  mutate(experience_level = factor(experience_level, levels = c('EN', 'MI', 'SE', 'EX')),
         company_size = factor(company_size, levels = c('S', 'M', 'L')))

################################################################################
################################################################################

#### Subseting df to remove unnecessary cols of salary and currency and grab only FT

salary_ft_df <- subset(salary_df, employment_type == "FT")
salary_ft_df <- select(salary_ft_df, -c('salary', 'salary_currency'))



### Add columns, breaking codes for country + continent in a table and join to the main df
###  For company location and residence
library(countrycode)

company_loc <- data.frame(company_location = unique(salary_ft_df$company_location))

company_loc <- company_loc %>%
  mutate(
    comp_continent = countrycode(sourcevar = company_location, origin = 'iso2c', 
                                 destination = 'continent'),
    comp_country = countrycode(sourcevar = company_location, origin = 'iso2c', 
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
salary_ft_df <- salary_ft_df[, c(1:7, 13, 14, 8:9, 11,12, 10)]

##############################################################################
##############################################################################

################### ################### ################### ################### 
################### Exp Level labels for facets  ################### 

explevel_labs = c('Entry-level','Mid-level','Senior-level','Executive-level')
names(explevel_labs) = c('EN','MI','SE','EX')              


################################################################################
################################################################################


########## Focusing on the Data Scientist ONLY for US and non-US res employee ##########
### sub-setting only for DS-related title:

ds_df <- salary_ft_df[grepl('Scien', salary_ft_df$job_title, ignore.case = TRUE) & 
                             grepl('Data', salary_ft_df$job_title, ignore.case = TRUE),  ] 

ds_df <- ds_df %>%
  mutate(is_us_res = ifelse(grepl("US", ds_df$employee_residence), "US", "Non-US"))

ds_df$job_title <- as.factor(ds_df$job_title)
summary(ds_df$job_title)


###################
#################  IQR summary of DS empl by residence and title

ds_df_stat <- ds_df %>%
  group_by(is_us_res, job_title) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())

#################  IQR summary of DS US-res empl by Exp Level

library(gt)
ds_df_stat_gt <- gt(ds_df_stat) %>%
  fmt_currency(columns = 3:7, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of data scientists from
             US and nonUS employee residence") %>%
  cols_label(
    job_title = 'Job Title',
    q25 = 'Q1 25%',
    median = 'Median',
    q75 = 'Q3 75%',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
  ) 
ds_df_stat_gt
gtsave(ds_df_stat_gt, "ds_df_stat.png")

################################################################################
################### BOX plot to compare US vs nonUS Data Scientist ###############

ds_df %>%
  ggplot(aes(x=salary_in_usd, y=is_us_res, color = is_us_res)) +
  geom_boxplot() +
  facet_wrap( ~ experience_level,
               labeller = labeller(experience_level = explevel_labs), ncol = 1) +
  scale_x_continuous(labels = scales::dollar_format()) + 
  scale_y_discrete(limits=c("US", "Non-US")) +
  labs(title = 
         strwrap('Comparison salary distribution US vs non-US residence employee'),
       x = 'Salary (USD)', color = 'Employee Residence') +
  theme(plot.title = element_text(size = 15, hjust = 0.5),
        axis.text.x = element_text(size = 10, face = 'bold'),
        axis.title.x = element_text(size = 12, face = 'bold'),
        axis.text.y = element_text(face = 'bold'),
        axis.title.y = element_blank(),
        legend.text = element_text(size = 9),
        legend.title=element_text(size=9, face = 'bold'),
        legend.box.background = element_rect(color='black', fill='transparent'),
        legend.background = element_rect(fill = 'transparent'),
        legend.position = c(0.9,0.9),
        strip.text.x = element_text(size=11, face = 'bold')) +
  geom_point(alpha = 0.5)

##########################################









###########  DO NOT NEED //////////////////////
################################################################################
################################################################################

us_res_ds %>%
  ggplot(aes(x = experience_level, y = salary_in_usd, color = experience_level)) +
  geom_boxplot() +
  labs(title = stringr::str_wrap('Salary range of US residence data scientist based on experience levels'), 
       x = 'Experience Level', y = 'Salary (USD)', col = 'Experience Level:  ') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 20, hjust = 0.5, vjust = 1), 
        axis.title.x = element_text(size = 15),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 15),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 11),
        legend.title = element_text(size=13),
        legend.position = 'bottom'
  ) +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                  , 'Executive-level')) +
  geom_point(alpha = 0.5) +
  geom_jitter(alpha = 0.5, position = position_jitter(width = .2)) 


################################################################################
# Side by side columns
ds_df %>%
  ggplot() +
  geom_col(aes(x = work_year, y=salary_in_usd, fill = is_us_res),
           position = "dodge",
           alpha = 0.5) +
  facet_wrap( ~ job_title,
              ncol = 3)


###########  Test Facet by title for DS US-residence ################ 
################  ################  ################  ################  
us_res_ds %>%
  ggplot(aes(x = experience_level, y = salary_in_usd, color = experience_level)) +
  geom_boxplot() +
  labs(title = stringr::str_wrap('Salary range of US residence data scientist based on experience levels'), 
       x = 'Experience Level', y = 'Salary (USD)', col = 'Experience Level:  ') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 20, hjust = 0.5, vjust = 1), 
        axis.title.x = element_text(size = 15),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 15),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 11),
        legend.title = element_text(size=13),
        legend.position = 'bottom'
  ) +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                  , 'Executive-level'))



