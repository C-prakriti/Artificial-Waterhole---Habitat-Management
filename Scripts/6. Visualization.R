#----------------
#Project: Wildlife Waterhole Utilization
#Purpose: To visualize and present our data using graphs and tables
#---------------

# 1. Create a donut chart to visualize species observed in each waterhole
# 1.1 Install and load the packages
library(ggplot2)
library(dplyr)

# 1.2 Import the independent_events csv file 
data <- read.csv("independent_events.csv")
str(data)

# 1.3 Assign custom colors for every animal detected
custom_colors <- c("Asian Elephant" = "#FF7F50", "Barking Deer" = "#9EA68D", "Birds" = "#8396A5", 
                   "Four-horned Antelope" = "#8A9A5B", "Indian Crested Porcupine" = "#8B4513", "Indian Grey Mongoose" = "#6A5ACD",
                   "Indian Hare" = "#DDA0DD", "Rhesus Monkey" = "#FFC0CB", "Spotted Deer" = "#006400","Wild Boar"= "#9B7E9B")

# 1.4 Count observation for each species in each waterhole
count_data <- data %>%
  group_by(waterhole, species) %>%
  summarise(count = n(), .groups = "drop")

# 1.5 Calculate proportions within each waterhole
count_data <- count_data %>%
  group_by(waterhole) %>%
  mutate(proportion = count / sum(count))

# 1.6 Create donut charts
ggplot(count_data, 
       aes(x = 2, y = proportion, fill = species)) +  # Here 2 is a constant value to position bars at equal distance from the center
  geom_bar(stat = "identity", width = 1, color = "black") +   #geom_bar fist creates a normal stacked bar plot
  coord_polar(theta = "y") +                                  #coord_polar bends that stacked bar into a circle
  xlim(1, 2.5) +    #Creates donut hole
  facet_wrap(~waterhole)+ #One donut chart per waterhole
  
  scale_fill_manual(values = custom_colors) +
  
  theme_void() +
  
  labs(
    title = "Species recorded in each waterhole",
    fill = "species"
  ) +
  
  theme(
    plot.title = element_text(hjust = 0.5)
  )
  
#--------------------------------------------------------------------------------------------------------------

# 2. Bar graph showing species visit for each waterhole 
# 2.1 Load the csv file containing species visit data for each waterhole
data <- read.csv("waterhole_data.csv")
str(data)

# 2.2 Create a barchart for species visit in each waterhole
ggplot(data, aes(x = waterhole, y = visits)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Total Visits at Each Waterhole",
       x = "Waterhole",
       y = "Total Visits") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))  # Center the title
theme_minimal()

# We can do this for other 3 variables as well

#---------------------------------------------------------------------------------------------------------------

# 3. Visualizing the temporal pattern of waterhole visitation by each species

# 3.1 Load the temporal metadata csv file in temp_data
temp_data <- read.csv("Temporal_metadata.csv")
str(temp_data)

# 3.2 Count the number activity for each species in each waterhole
summary_data <- temp_data %>%
  group_by(species, time_period) %>%
  summarize(count = n(), .groups = 'drop') 

# 3.3 Create the stacked bar plot
ggplot(summary_data, aes(x = species, y = count, fill = time_period)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Temporal Pattern of Waterhole Utilization by Species",
    x = "Species",
    y = "Count"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.4, size = 16, face = "bold"),
    axis.text.x = element_text(angle = 90, vjust = 0.9, hjust = 0.4, size = 12),
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.text = element_text(size = 12),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14)
  ) +
  scale_fill_manual(
    values = c("Morning" = "#EF5642", "Day" = "#54B1B4", "Evening" = "#EECD4A", "Night" = "#796120")
  )
unique(temp_data$time_period)

#------------------------------------------------------------------------------------------------------

# 4. Compare the temporal activity of prey, predator and mega herbivore using line plot

# 4.1 Load the temporal metadata csv file in cat_data
cat_data <- read.csv("Temporal_metadata.csv")
str(cat_data)

# 3.2 Summarize data by species and time of day and calculate the count
summary_data <- temp_data %>%
  group_by(category, time_period) %>%
  summarize(count = n(), .groups = 'drop') 

str(summary_data)

# 4.2 Line Plot Showing Temporal Patterns
ggplot(summary_data, aes(x = time_period, y = count, color = category, group = category)) +
  geom_line(size = 0.5) +
  geom_point(size = 3) +
  labs(
    title = "Temporal Pattern of Waterhole Utilization",
    x = "Time of Day",
    y = "Count",
    color = " Category"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 0.3, size = 12),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  ) +
  scale_color_manual(
    values = c("Prey" = "#49DEE3", "Predator" = "#E34949", "Mega-herbivore" = "#84E349")
  ) +
  scale_x_discrete(limits = c("Morning", "Day", "Evening", "Night"))

#------------------------------------------------------------------------------------------------------------------------

# 5. To visualize the relationship between dependent and independent variable (area of waterhole and species richness)

# 5.1 Load the csv file with dependent and independent variables
data <- read.csv("waterhole_data.csv")
str(data)

# 5.2 Plot the relationship between waterhole area and species richness
ggplot(data, aes(x = area_m2, y = species_richness)) +
  geom_point() +
  geom_smooth(method = "glm", method.args = list(family = "poisson"), se = FALSE) +
  labs(title = "Effect of area of waterhole on Species Richness", x = "Area of waterhole", y = "Species Richness")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5))  # Center the title

# You can plot relationships between various dependent and independent variables using the code above
#----------------------------------------------------------------------------------------------------------

