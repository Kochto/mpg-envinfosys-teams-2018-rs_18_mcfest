root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

img <- stack(paste0(envrmt$path_data_aerial_processed, "img.tif"))
indices <- stack(paste0(envrmt$path_data_aerial_processed, list.files(paste0(envrmt$path_data_aerial_processed), pattern=glob2rx("*index.tif"))[c(2, 4, 5)]), 
                 paste0(envrmt$path_data_aerial_processed, "pcamcfest1.tif"))

filter_img <- fil(rs = img, filters = c("mean5", "sbh5","sbv5","laplc5","gauss5"))
filter_ind <- fil(rs = indices, filters = c("mean5", "sbh5","sbv5","laplc5","gauss5"))

for (l in 1:nlayers(filter_img)) {
  writeRaster(filter_img[[l]], filename = paste0(envrmt$path_data_aerial_processed, "img_filter_", names(filter_img[[l]]), ".tif"), overwrite=TRUE)
}

for (l in 1:nlayers(filter_ind)) {
  writeRaster(filter_ind[[l]], filename = paste0(envrmt$path_data_aerial_processed, "ind_filter_", names(filter_ind[[l]]), ".tif"), overwrite=TRUE)
}

#GLCM Package

# The image was generated with the following code:
require(raster)
set.seed(0)
test_matrix <- matrix(runif(100)*32, nrow=10)
test_raster <- raster(test_matrix, crs='+init=EPSG:4326')
test_raster <- cut(test_raster, seq(0, 32))
plot(test_raster)
test_glcm <- glcm::expected_textures_3x3_1x1

library(glcm)
n_grey <- 2 # number of grey levels to use in texture calculation

pca <- stack(paste0(envrmt$path_data_aerial_processed, glob2rx("pca*")))

##for loop for glcm filter 3x3
glcm3x3 <- glcm::glcm(x = nadellaub,n_grey = n_grey, window = c(3,3))

factoextra::fviz
corrplot


###plot the filter
plotRGB(glcm3x3)
###save the filter
writeRaster(glcm3x3, filename = file.path(envrmt$path_processed, paste(savename, "_3x3_glcm.tif")))
###remove the filter
rm(glcm3x3)