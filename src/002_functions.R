#indices function @https://github.com/environmentalinformatics-marburg/satelliteTools/blob/master/R/rgbIndices.R

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