#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec  7 20:42:02 2023

@author: wanida
"""


#### Pie Chart
import pandas as pd
import matplotlib.pyplot as plt

# Create a DataFrame (replace this with your actual DataFrame)
data = {
    'Category': ['A', 'B', 'C', 'D'],
    'Values': [25, 30, 20, 25]
}
df = pd.DataFrame(data)

# Plotting a pie chart
plt.figure(figsize=(8, 8))
plt.pie(df['Values'], labels=df['Category'], autopct='%1.1f%%', startangle=90, colors=['red', 'green', 'blue', 'yellow'])
plt.title('Pie Chart Example')
plt.show()

####### Multiple pie chart #######
import pandas as pd
import matplotlib.pyplot as plt

# Create a DataFrame (replace this with your actual DataFrame)
data = {
    'Category': ['A', 'B', 'C', 'D', 'E'],
    'Values1': [25, 30, 20, 25, 15],
    'Values2': [20, 25, 18, 30, 15],
    'Values3': [15, 20, 25, 30, 10],
    'Values4': [30, 15, 20, 25, 10],
    'Values5': [10, 25, 30, 20, 15]
}
df = pd.DataFrame(data)

# Determine the number of rows and columns for subplots
num_rows = 2
num_cols = 3

# Create a figure and a grid of subplots
fig, axes = plt.subplots(num_rows, num_cols, figsize=(15, 10))
fig.suptitle('Faceted Pie Charts')

# Flatten the 2D array of subplots into a 1D array
axes = axes.flatten()

# Loop through the columns and create a pie chart for each
for i, col in enumerate(df.columns[1:]):
    ax = axes[i]
    ax.pie(df[col], labels=df['Category'], autopct='%1.1f%%', startangle=90)
    ax.set_title(f'Pie Chart {i+1}: {col}')

# Adjust layout to prevent overlapping titles
plt.tight_layout(rect=[0, 0.03, 1, 0.95])

# Show the plots
plt.show()


######### Group bar
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Create a DataFrame (replace this with your actual DataFrame)
data = {
    'State': ['State1', 'State1', 'State2', 'State2'],
    'Category': ['A', 'B', 'A', 'B'],
    'Value1': [20, 30, 25, 35],
    'Value2': [15, 25, 30, 20]
}
df = pd.DataFrame(data)

# Pivot the DataFrame to create groups
df_pivot = df.pivot(index='State', columns='Category', values=['Value1', 'Value2'])

# Plotting grouped bar chart
width = 0.35  # Width of the bars
ind = np.arange(len(df_pivot.index))  # Index locations for the groups

fig, ax = plt.subplots(figsize=(10, 6))

bar1 = ax.bar(ind - width/2, df_pivot['Value1'], width, label='Value1')
bar2 = ax.bar(ind + width/2, df_pivot['Value2'], width, label='Value2')

# Customize the plot
ax.set_title('Grouped Bar Chart of Values for Two States')
ax.set_xticks(ind)
ax.set_xticklabels(df_pivot.index)
ax.set_xlabel('State')
ax.set_ylabel('Values')
ax.legend()

# Show the plot
plt.show()
