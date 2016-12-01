%% scaleAmpltudes: function description
%
% Copyright (C) Signal Analysis Lab AS - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% Written by Geir Kulia <geir.kulia@1991.ieee.org> from august 2015
% 
function [signalScaled, instantaniousAmplitude] = scaleAmpltudes(signal)
	signalLength = length(signal);

	signalScaled = signal;
	correctionCurve = 1;

	for i = 1:3
		[tmpcorrectionCurve] = getCorrectiongCurve(signalScaled);

		if size(signalScaled, 1) > size(signalScaled, 2)
			signalScaled = signalScaled';
		end

		if size(correctionCurve, 1) > size(correctionCurve, 2)
			correctionCurve = correctionCurve';
		end

		signalScaled = signalScaled ./ tmpcorrectionCurve;
		correctionCurve = tmpcorrectionCurve .* correctionCurve;
	end

	% signalScaled(abs(signalScaled) > 1.1) = 0;

	instantaniousAmplitude = correctionCurve;

%% getCorrectiongCurve: function description
function [correctionCurve] = getCorrectiongCurve(signal)
	signalLength = length(signal);

	[yMax, xMax] = findpeaks( abs(signal) );

	% Add endpoints to extrame to correct some end-effects
	[xMax, yMax] = linearSplineNearBoundery(xMax, yMax, signal);

	correctionCurve = spline(xMax, yMax, 1:signalLength);
	% correctionCurve = pchip(xMax, yMax, 1:signalLength);