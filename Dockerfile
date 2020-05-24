FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&  apt-get install -y wget cmake libxerces-c-dev qt5-default freeglut3-dev libmotif-dev tk-dev  libxpm-dev libxmu-dev libxi-dev

ARG GEANT_VERSION
ARG PARALLEL
ARG INSTALL_DATA
RUN useradd -ms /bin/bash geant && usermod -a -G video geant
RUN mkdir /opt/geant4 && chown geant:geant /opt/geant4
ADD ./install-novnc-deps.sh /root/
RUN apt-get install -y git xvfb x11vnc && cd /home/geant && wget https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz && tar -xzvf v1.1.0.tar.gz  && ln -s /usr/bin/python3.6 /usr/bin/python && /root/install-novnc-deps.sh /home/geant/noVNC-1.1.0/utils && chown -R geant:geant /home/geant/noVNC-1.1.0

USER geant
WORKDIR /tmp
RUN wget http://cern.ch/geant4-data/releases/geant4.$GEANT_VERSION.tar.gz && \
    tar -xzvf ./geant4.$GEANT_VERSION.tar.gz -C /opt/geant4 && \
    mkdir /opt/geant4/geant4.$GEANT_VERSION.build
WORKDIR /opt/geant4/geant4.$GEANT_VERSION.build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/geant4/geant4.$GEANT_VERSION.install \
          -DGEANT4_USE_GDML=ON \
          -DGEANT4_INSTALL_DATA=$INSTALL_DATA \
          -DGEANT4_USE_OPENGL_X11=ON \
          -DGEANT4_USE_XM=ON \
          -DGEANT4_USE_QT=ON \
          -DGEANT4_BUILD_MULTITHREADED=ON /opt/geant4/geant4.$GEANT_VERSION && \
    make -j$PARALLEL && make -j$PARALLEL install

ENV GEANT_VERSION=$GEANT_VERSION
RUN echo "export Geant4_DIR=$(dirname $(find /opt -name Geant4Config.cmake | grep install))/" >> /opt/geant4/geant4.$GEANT_VERSION.install/bin/geant4.sh
WORKDIR /opt/geant4/geant4.$GEANT_VERSION.install

RUN rm -rf /opt/geant4/geant4.$GEANT_VERSION.build && rm -rf /opt/geant4/geant4.$GEANT_VERSION

CMD [ "bash" ]