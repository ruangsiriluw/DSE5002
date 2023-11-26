################################################################################
################################################################################

library(ggplot2)
library(dplyr)
library(gt)
library(tidyr)

project1_df <- read.csv("Project1/r project data.csv")

####### Checking data, change some col into factor to reorder values and plot
project1_df <- project1_df %>%
  mutate_at(vars('company_location', 'work_year', 'experience_level', 'company_size')
            , as.factor) %>%
  mutate(experience_level = factor(experience_level, levels = c('EN', 'MI', 'SE', 'EX')),
         company_size = factor(company_size, levels = c('S', 'M', 'L')))

################################################################################
################################################################################



###### Make a new df with country code and find its continent, new df needs to be unique
library(countrycode)

country_ctn <- data.frame(company_location = unique(project1_df$company_location))

country_ctn <- country_ctn %>%
  mutate(
    continent = countrycode(sourcevar = company_location, origin = 'iso2c', destination = 'continent'),
    country_name = countrycode(sourcevar = company_location, origin = 'iso2c', destination = 'country.name')
  )

salary_ctn <- project1_df %>%
  left_join(country_ctn, by = 'company_location')

summary(salary_ctn)


################################################################################
################################################################################
 ###################

salary_ctn_iqr <- salary_ctn %>%
  group_by(continent, experience_level) %>%
  summarise(quantiles = list(cal_quant(salary_in_usd)),
            min_salary = min(salary_in_usd),
            max_salary = max(salary_in_usd), 
            n = n()) %>%
  tidyr::unnest_wider(quantiles) %>%
  rename(q1 = '25%', median = '50%', q3 = '75%')

library(gt)
salary_ctn_iqr_gt <- gt(salary_ctn_iqr) %>%
  fmt_currency(columns = 3:7, currency = 'USD')%>%
  tab_header(title = "Salary range (USD) of companies in each continent") %>%
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
salary_ctn_iqr_gt
gtsave(salary_ctn_iqr_gt, "salary_ctn_iqr_gt.png")

###############################################################################





#########################################################################################




#################  BOXPLOT by continent and exp level ###################

salary_ctn %>%
  ggplot(aes(x = NULL, y = salary_in_usd, color = experience_level)) +
  geom_boxplot() +
  coord_flip() +
  facet_grid (continent ~experience_level) + 
  labs(title = stringr::str_wrap('Salary range based on experience levels from each continent'), 
       x = 'Experience Level', y = 'Salary (USD)', col = 'Experience Level: ') +
  scale_y_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 20, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 15),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.text = element_text(size = 13),
        legend.title=element_text(size=13),
        legend.position = 'top',
        strip.text.x = element_text(size = 10, face = "bold"),
        strip.text.y = element_text(size = 8, face = "bold")
  ) +
  scale_color_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                  , 'Executive-level')) 
  







############
##### Plot Exp level distribution base by continent:

library(wesanderson)
library(scales)

salary_ctn %>%
  ggplot() +
  geom_bar(aes(x=continent, fill = experience_level)) + 
  labs(title = 'Distribution of position by experience level from companies 
       located within each continent',
      x = 'Continent', y = 'Number of position', fill = 'Experience Level') +
  theme(plot.title = element_text(hjust = 0.5), 
        legend.text = element_text(size = 8),
        legend.position = 'right') +
  scale_fill_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                  , 'Executive-level')) +
  scale_fill_manual(
    name = 'Experience Level',
    values = wes_palette("Moonrise2", 4),
    labels = c('Entry-level', 'Mid-level', 'Senior-level', 'Executive-level')
  ) 


##### DENSITY Plot salary distribution base by exp level of ALL:

salary_ctn %>%
  ggplot() +
  geom_density(aes(x=salary_in_usd, fill = experience_level), 
               alpha = 0.5) +
  labs(title = 'Distribution of salary based on experience level from US located companies',
       x = 'Salary (USD)', y = 'Density', fill = 'Experience Level') +
  theme(plot.title = element_text(hjust = 0.5), 
        legend.text = element_text(size = 8),
        legend.position = 'right') +
  scale_fill_discrete(labels = c('Entry-level', 'Mid-level', 'Senior-level'
                                 , 'Executive-level')) +
  scale_fill_manual(
    name = 'Experience Level',
    values = wes_palette("Moonrise2", 4),
    labels = c('Entry-level', 'Mid-level', 'Senior-level', 'Executive-level')
  ) 





##//////////////////////////////////////////////////////////////////////////
##############  Plot with country = Too busy  REMOVE DO NOT USE 
rm(salary_ctn_eu_iqr)
salary_ctn %>%
  ggplot() +
  geom_col(aes(x=continent, y=salary_in_usd))
  facet_wrap(~ expeience_level)

#Filter table for criteria
salary_3ctn <- salary_ctn%>%
    filter(continent %in% c('Americas','Asia','Europe'))

##//////////////////// REMOVE DO NOT USE  /////////////////////////////////////
  #/////////////////////////////////////////////////////////////////////////////
  ######## Calculate IQR based on continent and exp level: 
  ##### AMERICAS
  salary_ctn_amer_iqr <- salary_ctn %>%
    filter(continent == 'Americas') %>%
    group_by(country_name, experience_level) %>%
    summarise(quantiles = list(cal_quant(salary_in_usd)),
              min_salary = min(salary_in_usd),
              max_salary = max(salary_in_usd)) %>%
    tidyr::unnest_wider(quantiles) %>%
    rename(q1 = '25%', median = '50%', q3 = '75%')
  
  ####### Eu
  salary_ctn_eu_iqr <- salary_ctn %>%
    filter(continent == 'Europe') %>%
    group_by(country_name, experience_level) %>%
    summarise(quantiles = list(cal_quant(salary_in_usd)),
              min_salary = min(salary_in_usd),
              max_salary = max(salary_in_usd)) %>%
    tidyr::unnest_wider(quantiles) %>%
    rename(q1 = '25%', median = '50%', q3 = '75%')
  
  ####### ASIA
  salary_ctn_as_iqr <- salary_ctn %>%
    filter(continent == 'Asia') %>%
    group_by(country_name, experience_level) %>%
    summarise(quantiles = list(cal_quant(salary_in_usd)),
              min_salary = min(salary_in_usd),
              max_salary = max(salary_in_usd)) %>%
    tidyr::unnest_wider(quantiles) %>%
    rename(q1 = '25%', median = '50%', q3 = '75%')
  #/////////////////////////////////////////////////////////////////////////////


