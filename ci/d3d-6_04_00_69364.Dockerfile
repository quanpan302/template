FROM centos:centos7
RUN yum groupinstall -y "Development Tools"

RUN yum install -y \
    openssl-devel \
    bzip2-devel \
    libffi-devel \
    xz-devel \
    libxml2-devel \
    boost-devel \
    wget

WORKDIR /root/Software
COPY Delft3D-6_04_00_69364 /root/Software/Delft3D-6_04_00_69364
COPY torque-6.0.1 /root/Software/torque-6.0.1
COPY mpich-3.2 /root/Software/mpich-3.2

RUN wget https://www.python.org/ftp/python/3.8.9/Python-3.8.9.tgz &&\
    tar xvf Python-3.8.9.tgz &&\
    rm -f Python-3.8.9.tgz

#COPY nefis-python-0.4.0 /root/Software/Python/nefis-python-0.4.0
#RUN echo $(ls -alh /root/Software)

WORKDIR /root/Software/torque-6.0.1
RUN ./autogen.sh &&\
    ./configure --prefix=/opt/torque6 2>&1 | tee torque-c.txt &&\
    make 2>&1 | tee torque-m.txt &&\
    make install 2>&1 | tee torque-mi.txt &&\
    ls /opt/torque6/bin && ls /opt/torque6/lib
ENV PATH=/opt/torque6/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/torque6/lib:$LD_LIBRARY_PATH
#RUN export PATH=/opt/torque6/bin:$PATH && echo $PATH
#RUN export LD_LIBRARY_PATH=/opt/torque6/lib:$LD_LIBRARY_PATH && echo $LD_LIBRARY_PATH

WORKDIR /root/Software/mpich-3.2
RUN ./configure --prefix=/opt/mpich2 2>&1 | tee mpich-c.txt &&\
    make 2>&1 | tee mpich-m.txt &&\
    make install 2>&1 | tee mpich-mi.txt &&\
    ls /opt/mpich2/bin
ENV PATH=/opt/mpich2/bin:$PATH
#RUN export PATH=/opt/mpich2/bin:$PATH && echo $PATH

WORKDIR /root/Software/Python-3.8.9
RUN ./configure --enable-optimizations &&\
    make altinstall
RUN rm -f /usr/bin/python3 &&\
    ln -s /usr/bin/python3.8 /usr/bin/python3
RUN wget https://bootstrap.pypa.io/get-pip.py &&\
    python3.8 get-pip.py
RUN pip3 install -U pip &&\
    pip3 install \
    bpytop \
    setuptools \
    scikit-build \
    Cython \
    numpy

#WORKDIR /root/Software/Python/nefis-python-0.4.0
#RUN pip3 install ./dist/nefis-0.4.0-cp38-cp38-linux_x86_64.whl
#RUN cp -rf ./lib/* /usr/local/lib/
#RUN export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:$LD_LIBRARY_PATH && echo $LD_LIBRARY_PATH

ENV LD_LIBRARY_PATH=/root/Software/Delft3D-6_04_00_69364/lnx64/lib:$LD_LIBRARY_PATH

WORKDIR /root