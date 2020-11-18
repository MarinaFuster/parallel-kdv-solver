function S = MethodStep(U, k, delta_t, order, parallel)
    X = gammas(order); % we obtain gammas for intended order
    S = zeros(size(U)); % we'll save result in S
    
    if (parallel)
        parfor n=1:2*order
            if mod(n, 2) == 0
                S = S + X(n/2)*LieTrotterStep(U, k, delta_t, n/2, true); % Reverse Lie Trotter 
            else
                S = S + X((n+1)/2)*LieTrotterStep(U, k, delta_t, (n+1)/2, false); % Non Reverse Lie Trotter
            end
        end
    else
        for n=1:2*order
            if mod(n, 2) == 0
                S = S + X(n/2)*LieTrotter(U, k, delta_t, n/2, true); % Reverse Lie Trotter
            else 
                S = S + X((n+1)/2)*LieTrotter(U, k, delta_t, (n+1)/2, false); % Non Reverse Lie Trotter
            end
        end
    end
end