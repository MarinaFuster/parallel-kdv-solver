clc

continue_asking = true;

while continue_asking
    run_mode = input('What mode do you want to run? (metrics|normal)> ', 's');
    if ~strcmp(run_mode, 'metrics') && ~strcmp(run_mode, 'normal')
        disp('Invalid option, try again :)')
    else
        continue_asking = false;
    end
end
if strcmp(run_mode, 'metrics')
    runMetrics=true;
else
    runMetrics = false;
end

continue_asking = true;
if ~runMetrics
    order = input("What order would you like to run the algorihtm?> ");
    delta_t = input("What deltaT would you like to run it with? (default: 0.0005)> ");

    while continue_asking
        p_mode = input('Should we run parallel mode or serial?(parallel|serial)> ', "s");
        if ~strcmp(p_mode, 'parallel')&& ~strcmp(p_mode, 'serial')
            disp('Inalid option. Mode must be parallel or serial.')
        else
            continue_asking = false;
        end
    end

    if strcmp(p_mode, 'parallel')
        parallel = true
    else
        parallel = false
    end
else
    % Metrics mode
    disp("Running in metrics mode with orders 2, 4 and 6")
    orders = [2, 4, 6];
    repetitions = 5
end
% Normal mode
%order = 4;
%delta_t = 0.0005;
%parallel = false;



delta_ts = [0.001, 0.005, 0.0001, 0.0005];

N = 256;
x = linspace(-10,10,N);
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
    fprintf(fileID,'%s\t%s\t%s\t%s\t%s\n','time','order', 'parallel', 'delta_t', 'repetition');

    parallel = false;
    for i=1:length(orders)
        for j=1:length(delta_ts)
           for rep=1:repetitions
                tic;
                results = Approximate(u, x, N, tmax, orders(i), parallel, delta_ts(j));
                t_series = toc;

                fprintf(fileID,'%E\t%d\t%s\t%f\t%d\n', t_series, orders(i), string(parallel), delta_ts(j), rep);
           end
        end
    end

    % this is separated from previous loop in order to start parallel pool
    % only once
    parallel = true;
    for i=1:length(orders)
        for j=1:length(delta_ts)
            for rep=1:repetitions
                tic;
                result = Approximate(u, x, N, tmax, orders(i), parallel, delta_ts(j));
                t_parallel = toc;

                fprintf(fileID,'%E\t%d\t%s\t%f\t%d\n', t_parallel, orders(i), string(parallel), delta_ts(j), rep);
            end
        end
    end

    fclose(fileID);
else
    % Normal mode
    Approximate(u, x, N, tmax, order, parallel, delta_t);
end
