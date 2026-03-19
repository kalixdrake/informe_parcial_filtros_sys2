clear
clc
close all

Rp = 1;
Rs = 15;

%% CARGA DE SEÑAL
load("Prueba01.mat")

Fs = 75000;
t = (0:length(Out)-1)/Fs;

figure
plot(t,Out)
title('Señal de entrada')
xlabel('Tiempo (s)')
ylabel('Amplitud')

%% ESPECTRO DE LA SEÑAL
N = length(Out);
f = (0:N-1)*Fs/N;
X = fft(Out);

figure
plot(f,abs(X))
xlim([0 20000])
title('Espectro de la señal de entrada')
xlabel('Frecuencia (Hz)')
ylabel('|X(f)|')

%% FILTRO PASA BAJOS
fp = 10.3125e3;
fs = 11.5625e3;

Wp = 2*pi*fp;
Ws = 2*pi*fs;

[n1,Wn1] = cheb1ord(Wp,Ws,Rp,Rs,'s');

%% FILTRO PASABANDA 1
fp = [10.92e3 12.46e3];
fs = [10.3125e3 13.4375e3];

Wp = 2*pi*fp;
Ws = 2*pi*fs;

[n2,Wn2] = cheb1ord(Wp,Ws,Rp,Rs,'s');

%% FILTRO PASABANDA 2
fp = [12.46e3 14.05e3];
fs = [11.5625e3 14.6875e3];

Wp = 2*pi*fp;
Ws = 2*pi*fs;

[n3,Wn3] = cheb1ord(Wp,Ws,Rp,Rs,'s');

%% FILTRO PASA ALTOS
fp = 14.6875e3;
fs = 13.4375e3;

Wp = 2*pi*fp;
Ws = 2*pi*fs;

[n4,Wn4] = cheb1ord(Wp,Ws,Rp,Rs,'s');

%% AJUSTE DE ÓRDENES SEGÚN EL ENUNCIADO

nPB = max(n2,n3); % mismo orden para pasabanda
nEXT = max(n1,n4); % mismo orden para extremos

%% DISEÑO FINAL DE FILTROS

[b1,a1] = cheby1(nEXT,Rp,Wn1,'low','s');
[b2,a2] = cheby1(nPB,Rp,Wn2,'bandpass','s');
[b3,a3] = cheby1(nPB,Rp,Wn3,'bandpass','s');
[b4,a4] = cheby1(nEXT,Rp,Wn4,'high','s');

%% MOSTRAR ÓRDENES
disp('Orden filtro pasa bajos:')
disp(nEXT)

disp('Orden filtros pasabanda:')
disp(nPB)

disp('Orden filtro pasa altos:')
disp(nEXT)

%% FUNCIONES DE TRANSFERENCIA
disp('Funcion de transferencia pasa bajos')
tf(b1,a1)

disp('Funcion de transferencia pasabanda 1')
tf(b2,a2)

disp('Funcion de transferencia pasabanda 2')
tf(b3,a3)

disp('Funcion de transferencia pasa altos')
tf(b4,a4)

%% RESPUESTA EN FRECUENCIA DE LOS FILTROS

figure
freqs(b1,a1)
title('Respuesta filtro pasa bajos')

figure
freqs(b2,a2)
title('Respuesta filtro pasabanda 1')

figure
freqs(b3,a3)
title('Respuesta filtro pasabanda 2')

figure
freqs(b4,a4)
title('Respuesta filtro pasa altos')

%% APLICAR FILTROS

y1 = lsim(tf(b1,a1),Out,t);
y2 = lsim(tf(b2,a2),Out,t);
y3 = lsim(tf(b3,a3),Out,t);
y4 = lsim(tf(b4,a4),Out,t);

%% SEÑALES FILTRADAS

figure

subplot(5,1,1)
plot(t,Out)
title('Señal original')

subplot(5,1,2)
plot(t,y1)
title('Salida filtro pasa bajos')

subplot(5,1,3)
plot(t,y2)
title('Salida filtro pasabanda 1')

subplot(5,1,4)
plot(t,y3)
title('Salida filtro pasabanda 2')

subplot(5,1,5)
plot(t,y4)
title('Salida filtro pasa altos')

%% ESPECTRO DE LAS SEÑALES FILTRADAS

Y1 = fft(y1);
Y2 = fft(y2);
Y3 = fft(y3);
Y4 = fft(y4);

figure
subplot(4,1,1)
plot(f,abs(Y1))
xlim([0 20000])
title('Espectro salida pasa bajos')

subplot(4,1,2)
plot(f,abs(Y2))
xlim([0 20000])
title('Espectro salida pasabanda 1')

subplot(4,1,3)
plot(f,abs(Y3))
xlim([0 20000])
title('Espectro salida pasabanda 2')

subplot(4,1,4)
plot(f,abs(Y4))
xlim([0 20000])
title('Espectro salida pasa altos')
