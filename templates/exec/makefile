
#EXECUTABLE MODULE
GCC:=g++
FLAGS:=-g
SOURCES:=$(shell find . -name  "*.cpp" ! -path "./test/*" )
HEADERS:=$(shell find . -name  "*.h" ! -path "./test/*" )
INC:=
LIBS:=
OUTPUT:=%s

all : ${OUTPUT}

${OUTPUT} : ${SOURCES} ${HEADERS}
	${GCC} ${SOURCES} ${INC} ${LIBS} ${FLAGS} -o ${OUTPUT}
	objdump -drCat -Mintel --no-show-raw-insn ${OUTPUT} > ${OUTPUT}.s
	rm -f *.o

clear :
	rm -f ${OUTPUT} *.o *.s