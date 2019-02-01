#parallel random forest

root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

# sta <- stack(list.files(envrmt$path_data_aerial_processed_selection, pattern = "*.tif", full.names = TRUE))
# writeRaster(sta, paste0(envrmt$path_data_aerial_processed, "full_stack.tif"))
# writeRaster(sta, filename= paste0(envrmt$path_data_aerial_processed, "full_stack.tif"),
#             format="GTiff", overwrite=TRUE)
#bri <- brick(paste0(envrmt$path_data_aerial_processed, "full_stack.tif"))

#read all train shapes
files <- list.files(paste0(envrmt$path_data_training), pattern = "*.shp", full.names = TRUE)
shapes <- lapply(files, raster::shapefile)
#set id and reproject to raster projection
for (h in 1:length(shapes)){
  shapes[[h]]@data$id <- 1:length(shapes[[h]]@data$id)
  shapes[[h]] <- sp::spTransform(shapes[[h]], crs(raster::stack(paste0(envrmt$path_data_aerial_processed_selection, "BI_index_norm.tif"))))
}


#extract values to list
rasfiles <- list.files(paste0(envrmt$path_data_aerial_processed_selection), pattern = "*.tif", full.names = TRUE)

ext_tab <- lapply(seq(length(shapes)), function(i){
  ext_ind <- lapply(seq(length(rasfiles)), function(x){
    stack <- raster::stack(rasfiles[x])
    ext <- raster::extract(stack, shapes[[i]], na.rm = FALSE, df=TRUE)
    cat("\n", rasfiles[x],
        "\nShape:", shapes[[i]]@data$type[1], 
        "\nTif", x, "of 54 \n")
    print(Sys.time())
    return(ext)
  })
  tab <- do.call("cbind", ext_ind)
  for (t in unique(tab$ID)){
  tab$abt [tab$ID == t] <- shapes[[i]]@data$abt[shapes[[i]]@data$id == t]
  }
  #names(tab) <- paste0(names(tab), "_", shapes[[i]]@data$type[1])
  tab <- tab[!duplicated(as.list(names(tab)))]
  tab$type <- shapes[[i]]@data$type[1]
  return(tab)
})

write.csv(ext_tab[[1]], file = paste0(envrmt$path_data_training, "traintab_1.csv"))
write.csv(ext_tab[[2]], file = paste0(envrmt$path_data_training, "traintab_2.csv"))
write.csv(ext_tab[[3]], file = paste0(envrmt$path_data_training, "traintab_3.csv"))
write.csv(ext_tab[[4]], file = paste0(envrmt$path_data_training, "traintab_4.csv"))
write.csv(ext_tab[[5]], file = paste0(envrmt$path_data_training, "traintab_5.csv"))



