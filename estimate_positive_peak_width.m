%******************************************************************
% Code to estimate the width of the base of a positive peak
%******************************************************************
% Programmer: G. Laguna
% Date: may. 31 2024
% Universidad Automoma Metropolitana 
% Unidad Lerma
%******************************************************************

%Estimate de peak width
function peak_width = estimate_positive_peak_width(y,target_ix,floor_level_treshold)
%Inputs:
%   y: Vector with bins.
%   target_ix: Reference point index.
%   floor_level_treshold: Fraction of the reference magnitude, in }(0,1],
%                         where the floor starts (low level).
%Outputs:
%   peak_width: peak width in samples

    len=length(y);
    floor_level = floor_level_treshold*y(target_ix);

    
    up_ix=len; %Default value
    down_ix=1; %Default value
    
    %Search up:
    i=target_ix+1;
    while (i<=len) & (y(i)>floor_level)    
        i=i+1; 
    end
    
    if (i<=len) & (y(i)<=floor_level)
        up_ix=i; 
    end
    
    %Search down:
    i=target_ix-1;
    while (i>=1) & (y(i)>floor_level)    
        i=i-1; 
    end
    
    if (i>=1) & (y(i)<=floor_level)
        down_ix=i; 
    end
    
    peak_width = up_ix-down_ix;
    