#include<iostream>
#include<sstream>
#include<fstream>
#include"Tester/Tester.h"
#include"../%project.h"

using std::cout;
using std::string;

void testFirst(Tester* t)
{
    t->assert_true(true,"test initialized");
}

int main()
{
    Tester t("test %project");
    t.test(testFirst,"first");
    return t.returnValue();
}