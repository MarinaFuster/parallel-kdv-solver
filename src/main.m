clc

% MODE: normal or metrics
runMetrics = true;

% Normal mode
order = 4;
delta_t = 0.01;
parallel = true;

% Metrics mode
repetitions = 10;
orders = [2, 4, 6];
delta_ts = [0.01, 0.001, 0.0001];

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



% METRICS OR NORMAL MODE
if(runMetrics)
    fileID = fopen('metrics.txt','w');
    fprintf(fileID,'%s\t%s\t%s\t%s\t%s\n','repetition','time','order', 'parallel', 'delta_t');
    for rep=1:repetitions
        parallel = false;
        for i=1:length(orders)
           for j=1:length(delta_ts)
                tic;
                Approximate(u, x, N, tmax, orders(i), parallel, delta_ts(j));
                t_series = toc;

                fprintf(fileID,'%d\t%E\t%d\t%s\t%f\n', rep, t_series, orders(i), string(parallel), delta_ts(j));
           end
        end
    end

    % this is separated from previous loop in order to start parallel pool
    % only once
    for rep=1:repetitions
        parallel = true;
        for i=1:length(orders)
            for j=1:length(delta_ts)
                tic;
                Approximate(u, x, N, tmax, orders(i), parallel, delta_ts(j));
                t_parallel = toc;
                fprintf(fileID,'%d\t%t\t%d\t%s\t%f\n', rep, t_parallel, orders(i), string(parallel), delta_ts(j));
            end
        end
    end

    fclose(fileID);
else
    % Normal mode
     Approximate(u, x, N, tmax, order, parallel, delta_t);
end

% in main you define the equation you want to aproximate and its initial
% conditions
% Here you call Approximate -> MethodStep (for each iteration) ->
% LieTrotter