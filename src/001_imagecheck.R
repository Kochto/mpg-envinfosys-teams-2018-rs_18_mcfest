source("F:/09_Semester/remote_sensing/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R")

b1 <- raster(paste0(envrmt$path_data_aerial, "476000_5630000_1.tif"))
b2 <- raster(paste0(envrmt$path_data_aerial, "476000_5632000_1.tif"))

plot(b1)
plot(b2)