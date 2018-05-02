%% hilbert_spectrum: Create the hilbert spectrum of given intrinsic mode functions
%
% Input:	
%
%	intrinsicModeFunctions (Matrix): a matrix containing all the intrinsic mode functions of signal. Each column contain one IMF
%
%	samplingFrequency (int): the sampling rate of the signal. Used to convert time and frequency to real rather than discrete values
%
%	medianFilterLength (int):
%
function hilbertSpectrum(intrinsicModeFunctions, samplingFrequency, medianFilterLength) 
	number_of_imf = size(intrinsicModeFunctions, 2);
	length_of_imf = size(intrinsicModeFunctions, 1);

	time = 1:length_of_imf;
	time = time ./ samplingFrequency;

	hold on
	for i = 1:number_of_imf
		[frequency, amplitude] = hilbertMethod(intrinsicModeFunctions(:, i), samplingFrequency);

	   	amplitude = 20 * log10(abs(amplitude));
	   	% amplitude = amplitude .^2;

	   	frequency = abs(frequency);
	   	if medianFilterLength > 0
	   		frequency = medfilt1(frequency, medianFilterLength);
	   		amplitude = medfilt1(amplitude, medianFilterLength);
        end

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

	% Uncomment next line to set blue background color
	% set(gca,'Color',[0 0 0.5156]);
