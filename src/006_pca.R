root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

img <- raster::stack(paste0(envrmt$path_data_aerial_processed, "img_res.tif"))
indices <- stack(paste0(envrmt$path_data_aerial_processed,
                        list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*_index.tif"))))
indices <- stack(indices, img[[1]], img[[2]], img[[3]])

####PCA####
#pcastack <- stack(indices$CIVEindex, indices$BIindex, indices$TGIindex, indices$VVIindex, indices$GLIindex, indices$CEVindex)
indices_norm <- normImage(indices, norm = TRUE)
names(indices_norm) <- names(indices)
indices_norm <- indices_norm[[-9]]

for (i in 1:length(names(indices_norm))){
  names(indices_norm[[i]]) <- paste0(names(indices_norm[[i]]), "_norm")
}

writeRaster(indices_norm, filename = paste0(envrmt$path_data_aerial_processed, names(indices_norm), ".tif"), bylayer=TRUE, overwrite = TRUE)

pca <- RStoolbox::rasterPCA(indices_norm, spca = FALSE, nComp = 5)
saveRDS(pca, file = paste0(envrmt$path_data_aerial_processed, "pca.rds"))
pca <- readRDS(paste0(envrmt$path_data_aerial_processed, "pca.rds"))

####Plots####

eigvalue.pca <- factoextra::get_eigenvalue(pca$model)
barplot <- factoextra::fviz_eig(pca$model, addlabels = TRUE,ylim=c(0,80))
png(paste0(envrmt$path_data_plots, "barplotPCA.png"), res=300, width=12, height = 10, units = "in")
print(barplot)
dev.off()

var.pca <- factoextra::get_pca_var(pca$model)
pointplot <- corrplot::corrplot(var.pca$contrib,is.corr = FALSE)
png(paste0(envrmt$path_data_plots, "pointplotPCA.png"), res=300, width=12, height = 10, units = "in")
print(corrplot::corrplot(var.pca$contrib,is.corr = FALSE))
dev.off()


rose <- factoextra::fviz_pca_var(pca$model, col.var = "cos2",
                                 gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                                 alpha.var = "cos2",# add transparency according to cos2-values
                                 repel = TRUE) # Avoid text overlapping
png(paste0(envrmt$path_data_plots, "rosePCA.png"), res=300, width=12, height = 10, units = "in")
print(rose)
dev.off()



writeRaster(pca$map$PC1, filename = paste0(envrmt$path_data_aerial_processed, "pca1.tif"), overwrite=TRUE)
writeRaster(pca$map$PC2, filename = paste0(envrmt$path_data_aerial_processed, "pca2.tif"), overwrite=TRUE)