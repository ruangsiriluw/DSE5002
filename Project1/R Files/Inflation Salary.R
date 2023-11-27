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

############################################################################
library(lubridate)
library(priceR)


testus <- subset(project1_df, company_location == "US")
testus$salary_in_usd <- as.numeric(testus$salary_in_usd)
testus$work_year <- format(testus$work_year, "%Y")

str(testus)
typeof(testus$work_year)

relevant_columns <- c("salary_in_usd", "work_year")
test <- testus[, relevant_columns]


# Adjust for inflation using historical average to extraporate":

infl <- 
  adjust_for_inflation(price = test$salary_in_usd,
    from_date = test$work_year,
    to_date = 2023,
    country = 'US',
    extrapolate_future_method = 'average',
    future_averaging_period = 'all',
    countries_dataframe = countries_dataframe, 
    inflation_dataframe = inflation_dataframe
  )
test$infl_adj <- infl

  