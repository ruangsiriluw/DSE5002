

#Ex1--
#2 <= nums.length <= 104
#–109 <= nums[i] <= 109
#–109 <= target <= 109


index_pair <- c()   #empty vector to store pairs of indices

two_sum <- function(nums_vector,target){
  
  for (i in seq_along(nums_vector)) {   
    for (j in seq_along(nums_vector)) {  
      
      if (nums_vector[i] + nums_vector[j] == target) {
        index_pair <- c(index_pair, list(c(i, j)))
      
      }
    }
  }
  print (index_pair)
}

# Test code
nums_vector <- c(5,7,12,34,6,10,8,9)
target <- 13
two_sum(nums_vector,target)


#expected answers
#[1] 1 7
#[1] 2 5
#[1] 5 2




###############---------Ex2
library(hash)
h2 <- hash()                   #create empty hash environment             

two_sum_hash <- function(nums_vector,target) {
  
  for(i in 1:length(nums_vector)) {              
    
    compl_num <- ( target - nums_vector[i] )    #assigning compliment numbers from subtracted values to key
    
    .set( h2, keys = compl_num, values = i)  #assign keys (compl numbers) and its values (i element)
  }
  
  for (j in 1:length(nums_vector)) {       
    
    if (nums_vector[j] %in% names(h2)) {    #if j from nums_vector is within keys of h2 (names(h2))
      
      print(paste(values(h2,nums_vector[j]), j))  
      # return values from hash table and paste (combine inputs into 1 string)
      
    } else {
      print ("no such numbers")    
    }
    
  }
}

# Test code
nums_vector <- c(5,7,12,34,6,10,8,9)
target <- 15
two_sum_hash(nums_vector,target)


