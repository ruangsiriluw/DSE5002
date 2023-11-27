################################################################################
################################################################################
## All library packages used in this analysis

library(ggplot2)
library(dplyr)
library(tidyr)
library(countrycode)
library(gt)
library(stringr)
library(priceR)



################################################################################
################################################################################
### Load csv data and reorder levels in some columns (bypass alphabetical orders)
# for plotting purpose, and filter only FT employment type

salary_df <- read.csv("Project1/r project data.csv")

salary_df <- salary_df %>%
  mutate_at(vars('company_location', 'experience_level', 'company_size')
            , as.factor) %>%
  mutate(experience_level = factor(experience_level, levels = c('EN', 'MI', 'SE', 'EX')),
         company_size = factor(company_size, levels = c('S', 'M', 'L')))

salary_df <-     select(salary_df, -c('salary', 'salary_currency'))
salary_ft_df <-  subset(salary_df, employment_type == "FT")


################################################################################
### Breaking iso2c codes for country + continent and add info of 
# company and employee country and location columns to FT salary dataframe

library(countrycode)

company_loc <- data.frame(company_location = unique(salary_ft_df$company_location))
company_loc <- company_loc %>%
  mutate(
    comp_continent = countrycode(sourcevar = company_location, origin = 'iso2c', 
                                 destination = 'continent'),
    comp_country = countrycode(sourcevar = company_location, origin = 'iso2c', 
                               destination = 'country.name')
  )


empl_res <- data.frame(employee_residence = unique(salary_ft_df$employee_residence))
empl_res <- empl_res %>%
  mutate(
    empl_continent = countrycode(sourcevar = employee_residence, origin = 'iso2c', 
                                 destination = 'continent'),
    empl_country = countrycode(sourcevar = employee_residence, origin = 'iso2c', 
                               destination = 'country.name')
  )

salary_ft_df <- salary_ft_df %>%
  left_join(company_loc, by = 'company_location')

salary_ft_df <- salary_ft_df %>%
  left_join(empl_res, by = 'employee_residence')

#### reorder columns:
salary_ft_df <- salary_ft_df[, c(1:7, 13, 14, 8:9, 11,12, 10)]


##############################################################################
################### ################### ################### ###################
################### Create label vectors for facets  ################### 

explevel_labs = c('Entry-level','Mid-level','Senior-level','Executive-level')
names(explevel_labs) = c('EN','MI','SE','EX')     

compsize.labs <- c('Small', 'Medium', 'Large')
names(compsize.labs) <- c("S", "M", "L")


################### ################### ################### ###################
################### ################### ################### ###################
##############################################################################


##############################################################################
###  SLIDE 2: Boxplot1 plotting salary based on company size and experienced
#### level


salary_ft_df %>%
  ggplot(aes(y = company_size, x = salary_in_usd, color = company_size)) +
  geom_boxplot() +
  facet_wrap( ~ experience_level, ncol =1,
               labeller = labeller(experience_level = explevel_labs)) + 
  labs(title = 
  str_wrap('Comparison of Salary Ranges Across Various Experience 
                    Levels and Company Sizes', width = 50, whitespace_only = TRUE), 
  x = 'Salary (USD)',   y = 'Company Size',col = 'Company Size: ') +
  scale_x_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 15, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 13),
        axis.text.x = element_text(size = 10),
        axis.title.y = element_text(size = 13),
        axis.text.y = element_text(size = 10),
        legend.text = element_text(size = 8),
        legend.title=element_text(size=10, face = "bold"),
        legend.position = c(0.82, 0.9),        
        legend.box.background = element_rect(fill='transparent'),
        legend.background = element_rect(fill = 'transparent'),
        strip.text.x = element_text(size = 12, face = "bold")
  ) +
  scale_color_discrete(labels = c('Small (<50 employees)',
                                  'Medium (50-250 employees)', 
                                  'Large (>250 employees)')) +
  geom_point(alpha = 0.2) 

################### 
###  SLIDE 2: Boxplot2 to view salary from company location by continent  ##

salary_ft_df %>%
  ggplot() +
  geom_boxplot(aes(x = salary_in_usd, y = NULL, color = experience_level)) +
  facet_grid (comp_continent ~ experience_level, 
              labeller = labeller(experience_level = explevel_labs)) + 
  labs(title = str_wrap('Comparison of Salary Ranges Across Various Experience 
              Levels and Company Location', width = 50, whitespace_only = TRUE), 
       x = 'Salary (USD)', col = 'Experience: ') +
  scale_x_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 15, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 13),
        axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.text = element_text(size = 8),
        legend.title=element_text(size=10),
        legend.position = 'top',
        strip.text.x = element_text(size = 10, face = "bold"),
        strip.text.y = element_text(size = 8, face = "bold")
  ) +
  scale_color_discrete(labels = explevel_labs) 


