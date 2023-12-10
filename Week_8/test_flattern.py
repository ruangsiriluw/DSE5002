#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec  7 10:26:55 2023

@author: wanida
"""

import pandas as pd
from itertools import chain

# Sample DataFrame
titles_df = pd.DataFrame({
    'original_title': ['Movie1', 'Movie2', 'Movie3'],
    'genres': [['Action', 'Drama'], ['Comedy', 'Drama'], ['Action', 'Comedy']]
})

# Remove unwanted characters from the 'genres' column
titles_df['genres'] = titles_df['genres'].apply(lambda x: [genre.replace("'", "") for genre in x])

# Flatten the list of lists using itertools.chain
flattened_genres = list(chain.from_iterable(titles_df['genres']))

# Get unique genres and count occurrences manually
unique_genres = list(set(flattened_genres))
genre_counts = {genre: flattened_genres.count(genre) for genre in unique_genres}

# Display the original DataFrame
print("Original DataFrame:")
print(titles_df[['original_title', 'genres']])

# Display the flattened list and unique genre counts
print("\nFlattened Genres:")
print(flattened_genres)

print("\nUnique Genres:")
print(unique_genres)

print("\nGenre Counts:")
print(genre_counts)
#######################################################

import itertools

items = ['cat',['dog','bird']]
flattern_test = itertools.chain.from_iterable(items)

print(list(flattern_test))

#######################################################
#######################################################

import pandas as pd
from itertools import chain

# Assuming titles.csv is in the "DSE5002/Week_8/" directory
titles_df = pd.read_csv("DSE5002/Week_8/titles.csv")

# Extract the 'genres' column and convert it to a list
unique_genres_list = titles_df['genres'].unique().tolist()

# Iterate over the list and replace characters in each genre string
processed_genres_list = [genre.replace('[', '').replace(']', '').replace("'", '').replace(',', '').strip() for genre in unique_genres_list]

# Split each processed genre string into a list of words
genres_words_list = [genre.split() for genre in processed_genres_list]

# Flatten the list of lists into a single list of words using chain.from_iterable
flattened_words = list(chain.from_iterable(genres_words_list))

test = set(flattened_words)
print(flattened_words)

#######################################################
#######################################################

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
#######################################################

