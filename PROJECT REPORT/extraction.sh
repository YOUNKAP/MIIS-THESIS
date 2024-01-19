#!/bin/bash
## This script process a single day GLDAS data and do all the required conversions needed for PySEBAL
## GENERAL ##
if [ -z "$GISBASE" ] ; then
    echo "You must be in GRASS GIS to run this program." >&2
    exit 1
fi
# Set a environment to enable overwrite by default
export GRASS_OVERWRITE=1

# Navigate to the folder containing single day .nc4 files
INDAT="/mnt/d/mi_is_project_data/2021/031" 

cd ${INDAT}

# set the computational region to Urmia Lake basin and set the computational resolution to 0.25 degrees
g.region vector=cmr res=0.25 -a
r.mask vect=cmr

# For loop to process all the .nc files in one go

for i in `ls GLDAS*.nc4`; do
    dt=`echo ${i}|cut -d. -f2-3`
    # Extract Air Temperature values 8 aviation meteorological station at time = dt and save the value in .csv file
    r.what -n map=GLDAS_NOAH025_3H_${dt}_Tair_final points=met_station  sep=comma output=a_temp_${dt}Z.csv
    # Extract Relative Humidity values 8 aviation meteorological station at time = dt and save the value in .csv file
    r.what -n map=GLDAS_NOAH025_3H_${dt}_Rh_final points=met_station  sep=comma output=a_rh_${dt}Z.csv
    # Extract Surface Pressure values 8 aviation meteorological station at time = dt and save the value in .csv file
    r.what -n map=GLDAS_NOAH025_3H_${dt}_Psurf_final points=met_station  sep=comma output=a_p_${dt}Z.csv
    # Extract Surface wind values 8 aviation meteorological station at time = dt and save the value in .csv file
    r.what -n map=GLDAS_NOAH025_3H_${dt}_Wind_final points=met_station  sep=comma output=a_ws_${dt}Z.csv

done
