#----------------
#Project: Wildlife Waterhole Utilization
#Purpose: To extract metadata from the image files
#---------------

#Load the required packages
library(dplyr)

#Load the metadata csv file
data <- read.csv("Sample_metadata.csv")

#Ensure the date-time column is in POSIXct format
data$datetime <- as.POSIXct(data$datetime, format = "%Y:%m:%d %H:%M:%S")

#Sort by species and datetime
data <- data %>%
  arrange(waterhole, species, datetime)

#Filter the images based on 30 minutes gap for each individual
filter_images <- function(df){         #df gives the subset of the dataset
  
  df <- df %>%
    arrange(datetime) %>%
    mutate(
      time_diff = c(Inf, diff(datetime))  #calculate time difference, inf for first row with no initial value
    ) %>%
    filter(time_diff > 30 * 60)           #time difference from previous row kept 30 minutes after previous image
  
  return (df)
}
  
  # Filter by site + species
  filter_images <- data %>%
    group_by(waterhole, species) %>%
    group_modify(~filter_images(.x)) %>%
    ungroup()
  
  #Remove the helper column (filter_images)
  filter_images <- filter_images %>%
    select(-time_diff)
  
  #Export the resulting csv file
  write.csv(filter_images, "independent_events.csv", row.names = FALSE)
    
