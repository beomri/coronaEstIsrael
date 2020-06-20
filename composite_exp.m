function f = composite_exp(x, b,c,d,f)

a = d / ((b - f)*exp(b*c));
e = a*exp(b*c);


part1 = a.*exp(b.*x);
part2 = d.*(x-c) + (e.*exp(f.*(x-c)));

f = (part1 .* (x<c)) + ( part2 .* (x>=c));

end

