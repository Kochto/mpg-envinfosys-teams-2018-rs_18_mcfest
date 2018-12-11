root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                 alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

#Set librarys
libs = c("lidR", "link2GI", "mapview", "raster", "rgdal", "ForestTools",
         "sp", "corrplot", "RStoolbox", "glcm", "TileManager", "factoextra", "smoothie")
lapply(libs, require, character.only = TRUE)

# Set project specific subfolders
project_folders = c("data/",                                 # data folders
                    "data/aerial/org/", "data/lidar/org/", "data/lidar/segtest/", "data/lidar/segtest/laubtest/", "data/lidar/segtest/nadeltest/",
                    "data/lidar/segtest/nadel_laub_test/", "data/grass/", 
                    "data/mof/", "data/tmp/", "data/aerial_processed/", "data/validation/",
                    "run/", "log/", "data/lidar/", "data/plots/",                  # bins and logging
                    "mpg-envinfosys-teams-2018-rs_18_mcfest/src/",   # source code
                    "mpg-envinfosys-teams-2018-rs_18_mcfest/doc/",
                    "mpg-envinfosys-teams-2018-rs_18_mcfest/Val_Tree_pos_Group/")   # markdown etc. 

envrmt = link2GI::initProj(projRootDir = root_folder, GRASSlocation = "data/grass",
                           projFolders = project_folders, path_prefix = "path_", 
                           global = FALSE)

rasterOptions(tmpdir = envrmt$path_data_tmp)
source(paste0(envrmt$`path_mpg-envinfosys-teams-2018-rs_18_mcfest_src`, "002_functions.R"))
