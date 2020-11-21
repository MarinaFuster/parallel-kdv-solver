clc

N = 256;
x = linspace(-10,10,N);
tmax = 1.5;
t=0;

% Initial conditions
c1=13;
c2=3;
u = 1/2.*c1.*(sech(sqrt(c1).*(x + 8)/2)).^2 + 1/2.*c2.*(sech(sqrt(c2).*(x + 1)/2)).^2;

% Accuracy: Error = |prev_result - curr_result|(inf)
% Conditions for error calculation
orders = [2, 4, 6];
delta_t = 0.0001;
parallel = false;

tic
results_strang_1 = Strang(u, x, N, tmax, delta_t)
time = toc
% for i=1:length(orders)
%     for n=1:1
%         tic
%         results_1 = Approximate(u, x, N, tmax, orders(i), parallel, delta_t);
%         time = toc;
        
%         Error is calculated in comparison to delta_t/2
%         results_2 = Approximate(u, x, N, tmax, orders(i), parallel, delta_t/2);
        
%         disp(size(results_1));
%         disp(size(results_2));
        
%         for j=1:size(results_1)
%             error{j} = results_2{j}-results_1{2*j};
%         end
        
%         disp(size(error));
        
%         total_error=cellfun(@(x)norm(x,inf), error);
        
%         disp("Order:");
%         disp(orders(i));
%         disp("Error:");
%         disp(total_error);
%         disp("Time:");
%         disp(time);
%     end
% end