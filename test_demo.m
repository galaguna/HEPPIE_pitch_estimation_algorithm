%******************************************************************
%Demo for HEPPIE pitch estimation algorithm
%******************************************************************
% Programmer: G. Laguna
% Date: may. 31 2024
% Universidad Automoma Metropolitana 
% Unidad Lerma
%******************************************************************

%Load the audio:
 [s,Fs] = audioread('TinySOL_octaves.wav'); 

%Set and execute pith estimation:
 window_size= 0.1;%[secs]
 hop_size= 0.1;%[secs]
 resolution= 10;%[Hz]
 [f_p,loc] = heppie(s,Fs,window_size,hop_size,resolution);

%Graphing: 
 t=(1/Fs)*loc;
 t_true=[0.01:0.01:7];
 f_true=[65.4*ones(1,100),130.8*ones(1,100),261.6*ones(1,100),523.3*ones(1,100),1046.5*ones(1,100),2093.0*ones(1,100),4186.0*ones(1,100)];

 semilogy(t,f_p,t_true,f_true);
 legend('estimated freq.','true freq.');
 title('Pitch tracking');
 xlabel('Time [sec]');
 ylabel('Freq. [Hz]');
    