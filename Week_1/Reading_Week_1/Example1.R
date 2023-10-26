myf <- function(x) {
  innerf <- function(x) assign('Global.res', x^2, envir = .GlobalEnv)
  innerf(x+1)
}
# Adding 1 to x, then square and assign to Global Env

myf(3)