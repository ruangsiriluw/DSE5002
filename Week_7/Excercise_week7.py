#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec  3 14:35:41 2023

@author: wanida
"""

## Ex1 to create a Palindrome function with for loop:

def palindrome(string):
    if (string == string[::-1]):  #Going in reverse with step -1
        return f"{string} is a palindrome"
    else:
        return f"{string} is not a palindrome"

        
#Test function:
print(palindrome("rotator"))
print(palindrome("yellow"))    

############################################
############# Other methods ##################

def palindrome(string):
    length = len(string)
    for i in range(length//2):
        if string[i] == string[length -1 -i]:
            return True
        else:
            return False

print(palindrome("rotator"))

############################################
#The current character is added in front of the existing reversed string, 
#effectively reversing the order of characters.

def is_palindrome(strg):
    revstr = ""
    for i in strg:
        revstr = i + revstr
    print(f"Reverse string is {revstr}")    
    if strg == revstr:
        return "The string is a palindrome."
    else:
        return "The string is not a palindrome."

print(is_palindrome("yellow"))
############################################
############################################


#Using While loop:
## Q2 to create a Palindrome function with for loop:

def palindrome_check(string):
    length = len(string)
    first = 0  #Firt index
    last = length -1  #Given Py starts with 0, last index is length -1
    while first < last:
        if string[first] == string[last]:
            first += 1
            last -= 1
        else:
            return "The string is not a palindrome."
        
    return "The string is a palindrome."

print(palindrome_check("rotator"))
    

############################################
# Q3:
from collections import defaultdict            

hash_map = defaultdict(int)

#This is a nested loop__DO NOT USE~~~~~~~~
def two_sum(nums, target):
    for i in range(len(nums)):
        for j in range(i+1, len(nums)):
            if nums[i] + nums[i+1] == target:
                return i, j
#########################

from collections import defaultdict            


def two_sum(nums, target):
    indices = defaultdict(list)
    
    for i, nums in enumerate(nums):
        complement = target - nums   
        
        if complement in indices:
            return indices[complement], [i]
        indices[nums].append(i)


        
nums = [2, 7, 11, 15]
target = 9
result = two_sum(nums, target)
print(result)


nums = [3,2,4]
target = 6
result = two_sum(nums, target)
print(result)


nums = [3,3]
target = 6
result = two_sum(nums, target)
print(result)

#Test code for last line
nums = [3,2,4]
target = 10
result = two_sum(nums, target)
print(result)


############################################
# Q4
# Negative index is used to call value of a list or array from the end of a list.  The syntax will include -1 
# as the last index.   For example:

word = "pineapple"

#print each letter backward, len(word) -1 = n-1 = # of loops
# second -1 = last index, thrid -1 = stepwise backward
for i in range(len(word) -1, -1, -1):
    print(word[i])


############################################

#Q5

str1 = "aab"
str2 = "xxy"


def two_strings(str1, str2):
    if len(str1) != len(str2):
        return False
    
    mapping_str1 = {}  #Use a dictionary to store a mapping
    mapping_seen = set() # keep track of characters in str2 that have already 
                        #been mapped to characters in str1.
    
    for i in range(len(str1)):  #slice string into each character
        str1_char = str1[i]
        str2_char = str2[i]
        
        if str1_char in mapping_str1:
            if mapping_str1[str1_char] != str2_char:
                return False    
        #Check the str1_char in the mapping_str1 is not equal to str2_char 
            
        elif str2_char in mapping_seen:
            return False
        #If str1_char is not in the mapping_str1 dictionary, it checks 
        #if str2_char is already mapped to another character in str1. 
        #If yes, it returns False.
    
        mapping_str1[str1_char] = str2_char
        #adding 
        mapping_seen.add(str2_char)
        
    return True

            
print(two_strings(str1, str2))
    








