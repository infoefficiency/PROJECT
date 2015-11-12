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
            % G?x����,x��,y����,y��?XŸ��Ʋ?YŸ��Ʋ?�׷���Ÿ��Ʋ?���ĵ�����
            % ex) G?-10,10,-10,10?X?Y?(Input)?y=x
            
            % ���� ���� ���ڿ��� �����Ͽ� �ɼ��� �����Ѵ�.
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
            
            % �׷��� ����                        
            h = ezplot(expr, [x_lb, x_ub, y_lb, y_ub]);            
            set(h, 'Color', 'b');
            xlabel(x_label);
            ylabel(y_label);
            title(g_title);       
            grid(gca, 'on');            
            print('graph', '-djpeg');       
            
            % ���۹��� ���� echo ����
            dos.writeUTF(expr);
            
            % �׷����� ����
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