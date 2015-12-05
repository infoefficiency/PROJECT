//C++
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <set>
#include <numeric>
#include <algorithm>

//C && POSIX
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

using namespace std;

//Matrix 선언
typedef vector<vector<double> > Matrix;
//h by m Matrix를 선언하기 위한 함수
Matrix zeros(int h, int w = -1);
//문자열이 주어졌을 때, delimiter를 이용하여 tokenize하는 함수
vector<string> tokenize(string, string del = " ");
//숫자들로 이루어진 문자열을 delimiter를 기준으로 double형으로 tokenize하는 함수
vector<double> tokToNum(string s, string del = " ");

int main(int argc, char* argv[]){	
	//samplebase를 접근한다.
	//읽어 들인 문자열을 tokenize한다.	
	string path = argv[1];
    ifstream fin;
    fin.open(path + "Spambase.txt");
	string str;
    getline(fin, str);
    vector<string> words = tokenize(str, "\t");
            
    //samplebase를 접근한 뒤 spam과 ham을 나누어서
    //매트릭스 형태로 저장한다.
    Matrix spam_mat, ham_mat;
    while(!fin.eof()){
        getline(fin, str);
        vector<double> v = tokToNum(str, "\t");       
        if(v.empty()){
			break;
		} 
        if(v.back() == 1){
			spam_mat.push_back(v);
		}
		else if(v.back() == 0){
			ham_mat.push_back(v);
		}        
    }        
    fin.close();
    
    
    /* 라플라시안 스무딩
     * ---  특정 단어가 한번도 출현하지 않았다는 경우 계산이 0으로 처리되지 않게 하기 위하여
     * 임의의(여기서는 마지막 값) 값을 1로 취해준다. */
    //spam_mat에 대하여 처리    
    for(int i = 0; i < spam_mat[0].size(); ++i){
		bool not_all_zero = 0;
		for(int j = 0; j < spam_mat.size(); ++j){
			if(spam_mat[j][i] != 0){
				not_all_zero = 1;
				break;
			}
		}
		
		if(not_all_zero){
			spam_mat[spam_mat.size()-1][i] = 1;
		}
	}
	
	//ham_mat에 대하여 처리
    for(int i = 0; i < ham_mat[0].size(); ++i){
		bool not_all_zero = 0;
		for(int j = 0; j < ham_mat.size(); ++j){
			if(ham_mat[j][i] != 0){
				not_all_zero = 1;
				break;
			}
		}		
		if(not_all_zero){
			ham_mat[ham_mat.size()-1][i] = 1;
		}
	}	
	
	
    //5-fold cross-validation을 위하여 spam과 ham의 5등분할 크기의 경계값을 미리 저장한다.
    int spam_part_sz[6];
    spam_part_sz[0] = 0;
    for(int i = 1; i <= 5; ++i){
		spam_part_sz[i] = spam_mat.size()*i/5;		
	}
	
	int ham_part_sz[6];
	ham_part_sz[0] = 0;
	for(int i = 1; i <= 5; ++i){
		ham_part_sz[i] = ham_mat.size()*i/5;		
	}
        
    // spam에 대하여 5등분 나눈 것의 확률을 저장한다.
    // 이 때 전체에 대한 확률도 같이 구한다.
    vector<double> spam_part_prob[5];
    vector<double> spam_total_prob(words.size());
    for(int i = 0; i < 5; ++i){
		spam_part_prob[i] = vector<double>(spam_mat[0].size());
		int lb = spam_part_sz[i];	//lower_bound
		int ub = spam_part_sz[i+1];	//upper_bound		
				
		for(int j = 0; j < spam_mat[0].size(); ++j){
			for(int k = lb; k < ub; ++k){
				if(spam_mat[k][j] == 1){
					spam_part_prob[i][j] += 1;
				}
			}
			spam_total_prob[j] += spam_part_prob[i][j];
			spam_part_prob[i][j] /= (ub-lb);
		}
	}
			
	//ham에 대하여 5등분 나눈 것의 확률을 저장한다.
	vector<double> ham_part_prob[5];
	vector<double> ham_total_prob(ham_mat[0].size());
    for(int i = 0; i < 5; ++i){
		ham_part_prob[i] = vector<double>(ham_mat[0].size());
		int lb = ham_part_sz[i];	//lower_bound
		int ub = ham_part_sz[i+1];	//upper_bound		
				
		for(int j = 0; j < ham_mat[0].size(); ++j){
			for(int k = lb; k < ub; ++k){
				if(ham_mat[k][j] == 1){
					ham_part_prob[i][j] += 1;
				}
			}
			ham_total_prob[j] += ham_part_prob[i][j];
			ham_part_prob[i][j] /= (ub-lb);
		}
	}
	
			
	//Directory를 탐색
	DIR *od1, *od2;
	struct dirent *dir1, *dir2;	
	
	//spam폴더 안에 있는 텍스트 문서를 읽은 뒤 저장한다.	
	char dirpath[100];
	strcat(dirpath, argv[1]);
	strcat(dirpath, "spam");
	if( (od1 = opendir(dirpath) ) == NULL){
		perror("Fail to open spam directory");
		exit(1);
	}
	vector<string> spam_vec;
	while( (dir1 = readdir(od1) ) != NULL){				
		string contents;
		ifstream spamfile;
		string path = argv[1];
		path += "spam/";
		path += dir1->d_name;		
		if(strcmp(dir1->d_name, ".") == 0 || strcmp(dir1->d_name, "..") == 0){		
			continue;
		}
				
		spamfile.open(path);				
		while(!spamfile.eof()){						
			getline(spamfile, str);						
			contents +=  str;			
		}		
		spam_vec.push_back(contents);
		spamfile.close();
	}	
	closedir(od1);
	
	//ham폴더 안에 있는 텍스트 문서를 읽는다.
	dirpath[0] = '\0';
	strcat(dirpath, argv[1]);
	strcat(dirpath, "ham");
	if( (od2 = opendir(dirpath) ) == NULL){
		perror("Fail to open ham directory");
		exit(1);
	}
	vector<string> ham_vec;
	while( (dir2 = readdir(od2) ) != NULL){				
		string contents;
		ifstream hamfile;		
		string path = argv[1];
		path += "ham/";
		path += dir2->d_name;		
		if(strcmp(dir2->d_name, ".") == 0 || strcmp(dir2->d_name, "..") == 0){		
			continue;
		}		
		
		hamfile.open(path);				
		while(!hamfile.eof()){						
			getline(hamfile, str);						
			contents +=  str;			
		}
		ham_vec.push_back(contents);
		hamfile.close();
	}
		
	//spam문서들의 각각의 경우에서 스팸 후보 문자가 출현하는지 확인한다.
	vector<vector<bool> >ck_mat_spam(spam_vec.size(), vector<bool>(words.size()));
	for(int i = 0; i < spam_vec.size(); ++i){
		for(int j = 0; j < words.size(); ++j){
			if( spam_vec[i].find(words[j]) != string::npos){
				ck_mat_spam[i][j] = true;
			}
		}
	}
	
	//ham문서들의 각각의 경우에서 스팸 후보 문자가 출현하는지 확인한다.
	vector<vector<bool> >ck_mat_ham(ham_vec.size(), vector<bool>(words.size()));
	for(int i = 0; i < ham_vec.size(); ++i){
		for(int j = 0; j < words.size(); ++j){
			if( ham_vec[i].find(words[j]) != string::npos){
				ck_mat_ham[i][j] = true;
			}
		}
	}
	
	/* 전채 판별 */
	//spam에 대하여 판별
	int s2s = 0;	//spam to spam
	int s2h = 0;	//spam to ham
	int h2s = 0;	//ham to spam	
	int h2h = 0;	//ham to ham
	for(int i = 0; i < spam_vec.size(); ++i){
		
		double spam_rst = 1/2;	//prior로 1/2을 곱해주어야 하는것
		double ham_rst = 1/2;	//prior로 1/2을 곱해주어야 하는것
		for(int j = 0; j < words.size(); ++j){
			if(ck_mat_spam[i][j]){		
				spam_rst *= spam_total_prob[j];
				ham_rst *= ham_total_prob[j];
			}
		}
		
		if(spam_rst >= ham_rst){
			s2s++;
		}		
		else{
			s2h++;
		}
	}
		
	for(int i = 0; i < ham_vec.size(); ++i){
		
		double spam_rst = 1/2;	//prior로 1/2을 곱해주어야 하는것
		double ham_rst = 1/2;	//prior로 1/2을 곱해주어야 하는것
		for(int j = 0; j < words.size(); ++j){
			if(ck_mat_ham[i][j]){		
				spam_rst *= spam_total_prob[j];
				ham_rst *= ham_total_prob[j];
			}
		}
		
		if(ham_rst >= spam_rst){
			h2h++;
		}		
		else{
			h2s++;
		}			
	}	
	
		
	int p_s2s[5]={0};
	int p_s2h[5]={0};
	int p_h2s[5]={0};
	int p_h2h[5]={0};
	for(int T = 0; T < 5; ++T){ //T : test
		for(int i = 0; i < spam_vec.size(); ++i){		
			double spam_rst = 1/2;	//prior로 1/2을 곱해주어야 하는것
			double ham_rst = 1/2;	//prior로 1/2을 곱해주어야 하는것
			for(int j = 0; j < words.size(); ++j){
				if(ck_mat_spam[i][j]){		
					spam_rst *= spam_part_prob[T][j];
					ham_rst *= spam_part_prob[T][j];
				}
			}
			
			if(spam_rst >= ham_rst){
				p_s2s[T]++;
			}		
			else{
				p_s2h[T]++;
			}
		}
		
		for(int i = 0; i < ham_vec.size(); ++i){			
			double spam_rst = 1/2;	//prior로 1/2을 곱해주어야 하는것
			double ham_rst = 1/2;	//prior로 1/2을 곱해주어야 하는것
			for(int j = 0; j < words.size(); ++j){
				if(ck_mat_ham[i][j]){		
					spam_rst *= spam_total_prob[j];
					ham_rst *= ham_total_prob[j];
				}
			}
			
			if(ham_rst >= spam_rst){
				p_h2h[T]++;
			}		
			else{
				p_h2s[T]++;
			}			
		}	
	}
			
	cout <<"12102266_Kim_Jinsol"<<endl;
	for(int i = 0; i < 5; ++i){
		cout <<"Classifier "<< i+1 
		<<": True positive = " << p_s2s[i]
		<<", True negative = " << p_h2h[i] 
		<<", False positive = " << p_h2s[i] 
		<<", False negative = " << p_s2h[i]
		<<", Precision = " <<  p_s2s[i] / (p_s2s[i] + p_h2s[i])
		<<", Recall = " << p_s2s[i] / (p_s2s[i] + p_s2h[i])<<endl;
	}
	
	cout <<"Classifier "<< 6 
		<<": True positive = " << s2s
		<<", True negative = " << h2h 
		<<", False positive = " << h2s 
		<<", False negative = " << s2h
		<<", Precision = " <<  s2s / (s2s + h2s)
		<<", Recall = " << s2s / (s2s + s2h)<<endl;      
				
    return 0;
}


Matrix zeros(int h, int w){
    if(w == -1) w = h;
    return Matrix(h, vector<double>(w,0));
}

vector<string> tokenize(string s, string del){
    vector<string> ret;
    for (int i = 0, j; i<s.size(); i = j + 1){
        if ((j = s.find_first_of(del, i)) == -1) j = s.size();
        if (j - i>0) ret.push_back(s.substr(i, j - i));
    }
    return ret;
}

vector<double> tokToNum(string s, string del){
    vector<double>ret;
    vector<string> vs = tokenize(s, del);
    for (int i = 0; i<vs.size(); ++i) ret.push_back(stod(vs[i]));
    return ret;
}

