#!/bin/bash
set -e

# Update package list
apt-get update

# Install required development packages and libraries
apt-get install g++ make git cmake \
  libblas-dev liblapack-dev libsqlite3-dev \
  libdcmtk-dev libdlib-dev libfftw3-dev \
  libinsighttoolkit5-dev \
  libnsl-dev \
  libpng-dev libtiff-dev uuid-dev zlib1g-dev \
  plocate

# Clone Plastimatch source code from GitLab
git clone https://gitlab.com/plastimatch/plastimatch.git

# Clone snap packaging repo from GitHub
git clone https://github.com/GiorgioCosentino/Plastimatch-snap

cd Plastimatch-snap
mkdir -p local/libs/
cd ..

# Create build directory for Plastimatch and enter it
mkdir plastimatch_compiled
cd plastimatch_compiled

# Configure the build (shared libs, CUDA disabled)
cmake -DBUILD_SHARED_LIBS=ON -DPLM_CONFIG_ENABLE_CUDA=OFF ../plastimatch/

# Build Plastimatch using all available cores
make -j$(nproc)

# Copy binaries and libraries to the snap packaging directory
cp plastimatch ../Plastimatch-snap/local
cd ..

printf "    organize:\n" >> /Plastimatch-snap/snapcraft.yaml
for l in libplm libblas.so. liblapack.so. libminc2.so. libgfortran.so. libdlib.so. libxml2.so. libicuuc.so. libicudata.so. libjpeg.so. libhdf5_serial_cpp.so.; do
  for file in $(locate $l | grep "/usr/lib/"); do
    cp "$file" /Plastimatch-snap/local/libs/
    base=$(basename "$file")
    printf "      libs/%s: lib/\n" "$base" >> /Plastimatch-snap/snapcraft.yaml
  done
done

# Move to snap packaging directory
cd Plastimatch-snap

# Build the snap package (using destructive mode)
snapcraft --destructive-mode

# Clean up build and source directories
rm -rf ../plastimatch_compiled
rm -rf ../plastimatch

# Move the built snap package to parent directory
cp plastimatch_*.snap ..

# Remove snap packaging directory to clean up
rm -rf ../Plastimatch-snap

exit
