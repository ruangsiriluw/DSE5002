# Load the ggplot2 library
# Create a boxplot with quantile data labels

library(ggplot2)

# Create a sample data frame
set.seed(123)
data <- data.frame(
  group = rep(c("A", "B", "C"), each = 50),
  value = c(rnorm(50), rnorm(50, mean = 2), rnorm(50, mean = 3))
)

# Create a boxplot with quantile data labels
#############
ggplot(data, aes(x = group, y = value)) +
  geom_boxplot() +
  stat_summary(
    fun = function(x) quantile(x, c(0.25, 0.5, 0.75)),
    geom = "text",
    aes(label = paste("Q", c(25, 50, 75), "=", round(..y.., 2))),
    position = position_dodge(width = 0.75),
    vjust = -0.5
  ) +
  labs(title = "Boxplot with Quantile Data Labels")
#############################################################



# Print the correlation matrix
print(cor_matrix)