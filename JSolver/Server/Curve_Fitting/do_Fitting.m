function ret = do_Fitting(str)

c = strsplit(str, '?');

% row, column
sz = str2double(strsplit(c{2}, ','));
row = sz(1); col = sz(2);

% element
elem = str2double(strsplit(c{3}, ','));
M = zeros(row,col);
for i = 1:row
    for j = 1:col
        M(i,j) = elem(col*(i-1) + j);
    end
end

% value
val = str2double(strsplit(c{4}, ','));

