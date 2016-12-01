%% alreadyResidue: Recognize monotone signal to trigger a stop of the sifting process.
%
% Intput: 
%	signal (array): One dimentional time series
%
% Output:	
%	alreadyResidue (boolean): 1 if residue, 0 if not.
%
% Copyright (C) Signal Analysis Lab AS - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% Written by Geir Kulia <geir.kulia@1991.ieee.org> from august 2015
% 
function alreadyResidue = alreadyResidue(signal)
	[yMax, xMax] = findpeaks(signal);
	[yMin, xMin] = findpeaks(-signal);

	if (length(xMin))+(length(xMax)) < 2
		% disp(['Already IMF: ' num2str()]);
		alreadyResidue = 1;
	else
		alreadyResidue = 0;
	end