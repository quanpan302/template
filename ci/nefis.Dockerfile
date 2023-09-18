FROM osgeo/gdal:ubuntu-full-3.1.0

RUN apt-get update
RUN apt-get install -y \
    software-properties-common \
    build-essential \
    autoconf \
    pkg-config \
    libtool \
    cpuset \
    openssl \
    libssl-dev \
    cgroup-tools \
    tcl8.6-dev \
    tk8.6-dev \
    libcgroup-dev \
    libhwloc-dev \
    bzip2 \
    libffi-dev \
    xz-utils \
    libxml2-dev \
    libboost-all-dev \
    wget \
    vim \
    python3-pip

WORKDIR /root/Software

#COPY Delft3D-6_04_00_69364 /root/Software/Delft3D-6_04_00_69364
#COPY hwloc-1.11.4 /root/Software/hwloc-1.11.4
#COPY torque-6.1.3 /root/Software/torque-6.1.3
#COPY mpich-3.2 /root/Software/mpich-3.2
#
##RUN wget https://www.python.org/ftp/python/3.8.9/Python-3.8.9.tgz &&\
##    tar xvf Python-3.8.9.tgz &&\
##    rm -f Python-3.8.9.tgz
COPY nefis-python-0.4.0 /root/Software/nefis-python-0.4.0

RUN echo $(ls -alh /root/Software)


#WORKDIR /root/Software/hwloc-1.11.4
#RUN ./configure 2>&1 | tee hwloc-c.txt &&\
#    make 2>&1 | tee hwloc-m.txt &&\
#    make install 2>&1 | tee hwloc-mi.txt
#
#WORKDIR /root/Software/torque-6.1.3
#RUN ./autogen.sh &&\
#    ./configure \
#    --prefix=/opt/torque6 \
#    --enable-gcc-warnings \
#    --enable-shared \
#    --enable-static \
#    --enable-fast-install \
#    --enable-syslog \
#    --enable-cgroups \
#    --enable-unixsockets \
#    --enable-tcl-qstat \
#    --with-scp \
#    --with-server-home=/var/spool/torque \
#    --with-boost-path=/usr/share/doc/libboost-all-dev \
#    --with-tcl=/usr/lib/tcl8.6 \
#    --with-tclinclude=/usr/include/tcl8.6 \
#    --with-tk=/usr/lib/tk8.6 \
#    --with-tkinclude=/usr/include/tcl8.6/tk-private/generic 2>&1 | tee torque-c.txt &&\
#    make 2>&1 | tee torque-m.txt &&\
#    make install 2>&1 | tee torque-mi.txt &&\
#    ls /opt/torque6/bin &&\
#    ls /opt/torque6/lib
#RUN export PATH=/opt/torque6/bin:$PATH
#RUN export LD_LIBRARY_PATH=/opt/torque6/lib:$LD_LIBRARY_PATH
#
#WORKDIR /root/Software/mpich-3.2
#RUN ./configure --prefix=/opt/mpich2 2>&1 | tee mpich-c.txt &&\
#    make 2>&1 | tee mpich-m.txt &&\
#    make install 2>&1 | tee mpich-mi.txt &&\
#    ls /opt/mpich2/bin
#RUN export PATH=/opt/mpich2/bin:$PATH
#
##WORKDIR /root/Software/Python-3.8.9
##RUN ./configure --enable-optimizations &&\
##    make altinstall
##
##RUN wget https://bootstrap.pypa.io/get-pip.py &&\
##    python3.8 get-pip.py
RUN pip3 install -U pip &&\
    pip3 install \
    bpytop \
    setuptools \
    scikit-build \
    Cython \
    numpy \
	netcdf4 \
	mako \
	bokeh

WORKDIR /root/Software/nefis-python-0.4.0
RUN make dist
RUN pip3 install ./dist/nefis-0.4.0-cp38-cp38-linux_x86_64.whl
RUN cp -rf ./lib/* /usr/local/lib/
RUN export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:$LD_LIBRARY_PATH && echo $LD_LIBRARY_PATH

#WORKDIR /root
#RUN apt-get update
#RUN add-apt-repository "deb https://apt.repos.intel.com/oneapi all main"
#RUN apt-get install -y \
#    libjpeg-dev \
#    libpcre3 libpcre3-dev \
#    intel-basekit \
#    intel-hpckit
#RUN ln -s /usr/lib/libgdal.so.3.1.0 /usr/lib/libgdal.so.27 &&\
#    ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so /usr/lib/x86_64-linux-gnu/libcrypto.so.10 &&\
#    ln -s /usr/lib/x86_64-linux-gnu/libpng16.so /usr/lib/x86_64-linux-gnu/libpng15.so.15 &&\
#    ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/x86_64-linux-gnu/libjpeg.so.62 &&\
#    ln -s /usr/lib/x86_64-linux-gnu/libpcre.so /usr/lib/x86_64-linux-gnu/libpcre.so.1

WORKDIR /root
