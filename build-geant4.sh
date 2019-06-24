#!/bin/bash

while getopts ":hs:v:i:d:p:" option
do

	case "${option}" in
        h) echo '
            Options:

                -v GEANT_VERSION. Default 4.10.04.p02
                -i Docker image. Ex: test/geant4
                -d Install data [ON|OFF]. Default ON
                ' && exit;;
		v) GEANT_VERSION=${OPTARG};;
		i) DOCKER_IMAGE=${OPTARG};;
        p) PARALLEL=${OPTARG};;
	esac
done

#Install data if not specified
if [ -z $DOCKER_IMAGE ]; then

    echo "DOCKER_IMAGE param is required" 
    exit 1
fi

#Set latest version if not defined
if [ -z $GEANT_VERSION ]; then

    GEANT_VERSION=10.05
fi

#Install data if not specified
if [ -z $INSTALL_DATA ]; then

    INSTALL_DATA=ON
fi

#GET number of CPU cores
if [ -z $PARALLEL ]; then

    PARALLEL=$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l) 
fi

docker build -t $DOCKER_IMAGE:$GEANT_VERSION-tmp \
            --build-arg GEANT_VERSION=$GEANT_VERSION \
            --build-arg PARALLEL=$PARALLEL \
            --build-arg INSTALL_DATA=$INSTALL_DATA .

docker-squash $(docker images $DOCKER_IMAGE:$GEANT_VERSION-tmp -q) -t $DOCKER_IMAGE:$GEANT_VERSION
docker rmi $DOCKER_IMAGE:$GEANT_VERSION-tmp 