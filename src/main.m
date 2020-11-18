clc

order = 4; % we will change this to get metrics

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

parallel = false;

Approximate(u, x, N, tmax, order, parallel);


% in main you define the equation you want to aproximate and its initial
% conditions
% Here you call Approximate -> MethodStep (for each iteration) ->
% LieTrotter