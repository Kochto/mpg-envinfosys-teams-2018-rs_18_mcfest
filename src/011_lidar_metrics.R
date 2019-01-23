root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

mof <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_org), chunksize = 100, 
                                 chunkbuffer = 10, cores = 4)
crs(mof) <- "+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"

lidR::opt_output_files(mof)<-paste0(envrmt$path_data_lidar_csf,"{ID}_csf")

# mof_csf<- lidR::lasground(mof, csf())
# lidR::opt_output_files(mof_csf)<-paste0(envrmt$path_data_lidar_csf,"{ID}_pitfree_csf")
# dsm_pitfree_csf <- lidR::grid_canopy(mof_csf, res = 0.5, 
#                                      lidR::pitfree(c(0,2,5,10,15), c(0, 0.5)))

test <- grid_metrics(mof, mean(Z), 20)
test2 <- grid_metrics(mof, lidR::entropy(Z, by = 1), res = 20, start = c(0, 0))

#lidr::entropy
#lidr::grid_metrics
#lidr::lasmetrics
#lidr::lastrees
#Baumschichten einteilen

#Baumschichten exportieren mit r.in.lidar
#custom function aus 


#https://github.com/GeoMOER-Students-Space/msc-phygeo-class-of-2017-creuden/blob/master/gis/gi-ws-08/scripts/gi-ws-08.R
#https://grass.osgeo.org/grass76/manuals/r.in.lidar.html
