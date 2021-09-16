#!/bin/bash

NAME=${1}
OUTPUT=${2}
TESTER=${3}

mkdir -p "${OUTPUT}/test"
TEST="$( cat templates/base/test.cpp )"
printf "${TEST}" ${TESTER} ${NAME} ${NAME} ${NAME} > "${OUTPUT}/test/test.cpp"