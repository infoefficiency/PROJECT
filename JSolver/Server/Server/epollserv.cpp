#include "header.hpp"
#include "file_process.hpp"
#include "util.hpp"

using namespace std;

const int BUF_SIZE = 100;
const int EPOLL_SIZE = 50;

int main(int argc, char* argv[]){
    int serv_sock, client_sock;
    struct sockaddr_in serv_addr, client_addr;
    socklen_t addr_sz = sizeof(serv_addr);
    char buf[BUF_SIZE];

    if(argc != 2){
        cout << "Usage : " << argv[0] << "<port>"<<endl;
        exit(1);
    }

    serv_sock = socket(PF_INET, SOCK_STREAM, 0);
    memset(&serv_addr, 0, addr_sz);

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons( atoi(argv[1]) );

    if( bind(serv_sock, (struct sockaddr*)&serv_addr, addr_sz) == -1){
        error_handling("bind() error");
    }

    if( listen(serv_sock, 5) == -1){
        error_handling("listen() error");
    }

    int epfd = epoll_create(EPOLL_SIZE);
    int event_cnt;
    struct epoll_event* ep_vec = new epoll_event[EPOLL_SIZE];
    struct epoll_event event;
    event.events = EPOLLIN;
    event.data.fd = serv_sock;
    epoll_ctl(epfd, EPOLL_CTL_ADD, serv_sock, &event);

    while(1){
        cout<<"wait"<<endl;
        if( (event_cnt = epoll_wait(epfd, ep_vec, EPOLL_SIZE, -1)) == -1){
            cerr << "epoll_wait() error"<<endl;
            break;
        }

        for(int i = 0; i < event_cnt; ++i){
            if(ep_vec[i].data.fd == serv_sock){
                client_sock = accept(serv_sock, (struct sockaddr*)&client_addr, &addr_sz);
                event.events = EPOLLIN;
                event.data.fd = client_sock;
                epoll_ctl(epfd, EPOLL_CTL_ADD, client_sock, &event);
                cout << "connected client : " << client_sock << endl;
            }
            else{
                // receive message from client
                char msg[200];
                int str_len;
                if( (str_len = read(ep_vec[i].data.fd, msg, sizeof(msg)) ) == -1){
                    error_handling("read() from client error");
                }
                string buf = msg;
                string rst;
                string no_data = "No Input.";

                cout << "received data : " << buf << endl;

                if(buf.empty()){
                    write(ep_vec[i].data.fd, no_data.c_str(), no_data.size());
                }

                if(buf[0] == 'C'|| buf[0] == 'A'){
                    make_txt(buf);
                    rst = get_result(ep_vec[i].data.fd);
                    remove_file("data_to_MATLAB.txt");
                    remove_file("data_to_cpp.txt");
                }
                else if(buf[0] == 'E'){
                    make_txt(buf);
                    rst = get_result(ep_vec[i].data.fd);
                    remove_file("data_to_MATLAB.txt");
                    remove_file("data_to_cpp.txt");
                }
                else if(buf[0] == 'G'){
                    make_txt(buf);
                    rst = get_result(ep_vec[i].data.fd);
                    remove_file("data_to_MATLAB.txt");
                    remove_file("data_to_cpp.txt");
                    send_graph(client_sock);
                }
                else if(buf[0] == 'F'){
                    make_txt(buf);
                    rst = get_result(ep_vec[i].data.fd);
                    remove_file("data_to_MATLAB.txt");
                    remove_file("data_to_cpp.txt");
                    send_graph(client_sock);
                }

                cout << "result : " << rst << endl; 
                epoll_ctl(epfd, EPOLL_CTL_DEL, ep_vec[i].data.fd, NULL);
                close(ep_vec[i].data.fd);

                cout<< "closed client : " << ep_vec[i].data.fd << endl;
            }
        }
    }
   
    close(serv_sock);
    close(epfd);
    return 0;
}

