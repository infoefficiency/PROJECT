#ifndef UTIL
#define UTIL

#include <iostream>
#include <string>

using namespace std;

void error_handling(const string& str){
    cerr<<str<<endl;
    exit(1);
}   

#endif
