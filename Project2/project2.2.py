#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec  8 21:14:05 2023

@author: wanida
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

levels_salary_df = pd.read_csv("~/Documents/Github/DSE5002/Project2/Levels_Fyi_Salary_Data.csv")

ww_ds_df = levels_salary_df[levels_salary_df["title"] =='Data Scientist']

#ww_ds_df[["city", "state", "country"]] = ww_ds_df["location"].str.split(', ', expand=True)
# remove space after str split
#ww_ds_df[['state', 'country']] = ww_ds_df[['state', 'country']].applymap(lambda x: x.strip() if isinstance(x, str) else x)



# Calculate statistics
loc_salary = ww_ds_df.groupby(
    ['location'])['totalyearlycompensation'].agg([np.median, np.std, np.count_nonzero])
                  
# Need to reset location from being an index                              
loc_salary.reset_index(inplace=True)
loc_salary[["city", "state", "country"]] = loc_salary["location"].str.split(', ', expand=True)
loc_salary['country'] =  np.where(loc_salary['country'].isna(),'United States', loc_salary['country'])

loc_salary = loc_salary.sort_values(by=['median'], ascending=False)
loc_salary.head(5)



#### Clean up Cost of Living file

cflv_df = pd.read_csv("~/Documents/Github/DSE5002/Project2/cost_of_living.csv")
cflv_df = cflv_df.drop(columns=['Rank'])

cflv_df[["city", "state", "country"]] = cflv_df["City"].str.split(', ', expand=True)
cflv_df['country'] = cflv_df['country'].fillna(cflv_df['state'])
cflv_df = cflv_df.rename(columns={'City': 'location'})

#getting rid of white space after string split
#cflv_df['country'] = cflv_df['country'].str.replace(' ', '')


#######
#Merge common city of both df to have salary + Cost of living, Clean up data
merge_df = pd.merge(loc_salary,cflv_df,how = 'inner', on=['city', 'country'])
merge_df = merge_df.drop(columns=['city','state_x','country','location_y','state_y'])
merge_df = merge_df.rename(columns={'location_x': 'location','median': 'median_salary','state_x':'state', 'count_nonzero': 'n'})
merge_df = merge_df[['location', 'median_salary','n','Cost of Living Index','Rent Index','Cost of Living Plus Rent Index','Groceries Index','Restaurant Price Index','Local Purchasing Power Index']]
merge_df.head()
merge_df.tail()

########################################################################
########################################################################
# Correlation of All Median salary vs cost of living index
sns.set_theme(style="whitegrid")
g = sns.lmplot(
    data=merge_df,
    x="Cost of Living Index", y="median_salary",
    height=5
)
plt.title('Salary correlation to Cost of Living Index of Each City')
plt.ylabel('Median Salary')

#
# Linear Regression plot
from scipy.stats import linregress
# Extract x and y data from the plot
x_col = merge_df["Cost of Living Index"]
y_sal_med = merge_df["median_salary"]

# Perform linear regression from Scatter plot
slope, intercept, r_value, p_value, std_err = linregress(x_col, y_sal_med)
slope_merge_df = round(slope, 2)
intercept_merge_df = round(intercept, 2)
r_value_merge_df = round(r_value, 2)
p_value_merge_df = round(p_value, 5)
std_err_merge_df = round(std_err, 2)

# Print the results
print(f"Slope: {slope_merge_df}")
print(f"Intercept: {intercept_merge_df}")
print(f"R-squared value: {(r_value_merge_df**2):.3f}")
print(f"P-value: {p_value_merge_df}")
print(f"Standard error: {std_err_merge_df}")

########################################################################


### Calculate afforability index using Median Salary/Cost of living index
##  Higher Salary and lower Cost of Living = Better Affordability
###  After calculation rank and view top 10

merge_df['Affordability Index'] = merge_df['median_salary'] / merge_df['Cost of Living Index']
aff_index_sorted = merge_df.sort_values(by=['Affordability Index'], ascending=False)
aff_index_sorted.head(10)

#Subsetting top 5 cities with highest Affordable Index, All in US
top5_aff_index = aff_index_sorted.iloc[0:5,]


