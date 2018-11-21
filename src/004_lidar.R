root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

las_files <- list.files(envrmt$path_data_lidar_org, pattern = glob2rx("*.las"),
                       full.names = TRUE)

# Write LAX file for each LAS file
# for(f in las_files){
#   writelax(f)
# }

lidar_file = readLAS(file.path(envrmt$path_data_lidar_org, "U4755631.las"))
plot(lidar_file, bg = "white", color = "Z")

lcat = catalog(envrmt$path_data_lidar_org)
lcat@crs = CRS("+init=epsg:25832") # ETRS89 / UTM zone 32N
cores(lcat) <- 3L
tiling_size(lcat) = 500

plot(lcat)

# Clip catalog to the area of interest
aoi = readOGR(file.path(envrmt$path_data_mof, "uwcAbteilung.shp"))
aio_bb = bbox(aoi)
lasclipRectangle(lcat, xleft = aio_bb[1], ybottom = aio_bb[2], 
                 xright = aio_bb[3], ytop = aio_bb[4],
                 ofile=file.path(envrmt$path_data_tmp, "las_mof_aio.las"))

# Create a LAX file for the cliped data, create a new catalog and set catalog 
# options as above but extened by the tiling size attribute that is set to 
# 500 m.
writelax(file.path(envrmt$path_data_tmp, "las_mof_aio.las"))
lcat = catalog(file.path(envrmt$path_data_tmp, "las_mof_aio.las"))
lcat@crs = CRS("+init=epsg:25832")
cores(lcat) = 3L
tiling_size(lcat) = 500
buffer(lcat) = 0

# Tile the catalog LAS file(s) to 500 m tiles and point the dataset to a new
# catalog. The tiled las files are stored in the path_clip directory.
lcat_tiled = catalog_retile(lcat, envrmt$path_data_lidar, "las_mof_aio_")
lcat_tiled@crs = CRS("+init=epsg:25832")
cores(lcat_tiled) = 3L
tiling_size(lcat_tiled) = 500
buffer(lcat_tiled) = 0

lcat_spatial = as.spatial(lcat)
mapview(lcat_spatial)

# Compute surface model with 0.5 m resolution and convert it to a raster object.
gridcanopy = grid_canopy(lcat_tiled, 0.5, subcircle = 0.2)
tincanopy = as.raster(gridcanopy)
crs(gridcanopy) = lcat@crs

tincanopy <- grid_tincanopy(lcat_tiled, 0.5, subcircle = 0.2)
tincanopy = as.raster(tincanopy)
crs(tincanopy) = lcat@crs

terrain <- grid_terrain(lcat_tiled, res = 0.5, method = "knnidw")
terrain = as.raster(terrain)
crs(terrain) = lcat@crs

writeRaster(lchmr, paste0(envrmt$path_data_lidar, "grid_terrain.tif"))

canopy <- tincanopy-terrain
