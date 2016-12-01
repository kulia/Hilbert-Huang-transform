%% differentiate: Returns the 
%
% Copyright (C) Signal Analysis Lab AS - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% Written by Geir Kulia <geir.kulia@1991.ieee.org> from august 2015
% 
function diff = differentiate(signal, stepSize)
	% diff = fivePointStencil(signal, stepSize);
	diff = eulerForward(signal);
	% diff = simpleMovingAverage(diff, stepSize);

%% Five-point stencil: 5th method for differentiation
%
% For more information about the method, see
% https://en.wikipedia.org/wiki/Five-point_stencil
%
% Inputs:
%  
%  signal (array): One dimentional time series
 
%  stepSize (int): Spacing between points in signal. Usually one.
%
% Output:
%
%  diff (array): The derivative of signal. Sets 2 * stepSize amount of elements of the ends of diff to zero to be discarded.
%
function diff = fivePointStencil(signal, stepSize)
	% diff = zeros(1, length(signal));
	% diff = nan(1, length(signal));
	diff = eulerForward(signal);

	for i = 2 * stepSize+1 : length(signal) - 2 * stepSize
		diff(i) = ( -signal(i + 2*stepSize) + 8 * signal(i + stepSize) - 8 * signal(i - stepSize) + signal(i - 2*stepSize) ) / (12 * stepSize);
	end



% Euler Forward: Simple method for differentiation
%
% Inputs:
%  
%  signal (array): One dimentional time series
%  
% Output:
%
%  diff (array): The derivative of signal. Sets 1 element of the end of diff to zero to be discarded.
%
function diff = eulerForward(signal)
	for i = 2:length(signal)-1
		diff(i) = (signal(i+1)-signal(i));
	end

	diff(length(signal)) = nan;

%% matrixMethod: function description
function diff = matrixMethod(signal)
	% signal must be normalized
	h = hilbtm(signal);

	diff(1) = 0;

	arg1 = -h(3:end);
	arg2 = conj(-h(1:end-2));

	diff(2:length(signal)-1) = angle( arg1 .* arg2 + pi );

	diff(1) = diff(2);
	diff(end+1) = diff(end);


