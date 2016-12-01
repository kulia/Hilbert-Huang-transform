%% sift: Extracting an intrinsic mode function (IMF) from a signal. 
%
% The sifting process is as follows:
% - Identify all the local extrema in the signal.
% - Connect all the local mminima by a cubic spline line as the upper envelope.
% - Repeat the procedure for the local minima to produce the lower envelope.
% - Calculate the mean envelope
% - Subtract the mean envelope from the signal
% - Set the difference as the signal
% - repeat until the difference is satisfies the requirements for an IMF.
%
% Input: 	signal (array): one dimentional time series containing
%
% Output: 	intrinsicModeFunction (array): returns the first intrinsic mode function of the signal
%
function intrinsicModeFunction = sift(signal)
	signalLength = length(signal);

	currentModeFunction = zeros(1, signalLength);
	previousModeFunction = signal;

	% numberOfSifts = 10;
	numberOfSifts = 50;
	% numberOfSifts = 5;

	% error = 1e-4;
	error = 1e-3;  % 1e-3 showed great results!

	% disp(' ');
	% disp('-- Estimating new IMF --');
	progress = 0;
	for sifts=1:numberOfSifts % no stoppage criteria
		% if mod(sifts, fix(numberOfSifts/100)) == 0 % Print progress
		% 	progress = progress + 1;
		% 	disp(['Sifting in progress: ' num2str(progress) ' %.']);
		% end

		meanEnvelope = meanEnvelope(previousModeFunction);
		if ( ( alreadyIntrinsicModeFunction(previousModeFunction) ) & max(abs(meanEnvelope)) < error ) 
			break;
		else
			currentModeFunction = previousModeFunction - meanEnvelope;
			previousModeFunction = currentModeFunction;
		end
	end

	intrinsicModeFunction = currentModeFunction;

%% meanEnvelope: Returns the mean between a spline containing all maxima and a spline containing all minima
%
% Input: 	signal (array): one dimentional time series containing
%
% Output: 	upperEnvelope (array): returns the mean between a spline containing all the signal's maxima and a spline containing all the signal's minima
%
function meanEnvelope = meanEnvelope(signal)
	upperEnvelope = upperEnvelope(signal);
	lowerEnvelope = lowerEnvelope(signal);

	if length(upperEnvelope) > 1 & length(lowerEnvelope) > 1 % Check that the evnelopes exists
		meanEnvelope = ( upperEnvelope + lowerEnvelope ) ./ 2;
	else
		meanEnvelope = [];
	end

%% upperEnvelope: Returns the spline through all maxima
%
% Input: 	signal (array): one dimentional time series containing
%
% Output: 	upperEnvelope (array): returns the spline through the signal's maxima
%
function upperEnvelope = upperEnvelope(signal)
	signalLength = length(signal);

	[yMax, xMax] = findpeaks(signal);
	[xMax, yMax] = linearSplineNearBoundery(xMax, yMax, signal);

	upperEnvelope = spline(xMax, yMax, 1:signalLength);

%% upperEnvelope: Returns the spline through all minima
%
% Input: 	signal (array): one dimentional time series containing
%
% Output: 	upperEnvelope (array): returns the spline through the signal's minima
%
function lowerEnvelope = lowerEnvelope(signal)
	signalLength = length(signal);

	[yMin, xMin] = findpeaks(-signal);
	[xMin, yMin] = linearSplineNearBoundery(xMin, yMin, -signal);
	yMin = -yMin;

	lowerEnvelope = spline(xMin, yMin, 1:signalLength);