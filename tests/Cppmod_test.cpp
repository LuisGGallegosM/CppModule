
#include"Tester/Tester.hpp"
#include"../src/Cppmod_module.hpp"

void testCppmod_module(Tester* t)
{
    const std::vector<std::string> args={ "exe" , "BasicExe", "./tests/build/output" };
    Cppmod_module(args);
}

int main()
{
    Tester test("Testing for cppmod");

    test.test(testCppmod_module,"test cppmod::module");

}