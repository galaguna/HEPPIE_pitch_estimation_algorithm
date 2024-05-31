%******************************************************************
% Code to find the next local maximum with respect to a reference point
%******************************************************************
% Programmer: G. Laguna
% Date: may. 31 2024
% Universidad Automoma Metropolitana 
% Unidad Lerma
%******************************************************************

%Find the next local maximum with respect a reference point
function next_max_ix = find_next_local_max(m,target_ix)
%Inputs:
%   m: Vector with local maximums marks (1 where maximum detected).
%   target_ix: Reference point index.
%Outputs:
%   next_max_ix: Index of maximum next to reference point. 
%                Note: If return 0 value, there is no other maximum.

    len=length(m);
    next_max_ix=0;%Default value 
    
    %Search up:
    i=target_ix+1;
    while (i<=len) & (m(i)~=1)    
        i=i+1; 
    end
    
    if (i<=len) & (m(i)==1)
        next_max_ix=i; 
    end
    
