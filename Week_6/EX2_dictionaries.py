# -*- coding: utf-8 -*-
"""
Created on Sun Jun 26 14:41:16 2022

@author: jlowh
"""
#defining a dictionary
dict1 = {1: 'Apple', 
         2: 'Banana', 
         3: 'Orange'} 

print("Dictionary:") 
print(dict1)
print(dict1[1])
print(dict1[4])


#defining defaultdict
from collections import defaultdict
# Function to return a default
# values for keys that is not
# present
def def_value():
    return "Not Present"
      
# Defining the dict
dict2 = defaultdict(def_value)
dict2[1] = 'Apple'
dict2[2] = 'Banana'
dict2[3] = 'Orange'

print(dict2[1])
print(dict2[4])
print(dict2)




# Defining the dict with list and can add values to 
dict2 = defaultdict(list)
dict2[1] = 'Apple'
dict2[2] = 'Banana'
dict2[3] = 'Orange'

dict2[4]
dict2[4].append('Mango')
dict2[4].append('Pineapple')





#merging dictionaries
# Adding keys that dict1 dose not have in dict2 to dict1
dict1.update(dict2)
print(dict1)

#key-value methods, encapsulated in a list
list(dict1.keys())
list(dict2.values())
list(dict2.items())

#get method, get item from dict
# without default
print(dict1.get(2))
print(dict1.get(5))   #Doesn't exist, return None
# with default
print(dict1.get(5 ,"5 is not a key"))


counter=0
counter =+ dict1.get(5,1)  #get 5, if not exists, return 1 on counter


#pop method
dict1.pop(4)
print(dict1.items())


