##################################Functions##################################
# this is an example function.. Always document what each function does
my_sum <- function(num1, num2) {
  # document your function here
  # what the function does
  # function inputs and outputs
  some_calculated_output <- (num1 + num2 )
  return(some_calculated_output) # return statement, return variables 
}

my_sum(50,30)

# Using default values for arguments
my_sum2 <- function(num1=20, num2=30) {
  # sum with default values for each input
  some_calculated_output <- (num1 + num2 )
  return(some_calculated_output) # return statement 
}

my_sum2()

# If you want to change default num, simply add to the function at the position
my_sum2( , 40)




# Using an ifelse to ensure inputs are numeric, 
# default assignment (num2 =30) comes after non-default num1 = ()
my_sum3 <- function(num1, num2=30) {
  # sum two numbers
  # if else to handle non-numeric values
  if(is.numeric(num1)&is.numeric(num2)){
    output <- (num1 + num2)
  } else{
    stop("ERROR: Both inputs must be numeric") 
  }
  
  return(output) # return statement 
}

#use stop function to stop execution of current expression and give error action

my_sum3(num1="a",num2=4)
my_sum3(num1=3)

