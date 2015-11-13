% This function modify the processed expression to the more friendly syntax
% for man
function ret = MATLAB_to_Man(expr)

expr = strrep(expr, 'log10(', 'log(');
expr = strrep(expr, 'log2(', 'lg(');
expr = strrep(expr, 'log(', 'ln(');
expr = strrep(expr, 'symsum(', 'sigma(');
ret = expr;