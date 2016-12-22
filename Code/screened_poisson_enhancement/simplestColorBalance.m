function [ Ic ] = simplestColorBalance( I, s )
% Implements the color balance from
% N. Limare, J.L. Lisani, J.M. Morel, A.B. Petro, and C. Sbert, Simplest Color Balance, 
% Image Processing On Line, (2011). http://dx.doi.org/10.5201/ipol.2011.llmps-scb

I = double(I);
Ic = I;
[m,n] = size(I);
data = sort(reshape(I,1,m*n));
per = round(s*m*n/100);
minVal = data(per);
maxVal = data(m*n-1-per);

if (maxVal <= minVal)
    for i = 1:m
        for j = 1:n
            Ic(i,j) = maxVal;
        end
    end
else
    for i = 1:m
        for j = 1:n
            if Ic(i,j) < minVal   % saturate at 0
                Ic(i,j) = 0;
            elseif Ic(i,j) > maxVal  % saturate at 255
                Ic(i,j) = 255;
            else
                Ic(i,j) = 255*(Ic(i,j)-minVal)/(maxVal-minVal); % color balance
            end
        end
    end   
end

end

