% This function return the name of symbolic variable lists.

function sym_list = get_Symbolic(expr)
%% exprssion�� �о ������ Symbolic ������ �����Ѵ�.
%���� �ĺ��� ��� HashSet

var = java.util.HashSet;        
% ��� : 
% � ������ �������� �����̸� ������ �ƴϴ�. �н��Ѵ�.
% � ������ �������� +, -, *, /, ^, ' ', ','  �̸� ������ ������.
for i = 1:length(expr)
    if( isletter(expr(i) ) )
        for j = i+1 :length(expr)
            % ���� ���� ������ ������ �ȵ� �� ���� �� �ĺ�
            if (j <= length(expr) && ( isletter(expr(j)) || expr(j) == '(') )
                break;
                % ���� ���� ���ڳ� '_' �� ������ ������ �Ϻζ�� �����Ѵ�.
            elseif (j <= length(expr) && ( ('0' <= expr(j) && expr(j) <='9') || expr(j) == '_' ) )
                continue;
            % �� �ܾ ���� ��
            elseif( j <= length(expr) && ( expr(j) == '+' || expr(j) == '-' || expr(j) == '*' || expr(j) == '/' ||...
                    expr(j) == '^' || expr(j) == ' ' || expr(j) == ',' || expr(j) == ')' ))                        
                tmp = expr(i:j-1);                                                
               % ���� ���� 
                if (var.contains(tmp) == 0)
                    %syms(tmp);
                    var.add(tmp);
                end
                % ������ ��� ������ �߰ų� �Ǵ� �̹� ����Ǿ ������ �ʿ� ����.
                % ������ Ż���Ͽ� ���ο� �ĺ��� ã�´�.
                break;
            end% end if
        end% end for
    end % end if
end % end for 

modified_expr = expr;
sym_list = var.toArray;