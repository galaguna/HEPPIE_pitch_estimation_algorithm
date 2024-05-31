%******************************************************************
%Code to determine the fundamental frequency under the criterion of 
%minimal distance between peak marks (including one at zero frequency).
%******************************************************************
% Programmer: G. Laguna
% Date: may. 31 2024
% Universidad Automoma Metropolitana 
% Unidad Lerma
%******************************************************************

%Function to estimate de fundamental freq.
function fund_freq= find_fundamental_freq(m,fs,fft_size)
%Inputs:
%   m: Vector with local maximums marks (1 where maximum detected).
%   fs: Sampling freq.
%   fft_size: Length of FFT window
%Output:
%   fund_freq: Estimated fundamental freq.

fo= fs/fft_size; %Freq. step
len=length(m);

d_ix=1;
distance(d_ix)=0; %By default
for i=1:len-1    
    if(m(i)==1) %If there is a peak mark
        next_max_ix = find_next_local_max(m,i);
        if next_max_ix >0 %If a next local max was found
            distance(d_ix)=next_max_ix-i;
            d_ix=d_ix+1;
        end
    end
end

[min_distance,min_ix] = min(distance); %min value and index

fund_freq=min_distance*fo;
