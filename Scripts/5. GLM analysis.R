#----------------
#Project: Wildlife Waterhole Utilization
#Purpose: 1. To identify the significant factors influencing species richness, visit, diversity and evenness
#---------------

# 1. Load required packages
library(tidyverse)
library(MASS)
library(broom)
library(car)

# 2. Load the csv file where the environmental variables and the species metadata are combined
trial_data <- read.csv("waterhole_data.csv")

# 3. Explore the data
str(trial_data)

# 4. Scale the predictors
trial_data <- trial_data %>%
  mutate(across(
    c(area_m2, waterlevel_m, distance_road_m, distance_water_m, distance_settlement_m),
    ~ as.numeric(scale(.))
  ))

#When fitting the model, we use poisson family for count variables which in our case is species richness and visits. 
#When fitting the model, we use gaussian family for continuous variables which in our case is species diversity and evenness.
# 5. To model relationship between species richness and independent variables
# 5.1 Fit GLM for species richness using Poisson GLM
richness_glm <- glm(
  species_richness ~ area_m2 + waterlevel_m + distance_road_m + distance_water_m + distance_settlement_m,
  family = poisson(link = "log"),
  
  data = trial_data
)
summary(richness_glm)

# 5.2 Check for dispersion
dispersion <- deviance(richness_glm) / df.residual(richness_glm)
dispersion

# 5.3 If the dispersion is > 1.5, consider using negative binomial model
if(dispersion > 1.5){
  richness_model <- glm.nb(
    species_richness ~ area_m2 + waterlevel_m + distance_road_m + distance_water_m + distance_settlement_m, 
    data = trial_data 
  )
} else {
  richness_model <- richness_glm
}
summary(richness_model)

# 5.4 Check for multicollinearity
vif(richness_model)

# 6. To model species visit against independent variables
visit_model <- glm.nb(
  species_visits ~ area_m2 + waterlevel_m +
    distance_road_m + distance_water_m +
    distance_settlement_m,
  data = trial_data
)
vif(visit_model)   #optional since already done above

# 7. In similar manner model for diversity and evenness using gaussian model.
# 7.1 Fit GLM for species diversity using gaussian model
diversity_glm <- glm(
  shannon_index ~ area_m2 + waterlevel_m + distance_road_m + distance_water_m + distance_settlement_m,
  family = gaussian(),
  data = trial_data
)
summary(diversity_glm)

# 7.2 Check for multicollinearity
vif(diversity_glm)

# 7.3 Residual diagnostics to check for model assumption
par(mfrow = c(2,2))
plot(diversity_glm)

# 7.4 Fit the model for species evenness against independent variables
evenness_model <- glm(
  evenness ~ area_m2 + waterlevel_m +
    distance_road_m + distance_water_m +
    distance_settlement_m,
  family = gaussian(),
  data = trial_data
)

# 7.5 Check for multicollinearity and residual diagnostics
vif(evenness_model)
par(mfrow = c(2,2))
plot(evenness_model)

# 8. Export the results as final table
# 8.1 Combine the data for each dependent variables into one table
final_table <- bind_rows(
  tidy(richness_model, conf.int = TRUE) %>%
    mutate(Response = "Species richness"),
  
  tidy(diversity_glm, conf.int = TRUE) %>%
    mutate(Response = "Species diversity"),
    
    tidy(visit_model, conf.int = TRUE) %>%
    mutate(Response = "Species visit"),
  
  tidy(evenness_model, conf.int = TRUE) %>%
    mutate(Response = "Species evenness")
) 

# 8.2 Add significance stars
final_table <- final_table %>%
  mutate(significance = case_when(
    p.value < 0.001 ~ "***",
    p.value <- 0.01 ~ "**",
    p.value <- 0.05 ~ "*",
    TRUE ~ ""
  ))

# 9. Export the final table
write.csv(final_table, "GLM_analysis.csv", row.names = FALSE)
