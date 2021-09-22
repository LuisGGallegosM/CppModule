#EXECUTABLE MODULE
GCC:=g++
FLAGS:=-Wall -Wextra -Wpedantic -g -O1 -std=c++17
SOURCES:=$(shell find ./src -name  "*.cpp" )
HEADERS:=$(shell find ./src -name  "*.h" )
OBJS:=$(patsubst ./src/%.cpp, build/%.o, ${SOURCES} )
INC:=
LIBS:=-lTester
INSTALL_DIR:=${HOME}/.local
NAME:=cppmod
OUTPUT:=${NAME}

all : build/${OUTPUT} testing
	@echo "building all"

build/%.o: src/%.cpp ${HEADER}
	@echo "updating source file $@"
	${GCC} $< ${LIBS} ${INC} ${FLAGS} -c -o $@

build/${OUTPUT} : ${OBJS} ${HEADERS}
	@echo "building project $@"
	${GCC} ${OBJS} ${LIBS} ${INC} ${FLAGS} -o build/${OUTPUT}
	objdump -drCat -Mintel --no-show-raw-insn build/${OUTPUT} > build/${OUTPUT}.s

clear :
	rm -fr build/*
	rm -fr tests/build/*

tests/build/test: build/${OUTPUT}
	@echo "building tests"
	rm -fr ./tests/build/output/*
	${GCC} $(shell find ./tests -name "*.cpp" ! -path "./tests/build/*" ) src/Cppmod_module.cpp ${LIBS} ${INC} ${FLAGS} -o tests/build/test

testing: tests/build/test
	@echo "running tests"
	rm -fr ./tests/build/output/*
	./tests/build/test
	${MAKE} -C tests/build/output