#!/bin/bash

NAME=${1}
PROJECT=${2:-"$( basename $PWD )"}
LOCATION=$( dirname ${BASH_SOURCE[0]})

sed "s/%project/${PROJECT}/g" ${LOCATION}/templates/base/src.cpp  | sed "s/%name/${NAME}/g" > "${NAME}.cpp"
echo "cpp source file generated"

sed "s/%project/${PROJECT}/g" ${LOCATION}/templates/base/src.h  | sed "s/%name/${NAME}/g" > "${NAME}.h"
echo "header source file generated"