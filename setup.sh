# setup
# http://qiita.com/yn-misaki/items/3ec0605cba228a7d5c9a
export SETUP_INSTALL_DIR="${HOME}/install"

function check_install() {
    if [ "$1" == "Y" ] || [ "$1" == "y" ] || [ "$1" == "" ];then
        echo 'True'
    else
        echo 'False'
    fi
}

function setup_first () {
    sudo apt-get update
    sudo apt-get install -y git zsh curl tmux mosh zip language-pack-ja
    if [ ! "`echo $SHELL`" = "/usr/bin/zsh" ]; then
        sudo chsh $(whoami) -s /usr/bin/zsh
    fi

        export ZPLUG_HOME=${HOME}/.zplug
    if [ ! -e $ZPLUG_HOME ]; then
            git clone https://github.com/zplug/zplug $ZPLUG_HOME
    fi

    zsh install.sh
    echo "source ${HOME}/dotfiles/init.zsh" >> ~/.zshrc
}

function install_golang () {
    export ZSHRC_FILENAME="$HOME/.zshenv"

    sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
    sudo apt-get -y update
    sudo apt-get -y install golang
    if [ ! "`grep 'GOPATH' $ZSHRC_FILENAME`" ]; then
        echo "write golang config to $ZSHRC_FILENAME"
        echo "# golang" >> $ZSHRC_FILENAME
        echo "export GOPATH=$HOME/.go" >> $ZSHRC_FILENAME
        echo "export PATH=$PATH:$HOME/.go/bin" >> $ZSHRC_FILENAME
    fi
}

function install_peco () {
#     export GOPATH="$HOME/.go"
#     export PATH=$PATH:$HOME/.go/bin
#     go get github.com/peco/peco/cmd/peco
    curl -L https://github.com/peco/peco/releases/download/v0.4.7/peco_linux_amd64.tar.gz | tar zx -C /tmp && \
    sudo mv /tmp/peco_linux_amd64/peco /usr/local/bin/
}

function install_neovim () {
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
}

function install_pyenv () {
    export ZSHRC_FILENAME="$HOME/.zshenv"
    if [ ! -e ${HOME}/.pyenv ]; then
        git clone https://github.com/yyuu/pyenv.git ${HOME}/.pyenv
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $ZSHRC_FILENAME
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $ZSHRC_FILENAME
        echo 'eval "$(pyenv init -)"' >> $ZSHRC_FILENAME
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
    fi
}

function install_python_packages () {
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils
    sudo apt-get install -y libopenblas-base
    sudo apt-get install -y tk-dev

    # install python by using pyenv
    export PYENV_PYTHON_VERSION="3.6.1"
    env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install $PYENV_PYTHON_VERSION
    pyenv global $PYENV_PYTHON_VERSION

    pip install --upgrade pip
    pip install numpy scipy scikit-learn
    pip install jupyter
    pip install tqdm click
    pip install matplotlib scikit-image toolz
    pip install glances
    pip install neovim
}

function install_opencv() {
    sudo apt-get install -y libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libtheora-dev \
        libvorbis-dev \
        libxvidcore-dev \
        libx264-dev \
        libopencore-amrnb-dev \
        libopencore-amrwb-dev \
        libopenexr-dev \
        libgstreamer-plugins-base1.0-dev \
        libavcodec-dev \
        libavutil-dev \
        libavfilter-dev \
        libavformat-dev \
        libavresample-dev
    git clone https://github.com/opencv/opencv.git
    mkdir opencv/build
    echo 'set(PYTHON_DEFAULT_EXECUTABLE "${PYTHON3_EXECUTABLE}")' >> opencv/cmake/OpenCVDetectPython.cmake
    cd opencv/build
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=ON \
      -D WITH_FFMPEG=ON \
      -D WITH_CUDA=OFF \
      -D WITH_GTK=ON \
      -D WITH_VTK=OFF \
      -D BUILD_opencv_ml=OFF \
      -D BUILD_opencv_dnn=OFF \
      -D BUILD_opencv_objdetect=OFF \
      -D BUILD_opencv_photo=OFF \
      -D BUILD_opencv_dnn=OFF \
      -D BUILD_opencv_shape=OFF \
      -D BUILD_opencv_ts=OFF \
      -D BUILD_opencv_stitching=OFF \
      -D BUILD_opencv_superres=OFF \
      -D BUILD_opencv_java_bindings_generator=OFF \
      -D INSTALL_TESTS=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D PYTHON3_EXECUTABLE=/home/ubuntu/.pyenv/shims/python \
      -D PYTHON3_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
      -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python -c "import numpy; print(numpy.get_include())") \
      -D PYTHON3_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
      -D PYTHON3_LIBRARY=$(python -c "import os;import sysconfig as sc;print(os.path.join(os.path.dirname(sc.get_path('stdlib')), sc.get_config_vars('LDLIBRARY')[0]))") \
      .. && make all -j4 && sudo make install && rm -rf opencv
}

