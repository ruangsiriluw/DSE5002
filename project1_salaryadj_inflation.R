
########  Adjusting inflation rate with priceR  #####################
################################
install.packages(priceR)
library(priceR)

set.seed(123)
nominal_prices <- rnorm(10, mean=10, sd=3)
years <- round(rnorm(10, mean=2006, sd=5))
df <- data.frame(years, nominal_prices)

df$in_2008_dollars <- adjust_for_inflation(nominal_prices, years, "US", to_date = 2008)



##################################################################
##################################################################
library(ggplot2)
library(dplyr)
library(lubridate)
library(ggpattern)
library(gt)


project1_df <- read.csv("Project1/r project data.csv")

####### Checking data, change some col into factor to reorder values and plot
salary_df <- project1_df %>%
  mutate_at(vars('company_location','experience_level', 'company_size')
            , as.factor) %>%
  mutate(experience_level = factor(experience_level, levels = c('EN', 'MI', 'SE', 'EX')),
         company_size = factor(company_size, levels = c('S', 'M', 'L')))


#### Subseting df to remove unnecessary cols of salary and currency and grab only FT
salary_ft_df <- subset(salary_df, employment_type == "FT")
salary_ft_df <- select(salary_ft_df, -c('salary', 'salary_currency'))


################### ################### ################### ################### 
################### Exp Level labels for facets  ################### 

explevel_labs = c('Entry-level','Mid-level','Senior-level','Executive-level')
names(explevel_labs) = c('EN','MI','SE','EX')              

################### ################### ################### ###################
################### ################### ################### ###################


##########  Filter for US company and US employee res ####################
###  Adjust salary to inflation rate #######################
####  using this needs to be connected online######################

install.packages(priceR)
library(priceR)

us_only_df <- subset(salary_ft_df, company_location == 'US' & 
                     employee_residence == 'US')

salary_in_usd <- us_only_df$salary_in_usd
# salary has to be a vector

us_only_df$adj_salary <- adjust_for_inflation(salary_in_usd, 
                       from_date = 2020, 
                       to_date = 2023, 
                       country = 'US',
                       extrapolate_future_method = 'average',
                       future_averaging_period = 'all')

############################  IQR of US and nonUS tables ##############

us_only_df$work_year <- as.character(us_only_df$work_year)

us_only_oldsalary <- us_only_df %>%
  group_by(work_year, experience_level) %>%
  summarise(q25 = quantile(salary_in_usd, 0.25),
            median = quantile(salary_in_usd, 0.5),
            q75 = quantile(salary_in_usd, 0.75),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n())
us_only_oldsalary


us_only_adj2023 <- us_only_df %>%
  group_by(work_year, experience_level) %>%
  summarise(q25 = quantile(adj_salary, 0.25),
            median = quantile(adj_salary, 0.5),
            q75 = quantile(adj_salary, 0.75),
            min_salary = min(adj_salary),
            max_salary = max(adj_salary), 
            n = n())
us_only_adj2023

######################################################
##### Test line plot salary per year


library(ggplot2)

compsize.labs <- c('Small', 'Medium', 'Large')
names(compsize.labs) <- c("S", "M", "L")


us_only_df %>%
  ggplot(aes(x = experience_level)) +
  geom_bar(aes(y = adj_salary, fill = "Adjusted Salary"), 
           position = position_dodge(width = 0.5), stat = "identity") +
  geom_bar(aes(y = salary_in_usd, fill = "Nominal Salary"), 
           position = position_dodge(width = 0.5), stat = "identity") +
  facet_wrap( ~ company_size, 
              labeller = labeller(company_size = compsize.labs))+
  scale_y_continuous(labels = scales::dollar_format()) + 
  labs(
    title = "Comparison of salary changes over time of US residence employee
     with different experience level from different size of US located company",
    x = "Experience Level",
    y = "Salary (USD)", fill = element_blank(),
    caption = 'EN:Entry-level, MI:Mid-level, SE:Senior-level, EX:Executive-level'
    ) +
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




######################################################
##################### DATA SCIENTIST ONLY ##################

ds_us_only_df <- us_only_df[grepl('Scien', us_only_df$job_title, ignore.case = TRUE) & 
                        grepl('Data', us_only_df$job_title, ignore.case = TRUE),  ]

ds_us_only_adj2023 <- ds_us_only_df %>%
  group_by(job_title, experience_level) %>%
  summarise(q25 = quantile(adj_salary, 0.25),
            median = quantile(adj_salary, 0.5),
            q75 = quantile(adj_salary, 0.75),
            min_salary = min(adj_salary),
            max_salary = max(adj_salary), 
            n = n())
ds_us_only_adj2023

######  Make gt summary table ##########


ds_us_only_adj2023_gt <- gt(ds_us_only_adj2023) %>%
  fmt_currency(columns = 3:7, currency = 'USD')%>%
  tab_header(title = "Adjusted salary range to 2023 (USD) of data scientist roles by experience level") %>%
  cols_label(
    job_title = 'Job Title',
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
ds_us_only_adj2023_gt

gtsave(ds_us_only_adj2023_gt, "ds_us_only_adj2023_gt.png")




compsize.labs <- c('Small', 'Medium', 'Large')
names(compsize.labs) <- c("S", "M", "L")

######################################################
###########  Plot for DS only

ds_us_only_df %>%
  ggplot(aes(x = experience_level)) +
  geom_bar(aes(y = adj_salary, fill = "Adjusted Salary"), 
           position = position_dodge(width = 0.5), stat = "identity") +
  geom_bar(aes(y = salary_in_usd, fill = "Nominal Salary"), 
           position = position_dodge(width = 0.5), stat = "identity") +
  facet_wrap( ~ company_size, 
              labeller = labeller(company_size = compsize.labs))+
  scale_y_continuous(labels = scales::dollar_format()) + 
  labs(
    title = "Comparison of salary changes over time of data scientists residence in US
     with different experience level from different size of US located company",
    x = "Experience Level",
    y = "Salary (USD)", fill = element_blank(),
    caption = 'EN:Entry-level, MI:Mid-level, SE:Senior-level, EX:Executive-level') +
  theme(plot.title = element_text(size = 14, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.position = 'right',
        strip.text.x = element_text(size = 11, face = "bold"),
        plot.caption = element_text(size = 8, hjust = 0.5)
        ) +
  
  scale_fill_manual(values = c("Nominal Salary" = "darkgrey", 
                               "Adjusted Salary" = "darkblue")) 
