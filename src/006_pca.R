root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

img <- raster::stack(paste0(envrmt$path_data_aerial_processed, "img_res.tif"))
indices <- stack(paste0(envrmt$path_data_aerial_processed,
                        list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*_index.tif"))))
indices <- stack(indices, img[[1]], img[[2]], img[[3]])

####PCA####
#pcastack <- stack(indices$CIVEindex, indices$BIindex, indices$TGIindex, indices$VVIindex, indices$GLIindex, indices$CEVindex)
#indices_norm <- normImage(indices, norm = TRUE)
#names(indices_norm) <- names(indices)
#indices_norm <- indices_norm[[-9]] #HI Rausgeworfen

# for (i in 1:length(names(indices_norm))){
#   names(indices_norm[[i]]) <- paste0(names(indices_norm[[i]]), "_norm")
# }

#writeRaster(indices_norm, filename = paste0(envrmt$path_data_aerial_processed, names(indices_norm), ".tif"), bylayer=TRUE, overwrite = TRUE)

indices_norm <- stack(paste0(envrmt$path_data_aerial_processed,
                        list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*_index_norm.tif"))))


#pca <- RStoolbox::rasterPCA(indices_norm, spca = FALSE, nComp = 5)
#saveRDS(pca, file = paste0(envrmt$path_data_aerial_processed, "pca.rds"))
pca <- readRDS(paste0(envrmt$path_data_aerial_processed, "pca.rds"))

####Plots####

eigvalue.pca <- factoextra::get_eigenvalue(pca$model)
barplot <- factoextra::fviz_eig(pca$model, choice = c("Variance"), ylim=c(0,80), geom = c("bar", "line"), barfill = "#9DC3E6", 
                                linecolor = "#000000", hjust = 0, addlabels = FALSE, main = "Variances", 
                                ggtheme = ggplot2::theme_gray())+
          ggplot2::theme(plot.title = element_text(hjust=0.5), axis.text = element_text(size = 38),axis.title.x = element_text(size = 38, margin = margin(t = 40, r = 0, b = 0, l = 0)), 
                         axis.title.y = element_text(size = 38, margin = margin(t = 0, r = 40, b = 0, l = 0)), title = element_text(size = 42))

png(paste0(envrmt$path_data_plots, "barplotPCA.png"), res = 500, width=20, height = 20, units = "in")
print(barplot)
dev.off()

var.pca <- factoextra::get_pca_var(pca$model)
rownames(var.pca$contrib) <- c("BI", "CEV", "CI", "CIVE", "COM", "ExG", "ExGR", "GLI", "MCFESTI", "NDTI", "NGRDI", "RI", "SI",
                         "TGI", "VARI", "VEG", "VVI", "RED", "GREEN", "BLUE")
colnames(var.pca$contrib) <- gsub(".", " ", colnames(var.pca$contrib), fixed = TRUE)
corrplot::corrplot(var.pca$contrib,is.corr = FALSE, method = "circle", type = "full", col = NULL,
                                outline = TRUE, diag = TRUE, tl.col = "#000000", tl.cex = 3)

png(paste0(envrmt$path_data_plots, "pointplotPCA.png"), res=500, width=20, height = 20, units = "in")
print(corrplot::corrplot(var.pca$contrib,is.corr = FALSE, method = "circle", type = "full", col = NULL,
                         outline = TRUE, diag = TRUE, tl.col = "#000000", tl.cex = 3))
dev.off()


rose <- factoextra::fviz_pca_var(pca$model, col.var = "cos2", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                                 alpha.var = "1",# add transparency according to cos2-values
                                 repel = TRUE,habillage ="none")+
  ggplot2::theme(plot.title = element_text(hjust=0.5), axis.text = element_text(size = 16),axis.title.x = element_text(size = 16, margin = margin(t = 40, r = 0, b = 0, l = 0)), 
                 axis.title.y = element_text(size = 16, margin = margin(t = 0, r = 40, b = 0, l = 0)), title = element_text(size = 24))
# Avoid text overlapping
png(paste0(envrmt$path_data_plots, "rosePCA.png"), res=350, width=10, height = 10, units = "in")
print(rose)
dev.off()



writeRaster(pca$map$PC1, filename = paste0(envrmt$path_data_aerial_processed, "pca1.tif"), overwrite=TRUE)
writeRaster(pca$map$PC2, filename = paste0(envrmt$path_data_aerial_processed, "pca2.tif"), overwrite=TRUE)