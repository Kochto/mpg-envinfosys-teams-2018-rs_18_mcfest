root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

img <- stack(paste0(envrmt$path_data_aerial_processed, "img.tif"))

indices <- stack(paste0(envrmt$path_data_aerial_processed, list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*index.tif"))))

#indices <- rgbIndices(img, rgbi = c("VVI","BI","TGI","GLI", "CIVE", "CEV", "mcfesti"))
# for (l in indices[[1:length(indices)]]) {
#   writeRaster(l, filename = paste0(envrmt$path_data_aerial_processed, names(l), "index.tif"), overwrite=TRUE)
# }

#writeRaster(indices$CEV, filename = paste0(envrmt$path_data_aerial_processed, names(indices$CEV), "index.tif"), overwrite=TRUE)

plot(indices, col = grey.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))
plot(indices$mcfestiindex, col = grey.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))
saveRDS(indices, file = paste0(envrmt$path_data_aerial_processed, "indices.rds"))

pcastack <- stack(indices$CIVEindex, indices$BIindex, indices$TGIindex, indices$VVIindex)
pcamcfest <- RStoolbox::rasterPCA(pcastack)

# tgi <- rgbIndices(img, rgbi = c("TGI"))
# plot(indices, col = gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))

#RS TOOLBOX BIB - Hauptkomponentenanalyse rasterPCA 