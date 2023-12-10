#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  5 18:38:15 2023

@author: wanida
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import requests


##########  Whole world salary ##################
##########  
levels_salary_df = pd.read_csv("~/Documents/Github/DSE5002/Project2/Levels_Fyi_Salary_Data.csv")

#Subsetting only data scientist salaries off the world salary table:
ww_salary_df = levels_salary_df[levels_salary_df["title"] =='Data Scientist']

# Sort total yearly compensation into another dataframe and pull out top 5 unique location:
sorted_totalyearlycomp_df = ww_salary_df.sort_values(by=['totalyearlycompensation'], ascending=False)

top5_location_df = sorted_totalyearlycomp_df.groupby('location').head(1).head(5)
print(top5_location_df[['location','totalyearlycompensation']])


##########  STACK PLOTING TOP 5 LOCATION
###  Plot salary composition
top5_salary_stack = top5_location_df[['location', 'basesalary','stockgrantvalue', 'bonus']] 

top5_salary_stack.plot.bar(
    x='location', stacked=True, title='Salary composition',xlabel = 'Location', ylabel = 'Salary in USD')                                 
plt.xticks(rotation=30)



#####################
###########  SanFrancisco, CA salary

sf_salary_df = ww_salary_df[ww_salary_df['location']== "San Francisco, CA"]

####  Plot SF CA salary with yrs of experience
sns.set_theme(style="whitegrid")
g = sns.lmplot(
    data=sf_salary_df,
    x="yearsofexperience", y="totalyearlycompensation",
    height=5
)


# Linear Regression plot
from scipy.stats import linregress
# Extract x and y data from the plot
x_data = sf_salary_df["yearsofexperience"]
y_data = sf_salary_df["totalyearlycompensation"]

# Perform linear regression
slope, intercept, r_value, p_value, std_err = linregress(x_data, y_data)
slope = round(slope, 2)
intercept = round(intercept, 2)
r_value = round(r_value, 2)
p_value = round(p_value, 5)
std_err = round(std_err, 2)

# Print the results
print(f"Slope: {slope}")
print(f"Intercept: {intercept}")
print(f"R-squared value: {r_value**2}")
print(f"P-value: {p_value}")
print(f"Standard error: {std_err}")


##########################################
##########################################

sf_sj_df = ww_salary_df[(ww_salary_df['location'] == "San Francisco, CA") | (ww_salary_df['location'] == "San Jose, CA")]


# Make a custom palette with gendered colors

g = sns.lmplot(
    x="yearsofexperience", y="totalyearlycompensation", 
    hue="location", data=sf_sj_df, height=5
    )
 





########## cost of living for DATA Analysis ##################
######### #need to find top 5 locations first ##############

cflv_df = pd.read_csv("~/Documents/Github/DSE5002/Project2/cost_of_living.csv")
cflv_df = cflv_df.drop(columns=['Rank'])

cflv_df.dtypes
cflv_df[["City", "State/Int.Country", "US"]] = cflv_df["City"].str.split(',', expand=True)
cflv_df['State/Int.Country'] = cflv_df['State/Int.Country'].str.strip()

# CA cost of living
ca_cflv_df = cflv_df[cflv_df['State/Int.Country']== "CA"]

# Calculate mean, median, and std of all CA index
ca_cflv_df.describe().round(2)


# CA,WA cost of living
sel_states_cflv = cflv_df[cflv_df['US State/Int.Country'].isin(["CA", "WA"])]
print(sel_states_cflv.groupby('US State/Int.Country').describe())





###########  Plot comparison of 2 states:

sns.set_theme(style="whitegrid")

# Scatter plot
f, ax = plt.subplots(figsize=(6.5, 6.5))
sns.despine(f, left=True, bottom=True)

sns.scatterplot(x="Cost of Living Index", y="Rent Index",
                hue="US State/Int.Country",
                palette="ch:r=-.2,d=.3_r",
                sizes=(1, 8), linewidth=0,
                data=sel_states_cflv, ax=ax) 


