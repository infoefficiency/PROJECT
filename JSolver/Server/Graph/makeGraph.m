function ret = makeGraph(Msg)
% G?x시작,x끝,y시작,y끝?X타이틀?Y타이틀?그래프타이틀?수식데이터
% ex) G?-10,10,-10,10?X?Y?(Input)?y=x

% 전송 받은 문자열을 분해하여 옵션을 지정한다.
Msg_cell = strsplit(Msg, '?');
rangeXY = strsplit(Msg_cell{2}, ',');
x_lb = eval(MAN_to_MATLAB(rangeXY{1}));
x_ub = eval(MAN_to_MATLAB(rangeXY{2}));
y_lb = eval(MAN_to_MATLAB(rangeXY{3}));
y_ub = eval(MAN_to_MATLAB(rangeXY{4}));            

x_label = Msg_cell{3};
y_label = Msg_cell{4};
if( strcmp(Msg_cell{5} , '(Input)') )
    g_title = Msg_cell{6};
else
    g_title = Msg_cell{5};
end

ret = Msg_cell{6};
expr = strsplit(Msg_cell{6}, ',');

% 그래프 생성              
hold on;
color_list = {'r', 'b', 'g', 'k', 'y', 'm', 'c'};
for i = 1: length(expr)
    h(i) = ezplot(expr{i}, [x_lb, x_ub, y_lb, y_ub]);            
    set(h(i), 'Color', color_list{i});
end
grid(gca, 'on');   
title(g_title); xlabel(x_label); ylabel(y_label);
legend(h(:), expr{:});

% 그림을 저장한다.
hold off
print('graph', '-djpeg');      