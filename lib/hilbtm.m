
function h=hilbtm(x)
% This code is copyright by Norden E. HUANG (or NASA)?
% If you do any modification of this code, please keep the below comments.
% The function HILBTM performs an improved Hilbert transform
% on data x(n,k), where n specifies the length of time series, and 
% k - the number of IMF components.
% The end effect is eliminated by extension of data by the wave, 
% which is calculated from the data points found between two extrema
% across the zero crossing.
% If the wave is not found (as in residue) the data is not extended.
% The function uses an improved extrema detection.
%
% Calling sequence-
% h=hilbtm(x)
%
% Input-
%	x	- 2-D matrix x(n,k) of IMF components
% Output-
%	h	- 2-D matrix h(n,k) of improved Hilbert transform
 
% Z. Shen (JHU)		Jan. 1996   Initial
% D. Xiang (JHU)		April 4, 2002  Modified
%	(Extended both ends with 2 waves ending at zero crossing,
%        and both ends with the same slope.)
% K. Blank (NASA GSFC)	April 18, 2003 Modified
%	(Improved the detection of extrema.)
% J. Marshak (NASA GSFC)	Jan.14, 2004 Modified
%	(Corrected the case when multiple IMFs are processed.) 
% K. Arnold (NASA GSFC) August 4, 2004 Modified
%   (Bail out if a zero crossing is not found; prevents crashing
%    when processing the residual component -- still not perfect.)

%----- Get dimensions
[n,k]=size(x);
if k>n
    x=x';z=k;k=n;n=z;    
