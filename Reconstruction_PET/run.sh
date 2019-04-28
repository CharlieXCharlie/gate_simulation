# This file is used to process ROOT data and to do the reconstruction.

# The 'sinogram' folder is used to save 'michelogram', 'ssrb', 'counts' and 'pos'(the
# information of each coincidence) file from data process section. However, the rebinning
# data 'FORE' and 'SSRB' file from the reconstruction section are saved in this folder
# ,too.
  
# The 'image' folder is used to save the reconstructed image.
# ====================================================================================

mkdir sinogram
# Data Processing Section
#inputdir="/home/lab4/Desktop/gate-exercices-master/GateContrib-master/imaging/myPET/bio16_cpu_res/out/"
#inputdir="../bio16_cpu_res/out/"
inputdir="../bio16_gpu_pha_fh/out/"
outputdir="sinogram/"
./ROOT2Sinogram $inputdir $outputdir

# ====================================================================================
# Image Reconstuction Section
mkdir image
echo ":: running FBP2D"
FBP2D par/fbp2d.par

echo ":: running FBP3DRP"
FBP3DRP par/fbp3drp.par

echo ":: using Fourier Rebinning to rebin data"
rebin_projdata par/fore.par
echo ":: running FBP2D using FORE"
FBP2D par/fbp2d_fore.par

#echo ":: using Single Slice Rebinning to rebin data"
#SSRB sinogram/SSRB miche_header/michelogram.hs

#echo "=== running OSMAPOSL"
#OSMAPOSL par/osmaposl.par

echo ":: All done!"
echo ":: All reconstructed image files are in the 'image'    directory"
echo ":: All sinogram            files are in the 'sinogram' directory"
echo ":: (:P)"