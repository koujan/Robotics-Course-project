function [ Iout ] = screenedPoisson( I, lambda )
I = double(I);
It = (fft2(I));  % Fourier Transform of input
[m,n] = size(It);
% constant parts of the multiplier in Fourier domain
normx=(pi^2)/(m^2);
normy=(pi^2)/(n^2);
	
for i = 1:m
    for j = 1:n
        if (i==1) && (j==1)
            It(i,j) = 0;
        else
            coeff = normx*(i^2)+normy*(j^2);
            % Solution to the Screened Poisson Equation in Fourier domain
            It(i,j)=It(i,j)*coeff/(coeff+lambda);
        end
    end
end

Iout = real(ifft2(It))/(4*m*n);  % Inverse FFT, back to spatial

end

