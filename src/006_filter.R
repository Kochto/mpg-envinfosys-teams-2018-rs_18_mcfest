root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

##for loop for glcm filter 3x3

nadellaub <- raster(paste0(envrmt$path_data_lidar_segtest, "testalle.tif"))

ht <- filter(img[[1]], fil=c("sobel5", "mean5"))

n_grey <- 3
glcm3 <- glcm::glcm(x = nadellaub, n_grey = n_grey, window = c(3,3))

rs[[i]]
nadellaub[[1]]
