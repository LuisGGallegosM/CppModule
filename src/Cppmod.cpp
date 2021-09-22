
#include"Cppmod.hpp"
#include<iostream>
#include<vector>

int main(int argc, char **argv)
{
    if (argc<2)
    {
        std::cout << "cppmodules\n";
        std::cout << "version 1.0.0\n";
        return 0;
    }
    const std::string subcmd=argv[1];
    std::vector<std::string> args;
    for(int i=2; i<argc;i++) args.push_back(argv[i]);

    if(subcmd=="module")
        return Cppmod_module(args);
    else
        {
            std::cout << "ERROR: subcommand " << subcmd <<" not found\n";
        }

    return 0;
}