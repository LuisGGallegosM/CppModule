#!/bin/bash

NAME=${1}
OUTPUT=${2}
TESTER=${3}
LOCATION=$( dirname ${BASH_SOURCE[0]})

if [ -d "${TESTER}" ]; then
    mkdir -p "${OUTPUT}/test"
    sed "s/%project/${NAME}/g" ${LOCATION}/templates/base/test.cpp | sed "s|%lib|${TESTER}|g" > "${OUTPUT}/test/test.cpp"
    echo "testing added"
else
    echo "Tester library does not exist at ${TESTER}"
fi