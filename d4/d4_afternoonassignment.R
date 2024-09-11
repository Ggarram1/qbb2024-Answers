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
 #                formula = n_maternal_dnm ~1 + Mother_age)
#summary(full_model)

#the "size" of the relationship can be determined based on the slope(maternal), at 0.378, this is 
#a positive slope. This means that as the mother gets older, there is a small increase
#in number of dnms. However, the Adjusted R-squared(maternal) is 0.23, this shows that this 
#is a mildly strong relationship.
#The "significance" of this relationship is denoted by the p-value (<2.2e^-16)
#This is a very low p-value which shows that the relationship is not due to chance,
#but, instead, is statistically significant.

#2.3
#full_model <- lm(data=dnm_by_parental_age,
 #               formula = n_paternal_dnm ~1 + Father_age)
#summary(full_model)
#the "size" of the relationship can be determined based on the slope(paternal), at 1.35, this is 
#a positive slope. This means that as the father gets older, there is an increase
#in number of dnms. However, the Adjusted R-squared(paternal) is 0.62, this shows that this 
#is a stronger relationship than observed between maternal age and maternal dnms.
#The "significance" of this relationship is denoted by the p-value (<2e^-16)
#This is a very low p-value which shows that the relationship is not due to chance,
#but, instead, is statistically significant.This value is slightly higher than that of
#the maternal data. 

#2.4
#y=b0 + b1*x1 + b2*x2
# (number of paternal DNMs) = 10.32 + (1.35*50.5)
#This would yield an estimate of 78.495 DNMs

#2.5
ggplot(data=dnm_by_parental_age) +
  geom_histogram(aes(x=n_maternal_dnm),color="#ef99f8", size=2, alpha=0.5)+
  geom_histogram(aes(x=n_paternal_dnm),color="#bb7977", size=2, alpha=0.5)+
  ggtitle("Maternal vs. Paternal DNMs by Age")

#2.6: Statistical Analysis
t.test(dnm_by_parental_age$n_maternal_dnm, dnm_by_parental_age$n_paternal_dnm)
#p1 <- ggplot(data=dnm_by_parental_age, aes(x=n_maternal_dnm)) +
  #geom_histogram(color="#eee9f8", size=2) +
  #ggtitle("Maternal DNMs")
#p2 <- ggplot(data=dnm_by_parental_age, aes(x=n_paternal_dnm)) +
  #geom_histogram(color="#177",size=2) +
  #ggtitle("Paternal DNMs")
#p1+p2 = plot
summary(plot)

#An (unpaired) T test was chosen as the maternal and paternal DNM counts are
#separate measurements, rather than repeated measurements of the same variable.
#This test is to consider these separately - that is, we are looking to determine 
#if there is a difference in number of paternal DNMs depending on father age
#and the number of maternal DNMs depending on mother age - we are not asking if
#the number of Maternal DNMs at a given age is different to the number of paternal
#DNMs at the same age/in the same organism.
#This uses, therefore, Welch's two sample t-test
#The p value from the t test is 2.2e^-16. This suggest a non-random cause
#for the difference. 
#This test is 2-tailed to consider both the positive and negative tails of the distribution.



#close the file
fs.close()
  