# Linear Regression plot
g = sns.lmplot(
    data=sel_states_cflv,
    x="Cost of Living Index", y="Rent Index", hue="US State/Int.Country",
    height=5
)

# Density plot THIS COULD BE BETTER PLOT
g = sns.kdeplot(
    data=sel_states_cflv,
    x="Cost of Living Index", y="Rent Index", hue="US State/Int.Country",
    thresh=.1,
)

#### Correlation Coeff

# Compute the Pearson correlation matrix
correlation_matrix = ca_cflv_df[['Cost of Living Index','Rent Index','Cost of Living Plus Rent Index','Groceries Index','Restaurant Price Index','Local Purchasing Power Index']].corr()
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', fmt=".2f", linewidths=0.5)
plt.title('Correlation Matrix')
plt.show()
#########################################################







##########  DATA Scientist salary ##################
########################################################################
#Subsetting only data scientist salaries only:

salary_df = pd.read_csv("~/Documents/Github/DSE5002/Project2/ds_salaries.csv")    
ds_salary_df = salary_df[salary_df["job_title"] =='Data Scientist']

print(ds_salary_df[['work_year','employment_type','salary_in_usd','remote_ratio']])

## Avg summary of ds_salary
ds_salary_results = ds_salary_df.groupby('experience_level')['salary_in_usd'].agg([np.mean, np.median, np.std])
ds_salary_results = round(ds_salary_results, 2)
print(ds_salary_results)

#  Summary with Statistics
ds_salary_summary = ds_salary_df.describe(include = 'all')
print(ds_salary_summary)
########################################################################










#using column/row indices subsetting data
df.iloc[5:10,13:15]
##############  Do not use  ###################
#///////!!!!  Cannont use Rank the totalyearlycompensation.  
#This is different types of ranking////////
ww_salaries_df['rankd_totalyearlycomp'] = ww_salaries_df['totalyearlycompensation'].rank(ascending=False)

#Breaking location:
ww_salary_df[["City", "State/Region", "Country"]] = ww_salary_df["location"].str.split(',', expand=True)

#///////Replace empty Country cells with US ////// May not need this ////////////
ww_salary_df['Country'] = np.where(ww_salary_df['Country'].isna(), 'United States', ww_salary_df['Country'])
####///////////////


###### Print selections
print(ww_salaries_df['totalyearlycompensation'].nlargest(n=5))  
#nlargest only works for numeric but the output is not unique for location


########## This one aggregate with location but diff experience salaries are combined
top5_salary_summary = ww_salary_df.groupby('location')['totalyearlycompensation'].agg([np.mean, np.median, np.std])
print(top5_salary_summary)
top5_sum = top5_salary_summary.sort_values(by=['mean']).tail(5)


# Summary of top 10 NOT GOOD TO USE unless it's only 1 location
col_describe =['level', 'location', 'totalyearlycompensation','basesalary','stockgrantvalue', 'bonus']
top_location_df[col_describe].describe().round(2)


##########
#export to csv file:
top5_location_df.to_csv('top5_location_df.csv')    
##########
#selected columns for plotting
top5_salary_pl = top5_salary_df[['company', 'level', 'totalyearlycompensation',
                                 'basesalary','stockgrantvalue', 'bonus',
                                 'City', 'State/Region', 'Country']]

print(top5_salary_pl[['City']].to_string(index=False))

#### STATISC SUMMARY use .describe()
cflv_df.describe()

##########
##########
#Top 10 for more locations
top_location_df = sorted_totalyearlycomp_df.groupby('location').head(1).head(10)
print(top_location_df[['location','totalyearlycompensation']])
##########
##########

############ Plot index of living by pairs:  Graph is too busy
    
sns.set()
sns.pairplot(data=coflv_df,
             x_vars=['Cost of Living Index','Rent Index','Cost of Living Plus Rent Index','Groceries Index','Restaurant Price Index','Local Purchasing Power Index'],
             y_vars= ['Cost of Living Index','Rent Index','Cost of Living Plus Rent Index','Groceries Index','Restaurant Price Index','Local Purchasing Power Index'],
              height=3.5)