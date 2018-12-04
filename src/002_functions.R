####indices function ####
#@https://github.com/environmentalinformatics-marburg/satelliteTools/blob/master/R/rgbIndices.R

rgbIndices<- function(rgb,
                      rgbi=c("VVI","VARI","NDTI","RI","CI","BI","SI","HI","TGI","GLI","NGRDI")) {
  
  ## compatibility check
  if (raster::nlayers(rgb) < 3)
    stop("Argument 'rgb' needs to be a Raster* object with at least 3 layers (usually red, green and blue).")
  
  ### processing
  
  
  ## separate visible bands
  red <- rgb[[1]]
  green <- rgb[[2]]
  blue <- rgb[[3]]
  
  indices <- lapply(rgbi, function(item){
    ## calculate Visible Vegetation Index vvi
    if (item=="VVI"){
      cat("\ncalculate Visible Vegetation Index (VVI)")
      VVI <- (1 - abs((red - 30) / (red + 30))) * 
        (1 - abs((green - 50) / (green + 50))) * 
        (1 - abs((blue - 1) / (blue + 1)))
      names(VVI) <- "VVI"
      return(VVI)
      
    } else if (item=="VARI"){
      # calculate Visible Atmospherically Resistant Index (VARI)
      cat("\ncalculate Visible Atmospherically Resistant Index (VARI)")
      VARI<-(green-red)/(green+red-blue)
      names(VARI) <- "VARI"
      return(VARI)
      
    } else if (item=="NDTI"){
      ## Normalized difference turbidity index
      cat("\ncalculate Normalized difference turbidity index (NDTI)")
      NDTI<-(red-green)/(red+green)
      names(NDTI) <- "NDTI"
      return(NDTI)
      
    } else if (item=="RI"){
      # redness index
      cat("\ncalculate redness index (RI)")
      RI<-red**2/(blue*green**3)
      names(RI) <- "RI"
      return(RI)
      
    } else if (item=="CI"){
      # CI Soil Colour Index
      cat("\ncalculate Soil Colour Index (CI)")
      CI<-(red-green)/(red+green)
      names(CI) <- "CI"
      return(CI)
      
    } else if (item=="BI"){
      #  Brightness Index
      cat("\ncalculate Brightness Index (BI)")
      BI<-sqrt((red**2+green**2+blue*2)/3)
      names(BI) <- "BI"
      return(BI)
      
    } else if (item=="SI"){
      # SI Spectra Slope Saturation Index
      cat("\ncalculate Spectra Slope Saturation Index (SI)")
      SI<-(red-blue)/(red+blue) 
      names(SI) <- "SI"
      return(SI)
      
    } else if (item=="HI"){    
      # HI Primary colours Hue Index
      cat("\ncalculate Primary colours Hue Index (HI)")
      HI<-(2*red-green-blue)/(green-blue)
      names(HI) <- "HI"
      return(HI)
      
    } else if (item=="TGI"){
      # Triangular greenness index
      cat("\ncalculate Triangular greenness index (TGI)")
      TGI <- -0.5*(190*(red - green)- 120*(red - blue))
      names(TGI) <- "TGI"
      return(TGI)
      
    } else if (item=="GLI"){
      cat("\ncalculate Green leaf index (GLI)")
      # Green leaf index
      GLI<-(2*green-red-blue)/(2*green+red+blue)
      names(GLI) <- "GLI"
      return(GLI)
      
    } else if (item=="NGRDI"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate Normalized green red difference index  (NGRDI)")
      NGRDI<-(green-red)/(green+red) 
      names(NGRDI) <- "NGRDI"
      return(NGRDI)
      
    } else if (item=="ExG"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate Excess Green Index (ExG)")
      ExG <- 2*green - red - blue 
      names(ExG) <- "ExG"
      return(ExG)
    
    } else if (item=="ExGR"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate  Excess Green Index - Excess Red Index (ExGR)")
      ExGR<- (2*green - red - blue) - (1.4*red - green)
      names(ExGR) <- "ExGR"
      return(ExGR)
      
    } else if (item=="VEG"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate  Vegetative Index (VEG)")
      VEG<- green / (red**0.667 * blue**0.333)
      names(VEG) <- "VEG"
      return(VEG)
      
    } else if (item=="CIVE"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate Color Index of Vegetation Extraction (CIVE)")
      CIVE<- 0.441*red - 0.881*green + 0.385*blue + 18.78745
      names(CIVE) <- "CIVE"
      return(CIVE)
      
    } else if (item=="COM"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate Combined Index (COM)")
      COM<- 0.25*(2*green - red - blue) + 0.3* ((2*green - red - blue) - (1.4*red - green)) + 0.33* (0.441*red - 0.881*green + 0.385*blue + 18.78745) + 0.12* (green / (red**0.667 * blue**0.333))
      names(COM) <- "COM"
      return(COM)
      
    } else if (item=="CEV"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate Combination aus Ponti (CEV)")
      CEV<- 0.33*((1 - abs((red - 30) / (red + 30))) * (1 - abs((green - 50) / (green + 50))) * (1 - abs((blue - 1) / (blue + 1)))) + 0.33*(2*green - red - blue) + 0.33*(0.441*red - 0.881*green + 0.385*blue + 18.78745)
      names(CEV) <- "CEV"
      return(CEV)
    
    } else if (item=="CEV_gew"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate Combination aus Ponti (CEV_gew)")
      CEV_gew<- 0.4*((1 - abs((red - 30) / (red + 30))) * (1 - abs((green - 50) / (green + 50))) * (1 - abs((blue - 1) / (blue + 1)))) + 0.2*(2*green - red - blue) + 0.4*(0.441*red - 0.881*green + 0.385*blue + 18.78745)
      names(CEV_gew) <- "CEV_gew"
      return(CEV_gew)
    
    } else if (item=="CEV_ohne"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate Combination aus Ponti (CEV_ohne)")
      CEV_ohne<- ((1 - abs((red - 30) / (red + 30))) * (1 - abs((green - 50) / (green + 50))) * (1 - abs((blue - 1) / (blue + 1)))) + (2*green - red - blue) + (0.441*red - 0.881*green + 0.385*blue + 18.78745)
      names(CEV_ohne) <- "CEV_ohne"
      return(CEV_ohne)
      
    } else if (item=="mcfesti"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate mcfesti (mcfesti)")
      mcfesti <- 0.25*(sqrt((red**2+green**2+blue*2)/3)) + 0.25*(0.441*red - 0.881*green + 0.385*blue + 18.78745) + 0.25*((1 - abs((red - 30) / (red + 30))) * (1 - abs((green - 50) / (green + 50))) * (1 - abs((blue - 1) / (blue + 1)))) + 0.25*(-0.5*(190*(red - green)- 120*(red - blue)))
      names(mcfesti) <- "mcfesti"
      return(mcfesti)
    }
    
      else if (item=="test"){
      # NGRDI Normalized green red difference index 
      cat("\ncalculate mcfesti (test)")
      test <- ((red - 2*green)/(red + 2*green)) + blue
      names(test) <- "test"
      return(test)
  }
  })
  return(raster::stack(indices))
}

