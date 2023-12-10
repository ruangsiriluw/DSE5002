#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 28 18:01:09 2023

@author: wanida
"""

set1 = {2,1,3,5,4,5}   #duplicate values got removed because set is unique values
set2 = set(['Orange', 'Apple','Banana','Apple'])

print(set1)
print(set2)
print(set1[1])  # error because there is no idex to the set

########################

set2.add('Pineapple')
print(set2)

set1.update([3,7,2,6])  #only add non-existing numbers
print(set1)

#remove or discard
set1.remove(7)
print(set1)
set1.remove(7)  #trying to remove again will cause error

set1.discard(7)
print(set1)  #discard will not throw error, so we don't know if it's there from the beginning


#combine 2 sets and will be ordered
set1.union(set2)
print(set1)

set3 = {2,10,2,22,45}

#Look for common elements using 'intersection'
set1.intersection(set3)

#For uncommon elements in set1 from set3, use 'difference'
set1.difference(set3)

#To show all elements uncommon for both set1 and set3 
# Use 'symmetric_difference'
set1.symmetric_difference(set3)
