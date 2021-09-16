#!/bin/bash

LOCATION=${1}
TESTER=${2}
NAME=${3}
OUTPUT=${4}

if [ -d "${TESTER}" ]; then
    mkdir -p "${OUTPUT}/test"
    sed "s/%project/${NAME}/g" ${LOCATION}/templates/base/test.cpp | sed "s|%lib|${TESTER}|g" > "${OUTPUT}/test/test.cpp"
    echo "testing added"
else
    echo "Tester library does not exist at ${TESTER}"
fi