####filter function####
#by Goergen@https://github.com/GeoMOER-Students-Space/mpg-envinfosys-teams-2018-rs_18_axmideda/blob/master/src/filterFunction.R

# fil <- function(rs, filters = c("mean3","mean5","mean7","sd3","sd5","sd7","sbh3","sbv3","sbh5","sbv5","laplc5","gauss5"),path = NULL,...){
#   
#   filt <- list()
#   
#   for (i in 1:nlayers(rs)){
#     
#     filtered <- lapply(filters, function(item) {
#       
#       if (item == "mean3"){
#       
#       cat("\napplying 3x3 mean filter")
#       
#       mean3 <- raster::focal(rs[[i]], matrix(1/9,nrow=3,ncol=3))
#       names(mean3) <- "mean3"
#       return(mean3)
#       
#     } else if (item == "mean5"){
#       
#       cat("\napplying 5x5 mean filter")
#       
#       mean5 <- raster::focal(rs[[i]], matrix(1/25,nrow=5,ncol=5), fun = sum)
#       names(mean5) <- "mean5"
#       return(mean5)
#       
#     } else if (item == "mean7"){
# 
#       cat("\napplying 7x7 mean filter")
# 
#       mean7 <- raster::focal(rs[[i]], matrix(1/49),nrow=7,ncol=7)
#       names(mean7) <- "mean7"
#       return(mean7)
# 
#     } else if (item == "sd3") {
# 
#       cat("\napplying 3x3 standard deviation filter")
# 
#       sd3 <- raster::focal(rs[[i]], matrix(1,3,3), fun = sd)
#       names(sd3) <- "sd3"
#       return(sd3)
# 
#     } else if (item == "sd5"){
# 
#       cat("\napplying 5x5 standard deviation filter")
# 
#       sd5 <- raster::focal(rs[[i]], matrix(1,5,5), fun = sd)
#       names(sd5) <- "sd5"
#       return(sd5)
# 
#     } else if (item == "sd7"){
# 
#       cat("\napplying 7x7 standard deviation filter")
# 
#       sd7 <- raster::focal(rs[[i]], matrix(1,7,7), fun = sd)
#       names(sd7) <- "sd7"
#       return(sd7)
# 
#     } else if (item == "sbh3") {
# 
#       cat("\napplying sobel 3x3 horizontal filter")
# 
#       sbh3 <- raster::focal(rs[[i]], matrix(c(-1,0,1,-2,0,2,-1,0,1)/4,nrow=3), fun = sum)
#       names(sbh3) <- "sbh3"
#       return(sbh3)
# 
#     } else if (item == "sbv3"){
# 
#       cat("\napplying sobel 3x3 vertical filter")
# 
#       sbv3 <- raster::focal(rs[[i]], matrix(c(-1,-2,-1,0,0,0,1,2,1),nrow=3), fun = sum)
#       names(sbv3) <- "sbv3"
#       return(sbv3)
#       
#     } else if (item == "sbh5"){
#       
#       cat("\napplying sobel 5x5 horizontal filter")
#       
#       sbh5 <- raster::focal(rs[[i]], matrix(c(2,1,0,-1,-2,2,1,0,-2,-1,4,2,0,-2,-4,2,1,0,-1,-2,2,1,0,-1,-2),nrow=5), fun = sum)
#       names(sbh5) <- "sbh5"
#       return(sbh5)
#       
#     } else if (item == "sbv5"){
#       
#       cat("\napplying sobel 5x5 vertical filter")
#       
#       sbv5 <- raster::focal(rs[[i]], matrix(c(-2,-2,-4,-2,-2,-1,-1,-2,-1,-1,0,0,0,0,0,1,1,2,1,1,2,2,4,2,2),nrow=5), fun = sum)
#       names(sbv5) <- "sbv5"
#       return(sbv5)
#       
#     } else if (item == "laplc5"){
#       
#       cat("\napplying laplace filter")
#       
#       laplc5 <- raster::focal(rs[[i]], matrix(c(0,1,0,1,0,1,0,1,0,1,0,1,-12,1,0,1,0,1,0,1,0,1,0,1,0)/12, nrow=5), fun = sum)
#       names(laplc5) <- "laplc5"
#       return(laplc5)
#       
#     } else if (item == "gauss5"){
#       
#       cat("\napplying gauss5 filter")
#       
#       gauss5 <- raster::focal(rs[[i]], matrix(c(1,1,2,1,1,1,2,4,2,1,2,4,8,4,2,1,2,4,2,1,1,1,2,1,1)/8,nrow=5), fun = sum)
#       names(gauss5) <- "gauss5"
#       return(gauss5)
#       
#     }
#       
#     })
#     # cat(paste0("\nWriting raster of ",names(rs)[i],"."))
#     # filtered <- raster::stack(filtered)
#     # writeRaster(filtered, filename = paste0(path,names(rs)[i],"_"), format = "GTiff",bylayer=TRUE,suffix=filters)
#     return(raster::stack(filtered))
#   }
# }
####filter scratch####

