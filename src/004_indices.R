root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

#img <- stack(paste0(envrmt$path_data_aerial_processed, "img.tif"))
#chm <- stack(paste0(envrmt$path_data_lidar, "canopy.tif"))

#img_res <- resample(img, chm, method = "bilinear")
#writeRaster(img_res, filename = paste0(envrmt$path_data_aerial_processed, "img_res.tif"), overwrite = TRUE)
img <- raster::stack(paste0(envrmt$path_data_aerial_processed, "img_res.tif"))
#indices <- rgbIndices(img, rgbi = c("VVI", "TGI", "GLI", "CIVE", "VARI", "ExGR", "VEG", 
 #                                   "NGRDI", "NDTI", "CI", "BI", "SI", "HI", "ExG", "COM", "CEV", "mcfesti"))

#writeRaster(indices, filename = paste0(envrmt$path_data_aerial_processed, names(indices), "_index.tif"), bylayer=TRUE, overwrite = TRUE)



indices <- stack(paste0(envrmt$path_data_aerial_processed,
                       list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*_index.tif"))))
indices <- stack(indices, img[[1]], img[[2]], img[[3]])


####LIDAR Indices####
#chm <- raster::raster(paste0(envrmt$path_data_lidar, "canopy.tif"))
#lindices <- raster::terrain(x = chm, opt = c("slope", "aspect", "TPI", "TRI", "roughness", "flowdir"), unit = "radians")




