clc
clear
close all

%% Parámetros del sistema

fs = 75000;        % frecuencia de muestreo
N = 200;           % orden del filtro

% frecuencias de símbolos FSK
f1 = 10700;
f2 = 11900;
f3 = 13100;
f4 = 14300;

% frecuencias de corte
fc1 = 11300;
fc2 = 12500;
fc3 = 13700;

% normalización
W1 = fc1/(fs/2);
W2 = fc2/(fs/2);
W3 = fc3/(fs/2);

%% Diseño filtros FIR con ventana de Hamming

% filtro pasabajos
b1 = fir1(N,W1,'low',hamming(N+1));

% filtro pasabanda inferior
b2 = fir1(N,[W1 W2],'bandpass',hamming(N+1));

% filtro pasabanda superior
b3 = fir1(N,[W2 W3],'bandpass',hamming(N+1));

% filtro pasaaltos
b4 = fir1(N,W3,'high',hamming(N+1));

%% Diagramas de Bode

figure
freqz(b1,1,2048,fs)
title('Filtro FIR Pasabajos')

figure
freqz(b2,1,2048,fs)
title('Filtro FIR Pasabanda Inferior')

figure
freqz(b3,1,2048,fs)
title('Filtro FIR Pasabanda Superior')

figure
freqz(b4,1,2048,fs)
title('Filtro FIR Pasaaltos')

%% Visualización profesional de todos los filtros

fvtool(b1,1,b2,1,b3,1,b4,1,'Fs',fs)
legend('LPF','BPF1','BPF2','HPF')
