#!/bin/bash

function addtesting()
{
    local NAME=${1}
    local OUTPUT=${2}

    mkdir -p "${OUTPUT}/test"
    sed "s/%project/${NAME}/g" ${LOCATION}/templates/base/test.cpp  > "${OUTPUT}/test/test.cpp"
    echo "testing added"
}

function addsrc()
{
    local NAME=${1}
    local PROJECT=${2:-"$( basename $PWD )"}

    sed "s/%project/${PROJECT}/g" ${LOCATION}/templates/base/src.cpp  | sed "s/%name/${NAME}/g" > "${NAME}.cpp"
    echo "cpp source file generated"

    sed "s/%project/${PROJECT}/g" ${LOCATION}/templates/base/src.h  | sed "s/%name/${NAME}/g" > "${NAME}.h"
    echo "header source file generated"
}

function module () {
    local NAME="${1}"
    local TYPE=${2:-"exec"}
    local OUTPUT="${3:-${NAME}}"

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
        printf "${MAKE}" ${NAME} > "${OUTPUT}/makefile"
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
        cd $NAME
        addsrc "Src"
        cd ..
        addtesting ${NAME} ${OUTPUT}

        cp "${LOCATION}/templates/base/launchLib.json" "${OUTPUT}/.vscode/launch.json"
        echo "debug vscode launch generated"
    fi
}

#operation starts here

OPERATION=${1}
shift

#find location of modules
if [ -d "${HOME}/.local/share/CppModule" ]; then
    LOCATION="${HOME}/.local/share/CppModule"
    else
    if [ -d "/usr/local/share/CppModule" ]; then
        LOCATION="/usr/local/share/CppModule"
    else
        echo "error, data not found in ${HOME}/.local/share/CppModule or /usr/local/share/CppModule"
        exit 1
    fi
fi

case "${OPERATION}" in
    "--version")
    echo "cppmodules"
    echo "v1.0.0"
    echo "data installed at ${LOCATION}"
    exit 0
    ;;
    "module")
        module $1 $2 $3
    ;;
    "add")
        addsrc $1 $2
    ;;
    "test")
        addtesting $1 $2
    ;;
    *)
        echo "error, invalid first argument"
        echo "possible first arguments: module, add, test"
    ;;
esac

echo "done"
exit 0