## RUN
If you want to create the voxelized phantom and source, run:
	sh generate_volume.sh
in the "Shell".

## Other data files in the 'gpu_volume' folder
The geometry information is saved in the 'generate_volume.par'. You
can modify it as you want. More information about how to create
other geometry is saved in the 'reference/STIR'.

When some new phantoms are create, the headerfile 'gpu_phantom.hdr' 
should be modified. (The information in the 'gpu_phantom.hv' is 
helpful.)

'gpu_phantom.v' has the voxelized phantom data.

'activities.dat' and 'ranges.dat' will be found in GATE User Guide.