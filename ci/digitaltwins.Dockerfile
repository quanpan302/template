# =========
# centos7, not success
# =========
# FROM centos:centos7
#
# MAINTAINER Quan Pan <quanpan302@hotmail.com>
#
# RUN yum groupinstall -y "Development Tools"
# RUN yum install -y vim-enhanced \
#     openssl-devel bzip2-devel \
# 	libffi-devel xz-devel \
# 	libxml2-devel boost-devel \
# 	wget cmake
# RUN debuginfo-install -y gcc
#
# # Args
# ## https://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.gz
# ARG gcc_url="https://ftp.gnu.org/gnu/gcc"
# ARG gcc_version=8.3.0
# ENV GCC_NAME=gcc-${gcc_version}
#
# ## https://download.osgeo.org/proj/proj-6.1.1.tar.gz
# ARG proj_url="https://download.osgeo.org/proj"
# ARG proj_version=6.1.1
# ENV PROJ_NAME=proj-${proj_version}
#
# ## http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-libkml-r864-64bit.tar.gz
# ARG libkml_url="http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci"
# ARG libkml_version=r864-64bit
# ENV LIBKML_NAME=install-libkml-${libkml_version}
#
# ## https://download.osgeo.org/gdal/3.0.2/gdal-3.0.2.tar.gz
# ARG gdal_url="https://download.osgeo.org/gdal"
# ARG gdal_version=3.2.2
# ENV GDAL_NAME=gdal-${gdal_version}
#
# ## https://www.python.org/ftp/python/3.8.9/Python-3.8.9.tgz
# ARG python_url="https://www.python.org/ftp/python"
# ARG python_version=3.8.9
# ENV PYTHON_NAME=Python-${python_version}
#
# # GCC
# ## /usr/lib64/libstdc++.so.6
# WORKDIR /root/Software/GCC
# RUN yum install -y bzip2
# RUN wget --no-check-certificate ${gcc_url}/${GCC_NAME}/${GCC_NAME}.tar.gz &&\
#     tar xf ${GCC_NAME}.tar.gz &&\
# 	rm -f ${GCC_NAME}.tar.gz
# RUN cd ${GCC_NAME} &&\
#     ./contrib/download_prerequisites &&\
#     ./configure --enable-languages=c,c++ --disable-multilib &&\
#     make &&\
#     make install &&\
#     export LD_LIBRARY_PATH=/usr/local/lib64:${LD_LIBRARY_PATH}
#
# # Python
# WORKDIR /root/Software/Python
#
# ## python
# RUN wget --no-check-certificate ${python_url}/${python_version}/${PYTHON_NAME}.tgz &&\
# 	tar xvf ${PYTHON_NAME}.tgz &&\
# 	rm -f ${PYTHON_NAME}.tgz
# RUN cd ${PYTHON_NAME} &&\
#     ./configure --enable-optimizations &&\
# 	make altinstall
#
# ## pip
# RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
# RUN python3.8 get-pip.py &&\
#     pip3 install setuptools &&\
#     pip3 install bpytop scikit-build
#
# # GDAL
# WORKDIR /root/Software/GDAL
#
# ## lib
# RUN yum install -y libzstd-devel sqlite-devel libwebp-devel hdf5-devel
#
# ## proj, /usr/local
# RUN wget --no-check-certificate ${proj_url}/${PROJ_NAME}.tar.gz &&\
#     tar xzf ${PROJ_NAME}.tar.gz &&\
# 	rm -f ${PROJ_NAME}.tar.gz
# RUN cd ${PROJ_NAME} &&\
#     ./configure &&\
#     make &&\
#     make install
#
# ## libkml, /usr/local
# RUN wget --no-check-certificate ${libkml_url}/${LIBKML_NAME}.tar.gz &&\
#     tar xzf ${LIBKML_NAME}.tar.gz &&\
# 	rm -f ${LIBKML_NAME}.tar.gz
# RUN cd install-libkml &&\
#     cp -rf include/* /usr/local/include &&\
#     cp -rf lib/* /usr/local/lib &&\
#     ldconfig
#
# ## gdal, /usr/local
# RUN wget --no-check-certificate ${gdal_url}/${gdal_version}/${GDAL_NAME}.tar.gz &&\
#     tar xzf ${GDAL_NAME}.tar.gz &&\
# 	rm -f ${GDAL_NAME}.tar.gz
# RUN cd ${GDAL_NAME} &&\
#     ./configure --with-libkml=/usr/local --with-proj=/usr/local &&\
#     make &&\
#     make install &&\
#     ldconfig
# CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
#
# # Python-lib, /usr/local/lib/python3.8.9/site-package/
# WORKDIR /root/Software/Python
#
# COPY ./ci/Python-lib /root/Software/Python/Python-lib
# RUN pip3 install -r /root/Software/Python/Python-lib/requirements.txt
#
# WORKDIR /root/Software/Python/Python-lib
# RUN rm -rf /usr/local/lib/python3.8/site-packages/wntr* &&\
#     cp -rf wntr* /usr/local/lib/python3.8/site-packages/
#
# # rm all
# WORKDIR /root
# RUN rm -rf ./Software/*
#
# WORKDIR /root

# =========
# ubuntu
# =========
FROM osgeo/gdal:ubuntu-full-3.2.2

MAINTAINER Quan Pan <quanpan302@hotmail.com>

RUN apt-get update
RUN apt-get install -y \
    vim \
    python3-pip
#   autoconf \
#   libtool \
#   flex \
#   g++ \
#   gfortran \
#   libstdc++6 \
#   byacc \
#   libexpat1-dev \
#   uuid-dev \
#   ruby \
#   build-essential \
#   wget \
#   pkg-config \
#   gedit \
#   libcurl4-openssl-dev

RUN pip3 install \
    setuptools \
    bpytop \
    scikit-build

# Python-lib, /usr/local/lib/python3.8.9/site-package/
WORKDIR /root/Software

COPY ./ci/Python-lib /root/Software/Python-lib
RUN pip3 install -r /root/Software/Python-lib/requirements.txt

WORKDIR /root/Software/Python-lib
RUN rm -rf /usr/local/lib/python3.8/dist-packages/wntr* &&\
    cp -rf wntr* /usr/local/lib/python3.8/dist-packages/

WORKDIR /root

# CMD cat /etc/os-release
# CMD python --version
# CMD python -m site
# CMD pip --version
# CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