######################////////////////////////################################
######################////////////////////////################################

########  Evaluate US vs Non-US residence salary   #################
# Add a US/nonUS employee residence column in a salary full time df 

salary_ft_df <- salary_ft_df %>%
  mutate(is_us_res = ifelse(grepl("US", salary_ft_df$employee_residence), 
                            "US", "Non-US"))


##############################################################################
## SLIDE 3: Density + Histogram plot to compare salary between US vs nonUS resident

salary_ft_df %>%
  ggplot() +
  geom_density(aes(x=salary_in_usd, fill = is_us_res), 
               alpha = 0.5) +
  facet_grid ( ~ experience_level,
               labeller = labeller(experience_level = explevel_labs)) +
  scale_x_continuous(labels = scales::dollar_format()) + 
  labs(title = 'Comparing Employee Salary Distributions: US vs. Non-US Residents',
       x = 'Salary (USD)', y = 'Density', fill = 'Employee Residence') +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 8, angle = 45, hjust = 1),
        legend.text = element_text(size = 8),
        legend.title=element_text(size=9),
        legend.position = 'bottom',
        strip.text.x = element_text(size = 10, face = "bold")) +
  geom_histogram(aes(x=salary_in_usd, y = ..density.., fill = is_us_res), 
                 alpha = 0.3)


#####################
## Slide 3: Summary table of salary range between US and nonUS resident.  
## Using gt summary to print a table

salary_ft_iqr <- salary_ft_df %>%
  group_by(is_us_res, experience_level) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            mean = mean(salary_in_usd),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())

salary_ft_iqr_gt <- gt(salary_ft_iqr) %>%
  fmt_currency(columns = 3:8, currency = 'USD')%>%
  tab_header(title = "Comparing Employee Residence Salary Range (USD)") %>%
  cols_label(
    is_us_res = 'Employee Residence',
    experience_level = 'Experience Level',
    q25 = 'Q1 25%',
    median = 'Median',
    q75 = 'Q3 75%',
    mean = 'Average',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
  ) %>%
  tab_footnote(
    footnote = "EN: Entry-level, MI: Mid-level, SE: Senior-level, EX: Executive-level/Director",
    locations = cells_column_labels(columns = 'experience_level')
  )
salary_ft_iqr_gt 
gtsave(salary_ft_iqr_gt, "salary_ft_iqr_gt.png")


######################////////////////////////################################
######################////////////////////////################################

###  Slide 4: Density + Histogram to compare salary of US residence only 

library(wesanderson)

salary_ft_df %>%
  filter(is_us_res == 'US') %>%
  ggplot()+
  geom_density(aes(x=salary_in_usd, fill = experience_level), 
               alpha = 0.4) +
  scale_x_continuous(labels = scales::dollar_format()) + 
  labs(title = 'Salary Distribution Across Experience Levels of Employees in US',
       x = 'Salary (USD)', y = 'Density', fill = 'Experience Level') +
  theme(plot.title = element_text(hjust = 0.5), 
        legend.text = element_text(size = 8),
        legend.position = c(0.9,0.7)) +
  scale_fill_discrete(labels = explevel_labs) +
  geom_histogram(aes(x=salary_in_usd, y = ..density.., fill = experience_level), 
                 alpha = 0.3) +
  scale_fill_manual(
    name = 'Experience Level',
    values = wes_palette("Moonrise2", 4),
    labels = explevel_labs
  ) 

################### 
### Slide 4: Barplot composition of company locations where US residence is employed

salary_ft_df %>%
  filter(is_us_res == 'US') %>%
  ggplot(aes(x = comp_country, fill = company_size)) +
  geom_bar(position = position_dodge2(width = 0.9)) +
  facet_wrap ( ~ experience_level, ncol=2,
               labeller = labeller(experience_level = explevel_labs)) +
  ylim(0,200) +
  
  labs(title = str_wrap('Composition of Company Size Based on Company Location'
                        , width = 50, whitespace_only = TRUE), 
       x = 'Salary (USD)', y = 'Count' ,fill = 'Company Size: ', hjust = 0.5) +
  theme(plot.title = element_text(size = 15, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 13),
        axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
        axis.title.y = element_text(size = 10),
        axis.text.y = element_text(size = 8),
        legend.text = element_text(size = 8),
        legend.title=element_text(size=10),
        legend.position = 'top',
        strip.text.x = element_text(size = 12, face = "bold")
  ) +
  scale_fill_manual(
    name = 'Company Size',
    values = wes_palette("BottleRocket2", 3),
    labels = compsize.labs) + 
  geom_text(aes(label = ..count..), stat = "count",position = position_dodge(width=0.9),
            vjust = -0.3,  color = "black", size = 3)
  geom_text(stat = "count", aes(label = ..count..),
            vjust = 1,)
  

