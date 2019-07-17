FROM ivanvr0/geant4-base:10.05.p01

RUN apt-get install -y g77
ADD magnetocosmics /opt
WORKDIR /opt
RUN ./configure_and_build.sh