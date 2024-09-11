library(tidyverse)
library(palmerpenguins)
library (ggthemes)

glimpse(penguins)

penguins[,"island"]

penguins[,c("species","island")]

penguins[2,c("species","island")]

ggplot (data= penguins)+
  geom_point(mapping=aes (x=flipper_length_mm, y=body_mass_g, color=species, shape=species))+
  geom_smooth(mapping=aes (x=flipper_length_mm, y=body_mass_g), method="lm") +scale_color_colorblind()+
  xlab("Flipper Length (mm)")+ylab("Body Mass (g)")+ggtitle("Relationship Between Body Mass and Flipper Length")

ggsave(filename="~/qbb2024-Answers/penguin-plot.pdf")

#does bill length or depth depend on the sex of the penguins<

ggplot(data=penguins,
       mapping = aes (x=bill_length_mm, fill = sex))+
  scale_fill_colorblind()+
  geom_histogram(position = "identity", alpha=0.5)+
  facet_grid(sex ~ species)

ggplot (data = penguins, mapping = aes (x=factor(year), y=body_mass_g, fill=sex)) + 
  xlab("Year")+ylab("Body Mass (g)")+ggtitle("Body Mass Over Time")+
  geom_boxplot()+
    facet_grid(island ~ species)
  
  