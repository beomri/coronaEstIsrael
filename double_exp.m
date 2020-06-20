function f = double_exp(x, a,b,c,f)

e = (a.*b.*exp(b.*c)) / (f.*exp(f.*c));
d = a.*exp(b.*c) - e.*exp(f.*c);


f = ((a.*exp(b.*x)) .* (x<c)) + ( (d + (e.*exp(f.*x))) .* (x>=c));

end

