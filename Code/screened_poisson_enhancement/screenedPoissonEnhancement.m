function [ Iout ] = screenedPoissonEnhancement( I, lambda, s )
% MATLAB Implementation of the C code by Sbert and Petro (see reference)

if (size(I,3) > 1)
    [m,n,~] = size(I);
    
    % Process each color channel separately
    IR = simplestColorBalance( reshape(I(:,:,1),m,n), s );  % Color balance the input
    It = screenedPoisson( IR, lambda );           % Screened Poisson equation based filtering
    Iout(:,:,1) = reshape( simplestColorBalance(It,s), m, n, 1); % Color balance the output
    
    % Repeat for other 2 channels
    IG = simplestColorBalance( reshape(I(:,:,2),m,n), s );
    It = screenedPoisson( IG, lambda );
    Iout(:,:,2) = reshape( simplestColorBalance(It,s), m, n, 1); 
    
    IB = simplestColorBalance( reshape(I(:,:,3),m,n), s );
    It = screenedPoisson( IB, lambda );
    Iout(:,:,3) = reshape( simplestColorBalance(It,s), m, n, 1); 
else
    % Grayscale case
    Ic = simplestColorBalance( I, s );
    It = screenedPoisson( Ic, lambda );
    Iout = simplestColorBalance(It,s);
end

end

