################################################################################
## All library packages used in this analysis

library(ggplot2)
library(dplyr)
library(tidyr)
library(countrycode)
library(gt)
library(stringr)



################################################################################
################################################################################
### Load csv data and reorder levels in some columns (avoid alphabetical orders)
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
################### Create label vectos for facets  ################### 

explevel_labs = c('Entry-level','Mid-level','Senior-level','Executive-level')
names(explevel_labs) = c('EN','MI','SE','EX')     

compsize.labs <- c('Small', 'Medium', 'Large')
names(compsize.labs) <- c("S", "M", "L")


################### ################### ################### ###################
################### ################### ################### ###################
##############################################################################

###  Slide2: Boxplot1 to compare salary between company size, 


salary_ft_df %>%
  ggplot(aes(y = company_size, x = salary_in_usd, color = company_size)) +
  geom_boxplot() +
  facet_wrap( ~ experience_level, ncol =2,
               labeller = labeller(experience_level = explevel_labs)) + 
  labs(title = 
  str_wrap('Comparison of Salary Ranges Across Various Experience 
                    Levels and Company Sizes', width = 50, whitespace_only = TRUE), 
  x = 'Salary (USD)',   y = 'Company Size',col = 'Company Size: ') +
  scale_x_continuous(labels = scales::dollar_format()) + 
  theme(plot.title = element_text(size = 15, hjust = 0.5, vjust = 0), 
        axis.title.x = element_text(size = 13),
        axis.text.x = element_text(size = 8,angle = 45, hjust = 1),
        axis.title.y = element_text(size = 13),
        axis.text.y = element_text(size = 10),
        legend.text = element_text(size = 8),
        legend.title=element_text(size=10, face = "bold"),
        legend.position = 'bottom',
        strip.text.x = element_text(size = 12, face = "bold")
  ) +
  scale_color_discrete(labels = c('Small (<50 employees)',
                                  'Medium (50-250 employees)', 
                                  'Large (>250 employees)')) +
  geom_point(alpha = 0.2) 


###  Slide2 Boxplot2 to view salary from company location by continent  ##

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
        strip.text.y = element_text(size = 7, face = "bold")
  ) +
  scale_color_discrete(labels = explevel_labs)




