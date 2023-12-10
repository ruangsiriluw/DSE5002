# -*- coding: utf-8 -*-
"""
Created on Fri Jul  8 13:45:35 2022

@author: jlowh
"""

import pandas as pd
import numpy as np
#importing data
df = pd.read_csv('DSE5002/Week_8/sales-3.csv')

#extracting data types
df.dtypes

#object is string type


#changing data types:
df['Order Date'] = pd.to_datetime(df['Order Date'], format='%m/%d/%Y')
df['Ship Date'] = pd.to_datetime(df['Ship Date'], format='%m/%d/%Y')
df.dtypes


### Subsetting

#selecting columns - dplyr select()
#single column or list of columns (double brackets)
print(df['City'].head())   #head =  first 5 rows
print(df[['Country','City']].head())  #print many columns

#subsetting rows
cat_df = df[df["Category"] =='Furniture']
cat_df.shape  #dimensions of dataframe

profit_df = df[df["Profit"] < 0 ]
profit_df.shape  

#multiple conditionals
furniture_profit_df = df[(df["Category"] =='Furniture') & (df["Profit"] < 0)]
furniture_profit_df.shape  


#subset of both rows and columns (we need to use .loc on the initial df as shown)
# Return column 'State' after subsetting both conditions in the front.

row_col_df = df.loc[(df["Category"] =='Furniture') & (df["Profit"] < 0),'State']
row_col_df.shape

row_col_df.unique()  #Grab unique States.  Panda series is a column


#using column/row indices subsetting data
df.iloc[5:10,13:15]

#creating new columns
# Str.split to break out with a delimiter (in this case is a '-')
# expand = True = return Dataframe/MultiIndex, False = return Series/Index
df[['StateAbbreviation','Year','OrderID']] = df['Order ID'].str.split('-',expand=True)
df[['StateAbbreviation','Year','OrderID']].head()

#dropping columns
df = df.drop(['StateAbbreviation','Year','OrderID'],axis=1)

### data transformation
#long to wide
wide_df = df.pivot(columns=['Category'],values=['Sales','Profit'])
wide_df.head()
# flattening the double index
wide_df2 = wide_df.copy()
wide_df2.columns = wide_df2.columns.to_flat_index()
wide_df2.head()

#wide to long
long_df = wide_df.melt(value_name='Value',var_name=['Metric','Category'])
long_df.head()


### aggregation
# single variable, signle aggregation method
df.groupby('Category')['Profit'].mean()

#multiple aggregation methods
df.groupby('Category')['Profit'].agg([np.mean, np.median, np.std])

#aggregating with custom functions
def group_range(x):
    return x.max() - x.min()
df.groupby(['Category'])['Profit'].apply(group_range)

#multiple variables:  Dictionary output of aggregates data
df.groupby('Category').agg({'Profit': ['median', 'std'], 'Sales': 'median'})

#######  named multi-agg, similar to summarize function in R
df.groupby(['Category','Sub-Category']).agg(
    median_profit=('Profit', np.median),
    median_sales=('Sales', np.median),
    
)


### Merging data, 2 dictionaries: Column = Key, Values = Values

df1 = pd.DataFrame({'a': ['foo', 'bar'], 'b': [1, 2]})
df2 = pd.DataFrame({'a': ['foo', 'baz'], 'c': [3, 4]})

print(df1)
print(df2)

# full join, Combine everything at a, left or df1 has priority
df1.merge(df2, how='outer', on='a')

# inner join, Only the common value of a column
df1.merge(df2, how='inner', on='a')

# left join, keep all the left df keys/values, 
# then add to left df with only common column 'a'
df1.merge(df2, how='left', on='a')
