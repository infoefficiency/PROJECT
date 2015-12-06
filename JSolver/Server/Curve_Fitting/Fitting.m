function [ret, ok] = Fitting(str)
try
    ok = 1;
    c = strsplit(str, '?');
    Fittype = c{4};
    if strcmp(Fittype, 'smoothingspline') | strcmp(Fittype, 'exp1') | (strcmp(Fittype(1:4), 'poly') && length(Fittype) == 5)
        dimension = 2;
    else
        dimension = 3;
    end

    % element matrix
    elem = str2double(strsplit(c{2}, ','));
    row1 = (length(elem) - 1) / dimension;
    col1 = dimension;
    M1 = zeros(row1,col1);
    for i = 1:row1
        for j = 1:col1        
            M1(i,j) = elem(col1*(i-1) + j);
        end
    end

    % value matrix
    val = str2double(strsplit(c{3}, ','));
    col2 = col1 - 1;
    row2 = (length(val)-1)/col2;
    M2 = zeros(row2,col2);
    for i = 1:row2
        for j = 1:col2        
            M2(i,j) = val(col2*(i-1) + j);
        end
    end

    % fit according to the dimension.
    if dimension == 2    
        % 2 - dimensional
        f = fit(M1(1:end, 1), M1(1:end, 2), Fittype);
        plot(M2(1:end,1), f(M2(1:end,1)), 'bo', 'MarkerSize', 10, 'linewidth',3);
        grid on;
        hold on;
        plot(M1(1:end, 1), M1(1:end, 2), 'r*', 'MarkerSize', 10);
        plot(f);    
        legend('serching data', 'existing data', 'fitted curve', 'location', 'best');        
    else
        % 3 - dimensional    
        f = fit([M1(1:end, 1), M1(1:end, 2)], M1(1:end, 3), Fittype);    
        plot3(M2(1:end,1), M2(1:end,2), f(M2(1:end,1), M2(1:end,2)), 'bo', 'MarkerSize', 10, 'linewidth', 3); 
        grid on;
        hold on;    
        plot3(M1(1:end, 1), M1(1:end, 2), M1(1:end, 3), 'r*', 'MarkerSize', 10);        
        plot(f);
        legend('serching data', 'existing data', 'fitted curve', 'location', 'best');  
    end

    % determine whether expression is exist or not.
    if strcmp(Fittype, 'smoothingspline') | strcmp(Fittype, 'lowess')
        exist_expr = false;
    else
        exist_expr = true;
    end

    if exist_expr == 1        
        % get expression : modify
        formula = char(f);
        coefn = coeffnames(f);
        coefv = coeffvalues(f);
        ret = ['f(x) = ', formula, '\n'];
        for i = 1: length(coefn)
            ret = [ret, coefn{i}, ' : ', num2str(coefv(i)), '\n'];
        end
        
        if dimension == 2            
            for i = 1:length(M2)
                ret = [ret, 'f(', num2str(M2(i)), ') = ', num2str(f(M2(i))), '\n'];
            end
        elseif dimension == 3
            for i = 1:length(M2)
                ret = [ret, 'f(', num2str(M2(i,1)), ',', num2str(M2(i,2)), ') = ', num2str(f(M2(i,:))), '\n'];
            end
        end            
    else   
        ret = 'No expression';    
    end

    print('./Curve_Fitting/graph', '-djpeg');
    close;
catch
    ok = 0;
    ret = 'Error input';
end
