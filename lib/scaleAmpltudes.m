%% scaleAmpltudes: function description
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