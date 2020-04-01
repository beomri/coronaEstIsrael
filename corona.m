function [fitresult, gof, rsq, dblTime] = corona()

close all;

y=[1 2 3 7 10 12 15 17 21 25 39 50 75 97 126 197 250 304 427 529 705 883 945 1238 1656 2030 2495 3035 3460 3865 4347 4831 5591];
x=[0 2 6 7 9 10 12:20 22:39];


opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.37 0.29];


lin_ft = fittype( 'linear_exp(x,a,b,c)', 'independent', 'x', 'dependent', 'y' );
opts.StartPoint = [0.368778098811191 0.0860478500029206 0.0497598384129591];
[lin_fitresult, lin_gof] = fit( x', y', lin_ft, opts );
exp_ft = fittype( 'exp1' );
opts.StartPoint = [0.37 0.29];
[exp_fitresult, exp_gof] = fit( x', y', exp_ft, opts );


% ft = fittype( 'exp1' );
% opts.StartPoint = [0.37 0.29];
% ft = fittype( 'linear_exp(x,a,b,c)', 'independent', 'x', 'dependent', 'y' );
% opts.StartPoint = [0.368778098811191 0.0860478500029206 0.0497598384129591];
% [fitresult, gof] = fit( x', y', ft, opts );
coeffvals = coeffvalues(exp_fitresult);

% f=@(y) coeffvals(1)*exp(coeffvals(2)*y);

ndays = 45;
range_num = 0:0.1:ndays;


figure; hold on;

startDate = datetime(2020,2,22);
% endDate = startDate + length(y) - 1;%datetime(2020,3,11);
data_range = startDate+x;
range_date = startDate+range_num;%linspace(startDate, startDate + ndays, length(bla));

plot(data_range, y,'.', 'MarkerSize', 20);

% fit_result = f(range_num);
[exp_ci, exp_graph] = predint(exp_fitresult, range_num);
exp_func_line = plot( range_date, exp_graph,'r-', 'DisplayName', 'exp' );
% plot( range_date, ci,'r--' );
[lin_ci, exp_graph] = predint(lin_fitresult, range_num);
lin_func_line = plot( range_date, exp_graph,'o-', 'DisplayName', 'lin' );


ylabel( '# cases');
next_day = startDate+x(end)+1;
next_num = x(end) + 1;
plot(next_day,feval(exp_fitresult, next_num),'.', 'MarkerSize', 30);
plot(next_day,feval(lin_fitresult, next_num),'.', 'MarkerSize', 30);
grid on;

datatip(exp_func_line, next_day, feval(exp_fitresult, next_num));
datatip(lin_func_line, next_day, feval(lin_fitresult, next_num));

lin_rsq = lin_gof.rsquare;
exp_rsq = exp_gof.rsquare;
dblTime = log(2)/coeffvals(2);

to_print = {['Linear R^{2} = ' num2str(lin_rsq)],...
    ['Exp R^{2} = ' num2str(exp_rsq)],...
    ['Doubling time = ' num2str(dblTime,2) ' days']};
lin_scale = true;
if lin_scale
    text(startDate+3, max(exp_graph)*0.5 , to_print);
else
    set(gca, 'YScale', 'log');
    text(startDate+3, max(fit_result)^0.6 , to_print);
end
end
