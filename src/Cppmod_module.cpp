
#include"Cppmod_module.hpp"
#include<filesystem>
#include<fstream>

namespace fs = std::filesystem;

enum class Type { Error, Exe, Lib };

const char testsDir[]="tests";
const char flags[]="-g";

int generateExec(const std::string& name, fs::path& outputPath, Type type);
void generateMakefile(const std::string& name, fs::path& outputPath, Type type);
void generateCppFile(const std::string& name, fs::path& outputPath, bool isMain, const std::string& code, const std::vector<std::string>& includes);
void generateHppFile(const std::string& name, fs::path& outputPath, const std::vector<std::string>& includes,const std::vector<std::string>& defs);

Type getType(const std::string& type);
bool isExec(Type t);

std::string toLower( const std::string& str);
std::string toUpper( const std::string& str);

int Cppmod_module(const std::vector<std::string>& args)
{
    Type type=getType(args[0]);
    const std::string& name= args[1];
    fs::path outputPath(args[2]);

    if (type==Type::Error)
    {
        std::cout << "ERROR: type of project does not exist\n"; 
        return 1;
    }

    if (fs::exists(outputPath))
    {
        std::cout << "project directory already exist already exists\n";
    }
    else
    {
        fs::create_directory(outputPath);
        std::cout << outputPath.string() << " project directory created\n";
    }

    if (type==Type::Exe)
        return generateExec(name,outputPath,type);
    return 0;
}

Type getType(const std::string& type)
{
    if (type=="exe") 
        return Type::Exe;
    else if (type=="lib")
        return Type::Lib;
    return Type::Error;
}

bool isExec(Type t)
{
    return t==Type::Exe;
}

int generateExec(const std::string& name, fs::path& outputPath, Type type)
{
    fs::path srcPath = outputPath / "src";
    fs::path testsPath = outputPath / testsDir;
    fs::path libsPath = outputPath / "libs";
    std::cout << "generating module '" << name << "' of type: exec\n";

    fs::create_directory(srcPath);
    fs::create_directory(testsPath);
    fs::create_directory(libsPath);
    fs::create_directory(libsPath / "include");
    fs::create_directory(libsPath / "bin");

    std::vector<std::string> empty;
    std::vector<std::string> incName={name};
    std::vector<std::string> inc={"src"};
    std::vector<std::string> def={"int dumbFunction();"};
    std::vector<std::string> inc2={ "../src/"+name, "Tester/Tester" };

    generateMakefile(name, outputPath,type);
    generateHppFile(name,srcPath,inc,empty);
    generateCppFile(name,srcPath,true,"dumbFunction();",incName);

    generateHppFile("src",srcPath,empty,def);
    generateCppFile("src",srcPath,false,"std::cout << \" it works! \\n\";",incName);

    generateCppFile("test",testsPath,true,"Tester test(\"basic testing\");\n\tdumbFunction();",inc2);

    return 0;
}

void generateCppFile(const std::string& name, fs::path& outputPath, bool isMain, const std::string& code, const std::vector<std::string>& includes)
{
    const std::string filename=outputPath.string()+"/"+name;
    std::ofstream cppfile(filename+".cpp",std::ios_base::trunc);

    cppfile << "#include<iostream>\n\n";

    for(const auto& inc : includes)
    {
        cppfile << "#include\""<< inc << ".hpp\"\n";
    }

    if (isMain)
        cppfile << "int main(int argc, char **argv)\n{\n";
    else
        cppfile << "int dumbFunction()\n{\n";
    cppfile << '\t' << code << '\n';
        
    cppfile << "\treturn 0;\n}\n";

    std::cout << "source file generated in " << filename << "\n";
}

void generateHppFile(const std::string& name, fs::path& outputPath, const std::vector<std::string>& includes, const std::vector<std::string>& defs)
{
    const std::string upperName= toUpper(name);
    const std::string filename=outputPath.string()+"/"+name;
    std::ofstream hppfile(filename+".hpp",std::ios_base::trunc);

    hppfile << "#ifndef " << upperName << "\n";
    hppfile << "#define " << upperName << "\n\n\n";

    for(const auto& inc : includes)
    {
        hppfile << "#include\""<< inc << ".hpp\"\n";
    }

    hppfile << "\n\n";
    for (const auto& def : defs)
    {
        hppfile << def << "\n";
    }

    hppfile << "\n#endif\n";
    std::cout << "source file generated in " << filename << "\n";
}

