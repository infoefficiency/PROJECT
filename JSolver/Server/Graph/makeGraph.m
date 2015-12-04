function [ret, ok] = makeGraph(Msg)
try
    ok = 1;
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

    ret = MAN_to_MATLAB(Msg_cell{6});
    expr = strsplit(ret, ',');    
    hold on;
    color_list = {'r', 'b', 'g', 'k', 'y', 'm', 'c'};
    for i = 1: length(expr)
        h(i) = ezplot(expr{i}, [x_lb, x_ub, y_lb, y_ub]);            
        set(h(i), 'Color', color_list{i});
    end
    grid(gca, 'on');   
    title(g_title); xlabel(x_label); ylabel(y_label);
    legend(h(:), expr{:});    
    hold off
    print('./Graph/graph', '-djpeg');        
    close;
catch
    ok = 0;
    ret = 'Error function';
end