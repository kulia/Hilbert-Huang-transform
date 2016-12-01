%% hilbert_spectrum: Create the hilbert spectrum of given intrinsic mode functions
%
% Input:	
%
%	intrinsicModeFunctions (Matrix): a matrix containing all the intrinsic mode functions of signal. Each column contain one IMF
%
%	samplingFrequency (int): the sampling rate of the signal. Used to convert time and frequency to real rather than discrete values
%
%	interpolationLength (float):
%
%	medianFilterLength (int):
%
%	method (string): 'h' or 'hilbert' for hilbert transform, whatever else for quadrature
%
% Copyright (C) Signal Analysis Lab AS - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% Written by Geir Kulia <geir.kulia@1991.ieee.org> from august 2015
% 
function hilbertSpectrum(intrinsicModeFunctions, samplingFrequency, medianFilterLength) 
	number_of_imf = size(intrinsicModeFunctions, 2);
	length_of_imf = size(intrinsicModeFunctions, 1);

	time = 1:length_of_imf;
	time = time ./ samplingFrequency;

	hold on
	for i = 1:number_of_imf
		[frequency, amplitude] = hilbertMethod(intrinsicModeFunctions(:, i), samplingFrequency);
		% if strcmp(method, 'hilbert') | strcmp(method, 'h')
		% 	[frequency, amplitude] = hilbertMethod(intrinsicModeFunctions(:, i), samplingFrequency);
	 	% else
	 	% 	[frequency, amplitude] = quadratureMethod(intrinsicModeFunctions(:, i), samplingFrequency, interpolationLength);
	 	% end

	   	amplitude = 20 * log10(abs(amplitude));
	   	% amplitude = amplitude .^2;

	   	frequency = abs(frequency);
	   	if medianFilterLength > 0
	   		frequency = medfilt1(frequency, medianFilterLength);
	   		amplitude = medfilt1(amplitude, medianFilterLength);
	   	end
	   	
	   	length_of_frequency = length(frequency);

		surface([time(:), time(:)], [frequency(:), frequency(:)], [amplitude(:), amplitude(:)], ...
	    	[amplitude(:), amplitude(:)], 'EdgeColor','flat', 'FaceColor','none');

	end

	setColorMapAndLabels()

%% setColorMap: set colormap and labels for the Hilbert Spectrum
function setColorMapAndLabels()
	colormap(jet);
	col = colorbar;

	ylabel(col,'Power [dB]', 'Interpreter', 'Latex')
	set(gca,'YDir','normal');
	xlabel('Time [s]', 'Interpreter', 'Latex');
	ylabel('Frequency [Hz]', 'Interpreter', 'Latex');

	% Uncomment next line to set bluebackground color
	% set(gca,'Color',[0 0 0.5156]);