#!/bin/sh

mkdir chainer_setup
cd chainer_setup
wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.3.tar.gz
tar xzvf openmpi-3.1.3.tar.gz
rm openmpi-3.1.3.tar.gz
cd openmpi-3.1.3
./configure --with-cuda
make -j4
sudo make install
cd ..

git clone -b v2.3.7-1 https://github.com/NVIDIA/nccl.git
cd nccl
make -j src.build
make pkg.debian.build
sudo apt install build-essential devscripts debhelper
make pkg.debian.build
sudo dpkg -i build/pkg/deb/libnccl*
cd ..

pip install mpi4py==3.0.0
pip install chainer==5.0.0 cupy==5.0.0
