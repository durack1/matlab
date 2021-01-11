function[eke]=ssh2eke(lat,atd,ssh,N)
%SSH2EKE  Converts alongtrack sea surface height to eddy kinetic energy.
%
%   EKE=SSH2EKE(LAT,ATD,SSH,N) computes the eddy kinetic energy from the
%   altimeter sea surface height anomaly SSH, smoothed alongtrack with 
%   an N-point Hanning filter.
%
%   LAT is the latitude, and ATD is the along-track distance in 
%   kilometers.  LAT and ATD the same size as SSH(:,:,1).
%
%   You should make sure that SSH has the mean sea surface height 
%   removed in order to avoid a contribution from aliasing the geoid.
%
%   Lilly et. al (2003) use a smoothing of N=5 in the Labrador Sea.
%   
%   See also READ_PATHFINDER.
%
%   Usage: eke=ssh2eke(lat,atd,ssh,N);
%          eke=ssh2eke(lat,atd,ssh,N);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
 
dx=1000*abs(vdiff(atd));
c=10./sw_f(lat)./dx;
c=vrep(c,size(ssh,3),3);

%ssh=ssh-vrep(mssh,size(ssh,3),3);

%The absence of a factor of 1/2 is because we assume isotropy---
%i.e. we only have one of two orthogonal directions, so we have 
%to count it twice.
eke=squared(c.*vdiff(vfilt(ssh,N),1));

