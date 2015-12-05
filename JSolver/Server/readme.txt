In order to run the server, you need to run MATLAB and shell in Linux at the same time.
The shell file, 'server_CPP.cpp' and the m-file, 'server_MATLAB.m', is in the right outsider of three folders.
In MATLAB, To run it, current working path should be same with the address of 'server_MATLAB.m'.
The m-file handles the calculation, equation, graph and fitting.
The shell file is core program of server, which is implemented as multiplexer model.
It receives the string from client and send the result applied to MATLAB function.
Also, according to the option, shell sends the graph image to client.
