
#LIBRARY MODULE
GCC:=g++
FLAGS:=-g
SOURCES:=$(shell find . -name  "*.cpp" ! -path "./test/*" )
HEADERS:=$(shell find . -name  "*.h" ! -path "./test/*" )
INC:=
LIBS:=-lTester
INSTALL_DIR:=${HOME}/.local
NAME:=%s
OUTPUT:=lib${NAME}

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

install: ${OUTPUT}.a
	cp ${OUTPUT}.a ${INSTALL_DIR}/lib/${OUTPUT}.a
	mkdir -p ${INSTALL_DIR}/include/${NAME}
	cp ${NAME}.h ${INSTALL_DIR}/include/${NAME}/${NAME}.h

uninstall:
	rm -f ${INSTALL_DIR}/lib/${OUTPUT}.a
	rm -rf ${INSTALL_DIR}/include/${NAME}