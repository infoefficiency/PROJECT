% This function modify the expression sent from client to right for the
% matlab syntax.
function ret = MAN_to_MATLAB(expr)
%% remove the black.
expr(expr == ' ') = [];

%% 4x -> 4*x 
tmp_expr = '';
for i = 1:length(expr)    
    if( (i + 1 <= length(expr)) && ( '0' <= expr(i)  && expr(i) <= '9' ) && isletter(expr(i+1)) )
        tmp_expr = strcat(tmp_expr,[expr(i),'*']);    
    elseif ( (i + 1 <= length(expr)) && ( expr(i) == ')'  && (isletter(expr(i+1)) || ( '0' <= expr(i+1)  && expr(i+1) <= '9' ))))
        tmp_expr = strcat(tmp_expr,[expr(i),'*']);
    else
        tmp_expr = strcat(tmp_expr, expr(i));
    end
end
expr = tmp_expr;

%% log  conversion.
% log( -> log10(
% lg( -> log2(
% ln( -> log(

expr = strrep(expr, 'log(', 'log10(');
expr = strrep(expr, 'lg(', 'log2(');
expr = strrep(expr, 'ln(', 'log(');

%% sigma( -> symsum(
expr = strrep(expr, 'sigma(', 'symsum(');

%% factorial
a = strfind(expr, '!');
if ~isempty(a)    
    idx = a(1);
    if expr(idx-1) == ')'
        for i = idx-1:-1:1
            if expr(i) == '('
                expr = [expr(1:i-1), 'factorial', expr(i:idx-1), expr(idx+1:end)];
                break;
            end
        end
    elseif '0'<= expr(idx-1) && expr(idx-1) <= '9'
        for i = idx-1:-1:1
            if i == 1
                expr = ['factorial(',expr(1:idx-1), ')', expr(idx+1:end)];
                break;
            elseif ~('0'<= expr(i) && expr(i) <= '9')
                expr = [expr(1:i), 'factorial(', expr(i+1:idx-1), ')', expr(idx+1:end)];
                break;
            end
        end
    end
end

ret = expr;