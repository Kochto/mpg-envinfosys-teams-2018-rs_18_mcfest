root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                 alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

#Set librarys
libs = c("link2GI",
         "raster",
         "rgdal",
         "sp")
lapply(libs, require, character.only = TRUE)

# Set project specific subfolders
project_folders = c("data/",                                 # data folders
                    "data/aerial/org/", "data/lidar/org/", "data/grass/", 
                    "data/data_mof/", "data/tmp/", "data/aerial_processed/",
                    "run/", "log/",                          # bins and logging
                    "mpg-envinfosys-teams-2018-rs_18_mcfest/src/",   # source code
                    "mpg-envinfosys-teams-2018-rs_18_mcfest/doc/")   # markdown etc. 

envrmt = link2GI::initProj(projRootDir = root_folder, GRASSlocation = "data/grass",
                           projFolders = project_folders, path_prefix = "path_", 
                           global = FALSE)

rasterOptions(tmpdir = envrmt$path_data_tmp)
