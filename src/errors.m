clc

N = 256;
x = linspace(-10,10,N);        % domain, is this ok?
tmax =  1.5;
t=0;

% Initial conditions
c1=13;
c2=3;
u = 1/2.*c1.*(sech(sqrt(c1).*(x + 8)/2)).^2 + 1/2.*c2.*(sech(sqrt(c2).*(x + 1)/2)).^2;

% Plots initial condition (we want to get a better idea of what we are dealing with)
plot(x,u,'LineWidth',1)
axis([-10 10 0 10])
xlabel('x')
ylabel('u')
text(6,9,['t = ',num2str(t,'%1.2f')],'FontSize',10)
drawnow

% Accuracy: Error = |prev_result - curr_result|(inf)
% Conditions for error calculation
orders = [2, 4, 6];
delta_t = 0.0005;
parallel = false;
fileID_errors = fopen('errors.txt','w');
fprintf(fileID_errors,'%s\t%s\t%s\n','order','delta_t', 'error');

for i=1:length(orders)
    results_1 = Approximate(u, x, N, tmax, orders(i), parallel, delta_t);
    % Error is calculated in comparisson to delta_t/2
    results_2 = Approximate(u, x, N, tmax, orders(i), parallel, delta_t/2);
    
    for j=1:size(results_1)
        error{j} = results_2{j*2-1}-results_1{j};
        % To compare step by step
        % fprintf(fileID_errors,'%d\t%f\t%f\n', orders(i), delta_t, error{j});
    end
    total_error=cellfun(@(x)norm(x,Inf), error);
    fprintf(fileID_errors,'%d\t%f\t%f\n', orders(i), delta_t, total_error);
end