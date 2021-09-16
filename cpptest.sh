#!/bin/bash

rm -r ./test/*
./cppmodule.sh Base ./test base
cd test
make