%% hilbertMethod: function description
%
% Copyright (C) Signal Analysis Lab AS - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% Written by Geir Kulia <geir.kulia@1991.ieee.org> from august 2015
% 
function [instantaniousFrequency, instantaniousAmplitude] = hilbertMethod(signal, samplingFrequency)
	signalLength = length(signal);

	[signal, instantaniousAmplitude] = scaleAmpltudes(signal);
	
	% h = hilbert(signal);
	h = hilbtm(signal);
	phase = angle(h);
	phase = unwrap(phase);
	instantaniousFrequency = (samplingFrequency / (2*pi)) * differentiate(phase, 15);

