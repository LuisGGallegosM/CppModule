#!/bin/bash

NAME=${1}
OUTPUT=${2:-$( basename $PWD )}
LOCATION=$( dirname ${BASH_SOURCE[0]})

SRC="$( cat ${LOCATION}/templates/base/src.cpp )"
printf "$SRC" ${NAME} > "${OUTPUT}/${NAME}.cpp"
echo "cpp source file generated"

SRC="$( cat ${LOCATION}/templates/base/src.h )"
printf "$SRC" ${NAME} > "${OUTPUT}/${NAME}.h"
echo "header source file generated"