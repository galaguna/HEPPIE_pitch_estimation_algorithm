%******************************************************************
%Code to find significant peaks, from the derivative and 
%zero crossing points, by means of a derivative wavelet
%matched filter.
%******************************************************************
% Programmer: G. Laguna
% Date: may. 31 2024
% Universidad Automoma Metropolitana 
% Unidad Lerma
%******************************************************************

%Find significant maximum points,by means derivative 
%function and detecting zero crossing
%points, from plus to minus, with a wavelet matched filter
function [m,main_ix]= find_significant_peaks(y,treshold)
%Inputs:
%   y: Input vector with function with maximum points. 
%   treshold: Fraction of the maximum value, in (0, 1], as significative level. 
%Outputs:
%   m: vector with local maximums marks (1 where maximum detected).
%   main_ix: index to main maximum

len=length(y);
m=zeros(1,len); %Significative maximum points, by default

%Differentiator filter:
b_d=[1 -1];
d=filter(b_d,1,y); %Derivative function
d_ls=d(1+1:length(d)); %Left shift to compensate filter latency
                       %[length(b_d)/2]+1

%Estimate de wavelet_len:
[Peak,Peak_ix] = max(d_ls); %Maximum value and index
p_peak_width = estimate_positive_peak_width(d_ls,Peak_ix,0.01);
wavelet_len=2*p_peak_width;

%Wavelet profile:
t=[0:2*pi/wavelet_len:2*pi-(2*pi/wavelet_len)];
b_r=-sin(t); %Wavelet as a matched filter coeficients to correlation function
%Correlation function (matched filter):
r=filter(b_r,1,d_ls);
r_ls=r(p_peak_width+1:length(r)); %Left shift to compensate filter latency
                                  %[length(b_r)/2]+1
%Default mark at zero freq.:
m(1)=1; 
%First local maximum:
[A,main_ix] = max(r_ls); %Maximum value and index
significative_level = A*treshold;
m(main_ix)=1; %Maximum mark

%Working vector:
r_w= clean_around_ix(r_ls,main_ix,wavelet_len);%Clear local maximum zone

%Second local maximum:
[A,max_ix] = max(r_w); %Maximum value and index
if  A > significative_level  %There are more than one significative bins:
    m(max_ix)=1; %Maximum mark

    while A > significative_level  
        r_w= clean_around_ix(r_w,max_ix,wavelet_len);%clear local maximum zone
        [A,max_ix] = max(r_w); %Maximum value and index
        if  A > significative_level
            m(max_ix)=1; %Maximum mark
        end
    end
end
