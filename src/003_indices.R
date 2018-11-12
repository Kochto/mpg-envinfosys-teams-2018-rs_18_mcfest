root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

img <- stack(paste0(envrmt$path_data_aerial_processed, "img.tif"))

indices <- rgbIndices(img, rgbi = c("VVI","BI","TGI","GLI", "CIVE", "CEV", "mcfesti"))


plot(indices, col = gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))
saveRDS(indices, file = paste0(envrmt$path_data_aerial_processed, "indices.rds"))
writeRaster(indices[1:2], filename = paste0(envrmt$path_data_aerial_processed, "indices.tif"), bylayer=TRUE, suffix=names(indices))

# tgi <- rgbIndices(img, rgbi = c("TGI"))
# plot(indices, col = gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))
