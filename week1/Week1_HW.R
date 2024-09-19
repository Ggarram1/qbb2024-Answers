library(tidyverse)
library(broom)
library(ggthemes)


#1.3
#reading in text file made in python
Coverage_3x <- read.delim("~/qbb2024-Answers/week1/coverage_3x.txt")

#plot the frequency of coverage as a histogram
histogram_plot <- ggplot(mapping = aes(x = X0)) +
  geom_histogram(data = Coverage_3x, aes(y = ..count..), binwidth = 1, color = "black", fill = "gray") +
  labs(title = "3x Genome Coverage", x = "Coverage", y = "Frequency") +
  theme_classic()

#set up mean, std dev, lambda, and the maximum before putting into a poisson
#analysis
mean_val <- 3
std_dev <- sqrt(3)
max_coverage = max(Coverage_3x)
lambda <- mean_val
poisson_values <- dpois(0:max_coverage, lambda) * 1000000
normal_values <- dnorm(0:max_coverage, mean_val, std_dev) * 1000000
histogram_plot <- histogram_plot +
  geom_line(aes(x = 0:max_coverage, y = poisson_values, color = "Poisson")) +
  geom_line(aes(x = 0:max_coverage, y = normal_values, color = "Normal")) +
  scale_color_manual(values = c("Poisson" = "lightblue", "Normal" = "black"))
histogram_plot

#1.5
#Reading in new text file
Coverage_10x <- read.delim("~/qbb2024-Answers/week1/coverage_10x.txt")
#plot the frequency of coverage as a histogram
histogram_plot <- ggplot(mapping = aes(x = X0)) +
  geom_histogram(data = Coverage_10x, aes(y = ..count..), binwidth = 1, color = "black", fill = "gray") +
  labs(title = "10x Genome Coverage", x = "Coverage", y = "Frequency") +
  theme_classic()

#set up mean, std dev, lambda, and the maximum before putting into a poisson
#analysis
mean_val <- 10
std_dev <- sqrt(10)
max_coverage = max(Coverage_10x)
print(max_coverage)
lambda <- mean_val
poisson_values <- dpois(0:max_coverage, lambda) * 1000000
normal_values <- dnorm(0:max_coverage, mean_val, std_dev) * 1000000
histogram_plot <- histogram_plot +
  geom_line(aes(x = 0:max_coverage, y = poisson_values, color = "Poisson")) +
  geom_line(aes(x = 0:max_coverage, y = normal_values, color = "Normal")) +
  scale_color_manual(values = c("Poisson" = "lightblue", "Normal" = "black"))
histogram_plot

#1.6
#Reading in new text file
Coverage_30x <- read.delim("~/qbb2024-Answers/week1/coverage_30x.txt")
#plot the frequency of coverage as a histogram
histogram_plot <- ggplot(mapping = aes(x = X0)) +
  geom_histogram(data = Coverage_30x, aes(y = ..count..), binwidth = 1, color = "black", fill = "gray") +
  labs(title = "30x Genome Coverage", x = "Coverage", y = "Frequency") +
  theme_classic()
histogram_plot

#set up mean, std dev, lambda, and the maximum before putting into a poisson
#analysis
mean_val <- 30
std_dev <- sqrt(10)
max_coverage = max(Coverage_30x)
print(max_coverage)
lambda <- mean_val
poisson_values <- dpois(0:max_coverage, lambda) * 1000000
normal_values <- dnorm(0:max_coverage, mean_val, std_dev) * 1000000
histogram_plot2 <- histogram_plot+
  geom_line(aes(x = 0:max_coverage, y = poisson_values, color = "Poisson")) +
  geom_line(aes(x = 0:max_coverage, y = normal_values, color = "Normal")) +
  scale_color_manual(values = c("Poisson" = "lightblue", "Normal" = "black"))
histogram_plot2
