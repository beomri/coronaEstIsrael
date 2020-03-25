function [fitresult, gof, rsq, dblTime] = corona()

close all;

y=[1 2 3 7 10 12 15 17 21 25 39 50 75 97 126 197 250 304 427 529 705 883 945 1238 1656 2030];
x=[0 2 6 7 9 10 12:20 22:32];

ft = fittype( 'exp1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.37 0.29];

[fitresult, gof] = fit( x', y', ft, opts );
coeffvals = coeffvalues(fitresult);

% f=@(y) coeffvals(1)*exp(coeffvals(2)*y);

ndays = 38;
% ndays = 40;
range_num = 0:0.1:ndays;


figure; hold on;

startDate = datetime(2020,2,22);
% endDate = startDate + length(y) - 1;%datetime(2020,3,11);
data_range = startDate+x;


plot(data_range, y,'.', 'MarkerSize', 20);

% fit_result = f(range_num);
[ci, fit_result] = predint(fitresult, range_num);
range_date = startDate+range_num;%linspace(startDate, startDate + ndays, length(bla));
func_line = plot( range_date, fit_result,'r-' );
% plot( range_date, ci,'r--' );


ylabel( '# cases');
next_day = startDate+x(end)+1;
next_num = x(end) + 1;
plot(next_day,feval(fitresult, next_num),'.', 'MarkerSize', 30);
grid on;

datatip(func_line, next_day, feval(fitresult, next_num));

rsq = gof.rsquare;
dblTime = log(2)/coeffvals(2);

% text(startDate+3, max(fit_result)*0.5 , {['R^{2} = ' num2str(rsq)], ['Doubling time = ' num2str(dblTime,2) ' days']});

set(gca, 'YScale', 'log');
text(startDate+3, max(fit_result)^0.6 , {['R^{2} = ' num2str(rsq)], ['Doubling time = ' num2str(dblTime,2) ' days']});

end
