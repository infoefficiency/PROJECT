#include "util.hpp"

void error_handling(char* str);
int main(){

    string buf;
    cout<<"Input : ";
    getline(cin, buf);

    // file output stream
    ofstream fout;
    fout.open("data_to_MATLAB.txt");
    fout << buf << endl;   
    fout.close();

    // wait until the "data_to_cpp.txt" file will be generated.
    while(1){
        if(access("data_to_cpp.txt", F_OK) != -1){
            break;
        }
    }

    // file input stream;
    string rst, tmp;
    ifstream fin;

    fin.open("data_to_cpp.txt");
   
    // wait until the MATLAB write what MATLAB calculate.
    while(1){
        fin.seekg(0, fin.end);
        int len = fin.tellg();
        fin.seekg(0, fin.beg);

        if(len != 0){
            break;
        }
    }

    if(fin.is_open()){        
        while(!fin.eof()){
            fin >> tmp;
            rst += tmp + " ";
        }
        fin.close();
    }
    else{
        cerr<<"Error"<<endl;
    }
    if( remove("data_to_cpp.txt") == -1){
        cerr<<"remove() error"<<endl;
    }

    cout<<rst<<endl;

    return 0;
}

void error_handling(char* str){
    cerr<<str<<endl;
    exit(1);
}