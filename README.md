# geant4-base

Geant4 base docker image. This dockerfile builds geant4 images to simplify development and simulation deploy, allowing to scale simulations over large number of clusters

You can download geant4 versions with:

```
docker pull ivanvr0/geant4-base:x.y.patch
```

10.06.p01:

```
docker pull ivanvr0/geant4-base:10.06.p01
```

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
./build-geant4.sh -i dockerid/repository-name:10.5 -v 10.5
```

Example:

```
./build-geant4.sh -i test/geant4-base:10.05 -v 10.05
```

### Manually build image (All systems with docker)

```
docker build -t test/geant4-base:10.05 \
            --build-arg GEANT_VERSION=10.05 \
            --build-arg PARALLEL=1 \
            --build-arg INSTALL_DATA=ON .
```
