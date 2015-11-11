% This function modify the expression sent from client to right for the
% matlab syntax.
function ret = modify(expr)
%% 공백 문자를 지운다.
expr(expr == ' ') = [];

%% 4x -> 4*x 로 바꾼다.
tmp_expr = '';
for i = 1:length(expr)
    % 앞이 숫자 뒤가 문자이면 그 사이에 * 추가
    if( (i + 1 <= length(expr)) && ( '0' <= expr(i)  && expr(i) <= '9' ) && isletter(expr(i+1)) )
        tmp_expr = strcat(tmp_expr,[expr(i),'*']);
    % 앞이 ')' 이고 뒤가 문자나 숫자이면 그 사이에 * 추가
    elseif ( (i + 1 <= length(expr)) && ( expr(i) == ')'  && (isletter(expr(i+1)) || ( '0' <= expr(i+1)  && expr(i+1) <= '9' ))))
        tmp_expr = strcat(tmp_expr,[expr(i),'*']);
    else
        tmp_expr = strcat(tmp_expr, expr(i));
    end
end
expr = tmp_expr;

%% log 관련해서 문자열 수정. 다음 순서로 수정한다.
% log( -> log10(
% lg( -> log2(
% ln( -> log(

expr = strrep(expr, 'log(', 'log10(');
expr = strrep(expr, 'lg(', 'log2(');
expr = strrep(expr, 'ln(', 'log(');

% sigma( -> symsum(
expr = strrep(expr, 'sigma(', 'symsum(');

ret = expr;