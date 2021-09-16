#!/bin/bash

NAME="${1}"
TYPE=${2:-"base"}
OUTPUT="${3:-${1}}"
TESTER="/lib/Tester"
LOCATION=$( dirname ${BASH_SOURCE[0]})

mkdir "${NAME}"
echo "generating module :'${NAME}' of type '${TYPE}' at ${OUTPUT}"

if [ -f "${OUTPUT}/${NAME}.h" ]; then
    echo "File \"${OUTPUT}/${NAME}.h\" already exists"
    exit 1
fi

MAKE="$( cat ${LOCATION}/templates/${TYPE}/makefile )"
printf "${MAKE}" ${NAME} ${TESTER} > "${OUTPUT}/makefile"
echo "makefile generated"

HEADER="$( cat ${LOCATION}/templates/${TYPE}/main.h)"
NAMEUPPER="$( echo $NAME | tr [:lower:] [:upper:] )"
printf "${HEADER}" "${NAMEUPPER}" "${NAMEUPPER}" > "${OUTPUT}/${NAME}.h"
echo "main header generated"

GIT="$( cat ${LOCATION}/templates/base/.gitignore)"
printf "${GIT}" ${NAME} ${NAME} > "${OUTPUT}/.gitignore"
echo "gitignore generated"

if [ ${TYPE} = "exec" ] | [ ${TYPE} = "root-exec" ]
then
    MAIN=$( cat ${LOCATION}/templates/${TYPE}/main.cpp)
    printf "${MAIN}" ${NAME} ${NAME} > "${OUTPUT}/${NAME}.cpp"
    echo "main cpp source file generated"
else
    ${LOCATION}/cppaddtesting.sh ${NAME} ${OUTPUT} ${TESTER}

    SRC="$( cat ${LOCATION}/templates/base/src.cpp )"
    printf "$SRC" ${NAME} > "${OUTPUT}/src.cpp"
    echo "cpp source file generated"

    SRC="$( cat ${LOCATION}/templates/base/src.h )"
    printf "$SRC" ${NAME} > "${OUTPUT}/src.h"
    echo "header source file generated"
fi

echo "done"