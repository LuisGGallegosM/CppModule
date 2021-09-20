
INSTALL_PATH:=${HOME}/.local

install:
	cp cppmod.sh ${INSTALL_PATH}/bin/cppmod
	mkdir -p ${INSTALL_PATH}/share/CppModule
	cp -r templates ${INSTALL_PATH}/share/CppModule/templates

uninstall:
	rm -f ${INSTALL_PATH}/bin/cppmod
	rm -fr ${INSTALL_PATH}/share/CppModule

testing:
	./cpptest.sh