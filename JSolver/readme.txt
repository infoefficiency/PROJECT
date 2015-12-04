In order to run the server, you need to run MATLAB and shell in Linux at the same time.
The shell file, epollserv,  is in the Server folder. And the m-file, serv, is in the right outsider of three folders.
In MATLAB, To run it, current working path should be same with the address of serv.m.
m-file handles the calculation, equation, graph and fitting. the role of shell file is server with multiplexer model.
The shell file receives the string and send the result derived from string we get. 
Also, according to the option, shell sends the graph image to client.