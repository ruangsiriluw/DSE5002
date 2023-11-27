#####  Loading libraries 

library(stringr)
library(dplyr)
library(ggplot2)
library(scales)

####### Load csv file in df 

project1_df <- read.csv("Project1/r project data.csv")

####### Checking data, change some col into factor to reorder values and plot
project1_df <- project1_df %>%
  mutate_at(vars('company_location', 'work_year', 'experience_level', 'company_size')
            , as.factor) %>%
  mutate(experience_level = factor(experience_level, levels = c('EN', 'MI', 'SE', 'EX')),
         company_size = factor(company_size, levels = c('S', 'M', 'L')))

str(project1_df)


############################ SUMMARY TABLES ###############################
library(tidyr)

##### Table1: Calculate IQR (quantile) summary of salary USD for all job title obtained for US company location:

## Make IQR summary table of us_df with quantile, min, max, following plot1:
#####  IQR by Experiences 
us_exp_iqr <- us_df %>%
  group_by(experience_level) %>%
  summarize(quantiles = list(cal_quant(salary_in_usd)),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd)
  ) %>%
  tidyr::unnest_wider(quantiles) %>%
  rename(q1 = '25%', median = '50%', q3 = '75%')

print(us_exp_iqr)
str(us_exp_iqr)

###### To make a nice table output

#############  TABLE 1 Range of all jobs working for US company #########
library(gt)

us_exp_iqr_gt <- gt(us_exp_iqr) %>%
  fmt_currency(columns = 2:6, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of all jobs in US located companies by experience level") %>%
  cols_label(
    experience_level = 'Experience Level',
    q1 = 'Q1',
    median = 'Median',
    q3 = 'Q3',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
    ) %>%
  tab_footnote(
    footnote = "EN: Entry-level, MI: Mid-level, SE: Senior-level, EX: Executive-level/Director",
    locations = cells_column_labels(columns = 'experience_level')
  )
us_exp_iqr_gt
gtsave(us_exp_iqr_gt, "us_exp_iqr_gt.png")

################
################ IQR by Titles
us_title_iqr <- us_df %>%
  group_by(job_title) %>%
  summarize(quantiles = list(cal_quant(salary_in_usd)),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd)
  ) %>%
  tidyr::unnest_wider(quantiles) %>%
  rename(q1 = '25%', median = '50%', q3 = '75%')
 
print(us_title_iqr)

us_title_iqr_gt <- gt(us_title_iqr) %>%
  fmt_currency(columns = 2:6, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of all jobs in US located companies by job title") %>%
  cols_label(
    job_title = 'Job Title',
    q1 = 'Q1',
    median = 'Median',
    q3 = 'Q3',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
  )
us_title_iqr_gt
gtsave(us_title_iqr_gt, "us_title_iqr_gt.png")


############ Boxplot 1 and facet based on title:  ##########################

#Plot 1 boxplot vertically without experience level:

us_df %>%
  ggplot(aes(x = experience_level, y = salary_in_usd, color = experience_level)) +
  geom_boxplot() +
  coord_flip() +
  facet_wrap(~ job_title, ncol = 7, labeller = label_wrap_gen(width = 25, multi_line = TRUE)) + 
  #facet wrap with set 8 columns and label wrap with width before 2nd line
  labs(title = str_wrap('Salary of each data science job based on experience levels
                        from company in US'), 
       x = 'Experience Level', y = 'Salary (USD)', col = 'Experience Level: ') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 20, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 15),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.y = element_text(size = 15),
        legend.text = element_text(size = 13),
        legend.title=element_text(size=13),
        legend.position = 'top',
        strip.text.x = element_text(size = 10, face = "bold")
  ) +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                  , 'Executive-level'))



##############################################################################
##############################################################################

#Table 2 US Data Scientist-related titles  ONLY summary:

### sub-setting only for DS-related title:
us_ds_df <- us_df[grepl('Scien', us_df$job_title, ignore.case = TRUE) & 
                    grepl('Data', us_df$job_title, ignore.case = TRUE),  ] 
us_ds_df$job_title <- as.factor(us_ds_df$job_title)
levels(us_ds_df$job_title)


