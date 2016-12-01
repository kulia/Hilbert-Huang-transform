%% alreadyIntrinsicModeFunction: Test if the signal has a zerocrossing between each extrema
%
% Intput: 
%	signal (array): One dimentional time series
%
% Output:	
%	alreadyIMF (boolean): 1 if IMF, 0 if not.
%
function alreadyIMF = alreadyIntrinsicModeFunction(signal)
	[yMax, xMax] = findpeaks(signal);

	[yMin, xMin] = findpeaks(-signal);
	yMin = -yMin;

	alreadyIMF = 1;
	% if ( sum(abs(yMax(yMax<0))) > 0 ) & ( sum(abs(yMin(yMin>0))) > 0 )
	% 	alreadyIMF = 0;
	% 	% disp('Signal is IMF.');
	% else
	% 	alreadyIMF = 1;
	% end


	if sum(length(xMin)+length(xMax)) < 1 | length(yMax(yMax < 0)) + length(yMin(yMin > 0)) > 0
		alreadyIMF = 0;
		% disp('Signal is not IMF. Run EMD. (1)');
	else
		for index = 1:(length(xMax)-1)
			if(length(xMin(xMin > xMax(index) & xMin < xMax(index+1))) > 1)
				alreadyIMF = 0;
				% disp('Signal is not IMF. Run EMD. (2)');
				break;
			end
			% disp(['Progress: ' num2str(100*index/length(xMax)-1) ' %.'])
		end
	end