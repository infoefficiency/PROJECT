function ret = arrange(expr, sym_list)
% 변수 선언
for i = 1:length(sym_list)
    syms(sym_list(i));
end

pre_vector = {'int', 'diff', 'symsum'};
for i = 1:length(pre_vector)
    cnt = 0;
    while true
        cand = strfind(expr, pre_vector{i});    
        lb = -1; ub = -1;
        if isempty(cand)        
            break;
        else
            lb = cand(1);
            for j = lb + length(pre_vector{i}) : length(expr)
                if expr(j) == '('
                    cnt = cnt + 1;
                elseif expr(j) == ')'
                    cnt = cnt -1;
                end

                if cnt == 0
                    ub = j;
                    break;
                end
            end        
            pre_rst = char(eval(expr(lb:ub)));
            expr = strrep(expr, expr(lb:ub), pre_rst);
        end
    end
end          

ret = expr;

