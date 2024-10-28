


%%

%  randi(maxval, rows, cols
rdata = randi(5, 1, 50);
plot(rdata)

%%

data = 1:10;
data = data .* data;

plot(data)

%%

x_axis = 1: 0.1 :1.9;

range =     1:10;
quad =      range .* range;
exponent =  range;
for i = range
    exponent(i) = 2 ^ i;
end
exponent


plot(x_axis, quad, x_axis, exponent)
xlabel("sus__value")
ylabel("cool")

title("exponent vs quadratic")
legend("Quadratic", "Exponential")
    