void generateMakefile(const std::string& name, fs::path& outputPath, Type type)
{
    const std::string filename=outputPath.string()+"/makefile";
    std::ofstream makefile(filename,std::ios_base::trunc);

    const std::string nameLowercase = toLower(name);

    const bool isExecutable= isExec(type);
    //definitions
    if (isExecutable)
        makefile << "#EXECUTABLE MODULE\n";
    else
        makefile << "#LIBRARY MODULE\n";
    makefile << "GCC:=g++\nFLAGS:=" << flags <<'\n';

    makefile << "SOURCES:=$(shell find ./src -name \"*.c\" -or -name \"*.cpp\" )\n";
    makefile << "HEADERS:=$(shell find ./src -name \"*.h\" -or -name \"*.hpp\" )\n";
    makefile << "OBJS:=$(patsubst ./src/%.cpp, build/%.o, ${SOURCES} )\n";
    if (isExecutable)
    {
        makefile << "INC:=-Ilibs/include\n";
        makefile << "LIBS:=-Llibs/bin\n";
        makefile << "OUTPUT:=" << nameLowercase <<"\n\n";
    }
    else
    {
        makefile << "INC:=\n";
        makefile << "LIBS:=\n";
        makefile << "OUTPUT:=lib" << name <<".a\n\n";
    }

    makefile << "all : build/${OUTPUT} testing"<<"\n\n";
    makefile << "\t@echo \" >${OUTPUT}: building all\"\n";

    //build
    makefile << "build/%.o: src/%.cpp ${HEADER}\n";\
    makefile << "\t@echo \" >${OUTPUT}: updating source file $@\"\n";
    makefile << "\tmkdir -p build\n";
    makefile << "\t${GCC} $< ${LIBS} ${INC} ${FLAGS} -c -o $@\n\n";

    makefile << "build/${OUTPUT} : ${OBJS} ${HEADERS}\n";
    makefile << "\t@echo \" >${OUTPUT} :building project $@\"\n";

    if (isExecutable)
        makefile << "\t${GCC} ${OBJS} ${INC} ${LIBS} ${FLAGS} -o build/${OUTPUT}\n";
    else
        makefile << "\tar rcs build/${OUTPUT} build/*.o\n";
    makefile << "\tobjdump -drCat -Mintel --no-show-raw-insn build/${OUTPUT} > build/${OUTPUT}.s\n\n";

    //clear
    makefile << "clear: \n";
    makefile << "\trm -fr build/*\n";
    makefile << "\trm -fr tests/build/*\n\n";

    //test build
    makefile << "tests/build/test : ${TESTS} build/${OUTPUT}\n";
    makefile << "\t@echo \" >${OUTPUT}: building tests\"\n";
    makefile << "\trm -fr ./tests/build/output/*\n";
    makefile << "\tmkdir -p ./tests/build\n";
    if (isExecutable)
        makefile << "\t${GCC} $(shell find ./tests -name \"*.c\" -or -name \"*.cpp\" ) $(filter-out build/"<< name << ".o, ${OBJS} ) ${INC} ${LIBS} -lTester ${FLAGS} -o tests/build/test\n\n";
    else
        makefile << "\t${GCC} $(shell find ./tests -name \"*.c\" -or -name \"*.cpp\" ) build/${OUTPUT} ${INC} ${LIBS} -lTester ${FLAGS} -o tests/build/test\n\n";
    
    //test run
    makefile << "testing : tests/build/test\n";
    makefile << "\t@echo \" >${OUTPUT} : running tests\"\n";
    makefile << "\trm -fr ./tests/build/output/*\n";
    makefile << "\t./tests/build/test\n\n";

    //install
    makefile << "install: build/${OUTPUT}\n";
	makefile << "\tcp build/${OUTPUT} ${INSTALL_DIR}/bin/${OUTPUT}\n";
	makefile << "\tmkdir -p ${INSTALL_DIR}/include/${NAME}\n";
    makefile << "\tcp ${NAME}.h ${INSTALL_DIR}/include/${NAME}/${NAME}.h\n\n";

    //uninstall
    makefile << "uninstall: \n";
    makefile << "\trm -f ${INSTALL_DIR}/lib/${OUTPUT}.a\n";
    makefile << "\trm -rf ${INSTALL_DIR}/include/${NAME}\n\n";
	
    std::cout << "makefile generated in " << filename << ".\n";
}

std::string toLower( const std::string& str)
{
    std::string output=str;
    for( auto& c : output)
    {
        c= std::tolower(c);
    }
    return output;
}

std::string toUpper( const std::string& str)
{
    std::string output=str;
    for( auto& c : output)
    {
        c= std::toupper(c);
    }
    return output;
}