function U = LieTrotter(U, k, delta_t, order, is_reverse)
    for n=1:order
        if is_reverse                           % Reverse step we apply (Non Linear o Linear).
            U = nonlinear(U, k, delta_t/order );
            U = linear(U, k, delta_t/order);
        else                                    % On foward step (Linear o Non Linear)
            U = linear(U, k, delta_t/order);
            U = nonlinear(U, k, delta_t/order);
        end
    end
end

% Linear step of Lie Trotter
function U = linear(U, k, delta_t)
    U = U.*exp(1i*k.^3*delta_t); % From applying Fourier transform to equation
end

% Non linear step of Lie Trotter algorithm
function U = nonlinear(U, k, delta_t)
    U = U - (3i*k*delta_t).*fft((real(ifft(U))).^2); %From applying Fourier transform to equation
end