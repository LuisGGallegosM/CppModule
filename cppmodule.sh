#!/bin/bash

NAME="${1}"
OUTPUT="${2}"
TYPE=${3:-"base"}
TESTER="../../Tester"

if [ -f "${OUTPUT}/${NAME}.h" ]; then
    echo "File \"${OUTPUT}/${NAME}.h\" already exists"
    exit 1
fi

MAKE="$( cat templates/${TYPE}/makefile )"
printf "${MAKE}" ${NAME} ${TESTER} > "${OUTPUT}/makefile"
HEADER="$( cat templates/${TYPE}/main.h)"
NAMEUPPER="$( echo $NAME | tr [:lower:] [:upper:] )"
printf "${HEADER}" "${NAMEUPPER}" "${NAMEUPPER}" > "${OUTPUT}/${NAME}.h"

GIT="$( cat templates/base/.gitignore)"
printf "${GIT}" ${NAME} ${NAME} > "${OUTPUT}/.gitignore"

if [ ${TYPE} = "exec" ] | [ ${TYPE} = "root-exec" ]
then
    MAIN=$( cat templates/${TYPE}/main.cpp)
    printf "${MAIN}" ${NAME} ${NAME} > "${OUTPUT}/${NAME}.cpp"
else
    ./cppaddtesting.sh ${NAME} ${OUTPUT} ${TESTER}

    SRC="$( cat templates/base/src.cpp )"
    printf "$SRC" ${NAME} > "${OUTPUT}/src.cpp"

    SRC="$( cat templates/base/src.h )"
    printf "$SRC" ${NAME} > "${OUTPUT}/src.h"
fi