function install_cmake () {
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:george-edison55/cmake-3.x
    sudo apt-get update
    sudo apt-get install -y cmake
}

function install_docker () {
    curl -sSL https://get.docker.com/ | sh
    sudo groupadd docker
    sudo gpasswd -a $USER docker
}

function install_gpu_driver () {
    export ZSHRC_FILENAME="${HOME}/.zshenv"

    cd $SETUP_INSTALL_DIR
    wget http://jp.download.nvidia.com/XFree86/Linux-x86_64/396.54/NVIDIA-Linux-x86_64-396.54.run
    sudo sh NVIDIA-Linux-x86_64-396.54.run --silent
}

function install_cuda () {
    sudo dpkg -i ${REPOS}
    sudo apt-get update
    sudo apt-get install -y --allow-unauthenticated cuda

    if [ ! "`grep '/usr/local/cuda/bin' $ZSHRC_FILENAME`" ]; then
        echo "write cuda config to $ZSHRC_FILENAME"
        echo "# cuda" >> $ZSHRC_FILENAME
        echo 'export PATH="$PATH:/usr/local/cuda/bin"'  >> $ZSHRC_FILENAME
        echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"' >> $ZSHRC_FILENAME
    fi
}

function install_cuda_9_0_1604 () {
    export ZSHRC_FILENAME="${HOME}/.zshenv"

    cd $SETUP_INSTALL_DIR
    export REPOS='cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb'
    if [ ! -e "${REPOS}" ]; then
        echo "download cuda to $SETUP_INSTALL_DIR"
        wget https://developer.nvidia.com/compute/cuda/9.0/prod/local_installers/${REPOS}
    fi

    install_cuda
}


function install_cuda_10_0_1604 () {
    export ZSHRC_FILENAME="${HOME}/.zshenv"

    cd $SETUP_INSTALL_DIR
    export REPOS='cuda-repo-ubuntu1604-10-0-local-10.0.130-410.48_1.0-1_amd64'
    if [ ! -e "${REPOS}" ]; then
        echo "download cuda to $SETUP_INSTALL_DIR"
        wget https://developer.nvidia.com/compute/cuda/10.0/prod/local_installers/${REPOS}
    fi

    install_cuda
}

function install_cudnn_7 () {
    cd $SETUP_INSTALL_DIR

    if [ ! -e 'cudnn.tgz' ]; then
        echo "download cudnn"
        curl -L -o libcudnn7_7.2.1.38-1+cuda9.0_amd64.deb \
          https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_7.2.1.38-1+cuda9.0_amd64.deb
        curl -L -o libcudnn7-dev_7.2.1.38-1+cuda9.0_amd64.deb \
          https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7-dev_7.2.1.38-1+cuda9.0_amd64.deb
    fi
    sudo dpkg -i libcudnn7_7.2.1.38-1+cuda9.0_amd64.deb
    sudo dpkg -i libcudnn7-dev_7.2.1.38-1+cuda9.0_amd64.deb
}

function install_chainer_5_0_0 () {
    cd $SETUP_INSTALL_DIR

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
    sudo apt -y install build-essential devscripts debhelper
    make pkg.debian.build
    sudo dpkg -i build/pkg/deb/libnccl*
    cd ..
    
    pip install mpi4py==3.0.0
    pip install chainer==5.0.0 cupy==5.0.0
}

echo -n "Set up first? [Y/n] "
read is_setup_first
echo -n "Set up neovim[Y/n] "
read is_setup_neovim
echo -n "Set up python[Y/n] "
read is_setup_python
echo -n "Set up cmake[Y/n] "
read is_setup_cmake
echo -n "Set up docker[Y/n] "
read is_setup_docker
echo -n "Set up opencv[Y/n] "
read is_setup_opencv
echo -n "Set up cuda[Y/n] "
read is_setup_cuda 
echo -n "Set up chainer[Y/n] "
read is_setup_chainer 

ret=`check_install ${is_setup_first}`
if [ ${ret} == 'True' ];then
    setup_first
    install_golang
    install_peco
fi
ret=`check_install ${is_setup_neovim}`
if [ ${ret} == 'True' ];then
    install_neovim
fi
ret=`check_install ${is_setup_python}`
if [ ${ret} == 'True' ];then
    install_pyenv
    install_python_packages
fi
ret=`check_install ${is_setup_cmake}`
if [ ${ret} == 'True' ];then
    install_cmake
fi
ret=`check_install ${is_setup_docker}`
if [ ${ret} == 'True' ];then
    install_docker
fi
ret=`check_install ${is_setup_opencv}`
if [ ${ret} == 'True' ];then
    install_opencv
fi
ret=`check_install ${is_setup_cuda}`
if [ ${ret} == 'True' ];then
    install_gpu_driver
    install_cuda_9_0_1604
    install_cudnn_7
fi
ret=`check_install ${is_setup_chainer}`
if [ ${ret} == 'True' ];then
    install_chainer_5_0_0
fi
