#Set pathes -------------------------------------------------------------------
#Automatically set root direcory depending on booted system (after path changes.)
if(Sys.info()["sysname"] == "Windows"){
  filepath_base = "F:/Uni/mpg-envinsys-plygrnd"
  #.libPaths("F:/rlib")
} else {
  filepath_base = "/media/eike/USB_1/09_Semester/mpg-envinsys-plygrnd"
  #.libPaths("/media/eike/USB_1/lrlib")
}

#filepath_base = path.expand("~/edu/mpg-envinsys-plygrnd")

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

envrmt = link2GI::initProj(projRootDir = filepath_base, GRASSlocation = "data/grass",
                  projFolders = project_folders, path_prefix = "path_", 
                  global = FALSE)

rasterOptions(tmpdir = envrmt$path_data_tmp)

