# Set pathes -------------------------------------------------------------------
# Automatically set root direcory depending on booted system
if(Sys.info()["sysname"] == "Windows"){
  filepath_base = "F:/09_Semester/remote_sensing"
  .libPaths("F:/rlib")
} else {
  filepath_base = "remote_sensing"
  .libPaths("")
}

#Set librarys
libs = c("link2GI",
         "raster",
         "rgdal",
         "sp")
lapply(libs, require, character.only = TRUE)

# Set project specific subfolders
project_folders = c("data/",                                 # data folders
                    "data/aerial/", "data/lidar/", "data/grass/", 
                    "data/data_mof", "data/tmp/", 
                    "run/", "log/",                          # bins and logging
                    "mpg-envinfosys-teams-2018-rs_18_mcfest/src/",   # source code
                    "mpg-envinfosys-teams-2018-rs_18_mcfest/doc/")   # markdown etc. 

envrmt = initProj(projRootDir = filepath_base, GRASSlocation = "data/grass",
                  projFolders = project_folders, path_prefix = "path_", 
                  global = FALSE)

rasterOptions(tmpdir = envrmt$path_data_tmp)
