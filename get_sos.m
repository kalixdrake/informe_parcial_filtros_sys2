Rp = 1;
Rs = 15;
fp = 10.3125e3;
fs = 11.5625e3;
Wp = 2*pi*fp;
Ws = 2*pi*fs;
[n1,Wn1] = cheb1ord(Wp,Ws,Rp,Rs,'s');
% analog
[b_a,a_a] = cheby1(4,Rp,Wn1,'low','s');
disp('Analog Roots:');
[p_a, z_a] = pzmap(tf(b_a,a_a));
disp(p_a);
% digital IIR (Bilinear)
Fs = 75000;
[b_d, a_d] = bilinear(b_a, a_a, Fs);
[sos, g] = tf2sos(b_d, a_d);
disp('Digital IIR SOS:');
disp(sos);
disp(g);
