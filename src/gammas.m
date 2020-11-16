% See eq. 3b of the Affine Combinator of splitting (...) paper
% 1/2 = γ_1 + γ_2 + ... + y_n
% 0   = γ_1 + 2^{-2j}γ_2 + ... + n^{-2j}γ_n
% Here I'm renaming the variables used in the paper to the ones used here
% for a more clear connection between Math - Code :P
function X = gammas(n)
    A = [ ones(1,n) ];
    B = [ 1/2 ];

    %% Max n we are accepting is 10.
    if n > 10
        disp("Something went wrong... n>10. Setting n=10")
        n = 10
    end 
    for j=1:floor(n/2)
        A = [A; [1:1:n].^(-2*j)];
        B = [B; 0];
        
    end
    X = linsolve(A,B);
end