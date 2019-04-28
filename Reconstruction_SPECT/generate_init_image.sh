#! /bin/sh
LC_ALL=C
export LC_ALL

mkdir -p preimage
cd preimage

echo "=== make init image"
generate_image ../generate_init_image.par

echo "=== finish"
cd ..