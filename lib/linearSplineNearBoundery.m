%% linearSplineNearBoundery: function description
%
% Copyright (C) Signal Analysis Lab AS - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% Written by Geir Kulia <geir.kulia@1991.ieee.org> from august 2015
% 
function [xExtrema, yExtrema] = linearSplineNearBoundery(xExtrema, yExtrema, signal)
	signalLength = length(signal);

	if length(yExtrema) > 1
		%% Correct the start
		% startLinearSplineInterpolation = ( (yExtrema(2)-yExtrema(1))/(xExtrema(2)-xExtrema(1)) ) * (1 - xExtrema(1)) + yExtrema(1);
		startLinearSplineInterpolation = yExtrema(1) + (yExtrema(2)-yExtrema(1)) .* ( ( 1 - xExtrema(1) ) ./ ( xExtrema(2) - xExtrema(1) ) );

		if size(yExtrema, 1) > size(yExtrema, 2)
			xExtrema = xExtrema';
			yExtrema = yExtrema';
		end

		if signal(1) > startLinearSplineInterpolation
			yExtrema = [signal(1), yExtrema];
		else
			yExtrema = [startLinearSplineInterpolation, yExtrema];
		end
		
		%% Correct end
		% endLinearSplineInterpolation = ( (yExtrema(end)-yExtrema(end-1)) / (xExtrema(end)-xExtrema(end-1)) ) * (signalLength - xExtrema(end-1)) + yExtrema(end-1);
		endLinearSplineInterpolation = yExtrema(end-1) + (yExtrema(end) - yExtrema(end-1) ) .* ( ( signalLength - xExtrema(end-1) ) ./ ( xExtrema(end) - xExtrema(end-1) ) );

		if signal(end) > endLinearSplineInterpolation
			yExtrema = [yExtrema signal(end)];
		else
			yExtrema = [yExtrema endLinearSplineInterpolation];
		end

	else
		yExtrema = [signal(1) yExtrema signal(end)];
	end

	xExtrema = [1 xExtrema signalLength];
