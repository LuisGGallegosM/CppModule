#include<iostream>
#include<sstream>
#include<fstream>
#include"%lib/Tester.h"
#include"%project.h"

using std::cout;
using std::string;

void testFirst(Tester* t)
{
    t->assert_true(false,"test initialized");
}

int main()
{
    %project::dumpFunction();
    Tester t("test %project");
    t.test(testFirst,"first");
    return t.returnValue();
}