#Filter Ideas
#mean 5 pix 2,5m
# mean5 <- raster::focal(rs[[i]], matrix(1/25, nrow = 5, ncol = 5), fun = sum)
# #mean 15 pix 7,5m
# mean15 <- raster::focal(rs[[i]], matrix(1/225, nrow = 15, ncol = 15), fun = sum)
# #mean 21 pix 10,5m
# mean21 <- raster::focal(rs[[i]], matrix(1/441, nrow = 21, ncol = 21), fun = sum)
# #mean 31 pix 15,5m
# mean31 <- raster::focal(rs[[i]], matrix(1/961, nrow = 31, ncol = 31), fun = sum)
# 
# #sobel 5 pix 2,5m
# sobel5 <- sqrt(raster::focal(viStack[[i]], matrix(c(2,1,0,-1,-2,2,1,0,-2,-1,4,2,0,-2,-4,2,1,0,-1,-2,2,1,0,-1,-2),nrow=5), fun = sum)**2+
#                 raster::focal(viStack[[i]], matrix(c(-2,-2,-4,-2,-2,-1,-1,-2,-1,-1,0,0,0,0,0,1,1,2,1,1,2,2,4,2,2),nrow=5), fun = sum)**2)
# #sobel 15 pix 7,5m
# sobel15 <- sqrt(raster::focal(rs[[i]], matrix(c(rep(-64, 7), -128, rep(-64, 7), rep(-32, 7), -64, rep(-32, 7), rep(-16, 7), -32, rep(-16, 7), rep(-8, 7), -16, rep(-8, 7), rep(-4, 7), -8, rep(-4, 7), rep(-2, 7), -4, rep(-2, 7), rep(-1, 7), -2, rep(-1, 7), 
#                                                 rep(0, 15), 
#                                                 rep(1, 7), 2, rep(1, 7), rep(2, 7), 4, rep(2, 7), rep(4, 7), 8, rep(4, 7), rep(8, 7), 16, rep(8, 7), rep(16, 7), 32, rep(16, 7), rep(32, 7), 64, rep(32, 7), rep(64, 7), 128, rep(64, 7)), nrow = 15), fun = sum)**2 +
#                 raster::focal(rs[[i]], t(matrix(c(rep(-64, 7), -128, rep(-64, 7), rep(-32, 7), -64, rep(-32, 7), rep(-16, 7), -32, rep(-16, 7), rep(-8, 7), -16, rep(-8, 7), rep(-4, 7), -8, rep(-4, 7), rep(-2, 7), -4, rep(-2, 7), rep(-1, 7), -2, rep(-1, 7), 
#                                                 rep(0, 15), 
#                                                 rep(1, 7), 2, rep(1, 7), rep(2, 7), 4, rep(2, 7), rep(4, 7), 8, rep(4, 7), rep(8, 7), 16, rep(8, 7), rep(16, 7), 32, rep(16, 7), rep(32, 7), 64, rep(32, 7), rep(64, 7), 128, rep(64, 7)), nrow = 15)), fun = sum)**2)
# #sobel 21 pix 10,5m
# sobel21 <- sqrt(raster::focal(rs[[i]], matrix(c(rep(-512, 10), -1024, rep(-512, 10), rep(-256, 10), -512, rep(-256, 10), rep(-128, 10), -256, rep(-128, 10), rep(-64, 10), -128, rep(-64, 10), rep(-32, 10), -64, rep(-32, 10), rep(-16, 10), -32, rep(-16, 10), rep(-8, 10), -16, rep(-8, 10), rep(-4, 10), -8, rep(-4, 10), rep(-2, 10), -4, rep(-2, 10), rep(-1, 10), -2, rep(-1, 10), 
#                                                 rep(0, 21), 
#                                                 rep(1, 10), 2, rep(1, 10), rep(2, 10), 4, rep(2, 10), rep(4, 10), 8, rep(4, 10), rep(8, 10), 16, rep(8, 10), rep(16, 10), 32, rep(16, 10), rep(32, 10), 64, rep(32, 10), rep(64, 10), 128, rep(64, 10), rep(128, 10), 256, rep(128, 10), rep(256, 10), 512, rep(256, 10), rep(512, 10), 1024, rep(512, 10)), nrow = 21), fun = sum)**2 +
#                 raster::focal(rs[[i]], t(matrix(c(rep(-512, 10), -1024, rep(-512, 10), rep(-256, 10), -512, rep(-256, 10), rep(-128, 10), -256, rep(-128, 10), rep(-64, 10), -128, rep(-64, 10), rep(-32, 10), -64, rep(-32, 10), rep(-16, 10), -32, rep(-16, 10), rep(-8, 10), -16, rep(-8, 10), rep(-4, 10), -8, rep(-4, 10), rep(-2, 10), -4, rep(-2, 10), rep(-1, 10), -2, rep(-1, 10), 
#                                                   rep(0, 21), 
#                                                   rep(1, 10), 2, rep(1, 10), rep(2, 10), 4, rep(2, 10), rep(4, 10), 8, rep(4, 10), rep(8, 10), 16, rep(8, 10), rep(16, 10), 32, rep(16, 10), rep(32, 10), 64, rep(32, 10), rep(64, 10), 128, rep(64, 10), rep(128, 10), 256, rep(128, 10), rep(256, 10), 512, rep(256, 10), rep(512, 10), 1024, rep(512, 10)), nrow = 21)), fun = sum)**2)
# #sobel 31 pix 15,5m
# sobel31 <- sqrt(raster::focal(rs[[i]], matrix(c(rep(-16384, 15), -32768, rep(-16384, 15), rep(-8192, 15), -16384, rep(-8192, 15), rep(-4096, 15), -8192, rep(-4096, 15), rep(-2048, 15), -4096, rep(-2048, 15), rep(-1524, 15), -2048, rep(-1524, 15), rep(-512, 15), -1524, rep(-512, 15), rep(-256, 15), -512, rep(-256, 15), rep(-128, 15), -256, rep(-128, 15), rep(-64, 15), -128, rep(-64, 15), rep(-32, 15), -64, rep(-32, 15), rep(-16, 15), -32, rep(-16, 15), rep(-8, 15), -16, rep(-8, 15), rep(-4, 15), -8, rep(-4, 15), rep(-2, 15), -4, rep(-2, 15), rep(-1, 15), -2, rep(-1, 15), 
#                                                 rep(0, 31), 
#                                                 rep(1, 15), 2, rep(1, 15), rep(2, 15), 4, rep(2, 15), rep(4, 15), 8, rep(4, 15), rep(8, 15), 16, rep(8, 15), rep(16, 15), 32, rep(16, 15), rep(32, 15), 64, rep(32, 15), rep(64, 15), 128, rep(64, 15), rep(128, 15), 256, rep(128, 15), rep(256, 15), 512, rep(256, 15), rep(512, 15), 1524, rep(512, 15), rep(1524, 15), 2048, rep(1524, 15), rep(2048, 15), 4096, rep(2048, 15), rep(4096, 15), 8192, rep(4096, 15), rep(8192, 15), 16384, rep(8192, 15), rep(16384, 15), 32768, rep(16384, 15)), nrow = 31), fun = sum)**2 +
#                 raster::focal(rs[[i]], t(matrix(c(rep(-16384, 15), -32768, rep(-16384, 15), rep(-8192, 15), -16384, rep(-8192, 15), rep(-4096, 15), -8192, rep(-4096, 15), rep(-2048, 15), -4096, rep(-2048, 15), rep(-1524, 15), -2048, rep(-1524, 15), rep(-512, 15), -1524, rep(-512, 15), rep(-256, 15), -512, rep(-256, 15), rep(-128, 15), -256, rep(-128, 15), rep(-64, 15), -128, rep(-64, 15), rep(-32, 15), -64, rep(-32, 15), rep(-16, 15), -32, rep(-16, 15), rep(-8, 15), -16, rep(-8, 15), rep(-4, 15), -8, rep(-4, 15), rep(-2, 15), -4, rep(-2, 15), rep(-1, 15), -2, rep(-1, 15), 
#                                                     rep(0, 31), 
#                                                     rep(1, 15), 2, rep(1, 15), rep(2, 15), 4, rep(2, 15), rep(4, 15), 8, rep(4, 15), rep(8, 15), 16, rep(8, 15), rep(16, 15), 32, rep(16, 15), rep(32, 15), 64, rep(32, 15), rep(64, 15), 128, rep(64, 15), rep(128, 15), 256, rep(128, 15), rep(256, 15), 512, rep(256, 15), rep(512, 15), 1524, rep(512, 15), rep(1524, 15), 2048, rep(1524, 15), rep(2048, 15), 4096, rep(2048, 15), rep(4096, 15), 8192, rep(4096, 15), rep(8192, 15), 16384, rep(8192, 15), rep(16384, 15), 32768, rep(16384, 15)), nrow = 31)), fun = sum)**2)
# #gauss 5 pix 2,5m
# gauss5 <- raster::focal(rs[[i]],  matrix(c(1,1,2,1,1,1,2,4,2,1,2,4,8,4,2,1,2,4,2,1,1,1,2,1,1),nrow=5), fun = sum)
# 
# #gauss 15 pix 7,5m
# 
# gauss15 <- raster::focal(rs[[i]], w=smoothie::kernel2dmeitsjer(type = "gauss",nx=15,ny=15,sigma=1),fun = sum)
# 
# #gauss 21 pix 10,5m
# gauss21 <- raster::focal(rs[[i]], w=smoothie::kernel2dmeitsjer(type = "gauss",nx=21,ny=21,sigma=1),fun = sum)
# 
# 
# #gauss 31 pix 15,5m
# gauss31 <- raster::focal(rs[[i]], w=smoothie::kernel2dmeitsjer(type = "gauss",nx=31,ny=31,sigma=1),fun = sum)
# 
# 
# 
# 
# #laplacian of gaussian 5 pix 2,5m
# LoG5 <- raster::focal(rs[[i]], w=smoothie::kernel2dmeitsjer(type = "LoG", nx=5,ny=5,sigma=1),fun = sum)
# 
# 
# #laplacian of gaussian 15 pix 7,5m
# LoG15 <- raster::focal(rs[[i]], w=smoothie::kernel2dmeitsjer(type = "LoG", nx=15,ny=15,sigma=1),fun = sum)
# 
# #laplacian of gaussian 21 pix 10,5m
# LoG21 <- raster::focal(rs[[i]], w=smoothie::kernel2dmeitsjer(type = "LoG", nx=21,ny=21,sigma=1),fun = sum)
# 
# #laplacian of gaussian 31 pix 15,5m
# LoG31 <- raster::focal(rs[[i]], w=smoothie::kernel2dmeitsjer(type = "LoG", nx=31,ny=31,sigma=1),fun = sum)

#glcm1 5 pix 2,5m
#glcm1 15 pix 7,5m
#glcm1 21 pix 10,5m
#glcm1 31 pix 15,5m

#glcm2 5 pix 2,5m
#glcm2 15 pix 7,5m
#glcm2 21 pix 10,5m
#glcm2 31 pix 15,5m

#haralick 5 pix 2,5m
#haralick 15 pix 7,5m
#haralick 21 pix 10,5m
#haralick 31 pix 15,5m