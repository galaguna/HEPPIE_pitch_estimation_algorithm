%******************************************************************
% Code for clearing a point boundary in a sequence
%******************************************************************
% Programmer: G. Laguna
% Date: may. 31 2024
% Universidad Automoma Metropolitana 
% Unidad Lerma
%******************************************************************

%Function to clean with zeros around a reference point.
function y= clean_around_ix(x,ix,radio)
%Inputs:
%   x: Input vector.
%   ix: Reference point.
%   radio: Samples to clean around de reference poit.
%Outputs:
%   y: Output vector.

x_len=length(x); %Signal length

y=x;
for i=-radio:radio 
    current_ix=ix-i;
    if(current_ix>0) & (current_ix<=x_len)
        y(current_ix)=0;
    end
end