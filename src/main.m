clc

order = 4; % we will change this to get metrics

N = 256;
x = linspace(-10,10,N);        % domain, is this ok?
tmax =  1.5;
t=0;

% Initial conditions
A=25;
B =16;
u = 3.*(A.^2).*(sech(A.*(x+2)./2).^2) + 3.*(B.^2).*(sech(B.*(x+1)./2).^2);

% Plots initial condition (we want to get a better idea of what we are dealing with)
plot(x,u,'LineWidth',1)
axis([-10 10 0 2100])
xlabel('x')
ylabel('u')
text(6,2000,['t = ',num2str(t,'%1.2f')],'FontSize',14)
drawnow

parallel = false; % TODO when using parallel true computer crashes, fix this

Approximate(u, x, N, tmax, order, parallel);


% in main you define the equation you want to aproximate and its initial
% conditions
% Here you call Approximate -> MethodStep (for each iteration) ->
% LieTrotter