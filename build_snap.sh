#!/bin/bash
set -e

# Declare an associative array to track copied libraries and avoid duplicates
declare -A processed_files

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
git clone https://gitlab.com/GiorgioCosentino/plastimatch.git

# Clone the Snap packaging repository
git clone https://github.com/GiorgioCosentino/Plastimatch-snap

cd Plastimatch-snap
# Create local/libs directory inside Snap package for libraries
mkdir -p local/libs/
cd ..

# Create build directory for Plastimatch and enter it
mkdir plastimatch_compiled
cd plastimatch_compiled

# Configure the build (shared libs enabled, CUDA disabled)
cmake -DBUILD_SHARED_LIBS=ON -DPLM_CONFIG_ENABLE_CUDA=OFF ../plastimatch/

# Compile Plastimatch using all available CPU cores
make -j$(nproc)

# Copy the main binary to the Snap package directory
cp plastimatch ../Plastimatch-snap/local

# ---- AUTOMATIC ORGANIZE BLOCK FOR YAML ----
# Add the 'organize:' section to snapcraft.yaml
printf "    organize:\n" >>/build/Plastimatch-snap/snapcraft.yaml

# Copy all libplm* libraries from the build directory into the Snap package
# and automatically append them to the YAML 'organize' section
for file in /build/plastimatch_compiled/libplm*; do
    base=$(basename "$file")
    
    # Copy the library into the Snap package's local/libs folder
    cp "$file" "/build/Plastimatch-snap/local/libs"
    
    # Append YAML line to include this library in the Snap package
    printf "      libs/%s: lib/\n" "$base" >> /build/Plastimatch-snap/snapcraft.yaml
done
# --------------------------------------------

cd ..

# Copy system libraries (e.g., BLAS, LAPACK, ICU, etc.) into Snap package
# and add them to the YAML 'organize' section
for l in libblas.so. liblapack.so. libminc2.so. libgfortran.so. libdlib.so. libxml2.so. libicuuc.so. libicudata.so. libjpeg.so. libhdf5_serial_cpp.so.; do
  for file in $(locate $l | grep "/usr/lib/"); do
    base=$(basename "$file")
    # Check if library has already been processed
    if [[ -z "${processed_files[$base]}" ]]; then
      cp "$file" /build/Plastimatch-snap/local/libs/
      printf "      libs/%s: lib/\n" "$base" >> /build/Plastimatch-snap/snapcraft.yaml
      processed_files["$base"]=1
    fi
  done
done

# Move to Snap packaging directory to build the snap
cd Plastimatch-snap

# Build the Snap package in destructive mode
snapcraft --destructive-mode

# Clean up build and source directories
rm -rf ../plastimatch_compiled
rm -rf ../plastimatch

# Move the built Snap package to the parent directory
cp plastimatch_*.snap ..

# Remove Snap packaging directory to clean up
rm -rf ../Plastimatch-snap

exit
