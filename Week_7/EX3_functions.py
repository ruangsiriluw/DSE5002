# -*- coding: utf-8 -*-
"""
Created on Mon Jul  4 13:43:39 2022

@author: jlowh
"""

def factorial(num=5):#function definition and named, default value of 5
    #code block that calculates a factorial and assigns it to fact
    fact=1
    # Initializes a variable fact with the value 1.
    #This variable will be used to accumulate the factorial as the loop iterates.
   
    for i in range(1, num+1):#for loop for finding factorial
    #Total Range always need to +1 because it starts with 0
        fact=fact*i
    #Multiplies the current value of fact by the loop variable i in each iteration. 
    #This accumulates the factorial.
        
    #return statement that returns an object from your function
    return fact    #return factorial 

print("function execution with default value: "+ str(factorial()))
print("function execution with argument provided: "+ str(factorial(num=4)))

factorial(3)
