
#LIBRARY MODULE
GCC:=g++
FLAGS:=-g
SOURCES:=$(shell find . -name  "*.cpp" ! -path "./test/*" )
HEADERS:=$(shell find . -name  "*.h" ! -path "./test/*" )
INC:=-I $(shell $(ROOTSYS)/bin/root-config --cflags)
LIBS:=$(shell $(ROOTSYS)/bin/root-config --ldflags --glibs) -lRooFit -lRooFitCore -lMinuit
OUTPUT:=%s

all : ${OUTPUT}

${OUTPUT} : ${SOURCES} ${HEADERS}
	${GCC} ${SOURCES} ${INC} ${FLAGS} -o ${OUTPUT}
	objdump -drCat -Mintel --no-show-raw-insn ${OUTPUT} > ${OUTPUT}.s
	rm -f *.o

clear :
	rm -f ${OUTPUT} *.o *.s