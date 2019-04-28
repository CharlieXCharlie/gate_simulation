#! /bin/sh
LC_ALL=C
export LC_ALL

mkdir -p gpu_volume
cd gpu_volume

echo "==== Make gpu volume ===="
generate_image ../generate_volume.par

echo "=== Finish ===="
cd ..