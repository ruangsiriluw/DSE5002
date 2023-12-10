#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  6 17:35:01 2023

@author: wanida
"""
#######################################################
## Q1

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from itertools import chain

titles_df = pd.read_csv("DSE5002/Week_8/titles.csv")
credits_df = pd.read_csv("DSE5002/Week_8/credits.csv")


genres_list = titles_df['genres'].str.replace('[\'\[\],]', '', regex = True).str.split().tolist()

flattened_genres = list(chain.from_iterable(genres_list))
print(flattened_genres)

unique_genres = set(flattened_genres)
print(unique_genres)    

#######################################################
### Q2









