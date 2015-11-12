clear all;
close all;
pause(1);

import java.io.*;
import java.lang.*;
import java.net.ServerSocket;
import java.net.Socket;

while true
    %% Connect
    port = 9000;
    server = ServerSocket(port);
    disp('Server : Waiting for request');   
    client = server.accept;
    disp('Server : Accepted');

    % Open Input_stream
    input_stream = client.getInputStream;   
    dis = DataInputStream (input_stream);  

    % Open Output_stream
    output_stream = client.getOutputStream;
    dos = DataOutputStream(output_stream);

    try       
        %% Input String    
        Msg =  char(dis.readUTF);      
        disp(['Received data : ', Msg]);

        %% Calculation Or Equation.
        if ( Msg(1) == 'C' || Msg(1) == 'E')
            Msg = Calc(Msg);          
            disp(['Result : ', Msg]);
            dos.writeUTF(Msg);
            disp('Sent data to client');
        %% Graph.        
        elseif (Msg(1) == 'G')    
            % G?x시작,x끝,y시작,y끝?X타이틀?Y타이틀?그래프타이틀?수식데이터
            % ex) G?-10,10,-10,10?X?Y?(Input)?y=x
            
            % 전송 받은 문자열을 분해하여 옵션을 지정한다.
            Msg_cell = strsplit(Msg, '?');
            rangeXY = strsplit(Msg_cell{2}, ',');
            x_lb = str2double(rangeXY{1});
            x_ub = str2double(rangeXY{2});
            y_lb = str2double(rangeXY{3});
            y_ub = str2double(rangeXY{4});            
            
            x_label = Msg_cell{3};
            y_label = Msg_cell{4};
            g_title = '';
            if( strcmp(Msg_cell{5} , '(Input)') )
                g_title = Msg_cell{6};
            else
                g_title = Msg_cell{5};
            end                        
            expr = Msg_cell{6};                        
            
            % 그래프 생성                        
            h = ezplot(expr, [x_lb, x_ub, y_lb, y_ub]);            
            set(h, 'Color', 'b');
            xlabel(x_label);
            ylabel(y_label);
            title(g_title);       
            grid(gca, 'on');            
            print('graph', '-djpeg');       
            
            % 전송받은 식을 echo 전송
            dos.writeUTF(expr);
            
            % 그래프를 전송
            fName = String('graph.jpg');            
            outFile = File(fName);            
            fis = FileInputStream(outFile);
            bis = BufferedInputStream(fis);
            
            len = 0;            
            while true
                len = bis.read();                
                if len == -1
                    break;
                end
                dos.write(len);
            end
            disp('Sent image file');      
        
        %% Curve Fitting.
        elseif (Msg(1) == 'F')
            
            
        end                    
        
        dis.close;   
        dos.close;   
        server.close; 
    catch
        Msg = 'Error occurred, Please retry';
        dos.writeUTF(Msg);    
        dis.close;   
        dos.close;   
        server.close; 
    end         
end