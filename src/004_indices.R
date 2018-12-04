root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

#img <- stack(paste0(envrmt$path_data_aerial_processed, "img.tif"))
#chm <- stack(paste0(envrmt$path_data_lidar, "canopy.tif"))

#img_res <- resample(img, chm, method = "bilinear")
#writeRaster(img_res, filename = paste0(envrmt$path_data_aerial_processed, "img_res.tif"), overwrite = TRUE)
img_res <- raster::stack(paste0(envrmt$path_data_aerial_processed, "img_res.tif"))
indices <- rgbIndices(img_res, rgbi = c("VVI","BI","TGI","GLI", "CIVE", "CEV"))

writeRaster(indices, filename = paste0(envrmt$path_data_aerial_processed, names(indices), "_index.tif"), bylayer=TRUE, overwrite = TRUE)

indices <- stack(paste0(envrmt$path_data_aerial_processed,
                       list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*_index.tif"))))

plot(indices, col = grey.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))
plot(indices$mcfestiindex, col = grey.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))

#RS TOOLBOX BIB - Hauptkomponentenanalyse rasterPCA
pcastack <- stack(indices$CIVEindex, indices$BIindex, indices$TGIindex, indices$VVIindex, indices$GLIindex, indices$CEVindex)
pcamcfest <- RStoolbox::rasterPCA(pcastack)
writeRaster(pcamcfest$map$PC1, filename = paste0(envrmt$path_data_aerial_processed, "pcamcfest1.tif"), overwrite=TRUE)
writeRaster(pcamcfest$map$PC2, filename = paste0(envrmt$path_data_aerial_processed, "pcamcfest2.tif"), overwrite=TRUE)

indices <- stack(paste0(envrmt$path_data_aerial_processed, list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*index.tif"))[c(2, 4, 5)]), 
                 paste0(envrmt$path_data_aerial_processed, "pcamcfest1.tif"))
