#----------------
#Project: Wildlife Waterhole Utilization
#Purpose: 1. To analyze the temporal activity pattern of each species in relation to waterhole use
        # 2. To compare the activity patterns of prey, predator and megaherbivores in relation to waterhole use
#---------------

# 1. Install and load the lubridate package
install.packages("lubridate")
install.packages("tidyverse")
library(lubridate)
library(tidyverse)

# 2. Load the csv file
data <- read.csv("independent_events.csv")

# 3. Read the structure of your datetime column
str(data$datetime)

# 4. Convert the character (yyyy:mm:dd hh:mm:ss) to datetime format
data$datetime_parsed <- as.POSIXct(
  data$datetime,
  format = "%m/%d/%Y %H:%M"
)

# 5. Extract hour
data$hour <- hour(data$datetime_parsed)

# 6. Classify time periods
data$time_period <- ifelse(
  data$hour >= 5 & data$hour < 12, "Morning",
  ifelse(
    data$hour >= 12 & data$hour < 17, "Day",
    ifelse(
      data$hour >= 17 & data$hour < 20, "Evening",
      "Night"
    )
  )
)

# 7. Remove the hour column if not necessary (optional)
data <- data %>%
 select(-hour)

# 8. Create a matrix to visualize the temporal activity by each species
summary <- data %>%
  group_by(species, time_period) %>%
  summarize(count = n(), .groups = "drop") %>%
  spread(key = time_period, value = count, fill = 0)

summary

#For purpose 2:
# 9. Add column to categorize the animals
data <- data %>%
  mutate(
    category = case_when(
      
      species %in% ("Tiger") ~ "Predator",
      species %in% c("Barking Deer", "Barking Deer", "Four-horned Antelope", "Indian Grey Mongoose", "Indian Hare",
                     "Rhesus Monkey", "Spotted Deer", "Wild Boar", "Birds", "Indian Crested Porcupine") ~ "Prey",
      species %in% ("Asian Elephant") ~ "Mega-herbivore",
      
      TRUE ~ "Unknown"
      
    )
  )

# 10. Summarize the data by category and prey
category_summary <- data %>%
  group_by(category, time_period) %>%
  summarize(count = n(), .groups = "drop") %>%
  spread(key = time_period, value = count, fill = 0)

# 11. Export the categorized csv file and data frame
write.csv(summary, "Temporal_activity_matrix.csv", row.names = FALSE)
write.csv(category_summary, "category_summary_matrix.csv", row.names = FALSE)
write.csv(data, "Temporal_metadata.csv", row.names = FALSE)









