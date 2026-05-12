#----------------
#Project: Wildlife Waterhole Utilization
#Purpose: To calculate species richness, species visit, species diversity and species evenness in each waterholes
#---------------

#Install and load the packages
install.packages("tidyverse")
install.packages("vegan")
library(tidyverse)
library(vegan)

#Load the csv independent data
data <- read.csv("independent_events.csv")
head(data)

# Count the number of times each species was recorded
species_count <- data %>%
  count(species)

species_count

# 1. Count the number of unique species seen in each waterhole - species richness
species_richness <- data %>%
  group_by(waterhole) %>%
  summarise(species_richness = n_distinct(species))

species_richness

# 2. Calculate Shannon diversity by waterhole - species diversity
# 2.1 Create a species abundance table for each waterhole
data_wide <- data%>%
  group_by(waterhole, species) %>%
  summarise(count = n(), .groups = "drop") %>%
  pivot_wider(names_from = species,
              values_from = count,
              values_fill = 0)

# 2.2 Remove the waterhole column temporarily
matrix <- data_wide[,-1]

# 2.3 Calculate shannon diversity
values <- diversity(matrix,
                               index = "shannon")
str(shannon_diversity)

# 2.4 Combine the waterhole column
species_diversity <- data.frame(
  waterhole = data_wide$waterhole,
  shannon_index = values
)

species_diversity

# 3. Calculate Pielou's evenness index - Species evenness
species_evenness <- species_diversity %>%
  left_join(species_richness,
            by = "waterhole") %>%
  mutate(evenness = shannon_index/log(species_richness))

species_evenness

# 4. Calculate number of independent visits to each waterhole
species_visit <- data %>%
  group_by(waterhole) %>%
  summarise(visits = n(), .groups = "drop") %>%
  arrange(waterhole, desc(visits))

species_visit

# Combine the species_visit values into species_evenness to create a single waterhole_species_metadata
waterhole_species_metadata <- species_evenness %>%
  left_join(species_visit,
            by = "waterhole")

waterhole_species_metadata  

#Export the final data as a csv file
write.csv(waterhole_species_metadata, "waterhole_species_metadata.csv", row.names = FALSE)


