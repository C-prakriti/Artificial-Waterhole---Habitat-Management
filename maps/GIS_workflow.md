# GIS Workflow

# Objective
This GIS workflow was used to derive environmental variables influencing wildlife utilization of artificial waterholes. The following spatial variables were calculated:
- Distance to nearest active road
- Distance to nearest settlement
- Distance to nearest permanent water source

  # Software Used
  - ArcGIS
  - OpenStreetMap data
  - ESRI Sentinel-2 Land Cover Explorer

  # Spatial Data Sources
  |Spatial Layer| Source |
  |-------------|--------|
  | Roads | OpenStreetMap |
  |Settlement Area | OpenStreetMap |
  | Permanent water source | ESRI Land Cover Data |
  | Waterhole coordinates | GPS |

  # GIS Processing Workflow
  ## Step 1: Imported the spatial layers
  All vector and raster layers were imported into GIS software
  The following layers were used:
  - Road network
  - Settlement areas
  - Permanent water source
  - Waterhole coordinates
  - Banke National Park boundary
 
  ## Step 2: Standardized the coordinate systems
  All layers were projected into WGS 1984 UTM Zone 44N using
  ArcToolbox > Data Management Tools > Projections and Transformation > Project 

  ## Step 3: Clipping Spatial layers
  The spatial layers were clipped to Banke National Park boundary
  Geoprocessing > Clip

  ## Step 4: Near Distance analysis
 Near tool was used to calculate distance of waterhole from nearest permanent water source, nearest road and nearest settlement
 ArcToolbox > Proximity > Near

  ## Step 5: Extracting Distance Values
  Distance values corresponding to each selected waterholes were extracted from the raster layers. The extracted values were exported as CSV format for statistical analysis

In this example, we used stored the spatial data in Sample_environmetal_data.csv. These variables were used in R to conduct statistical analysis to assess the influencing wildlife utilization of artificial waterholes.

    
  
