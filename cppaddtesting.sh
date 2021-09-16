#!/bin/bash

LOCATION=${1}
NAME=${2}
OUTPUT=${3}
TESTER=${4}


if [ -d "${TESTER}" ]; then
    mkdir -p "${OUTPUT}/test"
    sed "s/%project/${NAME}/g" ${LOCATION}/templates/base/test.cpp | sed "s|%lib|${TESTER}|g" > "${OUTPUT}/test/test.cpp"
    echo "testing added"
else
    echo "Tester library does not exist at ${TESTER}"
fi