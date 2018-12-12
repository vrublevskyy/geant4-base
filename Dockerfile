FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&  apt-get install -y libxerces-c-dev qt4-dev-tools freeglut3-dev libmotif-dev tk-dev cmake libxpm-dev libxmu-dev libxi-dev wget

ARG GEANT_VERSION
ARG PARALLEL
ARG INSTALL_DATA

RUN wget http://cern.ch/geant4-data/releases/geant4.$GEANT_VERSION.tar.gz && \
    mkdir /opt/geant4 && \
    tar -xzvf ./geant4.$GEANT_VERSION.tar.gz -C /opt/geant4 && \
    mkdir /opt/geant4/geant4.$GEANT_VERSION.build
WORKDIR /opt/geant4/geant4.$GEANT_VERSION.build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/geant4/geant4.$GEANT_VERSION.install \
          -DGEANT4_USE_GDML=ON \
          -DCMAKE_BUILD_TYPE=Debug \
          -DGEANT4_INSTALL_DATA=$INSTALL_DATA \
          -DGEANT4_USE_OPENGL_X11=ON \
          -DGEANT4_USE_XM=ON \
          -DGEANT4_USE_QT=ON \
          -DGEANT4_BUILD_MULTITHREADED=ON /opt/geant4/geant4.$GEANT_VERSION && \
    make -j$PARALLEL && make -j$PARALLEL install

ENV GEANT_VERSION=$GEANT_VERSION
RUN echo "export Geant4_DIR=$(dirname $(find /opt -name Geant4Config.cmake | grep install))/" >> /opt/geant4/geant4.$GEANT_VERSION.install/bin/geant4.sh

CMD [ "bash" ]