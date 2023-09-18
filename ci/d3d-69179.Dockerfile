#FROM centos:centos8
#RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
#RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
#RUN sed -i 'assumeyes=1' /etc//yum.conf
## RUN dnf config-manager --set-enabled powertools
#
#RUN dnf install -y \
#    epel-release epel-next-release

#FROM centos:centos7
#RUN yum update -y
#RUN yum groupinstall -y "Development Tools"
#RUN yum install -y \
#    epel-release \
#    yum-axelget \
#    cmake \
#    expat-devel \
#    uuid-dev \
#    readline-devel \
#    flex-devel \
#    bison-devel \
#    metis-devel \
#    petsc-devel \
#    netcdf-devel \
#    netcdf-fortran-devel \
#    gdal \
#    openssl-devel \
#    bzip2-devel \
#    libffi-devel \
#    xz-devel \
#    libxml2-devel \
#    boost-devel \
#    wget \
#    vim

FROM ubuntu:20.04
RUN apt update && apt install tzdata -y
ENV TZ="Europe/Amsterdam"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt install -y build-essential
RUN apt install -y gfortran
RUN apt install -y autoconf
RUN apt install -y \
    cmake \
    expat libexpat1-dev \
    uuid uuid-dev \
    libreadline-dev \
    flex \
    bison libbison-dev \
    metis libmetis-dev \
    petsc-dev \
	netcdf-bin \
    libnetcdf-dev \
    libnetcdff-dev \
	libnetcdf-mpi-dev \
    libgdal-dev \
    openssl \
    bzip2 \
    libffi-dev \
    xz-utils \
    libxml2 libxml2-dev \
    libboost-all-dev \
    wget \
    vim

RUN apt install -y mpich libmpich-dev
    
RUN apt install -y python3.8

WORKDIR /root/Software
COPY SVN-delft3d4_69179 /root/Software/Delft3D-69179
COPY torque-6.0.1 /root/Software/torque-6.0.1
COPY mpich-3.2 /root/Software/mpich-3.2

#RUN wget https://www.python.org/ftp/python/3.8.9/Python-3.8.9.tgz &&\
#    tar xvf Python-3.8.9.tgz &&\
#    rm -f Python-3.8.9.tgz

#WORKDIR /root/Software/torque-6.0.1
#RUN ./autogen.sh &&\
#    ./configure --prefix=/opt/torque6 2>&1 | tee torque-c.txt &&\
#    make 2>&1 | tee torque-m.txt &&\
#    make install 2>&1 | tee torque-mi.txt &&\
#    ls /opt/torque6/bin && ls /opt/torque6/lib
#RUN export PATH=/opt/torque6/bin:$PATH && echo $PATH
#RUN export LD_LIBRARY_PATH=/opt/torque6/lib:$LD_LIBRARY_PATH && echo $LD_LIBRARY_PATH

#WORKDIR /root/Software/mpich-3.2
#RUN ./configure --prefix=/opt/mpich2 2>&1 | tee mpich-c.txt &&\
#    make 2>&1 | tee mpich-m.txt &&\
#    make install 2>&1 | tee mpich-mi.txt &&\
#    ls /opt/mpich2/bin
#RUN export PATH=/opt/mpich2/bin:$PATH && echo $LD_LIBRARY_PATH

#WORKDIR /root/Software/Python-3.8.9
#RUN ./configure --enable-optimizations &&\
#    make altinstall
#RUN rm -f /usr/bin/python3 &&\
#    ln -s /usr/bin/python3.8 /usr/bin/python3
RUN wget https://bootstrap.pypa.io/get-pip.py &&\
    python3.8 get-pip.py
RUN pip3 install -U pip &&\
    pip3 install \
    bpytop \
    setuptools \
    scikit-build \
    Cython \
    numpy

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/include
ENV NETCDF_LIBS=$NETCDF_LIBS:/usr/include
ENV NETCDF_FORTRAN_LIBS=$NETCDF_FORTRAN_LIBS:/usr/include

WORKDIR /root/Software/Delft3D-69179/src/third_party_open/kdtree2
RUN ./autogen.sh
#RUN ./configure
#RUN ./make

WORKDIR /root/Software/Delft3D-69179/src
RUN cp -Rf ./third_party_open/swan/src/*.F ./third_party_open/swan/swan_mpi/
RUN cp -Rf ./third_party_open/swan/src/*.f90 ./third_party_open/swan/swan_mpi/
RUN cp -Rf ./third_party_open/swan/src/*.for ./third_party_open/swan/swan_mpi/

#./clean.sh
#rm -f 00-autogen.log 01-configure.log 02-make.log

RUN ./autogen.sh 2>&1 | tee 00-autogen.log
#RUN CFLAGS='-O2' CXXFLAGS='-O2' FFLAGS='-O2' FCFLAGS='-O2' ./configure --prefix=`pwd` --with-netcdf --with-mpi --with-metis --with-petsc
RUN CFLAGS='-O2' CXXFLAGS='-O2' FFLAGS='-O2' FCFLAGS='-O2' ./configure --prefix=`pwd` --with-netcdf --with-mpi --with-metis 2>&1 | tee 01-configure.log
#RUN FC=mpif90 make ds-install 2>&1 | tee 02-make.log
#-----
#*** No rule to make target `swmod1.for', needed by `swmod1.o'.  Stop.
#My hack to get around the issue was to copy the the source code from src/third_party_open/swan/src into src/third_party_open/swan/swan_mpi (and src/third_party_open/swan/swan_omp). I'm sure there is a better solution.
#-----
#make[3]: Entering directory '/root/Software/Delft3D-69179/src/third_party_open/swan/swan_mpi'
#/bin/bash ../../../libtool  --tag=FC   --mode=compile mpif90 -I/usr/include/hdf5/serial -I/usr/include/hdf5/serial -DUSE_MPI -O2 -ffree-line-length-none -cpp -c -o nctablemd.lo  nctablemd.f90
#libtool: compile:  mpif90 -I/usr/include/hdf5/serial -I/usr/include/hdf5/serial -DUSE_MPI -O2 -ffree-line-length-none -cpp -c nctablemd.f90  -fPIC -o .libs/nctablemd.o
#nctablemd.f90:25:12:
#   25 |         use netcdf
#      |            1
#Fatal Error: Cannot open module file 'netcdf.mod' for reading at (1): No such file or directory
#compilation terminated.

#WORKDIR /root/Software/Delft3D-69179
#RUN chmod 777 ./build.sh
#RUN ./build.sh all


#WORKDIR /root

#docker build --no-cache -t kwrprojects/d3d:69179 -f ./d3d-69179.Dockerfile .
#docker build -t kwrprojects/d3d:69179 -f ./d3d-69179.Dockerfile .
#
#docker push kwrprojects/d3d:69179
#
#docker system prune -f
#docker run -it -w /Docker --name D3D --volume="//d/Docker:/Docker" kwrprojects/d3d:69179
#docker run -it -w /root/Software/Delft3D-69179/src --name D3D --volume="//d/Docker:/Docker" kwrprojects/d3d:69179
