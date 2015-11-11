% This function is about calculation.
function ret = calc(str)
try
    %% Preprocess
    mode = str(1);
    expr = str(3:end);    
    % 입력 받은 문자열을 매트랩이 인식할 수 있게 변경
    expr = Man_to_MATLAB(expr);
    
    % 변수 선언
    sym_list = get_Symbolic(expr);        
    for i = 1:length(sym_list)
        syms(sym_list(i));
    end
    
    %% Calculation
    if mode == 'C'
        ret = char(eval(expr));
    %% Solve Equation.
    elseif mode == 'E'
        expr = arrange(expr, sym_list);        
        if nnz( expr == '''' )            
            % prime의 위치를 파악해서 y'' => D2y 로 바꾼다.
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
            
            % ----- 'x'는 사용자에 맞게 수정할 수 있게 구현해야한다.
            rst = dsolve(expr, 'x');
            ret = char(rst);
        else
            % Polynomial Equation   
            rst = solve(sym(expr));
            % save the solution.
            ret = char(rst(1));
            for i = 2:length(rst)
                ret = strcat(ret, [', ', char(rst(i))]);
            end
        end
    else
        ret = 'There are some errors in expression.';    
    end        
    ret = MATLAB_to_Man(ret);    
catch
    ret = 'There are some errors in expression.';    
end