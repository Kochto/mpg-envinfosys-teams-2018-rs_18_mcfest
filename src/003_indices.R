root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

img <- stack(paste0(envrmt$path_data_aerial_processed, "img.tif"))
names(img) <- c("img.red", "img.green", "img.blue")

indices <- rgbIndices(img, rgbi = c("VVI","VARI","NDTI","RI","CI","BI","SI","HI","TGI","GLI","NGRDI"))
tgi <- rgbIndices(img, rgbi = c("TGI"))

#plot(vvi, col = gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))