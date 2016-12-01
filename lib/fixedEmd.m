%% fixed_emd: Retrive the intrinsic mode functions of a signal by applying the empirical mode decomposition method
%
% Input:	
%	signal (array): One dimentional time series
%
%	NumberOfImf (int): The number of intrinsic mode functions needed to represent a signal
%    
% Output:	
%	allIntrinsicModeFunctions (Matrix): a matrix containing all the intrinsic mode functions of signal. Each column contain one IMF
%			
%	residue (array): contains the error between the sum of all intrinsic mode functions and the original signal
%
% Copyright (C) Signal Analysis Lab AS - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% Written by Geir Kulia <geir.kulia@1991.ieee.org> from august 2015
% 
function [allIntrinsicModeFunctions, residue] = fixedEmd(signal, numberOfSifts)


	allIntrinsicModeFunctions = [];

	
	% disp('Signal is not IMF. Run EMD.');
	signalLength = length(signal);

	numberOfImf = numberOfImf(signalLength);

	allIntrinsicModeFunctions = zeros(signalLength, numberOfImf);

	residue = signal;
	for i = 1:numberOfImf
		intrinsicModeFunction = fixedSift(residue, numberOfSifts);
		allIntrinsicModeFunctions(:, i) = intrinsicModeFunction(:);

		residue = residue - intrinsicModeFunction;
	end

	residue = signal - sum(allIntrinsicModeFunctions, 2)';

%% numberOfImf: calculates the number of intrinsic mode functions needed to represent a signal.
%
% Input: 	signalLength (int): the length of the signal
%
% Output: 	NumberOfImf (int): The number of intrinsic mode functions needed to represent a signal
%
function numberOfImf = numberOfImf(signalLength)
	numberOfImf = fix(log2(signalLength))-1;

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
% Copyright (C) Signal Analysis Lab AS - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% Written by Geir Kulia <geir.kulia@1991.ieee.org> from august 2015
% 
function intrinsicModeFunction = fixedSift(signal, numberOfSifts)
	signalLength = length(signal);

	currentModeFunction = zeros(1, signalLength);
	previousModeFunction = signal;

	for sifts=1:numberOfSifts % no stoppage criteria
		meanEnvelope = meanEnvelope(previousModeFunction);
		currentModeFunction = previousModeFunction - meanEnvelope;
		previousModeFunction = currentModeFunction;
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