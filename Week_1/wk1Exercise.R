#Week 1 Exercise

x <- 10
y <- 5
z <- 20

(x < z) & (x > y)

x & y != z

x + 2*y == z


test_vector <- c(1,5,11:22)
x %in% test_vector | y %in% test_vector | z %in% test_vector

#Need to return the indices, not the actual value, below is the correct way:

which((x == test_vector) | (y == test_vector) | (z == test_vector))


