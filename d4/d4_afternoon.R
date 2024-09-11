library(tidyverse)
library (ggthemes)

#iris_setosa <- iris %>%
  #filter(Species=="setosa")

#ggplot(data = iris_setosa, 
       #mapping = aes(x = Sepal.Width, y=Sepal.Length))+ geom_point() + stat_smooth(method="lm")

#m1<-lm(data = iris_setosa, formula= Sepal.Length ~1 + Sepal.Width)

#summary(m1)


library(palmerpenguins)
library(broom)
head(penguins)
glimpse(penguins)

#is there a relationship between bill length and depth
#considering all species together

full_model <- lm(data=penguins%>%filter(!is.na(sex)),
   formula = bill_length_mm ~1 + bill_depth_mm + species + sex)

reduced_model <-lm(data = penguins%>%filter(!is.na(sex)), formula = bill_length_mm ~ 1)
anova(full_model, reduced_model)

#ggplot(data=penguins,
#   mapping=aes(x=bill_depth_mm, y=bill_length_mm,
#   color=species))+ stat_smooth(method="lm")+
# geom_point()

summary(full_model)

#what is the bill length of a male gentoo penguin with a bill depth of 17.5?
#y=mmx+c
#y=27.62 + (0.53*17.5) + 2.89

#any penguin with a bill depth of 17.5?
#y=mmx+c

new_penguin <- tibble(
  species = "Gentoo",
  bill_depth_mm = 17.5,
  sex = "male"
)
predict(full_model, newdata=new_penguin)
# = 50.31


  