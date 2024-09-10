library(tidyverse)
library(broom)
library(ggthemes)
library(patchwork)

#read in the data
dnm <- read_csv(file = "~/qbb2024-Answers/d4/aau1043_dnm.csv")
ages <- read_csv(file = "~/qbb2024-Answers/d4/aau1043_parental_age.csv")

#begin to organize the data
dnm_summary <- dnm %>%
  group_by(Proband_id) %>%
  summarise(n_paternal_dnm = sum(Phase_combined == "father", na.rm= TRUE), 
            n_maternal_dnm = sum(Phase_combined == "mother", na.rm= TRUE))
#count number of maternal vs. paternal DNMs after grouping and organizing

dnm_by_parental_age <- left_join(dnm_summary, ages, by = "Proband_id")

#2.1:
#ggplot(data=dnm_by_parental_age,
        #mapping = aes(x=Father_age, y=n_paternal_dnm)) + stat_smooth(method="lm")+
  #xlab("Father Age (years)")+ylab("De Novo Mutations")+
  #geom_point()

#ggplot(data=dnm_by_parental_age,
       #mapping = aes(x=Mother_age, y=n_maternal_dnm)) + stat_smooth(method="lm")+
  #xlab("Mother Age (years)")+ylab("De Novo Mutations")+
  #geom_point()

#2.2:
#full_model <- lm(data=dnm_by_parental_age,
                 #formula = n_maternal_dnm ~1 + Mother_age)
#summary(full_model)

#the "size" of the relationship can be determined based on the slope(maternal), at 0.378, this is 
#a positive slope. This means that as the mother gets older, there is a small increase
#in number of dnms. However, the Adjusted R-squared(maternal) is 0.23, this shows that this 
#is a mildly strong relationship.

#2.3
full_model <- lm(data=dnm_by_parental_age,
                 formula = n_paternal_dnm ~1 + Father_age)
summary(full_model)
#the "size" of the relationship can be determined based on the slope(paternal), at 1.35, this is 
#a positive slope. This means that as the father gets older, there is an increase
#in number of dnms. However, the Adjusted R-squared(paternal) is 0.62, this shows that this 
#is a stronger relationship than observed between maternal age and maternal dnms.

#2.4
#y=b0 + b1*x1 + b2*x2
# (number of paternal DNMs) = 10.32 + (1.35*50.5)
#This would yield an estimate of 78.495 DNMs

#2.5
p1 <- ggplot(aes(x=Mother_age, y=n_maternal_dnm)) +
  geom_line(color="#eee9f8", size=2) +
  ggtitle("Maternal DNMs") +
  theme_ipsum()
p2 <- ggplot(aes(x=Father_age, y=n_paternal_dnm)) +
  geom_line(color="#177",size=2) +
  ggtitle("Price: range 1-100") +
  theme_ipsum()
p1+p2 = plot
#summary(plot)

#ggplot(data=dnm_by_parental_age,
 #     mapping = aes(x=Mother_age, y=n_maternal_dnm,n_paternal_dnm)) + stat_smooth(method="lm")+
  #geom_point()
#ggplot(data=dnm_by_parental_age,
       #mapping = aes (x=Father_age, y=n_paternal_dnm))+
  #geom_histogram(alpha=0.5)

#2.6: Statistical Analysis





#close the file
fs.close()
  