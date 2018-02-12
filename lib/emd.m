%% emd: Retrive the intrinsic mode functions of a signal by applying the empirical mode decomposition method
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
function [allIntrinsicModeFunctions, residue] = emd(signal)
	if size(signal, 1) > size(signal, 2)
		signal = signal';
	end

	allIntrinsicModeFunctions = [];

	if alreadyIntrinsicModeFunction(signal)
		% disp('Signal is already an IMF');
		allIntrinsicModeFunctions = signal';
	elseif alreadyResidue(signal)
		allIntrinsicModeFunctions = 0;
	else
		% disp('Signal is not IMF. Run EMD.');
		signalLength = length(signal);

		numberOfImf = numberOfImf(signalLength);

		allIntrinsicModeFunctions = zeros(signalLength, numberOfImf);

		residue = signal;
		for i = 1:numberOfImf
			intrinsicModeFunction = sift(residue);
			allIntrinsicModeFunctions(:, i) = intrinsicModeFunction(:);

			residue = residue - intrinsicModeFunction;
			if alreadyIntrinsicModeFunction(residue)
				allIntrinsicModeFunctions(:, i+1) = residue;
				allIntrinsicModeFunctions = allIntrinsicModeFunctions(:, 1:i+1);
				residue = zeros(signalLength, 1);
				break
			elseif alreadyResidue(residue)
				allIntrinsicModeFunctions = allIntrinsicModeFunctions(:, 1:i);
				break;
			end
		end
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