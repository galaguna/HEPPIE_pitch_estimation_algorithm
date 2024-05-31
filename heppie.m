%******************************************************************
%***     HElpful and Practical PItch Estimation (heppie)      ***
%******************************************************************
% Algorithm to estimate the fundamental frequency of a musical pitch.
%******************************************************************
% Beta version that operates with parameters for
% processing window size, hop, and resolution.
%******************************************************************
% Coding of proposed technique that is suported by periodogram 
% derivative with matching filter, including processing of
% zero-paddinng, to reach resolution, and conditional spectral 
% profile filtering.
%******************************************************************
% Programmer: G. Laguna
% Date: may. 31 2024
% Universidad Automoma Metropolitana 
% Unidad Lerma
%******************************************************************
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version. See <http://www.gnu.org/licenses/>
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%******************************************************************


function [f_p,loc] = heppie(x,Fs,wsize,hop,mres)
%Inputs:
%   x: Audio secuense
%   Fs: Sampling freq. 
%           Fs>2f_max (suitably Fs could round 4*f_max)
%   wsize: Working window by estimation [sec]  
%           0.1<=wsize<=1.0 (typically 0.1 sec)
%   hop: Interval between estimates [sec]
%        (typically 0.1 sec)   
%   mres: Required minimal resolution [Hz]
%        mres>=0.1 (typically 0.1Hz for musical tones or 10Hz for voice)
%Outputs:
%   f_p: sequence with fundamental frequences estimated for 
%           each wsize audio segment.
%   loc: sequence with initial position [samples] for 
%           each wsize audio segment.

    
    [r,c]=size(x);
    %A row vector is required:
    if c==1
        x=x';
    end
    
    x_len=length(x); %Signal length
    %Validate window size
    win_len=floor(wsize*Fs);
    if win_len>x_len
        win_len=x_len;
    end

    %Iterations:    
    step=floor(hop*Fs);
    u_len=x_len-win_len;%Usefull length
    if u_len>=step
        N=floor(u_len/step);
    else
        N=1;
    end
    
    ix=1; %Index to begining of working segment
    for i=1:N
        loc(i)=ix; %Localization vector
        s=x(ix:ix+win_len-1); %Working segment
        ix=ix+step; %Next begining of working segment
        
        %Zero paddinng to reach resolution
        z_len=(Fs/mres)-win_len;
        if z_len> 0
            s=[s zeros(1,z_len)];
        end
        
        s_len=length(s);
        %Periodogram:
        S=fft(s);
        P=(1/length(S))*S.*conj(S);

        %Working sequence:
        n=floor(length(P)/2);
        w=abs(P(1:n));

        %Spectral bins filtering
        if (wsize>0.25) %Heuristic rule
            %LP Filter with fp=0.1 fs=0.2 (Nyquist normalized):
            h=[-0.056 0.007	0.023 0.046	0.075 0.105	0.130 0.147	0.153 0.147	0.130 0.105	0.075 0.046	0.023 0.007	-0.056];
            h_len=length(h);
            h_delay=floor(h_len/2)+1;
            p=filter(h,1,w);
            p_ls=p(h_delay:length(p)); %Left shift to compensate filter latency
                                  %[length(h_r)/2]+1
        else %No filtering
            p_ls=w;
        end
        
        %Detect main and significative maximums:
        [m,main_max_ix] = find_significant_peaks(p_ls,0.1);

        %Fundamental frequency estimation:
        f_p(i)=find_fundamental_freq(m,Fs,s_len);
    end