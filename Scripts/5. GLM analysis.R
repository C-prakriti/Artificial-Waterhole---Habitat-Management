#----------------
#Project: Wildlife Waterhole Utilization
#Purpose: 1. To identify the significant factors influencing species richness, visit, diversity and evenness
#---------------

#Load required packages
library(tidyverse)
library(MASS)
library(broom)


#Load the csv file where the environmental variables and the species metadata are combined
trial_data <- read.csv("waterhole_data.csv")

#Explore the data
str(trial_data)

#When fitting the model, we use poisson family for count variables which in our case is species richness and visits. If over dispersed then we fit negative binomial family. 
#When fitting the model, we use gaussian family for continuous variables which in our case is species diversity and evenness.
#Fit GLM for species richness using Poisson GLM
richness_glm <- glm(
  species_richness ~ area_m2 + waterlevel_m + distance_road_m + distance_water_m + distance_settlement_m,
  family = poisson(link = "log"),
  
  data = trial_data
)

summary(richness_glm)

#Check for overdispersion
deviance(richness_glm) / df.residual(richness_glm)

# Here if the value is > 1.5,then overdispersed. Consider using Negative Binomial GLM
richness_nb <- glm.nb(
  species_richness ~ area_m2 + waterlevel_m + distance_road_m + distance_water_m + distance_settlement_m, 
  data = trial_data
)

summary(richness_nb)

# Interpret the obtained data using pr(>|z|) and for gaussian pr(>|t|)
# In similar manner model for species visit, diversity and evenness using gaussian model, as gaussian model works better for count data.
#For species diversity
diversity_glm <- glm(
  shannon_index ~ area_m2 + waterlevel_m + distance_road_m + distance_water_m + distance_settlement_m,
  family = gaussian(),
  data = trial_data
)
summary(diversity_glm)

#Check for multicollinearity
vif(richness_nb)
# VIF value < 3 gives a reliable data.

# Create a table to visualize the relationship between dependent and independent variables
# Extract model summaries
richness_tab <- tidy(richness_nb) %>%
  mutate(Response = "Species richness")

diversity_tab <- tidy(diversity_glm) %>%
  mutate(Response = "Species Diversity")

# Do this for species visit and evenness as well
#Combine all models
final_table <- bind_rows(
  richness_tab,
  diversity_tab
)

#Rename all the columns
final_table <- final_table %>%
  select(Response,
         term,
         estimate,
         std.error,
         statistic,
         p.value) %>%
  rename(
    "Response Var." = Response,
    "Term" = Term,
    "Estimate" = estimate,
    "Standard.error" = std.error,
    "Statistic" = statistic,
    "P.value" = p.value
  )

# Add significant star
final_table <- final_table %>%
  mutate(significance = 
           case_when(
             P.value < 0.01 ~ "**",
             P.value < 0.05 ~ "*",
             TRUE ~ ""
           ))

# Export the table as a csv file
write.csv(final_table, "GLM_analysis.csv", row.names = FALSE)