end
%----- Process each IMF component
for j=1:k
    zz= [];
    
    %----- Detect extrema -KB
    n_mx = 1; n_mn = 1;
    flagmax=0; flagmin=0;
    for i=2:n-1
        %----- Find local maximum
        if ((x(i,j) > x(i-1,j)) && (flagmax == 0))
            flagmax = 1;
            Xmax = i;
        end    
        if((x(i,j) < x(i+1,j)) && (flagmax == 1))
            flagmax = 0;
        end
        if((x(i,j) > x(i+1,j)) && (flagmax == 1))
            flagmax = 0;
            n_mx = Xmax;
        end
        
        %---- Find local minimum
        if((x(i,j) < x(i-1,j)) && (flagmin == 0))
            flagmin = 1;
            Xmin = i;
        end
        if((x(i,j) > x(i+1,j)) && (flagmin == 1))
            flagmin = 0;
        end
        if((x(i,j) < x(i+1,j)) && (flagmin == 1))
            flagmin = 0;
            
            n_mn = Xmin;
        end 
        
        if(x(n_mn,j) < 0 && x(n_mx,j) > 0) && (n_mn > 1 && n_mx > 1)
	    %----- 2 extrema found and they are across the zero crossing
            break;
        end
    end
    %----- End of extrema detection
    
    if n_mn<n_mx,
        first = n_mn;
        second = n_mx;
    else
        first = n_mx;
        second = n_mn;
    end
    
    %----- Get all y values between min and max extrema
    zz=x(first:second,j);
    %----- Get length of zz
    mm=length(zz);
    %----- Calculate the number of times to copy artificial wave
    if mm==1
        %----- Do not extend data if no wave found -JM
        x(:,j)=hilbert(x(:,j));
        continue;
    end
    ia=fix(first/(2*(mm-1)))+1;
    %----- Modify constant from 1 to 2. Do it at least twice -DX
    iaa=max(ia,2);
    %----- Reverse all the y values between the min and max extrema 
    zz1=flipud(zz); %zz1 is zz
    
    if n_mn<n_mx
        x1=zz1; %copy those values to x1
    else
        x1=[zz;zz1(2:mm)];
    end
    %----- Copy the artificial wave 2 times
    for jj=1:iaa,
        x1=[x1;zz(2:mm);zz1(2:mm)];
    end
    %----- Find the first zero-crossing and the slope -DX
    r=length(x1);
    n0 = [];
    for kk=1:r-1
        if((x1(kk)*x1(kk+1))<=0)
            if(abs(x1(kk)) > abs(x1(kk+1)))
                n0=kk; %found zero crossing
            else
                n0=kk+1; %found zero crossing
            end
            s0=x1(kk+1)-x1(kk); %calculate the slope
            break;
        end
    end
    if isempty(n0)
        %----- Do not extend data if no wave found -JM
        x(:,j)=hilbert(x(:,j));
        continue;
    end

    %----- Copy all artificial wave values from zero crossing to end
    x1=x1(n0:r); 
    %----- Attach actual y values from the minimum extrema
    %----- to the end of the dataset
    x1=[x1;x(first+1:n,j)];
    sz=length(x1); %length of x1
    np1=sz-n; %length of artificial wave portion of x1

    %---------------------Treat the tail----------------------------

    %----- Detect extrema -KB
    n_mx = 1; n_mn = 1;
    flagmax=0; flagmin=0;
    x_flip = fliplr(x1');
    for i=2:sz-1
        %----- Find local maximum
        if ((x_flip(i) > x_flip(i-1)) && (flagmax == 0))
            flagmax = 1;
            Xmax = sz-i;
        end    
        if((x_flip(i) < x_flip(i+1)) && (flagmax == 1))
            flagmax = 0;
        end
        if((x_flip(i) > x_flip(i+1)) && (flagmax == 1))
            flagmax = 0;
            n_mx = Xmax;
        end
        
        %----- Find local minimum
        if((x_flip(i) < x_flip(i-1)) && (flagmin == 0))
            flagmin = 1;
            Xmin = sz-i;
        end
        if((x_flip(i) > x_flip(i+1)) && (flagmin == 1))
            flagmin = 0;
        end
        if((x_flip(i) < x_flip(i+1)) && (flagmin == 1))
            flagmin = 0;
            n_mn = Xmin;
        end 
        
        if(x_flip(sz-n_mn) < 0 && x_flip(sz-n_mx) > 0) && (n_mn > 1 && n_mx > 1)
            %----- 2 extrema found and they are across the zero crossing
            break;
        end
    end
    clear x_flip;
    %----- End extrema detection

    if n_mn<n_mx
        first = n_mn;
        second = n_mx;
    else
        first = n_mx;
        second = n_mn;
    end

    %----- Use all y values between xmin and xmax
    zz=x1(first:second);
    mm=length(zz);
    %----- Reverse order of y values 
    zz1=flipud(zz);
    %----- Calculate the number of copies of artificial wave to make
    if mm==1
        %----- Do not extend data if no wave found -JM
        continue;
    end
    ia=fix((sz-second)/(2*(mm-1)))+1;
    %----- DX, modify constant from 1 to 2. At least 2
    iaa=max(ia,2);
    
    if(n_mn< n_mx)
         %----- Attach initial wave segment       
        x1=[x1(1:second);zz1(2:mm)];
        for jj=1:iaa
            %----- Copy artificial waves and append them to x1
            x1=[x1;zz(2:mm);zz1(2:mm)];
        end
        %----- Attach last wave segment
        x1=[x1;zz(2:mm-1)];
    else
        x1=x1(1:second);
        for jj=1:iaa
            %----- Copy artificial waves and append them to x1
            x1=[x1;zz1(2:mm);zz(2:mm)];
        end
        %----- Attach last wave segment       
        x1=[x1;zz1(2:mm-1)];
    end
     
    %----- DX, find the first zero-crossing and the slope
    r = length(x1);
    n0 = [];
    for k=1:r-1
        kk=r-k+1;
        if((x1(kk)*x1(kk-1))<=0)
            if(abs(x1(kk)) > abs(x1(kk-1)))
                n0=kk;
            else
                n0=kk-1;
            end
            if(((x1(kk)-x1(kk-1))*s0)>0)   %same sign as s0
                break;
            end
        end
    end
    if isempty(n0)
        %----- Do not extend data if no wave found -JM
        x(:,j)=hilbert(x(:,j));
        continue;
    end
    x1=x1(1:n0);

    %----- Calculate hilbert transform
    x1=hilbert(x1);
    if ((np1+n-1)<=n0)
        %----- Truncate artificial elements of dataset
	x(:,j)=x1(np1:np1+n-1);
    else
        np2=n0-np1;
        x(1:np2,j)=x1(np1:n0-1);
    end
end
%----- End of the processing the IMFs

%----- Assign the output
h=x;
clear x