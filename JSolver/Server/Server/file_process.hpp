#ifndef F_P
#define F_P

#include <unistd.h>
#include <fstream>
#include <string>

using namespace std;

// 1)make txt file in order to send the expression.
void make_txt(const string& buf){
    ofstream fout;
    fout.open("./Server/data_to_MATLAB.txt");
    fout << buf << endl;
    fout.close();
}

// 2)get the result from MATLAB and save it in the string. send the result.
string getRst_sendRst(int client_sock){
    //wait until the "data_to_cpp.txt" file will be generated.
    while(1){
        if( access("./Server/data_to_cpp.txt", F_OK) != -1){
            break;
        }
    }
    //file input stream
    string ret, tmp;
    ifstream fin;

    fin.open("./Server/data_to_cpp.txt");

    //wait until the MATLAB write what MATLAB calculate.
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
            ret += tmp + " ";
        }

        fin.close();
    }

    if( write(client_sock, ret.c_str(), ret.size()) == -1){
        cerr << "write() error" <<endl;
        exit(1);
    }
    return ret;
}

// 3) send the grap
void send_graph(int client_sock, const string path){
    ifstream ferr;
    ferr.open(path + "/err.txt");
    char ck[2];
    ferr.read(ck, 2);

    char buf[1000000];
    ifstream fin;
    if(ck[0] == '1'){
        sleep(1); //wait the completion of graph process
        fin.open(path + "/graph.jpg", ios::binary);        
    }
    else{
        fin.open(path + "/error.jpg", ios::binary);
    }

    fin.seekg(0, ios::end);
    int sz = fin.tellg();
    fin.seekg(0, ios::beg);
    fin.read(buf, sz);
    write(client_sock, buf, sz);
}

void remove_file(const string& s){
    if(remove(s.c_str()) == -1){
        cerr << "remove() error"<<endl;
        exit(1);
    }
}

#endif
