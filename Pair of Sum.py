#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  5 16:09:17 2023

@author: wanida
"""

def pair_sum(a, target):
    d = {}  # create dictionary
    for i in a:
        complement = target - i
        if complement in d:  # check hashmap
            return (d[complement], [i])
        else:
            d[i] = i  # add to hashmap
    return None

a = [3,1,3,2,6,9]
target = 6

results = pair_sum(a, target)
print(results)


##################

def pair_sum_indices(a, target):
    index_map = {}  # create dictionary to store indices
    for i, num in enumerate(a):
        complement = target - num
        if complement in index_map:  # check if complement's index is in the map
            return (index_map[complement], i)  # return the pair of indices
        index_map[num] = i  # add current index to the map
    return None

a = [3, 1, 3, 2, 6, 9]
target = 6

results = pair_sum_indices(a, target)
print(results)
