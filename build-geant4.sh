#!/bin/bash

while getopts ":hs:v:i:d:p:f:" option
do

	case "${option}" in
        h) echo '
            Options:

                -v GEANT_VERSION.
                -i Docker image. Ex: test/geant4:10.06.p01
                -d Install data [ON|OFF]. Default ON
                -f Dockerfile. Default: Dockerfile
                ' && exit;;
		v) GEANT_VERSION=${OPTARG};;
		i) DOCKER_IMAGE=${OPTARG};;
        p) PARALLEL=${OPTARG};;
        f) DOCKERFILE=${OPTARG};;
	esac
done

#Install data if not specified
if [ -z $DOCKER_IMAGE ]; then

    echo "DOCKER_IMAGE param is required" 
    exit 1
fi

#Set latest version if not defined
if [ -z $GEANT_VERSION ]; then

    GEANT_VERSION=10.06.p01
fi

#Install data if not specified
if [ -z $INSTALL_DATA ]; then

    INSTALL_DATA=ON
fi

if [ -z $DOCKERFILE ]; then

    DOCKERFILE=Dockerfile
fi

#GET number of CPU cores
if [ -z $PARALLEL ]; then

    PARALLEL=$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l) 
fi

docker build -t $DOCKER_IMAGE \
            --build-arg GEANT_VERSION=$GEANT_VERSION \
            --build-arg PARALLEL=$PARALLEL \
            --build-arg INSTALL_DATA=$INSTALL_DATA -f $DOCKERFILE .
