function f = linear_exp(x, b,c,d)

a = d / (b*exp(b*c));
e = a*exp(b*c);

part1 = a.*exp(b.*x);
part2 = (d.*(x-c)) + e;

f = (part1 .* (x<c)) + (part2 .* (x>=c));

end

