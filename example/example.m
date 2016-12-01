addpath('../lib')
set(0,'defaultaxesfontname','times new roman');
close all;

fig = 0;
fontSize = 24;
path_to_figures = '../fig/examples/';
mkdir(path_to_figures)

samplingFrequency = 10e3;
samplingPeriod = 1/samplingFrequency;

time = (1 : samplingPeriod : 2);

amplitude_0 = 1;
omega_0 = 2 * pi * 50;

amplitude_1 = 0.5;
omega_1 = 2 * pi * 70;

voltageWaveform = amplitude_0 * sin(omega_0 * time) ...
				+ amplitude_1 * cos(omega_1 * time .^2);

% Normalizing for the sake of simplicity
voltageWaveform = voltageWaveform ./ max( abs(voltageWaveform) );

%----------------------------------------------------------------
%			Plot voltage waveform
%----------------------------------------------------------------

fig = fig + 1;
figure(fig)
clf(fig)
box on

plot(1000 * time, voltageWaveform, 'b')
xlabel('Time [ms]')
ylabel('Voltage [pu]')

h = legend('$$v(t)$$');
set(h,'Interpreter','latex')
set(h,'FontSize',fontSize)

xlim([1400 1500])

ax = gca;
ax.FontSize = fontSize;

saveas(fig, [path_to_figures 'raw'] , 'png')

%----------------------------------------------------------------
%			Empirical Mode Decomposition
%----------------------------------------------------------------

[intrinsicModeFunctions, res] = emd(voltageWaveform);

fig = fig + 1;
figure(fig)
clf(fig)
box on
hold on

plot(1000 * time, intrinsicModeFunctions(:, 1), 'b')
plot(1000 * time, -1.1+intrinsicModeFunctions(:, end), 'r')
plot(1000 * time, -2.1+res, 'k--')
xlabel('Time [ms]')
ylabel('Voltage [pu]')

h = legend('$$c_1(t)$$', '$$c_2(t)$$', '$$r(t)$$');
set(h,'Interpreter','latex')
set(h,'FontSize',fontSize)

xlim([1400 1500])

ax = gca;
ax.FontSize = fontSize;
ax.YTick = [];

saveas(fig, [path_to_figures 'imf'] , 'png')

%----------------------------------------------------------------
%			Hilbert Spectrum
%----------------------------------------------------------------
fig = fig + 1;
figure(fig)
clf(fig)
box on
hold on
hilbertSpectrum(intrinsicModeFunctions(:, 1), samplingFrequency, 0.02 * samplingFrequency)
hilbertSpectrum(intrinsicModeFunctions(:, 2), samplingFrequency, 0.02 * samplingFrequency)
h = legend('$$c_1(t)$$', '$$c_2(t)$$');
set(h,'Interpreter','latex')
set(h,'FontSize',fontSize)
ax = gca;
ax.FontSize = fontSize;
saveas(fig, [path_to_figures 'hs'] , 'png')
