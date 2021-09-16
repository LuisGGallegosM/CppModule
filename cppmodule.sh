#!/bin/bash

LOCATION=${1}
TESTER=${2}
NAME="${3}"
TYPE=${4:-"base"}
OUTPUT="${5:-${3}}"

mkdir "${NAME}"
echo "generating module :'${NAME}' of type '${TYPE}' at ${OUTPUT}"

if [ -f "${OUTPUT}/${NAME}.h" ]; then
    echo "File \"${OUTPUT}/${NAME}.h\" already exists"
    exit 1
fi

#generate makefile
NAMELOWER="$( echo $NAME | tr [:upper:] [:lower:] )"
MAKE="$( cat ${LOCATION}/templates/${TYPE}/makefile )"
if [ ${TYPE} == "exec" ] || [ ${TYPE} == "root-exec" ]; then
    printf "${MAKE}" ${NAMELOWER} > "${OUTPUT}/makefile"
else
    printf "${MAKE}" ${NAMELOWER} ${TESTER} > "${OUTPUT}/makefile"
fi
echo "makefile generated"

#generate header
HEADER="$( cat ${LOCATION}/templates/${TYPE}/main.h)"
NAMEUPPER="$( echo $NAME | tr [:lower:] [:upper:] )"
printf "${HEADER}" "${NAMEUPPER}" "${NAMEUPPER}" > "${OUTPUT}/${NAME}.h"
echo "main header generated"

GIT="$( cat ${LOCATION}/templates/base/.gitignore)"
printf "${GIT}" ${NAMELOWER} ${NAMELOWER} > "${OUTPUT}/.gitignore"
echo "gitignore generated"

mkdir "${OUTPUT}/.vscode"

if [ ${TYPE} == "exec" ] || [ ${TYPE} == "root-exec" ]
then
    MAIN=$( cat ${LOCATION}/templates/${TYPE}/main.cpp)
    printf "${MAIN}" ${NAME} > "${OUTPUT}/${NAME}.cpp"
    echo "main cpp source file generated"

    printf "$(cat ${LOCATION}/templates/base/launchExec.json)" ${NAMELOWER} > "${OUTPUT}/.vscode/launch.json"
    echo "debug vscode launch generated"
else
    ${LOCATION}/cppaddtesting.sh ${LOCATION} ${TESTER} ${NAME} ${OUTPUT}

    cp "${LOCATION}/templates/base/launchLib.json" "${OUTPUT}/.vscode/launch.json"
    echo "debug vscode launch generated"
fi



echo "done"