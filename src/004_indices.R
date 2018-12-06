root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

#img <- stack(paste0(envrmt$path_data_aerial_processed, "img.tif"))
#chm <- stack(paste0(envrmt$path_data_lidar, "canopy.tif"))

#img_res <- resample(img, chm, method = "bilinear")
#writeRaster(img_res, filename = paste0(envrmt$path_data_aerial_processed, "img_res.tif"), overwrite = TRUE)
img <- raster::stack(paste0(envrmt$path_data_aerial_processed, "img_res.tif"))
#indices <- rgbIndices(img, rgbi = c("VVI", "TGI", "GLI", "CIVE", "VARI", "ExGR", "VEG", "NGRDI"))

#writeRaster(indices, filename = paste0(envrmt$path_data_aerial_processed, names(indices), "_index.tif"), bylayer=TRUE, overwrite = TRUE)

indices <- stack(paste0(envrmt$path_data_aerial_processed,
                       list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*_index.tif"))))

#RS TOOLBOX BIB - Hauptkomponentenanalyse rasterPCA
#pcastack <- stack(indices$CIVEindex, indices$BIindex, indices$TGIindex, indices$VVIindex, indices$GLIindex, indices$CEVindex)
pca <- RStoolbox::rasterPCA(indices)
saveRDS(pca, file = paste0(envrmt$path_data_aerial_processed, "pca.rds"))
pcamin <- RStoolbox::rasterPCA(indices[[-c(1, 2, 5)]])
saveRDS(pcamin, file = paste0(envrmt$path_data_aerial_processed, "pcamin.rds"))
pca <- readRDS(paste0(envrmt$path_data_aerial_processed, "pca.rds"))
pcamin <- readRDS(paste0(envrmt$path_data_aerial_processed, "pcamin.rds"))

eigvalue.pca <- factoextra::get_eigenvalue(pca$model)
factoextra::fviz_eig(pca$model, addlabels = TRUE,ylim=c(0,50))
var.pca <- factoextra::get_pca_var(pca$model)
factoextra::fviz_pca_var(pca$model, col.var = "black")
corrplot::corrplot(var.pca$contrib,is.corr = FALSE)
factoextra::fviz_pca_var(pca$model, col.var = "cos2",
                         gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                         alpha.var = "cos2",# add transparency according to cos2-values
                         repel = TRUE # Avoid text overlapping
)

factoextra::fviz
corrplot


writeRaster(pca$map$PC1, filename = paste0(envrmt$path_data_aerial_processed, "pca1.tif"), overwrite=TRUE)
writeRaster(pca$map$PC2, filename = paste0(envrmt$path_data_aerial_processed, "pca2.tif"), overwrite=TRUE)

indices <- stack(paste0(envrmt$path_data_aerial_processed, list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*index.tif"))[c(2, 4, 5)]), 
                 paste0(envrmt$path_data_aerial_processed, "pcamcfest1.tif"))
