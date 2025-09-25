#!/bin/bash
set -e

apt-get update

apt-get install g++ make git cmake \
  libblas-dev liblapack-dev libsqlite3-dev \
  libdcmtk-dev libdlib-dev libfftw3-dev \
  libinsighttoolkit5-dev \
  libnsl-dev \
  libpng-dev libtiff-dev uuid-dev zlib1g-dev

git clone https://gitlab.com/plastimatch/plastimatch.git

git clone https://github.com/GiorgioCosentino/Plastimatch-snap

mkdir plastimatch_compiled && cd plastimatch_compiled

cmake -DBUILD_SHARED_LIBS=ON -DPLM_CONFIG_ENABLE_CUDA=OFF ../plastimatch/

make -j$(nproc)

cp plastimatch ../Plastimatch-snap/local

cp libplm* ../Plastimatch-snap/local/libs

cd ../Plastimatch-snap

snapcraft --destructive-mode

rm -rf ../plastimatch_compiled

rm -rf ../plastimatch

cp plastimatch_*.snap ..

rm -rf ../Plastimatch-snap

exit