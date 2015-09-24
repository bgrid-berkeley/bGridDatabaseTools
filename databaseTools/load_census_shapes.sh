#!/bin/bash
## Simple script to load a bunch of census tracts (the projection of which I know), into psql 
## It would be nice to automate the choosing of the SRID using Emre's python code. 

# find all the shapefiles in my folder
declare SHAPEFILES=$(ls /home/mtabone/gis_shapefiles_tmp/*.shp)

# for each shapefie, load it into the database
for i in $SHAPEFILES;
do

# declare a tablename as the filename, in the gis_data schema without the shapefile ending. 
declare TABLENAME=gis_data.$(echo $i | sed s,/home/mtabone/gis_shapefiles_tmp/,, | sed s,.shp,,)
echo $TABLENAME

# Actually load into psql 
shp2pgsql -s 4269 $i $TABLENAME | psql --username mtabone --dbname bgrid -v ON_ERROR_STOP=1

done

