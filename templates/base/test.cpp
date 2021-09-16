#include<iostream>
#include<sstream>
#include<fstream>
#include"../%s/Tester.h"
#include"../%s.h"

using std::cout;
using std::string;

void testFirst(Tester* t)
{
    t->assert_true(false,"test initialized");
}

int main()
{
    %s::dumpFunction();
    Tester t("test %s");
    t.test(testFirst,"first");
    return t.returnValue();
}