#########################################

# Summarize data for Table 2 Range by exp level and job title:

us_ds_iqr <- us_ds_df %>%
  group_by(experience_level, job_title) %>%
  summarize(quantiles = list(cal_quant(salary_in_usd)),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd)
  ) %>%
  tidyr::unnest_wider(quantiles) %>%
  rename(q1 = '25%', median = '50%', q3 = '75%')

print(us_ds_iqr)

###### To make a nice summary table
us_ds_iqr_gt <- gt(us_ds_iqr) %>%
  fmt_currency(columns = 3:7, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of data scientist-related title 
             in US located companies by experience level of each job title") %>%
  cols_label(
    experience_level = 'Experience Level',
    job_title = 'Job Title / Experience Level',
    q1 = 'Q1',
    median = 'Median',
    q3 = 'Q3',
    min_salary = 'Minimum',
    max_salary = 'Maximum'
  ) %>%
  tab_footnote(
    footnote = "EN: Entry-level, MI: Mid-level, SE: Senior-level, EX: Executive-level/Director")
us_ds_iqr_gt
gtsave(us_ds_iqr_gt, "us_ds_iqr_gt.png")



############# plot salary by Exp level for US employer DS-related titles ##############
### Boxplot 2. Salary of DS-related title in US-based company, based on experienced level


us_ds_df %>%
  ggplot(aes(x = experience_level, y = salary_in_usd, color = experience_level)) +
  geom_boxplot() +
  coord_flip () +
  labs(title = str_wrap('Salary of all data scientist-related job titles 
       based on experience levels from companies in US'),
       x = 'Experience Level', y = 'Salary (USD)', col = 'Experience Level: ') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 18, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 10), 
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 10), 
        legend.text = element_text(size = 10),
        legend.title=element_text(size=11),
        legend.position = 'right') +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                  , 'Executive-level')) +
  guides(color = guide_legend(reverse = TRUE)) +
  geom_point(alpha = 0.5)+
  geom_jitter(alpha = 0.8, position = position_jitter(width = .3)) 

ggsave('boxplot2 us ds by exp level.png')



#### Boxplot 3 for each title
###
us_ds_df %>%
  ggplot(aes(x = experience_level, y = salary_in_usd, color = experience_level)) +
  geom_boxplot() +
  coord_flip () +
  facet_wrap(~job_title,labeller = label_wrap_gen(width = 25, multi_line = TRUE))+
  labs(title = str_wrap('Salary of each data scientist-related title 
       based on experience levels from companies in US'),
       x = 'Experience Level', y = 'Salary (USD)', col = 'Experience Level: ') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 18, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 10, angle = 45, hjust = 1), 
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 10), 
        legend.text = element_text(size = 10),
        legend.title=element_text(size=11),
        legend.position = 'top',
        strip.text = element_text(size = 9, color = "dark red")) +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                  , 'Executive-level')) +
  guides(color = guide_legend(reverse = TRUE)) +
  geom_point(alpha = 0.5)

ggsave('boxplot3 us ds by exp level and title.png')

############################################################
############################################################
###### TEST HISTOGRAM ############



#############
#///////////////////////////////////////////////
#### Load viridis color palettes to dot plot and box plot based on each DS-related title
library(viridis)

testplot <- ggplot(data = us_ds_df, aes(x = work_year, y = salary_in_usd, color = experience_level))

testplot +
  geom_point() +
  geom_jitter() +
  labs(title = 'Salary of each data scientist-related titles in US employer 
       each year',
       x = 'Work Year', y = 'Salary (USD)', color = 'Experience Level') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(hjust = 0.5), 
        legend.text = element_text(size = 8),
        legend.position = 'bottom') +
  facet_wrap( ~job_title,scales = "free_y") +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level', 'Executive-level')) + 
  scale_color_viridis(discrete = TRUE, option = "D")

#///////////
library(wesanderson)


