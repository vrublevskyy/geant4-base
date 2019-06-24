# geant4-base

Geant4 base docker image. This dockerfile builds geant4 images to simplify development and simulation deploy, allowing to scale simulations over large number of clusters

## Requirements

 * Install docker: https://docs.docker.com/install/

## How to build docker image

### Linux build script

Show help:

```
./build-geant4.sh -h
```

Build image:

```
./build-geant4.sh -i dockerid/repository-name -v 10.5
```

Example:

```
./build-geant4.sh -i test/geant4-base -v 10.05
```

### Manually build image (All systems with docker)

```
docker build -t test/geant4-base \
            --build-arg GEANT_VERSION=10.05 \
            --build-arg PARALLEL=1 \
            --build-arg INSTALL_DATA=ON .
```
