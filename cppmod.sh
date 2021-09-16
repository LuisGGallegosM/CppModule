#!/bin/bash

OPERATION=${1}
LOCATION=$( dirname ${BASH_SOURCE[0]})

shift

case "${OPERATION}" in
    "module")
        ${LOCATION}/cppmodule.sh ${1} ${2} ${3}
    ;;
    "add")
        ${LOCATION}/cppaddsrc.sh ${1} ${2}
    ;;
    "test")
        ${LOCATION}/addtesting.sh ${1} ${2} ${3}
    ;;
    *)
        echo "error"
    ;;
esac
