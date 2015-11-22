% This function modify the expression sent from client to right for the
% matlab syntax.
function ret = MAN_to_MATLAB(expr)
%% ��� ���ڸ� �����.
expr(expr == ' ') = [];

%% 4x -> 4*x �� �ٲ۴�.
tmp_expr = '';
for i = 1:length(expr)
    % ���� ���� �ڰ� �����̸� �� ���̿� * �߰�
    if( (i + 1 <= length(expr)) && ( '0' <= expr(i)  && expr(i) <= '9' ) && isletter(expr(i+1)) )
        tmp_expr = strcat(tmp_expr,[expr(i),'*']);
    % ���� ')' �̰� �ڰ� ���ڳ� �����̸� �� ���̿� * �߰�
    elseif ( (i + 1 <= length(expr)) && ( expr(i) == ')'  && (isletter(expr(i+1)) || ( '0' <= expr(i+1)  && expr(i+1) <= '9' ))))
        tmp_expr = strcat(tmp_expr,[expr(i),'*']);
    else
        tmp_expr = strcat(tmp_expr, expr(i));
    end
end
expr = tmp_expr;

%% log ����ؼ� ���ڿ� ����. ���� ��� �����Ѵ�.
% log( -> log10(
% lg( -> log2(
% ln( -> log(

expr = strrep(expr, 'log(', 'log10(');
expr = strrep(expr, 'lg(', 'log2(');
expr = strrep(expr, 'ln(', 'log(');

% sigma( -> symsum(
expr = strrep(expr, 'sigma(', 'symsum(');
ret = expr;