# Creating 2 functions here called f and g, with input of variable x
# value of y <- 2 inside of f function, so y <- 10 is not part of f
# but part of g function

y <- 10
f <- function(x) {
  y <- 2
  y^2 + g(x)
}

g <- function(x) {
  x*y
}

