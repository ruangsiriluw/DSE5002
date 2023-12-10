#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec  1 13:41:19 2023

@author: wanida
"""

import random
random.seed(10)

int_list = []
n = 50
for i in range(n):
 int_list.append(random.randint(0,15))
print(int_list)


for i in [10, 30]:
    print(int_list[i])
    
    
import string
az_upper = string.ascii_uppercase

az_list = []

for i in az_upper:
    az_list.append(i)
    
print(az_list)




set_1 = {1,2,3,4,5}
set_2 = set(int_list)
set_3 = set_1.symmetric_difference(set_2)


from collections import defaultdict
def def_value():
    return 'Not Present'

dict_1 = defaultdict(def_value)

dict_1['int_list'] = int_list
dict_1['set_1'] = set_1
dict_1['set_2'] = set_2
dict_1['set_3'] = set_3

dict_2 = {'set_1': set_1, 'az_list': az_list}


print(dict_1['az_list'])

set_4 = set(dict_1['az_list'],)
len(set_4)

len(dict_2['az_list'])


dict_2.update(dict_1)

print(dict_2['az_list'])
# dictionary 2 retrieved the values of 'az_list' key as a string "Not Present".



