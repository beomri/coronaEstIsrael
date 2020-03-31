function f = linear_exp(x, a,b,c)

d = a.*b.*exp(b.*c);
e = (a.*exp(b.*c)) - (d.*c);

f = ((a.*exp(b.*x)) .* (x<c)) + (((d.*x)+e) .* (x>=c));

end

