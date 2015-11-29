while true
    disp('strat!!');
    while true
        if (exist('data_to_MATLAB.txt') == 2)
            break;
        end
    end

    fin = fopen('data_to_MATLAB.txt', 'r');
    A = textscan(fin, '%s');
    A = cellfun(@transpose,A,'un',0);
    A = A{1};
    str = strjoin(A);
    tmp = strsplit(str, '#');
    str = char(tmp(1));

    if( str(1) == 'C' || str(1) == 'E')
        rst = Calc(str);
        disp(['Result : ', rst]);
    elseif( str(1) == 'G')
        [rst, ok] = makeGraph(str);        
        ferr = fopen('/home/jinsol/Capstone/Graph/err.txt', 'w');
        if ok == 1
            fwrite(ferr, '1');
            fclose(ferr);
        elseif ok == 0
            fwrite(ferr, '0');
            fclose(ferr);
        end
    elseif( str(1) == 'F')

    end

    fout = fopen('/home/jinsol/Capstone/Server/data_to_cpp.txt', 'w');
    fwrite(fout, rst);

    fclose(fin);
    fclose(fout);
    disp('end');
end