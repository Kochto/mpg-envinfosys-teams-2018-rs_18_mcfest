if (Sys.info()["sysname"] == "Windows"){
  source("F:/09_Semester/remote_sensing/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R")
} else {
  source("/media/eike/USB_1/09_Semester/remote_sensing/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R")
}
#List files in the data aerial folder
ls <- list.files(paste0(envrmt$path_data_aerial), pattern = ".tif")

#Read Images
b <- list()
for (i in ls){
  b[[i]] <- stack(paste0(envrmt$path_data_aerial, i))
}
names(b) <- 1:length(b)

#Check projections of images
for (c in b){
  v <- crs(c)
  print(v)
}

#Read edited Shapefile
abt<- readOGR(paste0(envrmt$path_data_data_mo, "uwcAbteilung.shp"),
              layer= ogrListLayers(paste0(envrmt$path_data_data_mo, "uwcAbteilung.shp")))

#Check projections of Shapefile
crs(abt)

#Cropping relevant images (picture one and two do not overlap with the bounding box - no cropping required)
b3_c <- crop(b$`3`, abt, filename=paste0(envrmt$path_data_aerial_processed, "b3_c.tif"))
b4_c <- crop(b$`4`, abt, filename=paste0(envrmt$path_data_aerial_processed, "b4_c.tif"))
b5_c <- crop(b$`5`, abt, filename=paste0(envrmt$path_data_aerial_processed, "b5_c.tif"))
b6_c <- crop(b$`6`, abt, filename=paste0(envrmt$path_data_aerial_processed, "b6_c.tif"))
b7_c <- crop(b$`7`, abt, filename=paste0(envrmt$path_data_aerial_processed, "b7_c.tif"))
b8_c <- crop(b$`8`, abt, filename=paste0(envrmt$path_data_aerial_processed, "b8_c.tif"))

#Merging the "stripes" toghether with the actual images
b3_4_cm <- mosaic(b3_c, b4_c, fun="min", filename=paste0(envrmt$path_data_aerial_processed, "b3_4_cm.tif"))
b5_6_cm <- mosaic(b5_c, b6_c, fun="min", filename=paste0(envrmt$path_data_aerial_processed, "b5_6_cm.tif"))

#creating one mosaic
img <- merge(b3_4_cm, b5_6_cm, b7_c, b8_c, filename=paste0(envrmt$path_data_aerial_processed, "img.tif"))
