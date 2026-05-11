# R codes and their description
Here is the description of what each R code file entails: 
1. **Extract metadata from images** = use exiftoolr to extract metadata into csv format
2. **Creating independent events** = Following (O'brien, 2002), the image of a species captured in a waterhole for consecutive 30 minutes was collapsed into one
3. **Calculate species richness, visit, diversity and evenness** = Code to calculate these factors for each waterhole
4. **Analyzing Temporal acitivity** = Has code to analyze the temporal activity of each species as well as the comparison of active period among prey, predator and mega-herbivores with respect to waterhole utilization
5. **GLM analysis** = Analyse the relationship between dependent variables (richness, visit, diversity and richness) with the independent variables (environmental and site variables)
6. **Visualization** = Codes to create maps for above analysis

 # Packages used:
   1. exiftoolr
   2. dplyr
   3. tidyverse
   4. lubridate
   5. vegan
   6. MASS
   7. ggplot2
   8. broom
