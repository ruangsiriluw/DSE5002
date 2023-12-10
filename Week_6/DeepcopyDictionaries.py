#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec  1 08:40:37 2023

@author: wanida
"""

import copy
# Dictionary of strings and ints
wordsDict = {
    "Hello": 56,
    "at" : 23 ,
    "test" : 43,
    "this" : 43,
    "who" : [56, 34, 44]
    }

# create a Shallow copy  the original dictionary
newDict = wordsDict.copy()

newDict['at'] = 200
newDict['who'].append(222)

newDict.values()
wordsDict.values()

'''This change the values in original Dict list object or user defined obj.
Note that it won't change the original Integer object'''


'''To avoid changing the original list obj, need deepcopy command'''

dict = copy.deepcopy(dict)  #call in class or function of from 'copy' module

otherdict = copy.deepcopy(wordsDict)

'''
Modify the contents of list object in deep copied dictionary will 
have no impact on original dictionary because its a deep copy.  Regardless
of what type of object.
'''
otherdict["who"].append(100)
otherdict.items()
wordsDict.items()

#try append in int object and it did not change the original dict.

otherdict['at'] = 99
otherdict.items()
wordsDict.items()


'''
Test run if this dictionary is ordered with keys.
'''

testDict = {
    "this" : 43,
    "who" : [56, 34, 44],
    "Hello": 56,
    "at" : 23 ,
    "test" : 43
    }
print(testDict.keys())







