library("tidyverse")

df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
#this opens the data file in R.
df <- df %>%
  mutate( SUBJECT=str_extract( SAMPID, "[^-]+-[^-]+" ), .before=1 )
#this organizes by subject

df %>% 
  group_by(SUBJECT) %>%
  summarize(counts=n()) %>%
  arrange(counts) 
#this organizes the subjects based on number of samples taken from each subject.

#The subjects from which the most samples were taken are K-562 (217 samples) 
#and GTEX-NPJ8 (72). Only one sample was taken from GTEX-1JMI6 and GTEX-1PAR6.


df %>% 
  group_by(SMTSD) %>%
  summarize(counts=n()) %>%
  arrange(-counts) 
#this organizes based on number of samples taken from each tissue type across subjects

#When grouping by tissue type, rather than Subject or considering organ, 
#the fewest samples were taken from the medulla of pt's kidneys while the most 
#samples were taken from the whole blood and skeletal muscle.

df_npj8 <- filter(df, SUBJECT=="GTEX-NPJ8")
 #this filters the data by one subject and saves the filtered data as a new
#object
 
 df_npj8 %>% 
   group_by(SMTSD) %>%
   summarize(counts=n()) %>%
   arrange(counts) 
#This shows how many samples were taken from each tissue type in only
#subject GTEX-NPJ8
 
 #The most samples were taken from whole blood (9), reflecting the total data,
 #while adipose, aortic, and esophageal tissues were only sampled once, as 
 #were: kidney (cortex), pancreas, pituitary, prostate, spleen and testis.
 #The data show the most samples taken from blood and brain tissue types. This
 #may be due to an increased tissue diversity in the brain/other tissues well sampled.
 
df_filtered <-  filter(df, !is.na(SMATSSCR) ) 
 #This removes all data where the SMATSSCR score is "N/A"
 
 df_filtered %>% 
   group_by(SUBJECT) %>%
   summarize(counts=n()) %>%
   arrange(counts) 
#As 980 subjects are shown prior to filtering by NA, while 966 subjects are
#shown after. Thus, there were 14 subjects who had a score of N/A for SMATSSCR.
 
#The mean scores for these data are predominantly low, with the the majority of
#the subjects showing rather low SMATSSCR. This is good as it suggests the 
#majority of the tissue has not undergone extensive cell death at the time of sampling.

#To present these data, a histogram of SMATSSCR scores could show the 
#distribution of the means.
 
 