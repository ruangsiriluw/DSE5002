# -*- coding: utf-8 -*-
"""
Created on Sun Jul  3 09:24:12 2022

@author: jlowh
"""

import string
letters = string.ascii_uppercase

letter_list1 = []  #empty list for deposite of letter after iterating
for letter in letters:
    letter_list1.append(letter)


letter_list1 = []  #empty list for deposite of letter after iterating
for letter in letters:
    break   #put the break here, so that you can check the first loop first.
    #If this works, remove the break
    letter_list1.append(letter)



#For looping in a specific range/idex, Use range(len(list or variables))
letter_list2 = []  
for i in range(len(letters)):
    letter_list2.append(letters[i])
    
letter_list1 == letter_list2


#For both key and values from a Tubple list
letter_list3 = []  #empty list for deposite of letter after iterating
for i, letter in enumerate(letters):
    letter_list3.append(letter)
    print("Indices: " +str(i) + "Value: " + letter)




#while loop
'''The plus-equals operator 
+= provides a convenient way to add a value 
to an existing variable and assign the new value back to the same variable. 
In the case where the variable and the value are strings, 
this operator performs string concatenation instead of addition.
The operation is performed in-place, meaning that any other variable 
which points to the variable being updated will also be updated.'''


z = 1
while z < 10:
    z += z * 2 # += means add to existing list
    print(z)

'''Inside the loop, update the value of z by adding z * 2 to its current value.
Print the updated value of z.
1 + (1 * 2) = 3
3 + (3 * 2) = 9
9 + (9 * 2) = 27
Repeat the loop until the condition z < 10 is no longer true.'''



''''Remainder divided by 2 == 0  is even number
1 is not remaining ==0, so 1 + 1
2 remaining ==0, so 2+3 = 5


'''
z = 1    
while z < 10:
    if (z % 2) == 0:  #if z is an even number
        z += 3
        print(z)
    else:
        z += 1
        print(z)
        
        
#nesting of 2 lists, looking through idices of each list and see which is matched

list1 = [3,5,10,3,7,4,6]
list2 = [3,4,2,10,3,8,9]
work_on2 = 0   #Initialize a variable called it 'work_on2' with value starts at 0
                #This variable is used to count the number of iterations in the nested loops.
for i in range(len(list1)):
    for j in range(len(list2)):
        work_on2+=1
        #Increments the work_on2 variable by 1. This is done in each iteration 
        #of the nested loops, counting the total number of iterations.
        
        if list1[i] == list2[j]:
            print("Both elements are the same. " + '\nlist1 indice is: '+ str(i) + '\n list2 indice is: ' + str(j) )

#When print, convert integer to string; otherwise, it gets error.
#Answers indicate the idex position **Starts with 0 in Py



#Hashmap with 2 loops
       
from collections import defaultdict            
work_on   = 0
hash_map = defaultdict(int)
#Creates a defaultdict named hash_map with default values set to 0. 
# Store indices 
#It will be used to store indices of list1 and a boolean indicating whether 
#the corresponding value in list1 exists in list2.


for i in range(len(list1)):
    work_on += 1  #counting number of loops/iterations
    hash_map[i] = list1[i] in list2
    #Adding idex of list1 and Boolean as whether the value of list1 exists in list2
    #Checks if the value at index i in list1 exists in list2 
    #and stores the result in the hash_map with key i.
     
    
for key, value in hash_map.items(): #iterate over key and value in a hashmap above
   if value == True:  #only picking the condition that is true
        for j in range(len(list2)):
            work_on += 1
            if list1[key] == list2[j]:
    #Checks if the element in list1 at the index specified by key is equal to 
    #the element in list2 at the index j. Then, print below
                print("Both elements are the same. " + '\nlist1 indice is: '+ str(key) + '\n list2 indice is: ' + str(j))
   else:
        work_on += 1
        
print('nested loop number of steps: ' + str(work_on2))
print('hash map number of steps: ' + str(work_on))
                
            
            
