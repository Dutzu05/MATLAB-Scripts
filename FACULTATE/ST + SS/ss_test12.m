t = 0:1e-7:2e-5;

A = 1; % amplitudinea luata din grafic care merge de la -1 la 1

fc = 1e6; % frecventa luata din primul grafic approx 20 de perioada in 2*106-5 secunde

fm = 1e5; % semnalul sursa x 2 perioade in approx 2 * 10^-5 secunde 100khz
x = cos(2*pi*fm*t);

c = A * cos(2*pi*fc*t); % purtatorul
s = A * cos(2*pi*fc*t + x);

subplot(3,1,1)
plot(t, x)

subplot(3,1,2)
plot(t, c)

subplot(3,1,3)
plot(t, s)
sgtitle('Signal Modulation Analysis'); % Add a title for the entire figure
% Add labels to the plots for clarity
xlabel('Time (s)');
ylabel('Amplitude');