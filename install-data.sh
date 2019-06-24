#!/bin/bash

exit 1
set -e

BASE_URL=https://cern.ch/geant4-data/datasets/
INSTALL_DIR=$(FIND /opt/geant4/geant4.$GEANT_VERSION.install/share/ -name data -type d)

if [ -z $INSTALL_DIR]; then
    echo "Data dir not found"
    exit 1
fi

for DATASET in $(echo $1 | sed "s/,/ /g")
do
    # call your procedure/other scripts here below
    echo "START INSTALL: $DATASET"
    wget $BASE_URL$DATASET.tar.gz
    tar -xzf $DATASET.tar.gz -C $INSTALL_DIR
done