sns.set()
ax=sns.pairplot(data=top5_aff_index,
             x_vars=['Cost of Living Index','Rent Index','Cost of Living Plus Rent Index','Groceries Index','Restaurant Price Index','Local Purchasing Power Index','Affordability Index'],
             y_vars= ['median_salary'],
             hue = 'location')
ax.set(ylabel='Median Salary in USD')

##############################################
### Stack plot of index composition

top5_col_index_pl = top5_aff_index[['location','Cost of Living Index','Rent Index','Cost of Living Plus Rent Index','Groceries Index','Restaurant Price Index','Local Purchasing Power Index']]
top5_col_index_pl.plot.bar(
    x='location', stacked=True, title='Cost of living index composition',xlabel = 'Location', ylabel = 'Index')                                 
plt.xticks(rotation=30)
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0)

#######################





########################################################################
##########  DATA Scientist salary ##################
########################################################################
#Subsetting only data scientist salaries only:

salary_df = pd.read_csv("~/Documents/Github/DSE5002/Project2/ds_salaries.csv")
ds_salary = salary_df[(salary_df["job_title"] == 'Data Scientist') &\
                      (salary_df['employment_type'] == 'FT') &\
                          (salary_df['employee_residence'] == 'US')]


## Stats summary of ds_salary


ds_salary_summary = ds_salary.groupby('experience_level')['salary_in_usd']\
    .agg([np.mean, np.median, np.std, np.min, np.max])
ds_salary_summary.round(2)

#  subtracting the median salary with the median of the highest 
ds_salary_median = ds_salary['salary_in_usd'].median()
top5_salary_difference = top5_aff_index['median_salary'] - ds_salary_median
print(f'Minimum salary difference: {top5_salary_difference.min()}')
print(f'Maxinimum salary difference: {top5_salary_difference.max()}')



########################################################################
########################################################################

##### Going back to top 5 cities and pull out the salary composition
top5_cities_list = list(top5_aff_index['location'])

top5_cities = ww_ds_df[ww_ds_df['location'].isin(top5_cities_list)]
top5_cities = top5_cities.sort_values(by='location', ascending=False)


### Stack plot of salary composition

top5_stackpl = top5_cities[['location', 'basesalary','stockgrantvalue', 'bonus']] 
top5_stackpl.plot.bar(
    x='location', stacked=True, title='Salary composition',xlabel = 'Location', ylabel = 'Salary in USD')                                 
plt.xticks(rotation=30)



######################  DO NOT USE  ################################
########################################################################
# Regression Analysis using statistic model ols (ordinary least square)
from statsmodels.formula.api import ols

# Replace spaces with underscores in column names
merge_df.columns = merge_df.columns.str.replace(' ', '_')

model = ols('median ~ Cost_of_Living_Index', data=merge_df).fit()
print(model.summary())


### Function to convert_currency
#https://pytutorial.com/currency-conversion-in-python/
import requests

def convert_currency(amount, from_currency, to_currency):
    base_url = "https://api.exchangerate-api.com/v4/latest/"

    # Fetch latest exchange rates
    response = requests.get(base_url + from_currency)
    data = response.json()

    if 'rates' in data:
        rates = data['rates']
        if from_currency == to_currency:
            return amount

        if from_currency in rates and to_currency in rates:
            conversion_rate = rates[to_currency] / rates[from_currency]
            converted_amount = amount * conversion_rate
            return converted_amount
        else:
            raise ValueError("Invalid currency!")
    else:
        raise ValueError("Unable to fetch exchange rates!")

# Convert 1 USD to  (live rates)
amount = 1
from_currency = "USD"
to_currency = ["INR", "EGP"]
converted_amount = convert_currency(amount, from_currency, to_currency)
print(f"{amount} {from_currency} is equal to {converted_amount} {to_currency}")



#Print multiple col
#print(ds_salary[['work_year','employment_type','salary_in_usd','remote_ratio']])


# Remove " United States" from City column and add a location common to merge
#cflv_df['location'] = cflv_df['City'].str.replace(', United States', '')