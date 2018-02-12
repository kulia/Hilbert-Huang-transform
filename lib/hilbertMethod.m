function [instantaniousFrequency, instantaniousAmplitude] = hilbertMethod(signal, samplingFrequency)
	signalLength = length(signal);

	[signal, instantaniousAmplitude] = scaleAmpltudes(signal);
	
	h = hilbtm(signal);
	phase = angle(h);
	phase = unwrap(phase);
	instantaniousFrequency = (samplingFrequency / (2*pi)) * differentiate(phase, 15);