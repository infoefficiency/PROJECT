clear all;
close all;
pause(1);

import java.io.*;
import java.lang.*;
import java.net.ServerSocket;
import java.net.Socket;

% while true
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
            expr = makeGraph(Msg);            
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
% end