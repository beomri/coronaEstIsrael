function [fitresult, gof, rsq, dblTime] = corona()

close all;

y=[1 2 3     7    10    12    15    17    21    25    39    50    75 97 126 197 250];
x=[1 3 7 8 10 11 13:21 23:24]-1;

ft = fittype( 'exp1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.37 0.29];

[fitresult, gof] = fit( x', y', ft, opts );
rsq = gof.rsquare;
disp(rsq);
coeffvals = coeffvalues(fitresult);

f=@(y) coeffvals(1)*exp(coeffvals(2)*y);

ndays = 26;
% ndays = 40;
bla = 0:0.1:ndays;


figure; hold on;

startDate = datetime(2020,2,21);
% endDate = startDate + length(y) - 1;%datetime(2020,3,11);
data_range = startDate+x;
plot(data_range, y,'.', 'MarkerSize', 20);

function_range = linspace(startDate, startDate + ndays, length(bla));
plot( function_range, f(bla) );


ylabel( '# sick');
next_day = startDate+x(end)+1;
next_num = x(end) + 1;
plot(next_day,feval(fitresult, next_num),'.', 'MarkerSize', 30);
grid on;

dblTime = log(2)/coeffvals(2);
text(startDate+3, 300, ['R^{2} = ' num2str(rsq)]);
text(startDate+3, 350, ['Doubling time = ' num2str(dblTime,2) ' days']);


end

