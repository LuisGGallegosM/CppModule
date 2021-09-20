#!/bin/bash

rm -rf ./test/*
cd test

../cppmod.sh module Lib lib
cd Lib
make
cd ..

../cppmod.sh module Exec "exec"
cd Exec
make
./exec
cd ..

../cppmod.sh module RootLib "root-lib"
cd RootLib
make
cd ..

../cppmod.sh module RootExec "root-exec"
cd RootExec
make
./rootexec
cd ..