function ret = Calculation(str)
try 
    %% Decide mode
    mode = str(1);
    expr = str(3:end);
    %% Operation
    % Calculation
    if mode == 'C'
        rst = sym(expr);
        ret = char(rst);
    elseif mode == 'E'
        if nnz( expr == '''' )
            disp('ODE');
            % ODE
            while true
                % find the position of  prime
                pos = strfind(expr, '''');
                % if not exist then, break
                if isempty(pos)
                    break;
                end
                
                % check the continuous length of prime
                len = 1;
                for i = 2:length(pos)
                    if pos(i) - pos(i-1) == 1
                        len = len + 1;
                    else
                        break;
                    end         
                end
                % replace (variable + prime) to MATLAB syntax
                expr = strrep(expr, expr(pos(1)-1 : pos(1+len-1)), ['D', num2str(len), expr(pos(1)-1)]);              
            end
            
            rst = dsolve(expr, 'x');
            ret = char(rst);
        else
            % Polynomial Equation   
            % Declare Variable            
            vars = unique(expr(isletter(expr)));            
            disp('1');
            for i = 1:length(vars)
                var(i) = sym(vars(i));
            end
            
            % Solve
            rst = solve(sym(expr));
            ret = char(rst(1));
            for i = 2:length(rst)
                ret = strcat(ret, ['\n', char(rst(i))]);
            end
        end    
    end        
catch
    ret = 'There are some errors in expression.';    
end