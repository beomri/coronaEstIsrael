function [fitresult, gof, rsq, dblTime] = corona()

close all;

y=[1 2 3 7 10 12 15 17 21 25 39 50 75 97 126 197 250 304 427 529 705 883 ...
    945 1238 1656 2030 2495 3035 3460 3865 4347 4831 5591 6211 7030 7589 ...
    8018 8611 9006 9404 9755 10095 10505 10878 11235 11868 12200 12591 ...
    12855 13107 13362 13654 13883 14326 14592 14882 15148 15398];
x=[0 2 6 7 9 10 12:20 22:64];


opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';

% ft = fittype( 'exp1' );
% chosen_model=1;
% opts.StartPoint = [0.37 0.29];

ft = fittype( 'linear_exp(x, b,c,d)', 'independent', 'x', 'dependent', 'y' );
chosen_model=2;
opts.StartPoint = [0.2 30 500];

% ft = fittype( 'double_exp(x, a,b,c,f)', 'independent', 'x', 'dependent', 'y' );
% chosen_model=3;
% opts.StartPoint = [0.37 0.29 30 0.01];


% ft = fittype( 'composite_exp(x, b,c,d,f)', 'independent', 'x', 'dependent', 'y' );
% chosen_model=4;
% opts.StartPoint = [0.2 30 200 0.1];

[fitresult, gof] = fit( x', y', ft, opts );
coeffvals = coeffvalues(fitresult);

% f=@(y) coeffvals(1)*exp(coeffvals(2)*y);

ndays = 65;
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


to_print = {['R^{2} = ' num2str(rsq)]}; %, ['Doubling time = ' num2str(dblTime,2) ' days']
switch chosen_model
    case 2
        dblTime = log(2)/coeffvals(1);
        lin_slope = coeffvals(3);
        transition_date = startDate+coeffvals(2);
        xline(transition_date);
        to_print{2} = ['Doubling time = ' num2str(dblTime,2) ' days'];
        to_print{3} = ['Linear progress = ' num2str(lin_slope)];
    case 3
        dblTime = log(2)/coeffvals(2);
        dbltime2 = log(2)/coeffvals(4);
        transition_date = startDate+coeffvals(3);
        xline(transition_date);
        to_print{2} = ['Doubling time = ' num2str(dblTime,2) ' days'];
        to_print{3} = ['2nd doubling time = ' num2str(dbltime2)];
    case 4
        dblTime = log(2)/coeffvals(1);
        dblTime2 = log(2)/coeffvals(4);
        lin_slope = coeffvals(3);
        transition_date = startDate+coeffvals(2);
        xline(transition_date);
        to_print{2} = ['Doubling time = ' num2str(dblTime,2) ' days'];
        to_print{3} = ['2nd Doubling time = ' num2str(dblTime2,2) ' days'];
        to_print{4} = ['Linear progress = ' num2str(lin_slope)];
end

text(startDate+3, max(fit_result)*0.5 , to_print);

% set(gca, 'YScale', 'log');
% text(startDate+3, max(fit_result)^0.75 , to_print);

end
