root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

img <- stack(paste0(envrmt$path_data_aerial_processed, "img.tif"))
indices <- stack(paste0(envrmt$path_data_aerial_processed, list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*index.tif"))[c(2, 4, 5)]), 
                 paste0(envrmt$path_data_aerial_processed, "pcamcfest1.tif"))

filter_img <- fil(rs = laub, filters = c("mean5", "sbh5","sbv5","laplc5","gauss5"))
filter_ind <- fil(rs = indices, filters = c("mean5", "sbh5","sbv5","laplc5","gauss5"))

for (l in 1:nlayers(filter_img)) {
  writeRaster(filter_img[[l]], filename = paste0(envrmt$path_data_aerial_processed, "img_filter_", names(filter_img[[l]]), ".tif"), overwrite=TRUE)
}

for (l in 1:nlayers(filter_ind)) {
  writeRaster(filter_ind[[l]], filename = paste0(envrmt$path_data_aerial_processed, "ind_filter_", names(filter_ind[[l]]), ".tif"), overwrite=TRUE)
}