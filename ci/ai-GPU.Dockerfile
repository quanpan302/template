FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu18.04
LABEL maintainer quanpan302@hotmail.com

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/Amsterdam"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    nvidia-driver-440 \
    keyboard-configuration \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    cmake \
    g++ \
    wget \
    build-essential \
    cmake \
    git \
    unzip \
    pkg-config \
    python-dev \
    python-opencv \
    libopencv-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libgtk2.0-dev \
    python-numpy \
    python-pycurl \
    libatlas-base-dev \
    gfortran \
    webp \
    python-opencv \
    qt5-default \
    libvtk6-dev \
    zlib1g-dev \
    libcudnn7=7.6.5.32-1+cuda10.2 \
    libcudnn7-dev=7.6.5.32-1+cuda10.2 \
    python3-pip \
    python3-venv \
    nano

RUN alias python='/usr/bin/python3'
RUN pip3 install numpy
RUN pip3 install torch

#RUN echo ############ && python --version && ##############

WORKDIR /root/Software
# Install Open CV - Warning, this takes absolutely forever
RUN git clone https://github.com/opencv/opencv_contrib  && \
    cd opencv_contrib  && \
    git fetch --all --tags  && \
    git checkout tags/4.3.0  && \
    cd .. && \
    git clone https://github.com/opencv/opencv.git  && \
    cd opencv  && \
    git checkout tags/4.3.0

#RUN pip3 freeze && which python3 && python3 --version

################################################################
#################### OPENCV CPU ################################

WORKDIR /root/Software/opencv
#RUN pwd &&\
#    cd opencv  && \
#    pwd &&\
#    mkdir build && cd build && \
#    pwd &&\
#    cmake -DCMAKE_BUILD_TYPE=Release  \
#      -DENABLE_CXX14=ON                 \
#      -DBUILD_PERF_TESTS=OFF            \
#      -DOPENCV_GENERATE_PKGCONFIG=ON    \
#      -DWITH_XINE=ON                    \
#      -DBUILD_TESTS=OFF                 \
#      -DENABLE_PRECOMPILED_HEADERS=OFF  \
#      -DCMAKE_SKIP_RPATH=ON             \
#      -DBUILD_WITH_DEBUG_INFO=OFF       \
#      -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules  \
#
#      -Dopencv_dnn_superres=ON /usr/bin/ .. && \
#    make -j$(nproc) && \
#    make install

################################################################
#################### OPENCV GPU ################################

WORKDIR /root/Software/opencv
RUN mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -D CMAKE_CXX_COMPILER=/usr/bin/g++ \
    -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
    -D BUILD_NEW_PYTHON_SUPPORT=ON \
    -D BUILD_opencv_python3=ON \
    -D HAVE_opencv_python3=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.2 \
    -D CUDA_BIN_PATH=/usr/local/cuda-10.2 \
    -D CUDNN_INCLUDE_DIR=/usr/include/cudnn.h \
    -D WITH_CUDNN=ON \
    -D CUDA_ARCH_BIN=6.1 \
    -D OPENCV_DNN_CUDA=ON \
    -D WITH_CUDA=ON \
    -D BUILD_opencv_cudacodec=OFF \
    -D WITH_GTK=ON \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CUDA_HOST_COMPILER:FILEPATH=/usr/bin/gcc-7 \
    -D ENABLE_PRECOMPILED_HEADERS=OFF \
    -D WITH_TBB=ON \
    -D WITH_OPENMP=ON \
    -D WITH_IPP=ON \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_TESTS=OFF \
    -D WITH_CSTRIPES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D CMAKE_INSTALL_PREFIX=/usr/local/ \
    -DBUILD_opencv_python3=ON         \
    -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
    -D PYTHON3_EXECUTABLE=$(which python3)  \
    -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
    -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -D PYTHON3_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))")  \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())")  \
    -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")  \
    -D OPENCV_GENERATE_PKGCONFIG=ON .. \
    -Dopencv_dnn_superres=ON /usr/bin/ .. && \
    make -j$(nproc) && \
    make install && \
    pip3 install python_loader
