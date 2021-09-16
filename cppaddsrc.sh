#!/bin/bash

LOCATION=${1}
NAME=${2}
PROJECT=${3:-"$( basename $PWD )"}

sed "s/%project/${PROJECT}/g" ${LOCATION}/templates/base/src.cpp  | sed "s/%name/${NAME}/g" > "${NAME}.cpp"
echo "cpp source file generated"

sed "s/%project/${PROJECT}/g" ${LOCATION}/templates/base/src.h  | sed "s/%name/${NAME}/g" > "${NAME}.h"
echo "header source file generated"