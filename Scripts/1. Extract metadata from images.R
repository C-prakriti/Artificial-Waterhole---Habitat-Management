#----------------
#Project: Wildlife Waterhole Utilization
#Purpose: To extract metadata from the image files
#---------------

#Install and load packages
install.packages("exifr")
install.packages("dplyr")
library(exifr)
library(dplyr)

#Set the directory containing the media files
dir <- "D:/Github/Example/Images"

# Read metadata of all images from the folder
metadata <- read_exif(dir, recursive = TRUE)

# View the metadata 
head (metadata)

# Select the required variables
data <- metadata[,c(
  "FileName",
  "SourceFile",
  "DateTimeOriginal",
  "FileType"
)]

#When the Source file is: D:/Example/Tiger/waterhole.jpg
#Extract the folder name, which is named after the species when the images were sorted - each species per folder
data$Species <- basename(dirname(data$SourceFile))

#Extract the file name where each image file has been renamed using the waterhole name
data$waterhole <- basename(data$SourceFile)

#Export the metadata as a csv file
write.csv (data, "Sample_metadata.csv", row.names = FALSE)


