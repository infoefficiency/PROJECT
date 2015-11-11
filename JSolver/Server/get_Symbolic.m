% This function return the name of symbolic variable lists.

function sym_list = get_Symbolic(expr)
%% exprssion을 읽어서 변수를 Symbolic 변수로 선언한다.
%문자 후보를 담는 HashSet

var = java.util.HashSet;        
% 방법 : 
% 어떤 문자의 오른쪽이 문자이면 변수가 아니다. 패스한다.
% 어떤 문자의 오른쪽이 +, -, *, /, ^, ' ', ','  이면 변수를 나눈다.
for i = 1:length(expr)
    if( isletter(expr(i) ) )
        for j = i+1 :length(expr)
            % 문자 다음 나오면 변수가 안될 것 같은 것 후보
            if (j <= length(expr) && ( isletter(expr(j)) || expr(j) == '(') )
                break;
                % 문자 다음 숫자나 '_' 가 나오면 변수의 일부라고 생각한다.
            elseif (j <= length(expr) && ( ('0' <= expr(j) && expr(j) <='9') || expr(j) == '_' ) )
                continue;
            % 한 단어가 끝날 곳
            elseif( j <= length(expr) && ( expr(j) == '+' || expr(j) == '-' || expr(j) == '*' || expr(j) == '/' ||...
                    expr(j) == '^' || expr(j) == ' ' || expr(j) == ',' || expr(j) == ')' ))                        
                tmp = expr(i:j-1);                                                
               % 변수 생성 
                if (var.contains(tmp) == 0)
                    %syms(tmp);
                    var.add(tmp);
                end
                % 변수가 없어서 선언을 했거나 또는 이미 선언되어서 선언할 필요 없다.
                % 루프를 탈출하여 새로운 후보를 찾는다.
                break;
            end% end if
        end% end for
    end % end if
end % end for 

modified_expr = expr;
sym_list = var.toArray;