####################################Loops####################################

for(i in 1:10) { # Head of for-loop, i is in particular vector
  
  x1 <- i^2      # Code block
  print(x1)      # Print results
}

x2 <- c("Samsung", "Apple", "Meta", "Google", "Microsoft")  # Create character vector

for(i in x2) {     # Loop over character vector, i in x2 vector
  
  print(paste("The name", i, "consists of", nchar(i), "characters."))
}

# appending to a vector
x3 <- numeric()  
for(i in 1:10) {    # Head of for-loop
  x3 <- c(x3, i^2)  # Code block, adding value in x3 in R format using "," (or .append in Py3)
}
print(x3)


# nested for loop (bad bad bad 
# --> need to using hashing to eliminate complexity)
x4 <- character()                                          # Create empty data object
loop_work <- 0
for(i in 1:5) {                                            # Head of first for-loop
  for(j in 1:5) {                                          # Head of nested for-loop
    loop_work <- loop_work + 1            # Creating a counter to count each generation of loop
    x4 <- c(x4, paste(LETTERS[i], letters[j], sep = "_"))  # Code block, iterating 25 steps!
          #LETTERS, letters is a function here
  }
}

### A better way using hashing --> this is on almost every tech interview
library(hash)

h <- hash()                # Making hash environment/object
x5 <- c()                  # Create an empty vector
hash_work <- 0             # counter starting with 0

#Creating a hash map
#First "loop" create a Big and litter letters in h environment
for(i in 1:5){                          
  hash_work <- hash_work + 1
  h[LETTERS[i]] <- letters[1:5]   #Creating a key with big letter with length of i as 1-5 
                                  #and adding value = letter 1-5 to hash table h
}                           # h is a hash env with big letter as key and little letter as value     
                            # Whole thing is called Hash map

for(j in 1:length(h)){              # Iterate with j with length of hash environment
  hash_work <- hash_work + 1
  x5 <- c(x5, paste(names(h)[j], h[[names(h)[j]]] ,sep='_')) 
  #Creating a vector called x5, returning key in h at j (from 1 through length of h) with [ ]
  # and value of h key with [[ ]], or can be "h[[ LETTER[j] ]]", with a separator
}
print(hash_work)
print(loop_work)
#make sure we just made the same two vectors
all(x4 == x5)

# for loop with break statement
for(i in 1:10) {                  # Head of for-loop
  x6 <- i^2                       # Code block
  print(x6)                       # Print results
  if(i >= 5) {                    # Conditionally stop for-loop
    break                         # Using break-statement
  }
}

# for loop with next statement (skip)
for(i in 1:10) {                    # Head of for-loop
  if(i %in% c(1, 3, 5, 7, 9)) {     # Conditionally skip iteration, when i is odd number
    next                            # Using next-statement to skip those i odd numbers
  }
  x7 <- i^2                         # Code block, after skipping, square not skipping i
  print(x7)                         # Print results
}

# iterating over a dataframe
iris_new1 <- iris   
for(i in 1:ncol(iris_new1)) {                       # Head of for-loop
  if(grepl("Width", colnames(iris_new1)[i])) {      # Logical condition, pattern = "Width", data = colnames of iris_new1 
    iris_new1[ , i] <- iris_new1[ , i] + 1000       # Code block, add 1000 to df, iterating in colume
  }
}
head(iris_new1)


#################################While Loops#################################
#If your condition is not met, the loop will go forever

i <- 1            # set the initial value
while (i < 6) {   # Head of while loop + test condition
  print(i)        # Code block
  i = i+1         # Code block (make sure you add 1 or the condition will not be met!)
}

typeof(i)

####################################Apply####################################
head(iris)

# row sums for the 1st 5 rows and 1st 4 columns of IRIS, MARGIN 1 is row
apply(iris[1:5,1:4],MARGIN=1,FUN=sum)

# col means for all rows of the 1st 4 columns of IRIS, MARGIN 2 is column
apply(iris[,1:4],MARGIN=2,FUN=mean)

# Custom function for apply where "square" is a function.
square <- function(x){
  x^2
}

# row & col custom function for the 1st 5 rows and 1st 4 columns of IRIS, 
# MARGIN = c(1,2) to do function to all elements in both cols and rows
apply(iris[1:5,1:4],MARGIN=c(1,2),FUN=square)

iris[1:5,1:4]

1.4^2
