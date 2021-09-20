
#LIBRARY MODULE
GCC:=g++
FLAGS:=-g
SOURCES:=$(shell find . -name  "*.cpp" ! -path "./test/*" )
HEADERS:=$(shell find . -name  "*.h" ! -path "./test/*" )
INC:=-I $(shell $(ROOTSYS)/bin/root-config --cflags)
LIBS:=$(shell $(ROOTSYS)/bin/root-config --ldflags --glibs) -lRooFit -lRooFitCore -lMinuit -lTester
OUTPUT:=lib%s

all : ${OUTPUT}.a testing
	./testing

${OUTPUT}.a : ${SOURCES} ${HEADERS}
	${GCC} ${SOURCES} ${INC} ${LIBS} ${FLAGS} -c
	ar rcs ${OUTPUT}.a *.o
	objdump -drCat -Mintel --no-show-raw-insn ${OUTPUT}.a > ${OUTPUT}.s
	rm -f *.o

clear :
	rm -f ${OUTPUT}.a *.o *.s
	rm -f testing

testing : test/test.cpp ${OUTPUT}.a
	g++ test/test.cpp ${OUTPUT}.a ${INC} ${LIBS} ${FLAGS} -o testing