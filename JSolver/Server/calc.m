% This function is about calculation.
function ret = calc(str)
try     
    %% Decide mode
    mode = str(1);
    expr = str(3:end);    
    % 입력 받은 문자열을 매트랩이 인식할 수 있게 변경
    expr = modify(expr);
    %% Operation
    % Calculation
    if mode == 'C'                        
        % 변수 선언
        sym_list = get_Symbolic(expr);        
        for i = 1:length(sym_list)
            syms(sym_list(i));
        end        
        % 계산
        ret = eval(expr);
    % Solve Equation.
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
            
            disp(expr);
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
                ret = strcat(ret, [', ', char(rst(i))]);
            end
        end
    else
        ret = 'There are some errors in expression.';    
    end        
catch
    ret = 'There are some errors in expression.';    
end