######################////////////////////////################################
######################////////////////////////################################

### Slide 5:  Plot of job titles by Experienced Level from US resident employees
  
salary_ft_df %>%
  filter(is_us_res == 'US') %>%
  ggplot(aes(x = salary_in_usd, y = experience_level)) +
  geom_point(aes(shape = experience_level, 
                 color = experience_level), size = 3, alpha = 0.7) +
  facet_wrap(~ job_title, ncol = 7, 
             labeller = label_wrap_gen(width = 30, multi_line = TRUE)) + 

  labs(title = 
  'Salary Distribution Across Experience Levels for Each Job Title Among
  US Resident Employee', 
    x = 'Salary (USD)', y = 'Experience Level', 
    col = 'Experience Level: ') +
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
    scale_color_discrete(labels = explevel_labs) +
    guides(shape = FALSE)
  
  
#####################////////////////////////################################
######################////////////////////////################################ 
 

##########  Analysis of Data Scientist-related job titles #################### 
# Subset full-time salary data frame into data scientist related dataframe
  
ds_df <- salary_ft_df[
  grepl('Scien', salary_ft_df$job_title, ignore.case = TRUE) & 
  grepl('Data', salary_ft_df$job_title, ignore.case = TRUE),  ] 


################### 
## Slide 6: Summary table of salary range of data scientist-related titles
# between US and nonUS resident employee and print gt table  

ds_df_stat <- ds_df %>%
  group_by(is_us_res, job_title) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            mean = mean(salary_in_usd),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())

ds_df_stat_gt <- gt(ds_df_stat) %>%
  fmt_currency(columns = 3:8, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of data scientists from
             US and nonUS residence") %>%
  cols_label(
    job_title = 'Job Title',
    q25 = 'Q1 25%',
    median = 'Median',
    q75 = 'Q3 75%',
    mean = 'Average',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
  ) 
ds_df_stat_gt
gtsave(ds_df_stat_gt, "ds_df_stat.png")


###########################
###  Slide 6: Boxplot of data scientist-related titles to compare salary of 
# US vs nonUS resident employee 

ds_df %>%
  ggplot(aes(x=salary_in_usd, y=is_us_res, color = is_us_res)) +
  geom_boxplot() +
  facet_wrap( ~ experience_level,
              labeller = labeller(experience_level = explevel_labs), ncol = 1) +
  scale_x_continuous(labels = scales::dollar_format()) + 
  scale_y_discrete(limits=c("US", "Non-US")) +
  labs(title = 
         "Salary Distribution Across Job Titles for\nUS Residents Employee based on Experience Level",
       x = 'Salary (USD)', color = 'Employee Residence') +
  theme(plot.title = element_text(size = 14, hjust = 0.5, vjust = -1,
                                  margin = margin(b = 20), face = 'bold'
                                 ),
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


#####################////////////////////////################################
######################////////////////////////################################ 

## Slide 7: Summary table of salary range of data scientist-related titles
# focusing on US resident only evaluating range based on experience level

ds_us_stat <- ds_df %>%
  filter(is_us_res == 'US') %>%
  group_by(job_title, experience_level) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            mean = mean(salary_in_usd),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())

ds_us_stat_gt <- gt(ds_us_stat) %>%
  fmt_currency(columns = 3:8, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of data scientists from
             US residence only") %>%
  cols_label(
    experience_level = 'Experience Level',
    job_title = 'Job Title',
    q25 = 'Q1 25%',
    median = 'Median',
    q75 = 'Q3 75%',
    mean = 'Average',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
  ) %>%
  tab_footnote(
    footnote = "EN: Entry-level, MI: Mid-level, SE: Senior-level, EX: Executive-level/Director",
    locations = cells_column_labels(columns = 'experience_level')
  )
ds_us_stat_gt
gtsave(ds_us_stat_gt, "ds_us_stat.png")


################### 
## Slide 7: Bloxplot of salary range of data scientist-related titles
# focusing on US resident only evaluating range based on experience level

ds_df %>%
  filter(is_us_res == 'US') %>%
  ggplot(aes(x = salary_in_usd, y = experience_level, color = experience_level)) +
  geom_boxplot() +
  labs(title = 'Salary Range for Data Scientist-Related Titles of US residence
                by Experience Levels', 
       x = 'Salary (USD)', y = 'Experience Level', col = 'Experience: ') +
  scale_x_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 14.5, hjust = 0.5, vjust = 1,
                                  lineheight = 0.9,
                                  margin = margin(b = 20), face = 'bold'), 
        axis.title.x = element_text(size = 13),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 13),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 11),
        legend.title = element_text(size=13),
        legend.position = 'bottom'
  ) +
  scale_color_discrete(labels = explevel_labs) +
  geom_point(alpha = 0.5)