testplot +
  geom_point() +
  labs(title = 'Salary of each data scientist-related titles in US employer each year',
       x = 'Work Year', y = 'Salary (USD)', color = 'Experience Level') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(hjust = 0.5), 
        legend.text = element_text(size = 10),
        legend.position = 'bottom') +
  facet_wrap(~ job_title, scales = "free_y") +
  scale_color_manual(
    name = 'Experience Level',
    values = wes_palette("Moonrise2", 4),
    labels = c('Entry-level', 'Mid-level', 'Senior-level', 'Executive-level')
  ) 

####  By Exp level, color = year, tightening jitter points
ggplot(data = us_ds_df, aes(x = experience_level, y = salary_in_usd, color = work_year)) +
  geom_point() +
  geom_jitter(alpha = 0.8, position = position_jitter(width = .2)) +
  labs(title = 'Salary of each data scientist-related titles in US employer each year',
       x = 'Experience Level', y = 'Salary (USD)', color = 'Work Year') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(hjust = 0.5), 
        legend.text = element_text(size = 10),
        legend.position = 'bottom') +
  facet_wrap(~ job_title, scales = "free_y") +
  scale_color_manual(
    name = 'Work Year',
    values = wes_palette("Moonrise2", 4)
) 


##### summarize quantile and mean
us_ds_summary <- us_ds_df %>%
  group_by(job_title) %>%
  summarise(quants25 = quantile(salary_in_usd, 0.25),
            quants50 = quantile(salary_in_usd, 0.5),
            quants75 = quantile(salary_in_usd, 0.75),
            mean = mean(salary_in_usd),
            n = n())

colnames(us_ds_summary) <- c('Job Title', 'Q1 Salary (USD)', 'Median Salary (USD)', 
         'Q3 Salary (USD)', 'Avg (USD)', 'n')

column_usd <- c('Q1 Salary (USD)', 'Median Salary (USD)', 
                'Q3 Salary (USD)', 'Avg (USD)')
us_ds_summary <- us_ds_summary %>%
  mutate_at(column_usd, ~dollar_format(digits =2) (.))

print(us_ds_summary)

write.csv(us_ds_summary, 'Quantile Salary of US Data Scientist.csv')




#//CREATE A TABLE////////////////////////////////////////// 
#to summarize, use describe or describeBy in psych library:
#psych::describeBy(us_df, group = us_df$job_title)

### gtsummary will have 'counts' output in a nice table:
library(gtsummary)
library(labelled)

us_ds_df %>% tbl_summary()
print(us_df)

#////////////////////////////////////////////////////////

########  Adjusting inflation rate with priceR  #####################

install.packages(priceR)
library(priceR)
wages <- data.frame(
  fiscal_year = 2010:2016,
  wage = c(50000, 51000, 52000, 53000, 54000, 55000, 54000)
)

countries_dataframe <- show_countries()
inflation_dataframe <- retrieve_inflation_data('US')

adjust_for_inflation(wages, 2010, to_date = 2016, country = 'US',
                     countries_dataframe = countries_dataframe, 
                     inflation_dataframe = inflation_dataframe)

salary_infl <- salary_ft_df %>%
  adjust_for_inflation(salary_in_usd, 2020, to_date = 2023, country = 'US',
                       countries_dataframe = countries_dataframe, 
                       inflation_dataframe = inflation_dataframe)


#///////////////////////////////DO NOT NEED///////////////////
#//////////////////////////////////////////////////////////////////////////
# This would not grab other columns
# us_title_qt <- aggregate(us_df$salary_in_usd, by = list(us_df$job_title, us_df$experience_level)
#                         , FUN = cal_quant)

# Convert us_title-qt aggregate 2 var table to df with 4 column names
# us_title_qt_df <- do.call(data.frame, us_title_qt)
# colnames(us_title_qt_df) <- c('job_title', 'experience_level',
#                              'quantile_25%', 'median' ,'quantile_75%')
#//////////////////////////////////////////////////////////////////////////

###### sub-setting df for 'US-location' only into another df
us_df <- subset(project1_df, company_location == "US")


#######  Making quantile function to be used in multiple tables ###########

cal_quant <- function(x) {
  quantiles <- quantile(x, c(0.25, 0.5, 0.75))
  return(quantiles)
}


