################################################################################
################################################################################

library(ggplot2)
library(dplyr)
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
################################################################################


################### ################### ################### ################### 
################### Exp Level labels for facets  ################### 

explevel_labs = c('Entry-level','Mid-level','Senior-level','Executive-level')
names(explevel_labs) = c('EN','MI','SE','EX')              

################### ################### ################### ###################
################### ################### ################### ###################


######################################################################
#################### IQR Stats ################### ###################
################## compare US vs nonUS residence salary side by side

employee_res_df <- select(salary_ft_df, 'experience_level', 'salary_in_usd', 
                          'employee_residence','empl_continent', 
                          'company_location', 'comp_continent') 
employee_res_df <- employee_res_df %>%
  mutate(is_us_res = ifelse(grepl("US", employee_res_df$employee_residence), "US", "Non-US"))

################ Summary IQR table
employee_res_df_comp <- employee_res_df %>%
  group_by(is_us_res, experience_level) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())
employee_res_df_comp

##################  Make gt summary table US vs NON US:
employee_res_df_comp_gt <- gt(employee_res_df_comp) %>%
  fmt_currency(columns = 2:6, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) comparing US and non-US residence employee by experience level") %>%
  cols_label(
    is_us_res = 'Employee Residence',
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
employee_res_df_comp_gt 
gtsave(employee_res_df_comp_gt, "employee_res_df_comp_gt.png")


##########################################################################
#########  Density + Histogram plot based on US vs NON-US employee res #####
employee_res_df %>%
  ggplot() +
  geom_density(aes(x=salary_in_usd, fill = is_us_res), 
               alpha = 0.5) +
  facet_grid ( ~ experience_level,
              labeller = labeller(experience_level = explevel_labs)) +
  scale_x_continuous(labels = scales::dollar_format()) + 
  labs(title = 'Comparison salary distribution US vs non-US residence employee',
       x = 'Salary (USD)', y = 'Density', fill = 'Employee Residence') +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 8, angle = 45, hjust = 1),
        legend.text = element_text(size = 8),
        legend.title=element_text(size=10),
        legend.position = 'right') +
geom_histogram(aes(x=salary_in_usd, y = ..density.., fill = is_us_res), 
               alpha = 0.3)

##########################################################################
##########################################################################


#######################From here US vs Non-US residence analysis
# Sepearate between US vs Non-US employee residence for ploting#######

salary_us_res <- subset(salary_ft_df, employee_residence == "US")
salary_nonus_res <- subset(salary_ft_df, employee_residence != "US")

######################################################################


############# US RESIDENCE ONLY  Boxplot of this data US employee by Exp level

salary_us_res %>%
  ggplot(aes(x = experience_level, y = salary_in_usd, color = experience_level)) +
  geom_boxplot() +
  coord_flip() +
  labs(title = stringr::str_wrap('Salary range of US employee residence based on experience levels'), 
       x = 'Experience Level', y = 'Salary (USD)', col = 'Experience Level') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 20, hjust = 1, vjust = 1), 
        axis.title.x = element_text(size = 15),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 15),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.title = element_text(size=12),
        legend.position = c(0.9,0.2)
  ) +
  scale_color_discrete(limits = c('EX', 'SE', 'MI', 'EN'),
                       labels = c('Executive-level', 'Senior-level',
                                  'Mid-level', 'Entry-level')) +
  geom_point(alpha = 0.5) +
  geom_jitter(alpha = 0.5, position = position_jitter(width = .2)) 

######################################################################
######################  Add Density + Histogram Plot US-res empl by Exp Level

library(wesanderson)
salary_us_res %>%
  ggplot() +
  geom_density(aes(x=salary_in_usd, fill = experience_level), 
               alpha = 0.4) +
  scale_x_continuous(labels = scales::dollar_format()) + 
  labs(title = 'Distribution of salary based on experience level from US employee residence',
       x = 'Salary (USD)', y = 'Density', fill = 'Experience Level') +
  theme(plot.title = element_text(hjust = 0.5), 
        legend.text = element_text(size = 8),
        legend.position = c(0.9,0.6)) +
  scale_fill_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                 , 'Executive-level')) +
  geom_histogram(aes(x=salary_in_usd, y = ..density.., fill = experience_level), 
                 alpha = 0.3) +
  scale_fill_manual(
    name = 'Experience Level',
    values = wes_palette("Moonrise2", 4),
    labels = c('Entry-level', 'Mid-level', 'Senior-level', 'Executive-level')
  ) 
############################################################################
##########################################################################


################   Plot base on Title within US-res only
################
salary_us_res %>%
  ggplot(aes(x = salary_in_usd, y = experience_level)) +
  geom_point(aes(shape = experience_level, color = experience_level), 
             size = 3) +
  facet_wrap(~ job_title, ncol = 7, labeller = label_wrap_gen(width = 25, multi_line = TRUE)) + 
  #facet wrap with set 8 columns and label wrap with width before 2nd line
  labs(title = 'Salary of each title from US residence employee based on experience level', 
       x = 'Salary (USD)', y = 'Experience Level', col = 'Experience Level: ') +
  scale_x_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 20, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 15),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.y = element_text(size = 15),
        legend.text = element_text(size = 13),
        legend.title=element_text(size=13),
        legend.position = 'top',
        strip.text.x = element_text(size = 8, face = "bold")
  ) +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                  , 'Executive-level')) +
  guides(shape = FALSE)









######################################################################
######################################################################
#//////////////////// DO NOT NEED seperate IQR US and nonUS/////////////
#/////////////////////////////////////////////////////////////////////////////
#####  Separate US vs NON-US #######
#####  Get Stat IQR salary range data 

salary_us_res_stat <- salary_us_res %>%
  group_by(experience_level) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())

#####  Make summary IQR salary range data table
library(gt)
salary_us_res_stat_gt <- gt(salary_us_res_stat) %>%
  fmt_currency(columns = 2:6, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of all US residence employee by experience level") %>%
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


salary_nonus_res_stat <- salary_nonus_res %>%
  group_by(experience_level) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())

salary_nonus_res_stat_gt <- gt(salary_nonus_res_stat) %>%
  fmt_currency(columns = 2:6, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of all non-US residence employee by experience level") %>%
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
salary_nonus_res_stat_gt
gtsave(salary_nonus_res_stat_gt, "salary_nonus_res_stat_gt.png")
