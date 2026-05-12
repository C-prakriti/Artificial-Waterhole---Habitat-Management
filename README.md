# Wildlife Waterhole Utilization 
This project contains data analysis, GIS workflow, camera trap processing and statistical modeling used to assess the utilization pattern of artificial waterholes by mammals 

# Title
An Assessment of Utilizaiton Pattern of Artificial Waterholes by Wildlie in Banke National Park

# Overview
Artificial waterholes are a common habitat management strategy applied by park officials to ensure water availability during dry seasons. This project was carried out to see how effectively the artificial waterholes are being used by the wild animals and what characterstics of the waterholes or environmental factors influenced the species to use the waterhole. 

# Objectives
1. To analyze species richness, diversity, evenness and visitation patterns at artificial waterholes
2. To assess the temporal pattern of waterhole ustilization by different fauna
3. To determine the potential environmental factors that influences a species choice of a waterhole
   
# Methods
## Data Collection
### 1. Camera trapping
In Field
- 8 Bolymedia BG584 invisible infrared wireless trap cameras were deployed in 8 functioning waterholes for a total of 17 days in the month of May.
-  The cameras were set to run for 24 hours with PIR trigger of 5 seconds and trigger burst of 3.
-  The cameras were placed at a height of 30 - 170 cm above the ground depending on the topography. 
### 2. Site Characterstics
In Field
- The area of each waterholes were measured using a GPS device. They were also confirmed by the parks records at the time of waterhole construction.
- The water level was measured using the measuring tape for shallow waterholes and visual assessment by park experts for larger ones.
  
### 3. Environmental Parameters
In ArcGIS
| Parameter | Type | Source |
|-----------|--------|------|
| Permanent water source | Raster | ESRI Sentinel-2 Land Cover Explorer | 
| Settlement Area | Vector | Open Street Map|
|Active Roads | Vector | Open Street Map |

## Data Analysis 
### Data Wrangling
In R 
- Extracted metadata (Source file, datetime stamp) from the camera trap images
- Created 30 minutes independent image (O'Brien et al., 2003).
### Diversity Indices
In R
- Species richness recorded in each waterholes from the images and presented in donut chart
- Species visit recorded to see the number of times the individuals used waterholes
- Species diversity calculated using Shannon-Weiner diversity index
- Species eveness calculated using Pielou's evenness Index
### Temporal Utilization
In R
- Classified 24 h period into four time periods i.e. morning, day, evening and night 
- Compared the temporal activity between prey, predator and mega-herbivores
### GLM Modeling
- Dependent variable = Species visit, Species richness, Species evenness and Species diversity
- Independent variable = Area of waterhole, Level of waterhole, Distance from nearest permanent water source, Distance from nearest active road and Distance from nearest settlement area
- Fitted various models to determine the best model for each dependent variable. Gaussian model for species diversity, Poisson model for species richness and negative binomial model for species visit
- The significance between dependent and independent variable was assessed = p-value (pr(>|z|).

# Tools Used
- R (4.5.3)
- ArcGIS
- BR's Exif Extractor
- Microsoft Excel
- Camera trap

# Workflow
```mermaid
flowchart TD

A[Preliminary Survey] --> B[Waterhole Selection]
B --> C[Camera Trap Installation]
C --> D[Image Collection]
D --> E[Data Cleaning]

E --> F[Species Identification]
F --> G[Independent Event Classification]

G --> H[Statistical Analysis]
H --> I[Species Diversity Analysis]
H --> J[Temporal Activity Analysis]
H --> K[GLM Modeling]

J --> L[Visualization & Mapping]
```

# Key Results
- The temporal activity differed. between prey and predators
- Waterholes with smaller area were visited more frequently.
- Waterholes near the roads supported more species richness.
  
# Repository Structure
```text
artificial-waterhole-utilization/
│
├── README.md           # Project overview
├── data/               # Sample and processed datasets
├── scripts/            # R analysis scripts
├── results/            # Graphs, tables, and outputs
├── maps/               # GIS layers and maps
├── docs/               # Thesis documents and reports
└── images/             # Camera trap and study area images
```

# Reproducibility
The repository includes:
- sample datasets,
- R scripts,
- visualization workflows,
- and processed outputs
to demonstrate the analytical methodology used in this study