#####################////////////////////////################################
######################////////////////////////################################ 

## Create and add a columns with adjusted salary to the year 2023 using priceR
# Only subsetting US company location and US employee residence to legitimately  
# evaluate the salary and adjust to Inflation Rate by US country

library(priceR)

us_only_df <- subset(salary_ft_df, company_location == 'US' & 
                       employee_residence == 'US')

salary_in_usd <- us_only_df$salary_in_usd
# salary has to be a vector for priceR function

us_only_df$adj_salary <- 
  adjust_for_inflation(salary_in_usd, 
                       from_date = 2020, 
                       to_date = 2023, 
                       country = 'US',
                       extrapolate_future_method = 'average',
                       future_averaging_period = 'all')


##################  
## Create a dataframe with adjusted salary and select only data scientist-related
#title to do analysis

ds_us_only_df <- 
  us_only_df[grepl('Scien', us_only_df$job_title, ignore.case = TRUE) & 
                    grepl('Data', us_only_df$job_title, ignore.case = TRUE),  ]


###############
###  Slide 8:  Barplot of nominal vs adjust salary of data 
### scientists only in US location and residence 


ds_us_only_df %>%
  filter(job_title== 'Data Scientist') %>%
  ggplot(aes(x = experience_level)) +
  geom_bar(aes(y = adj_salary, fill = "Adjusted Salary"), 
           position = position_dodge(width = 0.5), stat = "identity") +
  
  geom_bar(aes(y = salary_in_usd, fill = "Nominal Salary"), 
           position = position_dodge(width = 0.5), stat = "identity") +
  
  facet_wrap( ~ company_size, 
              labeller = labeller(company_size = compsize.labs))+
  scale_y_continuous(labels = scales::dollar_format()) + 
  labs(
    title = "Comparing Salary Changes for Data Scientists Title Residing in the US
Across Various Experience Levels and Company Size",
    x = "Experience Level",
    y = "Salary (USD)", fill = element_blank(),
    caption = 'EN:Entry-level, MI:Mid-level, SE:Senior-level') +
  theme(plot.title = element_text(size = 14, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.position = 'right',
        strip.text.x = element_text(size = 11, face = "bold"),
        plot.caption = element_text(size = 8, hjust = 0.5)
  ) +
  
  scale_fill_manual(values = c("Nominal Salary" = "darkgrey", 
                               "Adjusted Salary" = "darkred")) 


### Slide 9: Summary table of adjusted salary range of data scientist-related titles
# from US located company and US residence employee 

ds_us_only_adj2023 <- ds_us_only_df %>%
  group_by(job_title, experience_level) %>%
  summarise(q25 = quantile(adj_salary, 0.25),
            median = quantile(adj_salary, 0.5),
            q75 = quantile(adj_salary, 0.75),
            mean = mean(adj_salary),
            min_salary = min(adj_salary),
            max_salary = max(adj_salary), 
            n = n())
ds_us_only_adj2023

ds_us_only_adj2023_gt <- gt(ds_us_only_adj2023) %>%
  fmt_currency(columns = 3:8, currency = 'USD')%>%
  tab_header(title = "Adjusted salary range to 2023 (USD) of data scientists from
             US residence only") %>%
  cols_label(
    experience_level = 'Experience Level',
    job_title = 'Job Title',
    q25 = 'Q1 25%',
    median = 'Median',
    q75 = 'Q3 75%',
    mean = 'Average',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
  ) %>%
  tab_footnote(
    footnote = "EN: Entry-level, MI: Mid-level, SE: Senior-level, EX: Executive-level/Director",
    locations = cells_column_labels(columns = 'experience_level')
  )
ds_us_only_adj2023_gt
gtsave(ds_us_only_adj2023_gt, "ds_us_only_adj2023_gt.png")



############################# ~~THE END~~~ ###################################
##############################################################################


