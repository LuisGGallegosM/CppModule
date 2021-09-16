#!/bin/bash

OPERATION=${1}
LOCATION="/usr/local/bin/CppModule"

if [ ${1} == "--version" ]; then
    echo "cppmodules"
    echo "v1.0.0"
    exit 0
fi

shift

case "${OPERATION}" in
    "module")
        ${LOCATION}/cppmodule.sh ${LOCATION} ${1} ${2} ${3}
    ;;
    "add")
        ${LOCATION}/cppaddsrc.sh ${LOCATION} ${1} ${2}
    ;;
    "test")
        ${LOCATION}/addtesting.sh ${LOCATION} ${1} ${2} ${3}
    ;;
    *)
        echo "error"
    ;;
esac
