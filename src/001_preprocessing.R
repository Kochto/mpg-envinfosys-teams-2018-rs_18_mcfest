if (Sys.info()["sysname"] == "Windows"){
  source("F:/09_Semester/remote_sensing/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R")
} else {
  source("/media/eike/USB_1/09_Semester/remote_sensing/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R")
}
#List files in the data aerial folder
ls <- list.files(paste0(envrmt$path_data_aerial), pattern = ".tif")

#Read Images
imagelist <- list()
for (i in ls){
  imagelist[[i]] <- brick(paste0(envrmt$path_data_aerial, i))
}
names(imagelist) <- 1:length(imagelist)

#Check projections of images
pro <- c()
for (c in imagelist){
  v <- crs(c)
  pro <- c(pro, v)
}
if (length(unique(pro))!= 1){
  print("at least one image has not the same projection")
} else {
  print("all projections are equal")
}

#Read edited Shapefile
abt<- readOGR(paste0(envrmt$path_data_data_mo, "uwcAbteilung.shp"),
              layer= ogrListLayers(paste0(envrmt$path_data_data_mo, "uwcAbteilung.shp")))

#Check projections of Shapefile
crs(abt)

#Cropping relevant images (picture one and two do not overlap with the bounding box - no cropping required)
cropped <- lapply(imagelist[3:length(imagelist)], crop, abt)

#(Optional write out cropped raster)
for (l in cropped[1:length(cropped)]) {
  writeRaster(l, filename = paste0(envrmt$path_data_aerial_processed, "cropped", 
                                   substr(gsub("[.]", "_", names(l)[1]), 1, 15),
                                   substr(gsub("[.]", "_", names(l)[1]), 18, 19), ".tif"), overwrite=TRUE)
}

#Merging the "stripes" toghether with the actual images
imagelist_3_4_cm <- mosaic(cropped$`3`,cropped$`4`, fun="min", filename=paste0(envrmt$path_data_aerial_processed, "b3_4_cm.tif"))
imagelist_5_6_cm <- mosaic(cropped$`5`, cropped$`6`, fun="min", filename=paste0(envrmt$path_data_aerial_processed, "b5_6_cm.tif"))

#creating one mosaic
img <- merge(imagelist_3_4_cm, imagelist_5_6_cm, cropped$`7`, cropped$`8`, filename=paste0(envrmt$path_data_aerial_processed, "img.tif"))
