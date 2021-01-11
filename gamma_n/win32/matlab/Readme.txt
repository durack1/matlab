
						         GAMMA-N

		 			A PACKAGE OF NEUTRAL DENSITY ROUTINES
	

		   			 David Jackett and Trevor McDougall


		     			CSIRO Division of Marine Research
		        GPO Box 1538, Hobart, Tasmania, 7001, Australia


			     			   Version 3.1
			      			  January, 1997



This directory contains MATLAB code which enables the user to label
arbitrary hydrographic data with neutral density (function gamma_n), and
subsequently find the positions of specified neutral density surfaces on a
section of hydrographic data (function nsfcs). The calling sequences for
these two functions are given below. Complete details of the algorithms used
in the package can be found in 'A neutral density variable for the world's
oceans' by D.R. Jackett and T.J. McDougall, Journal of Physical Oceanography,
Vol.27(2) 1997, 237-263.

These two MATLAB functions respectively call two executable FORTRAN programs
'glabel_m' and 'nsfcs_m', which have been pre-compiled for use on a PC. If
you wish to run this MATLAB code on a machine other than a PC you will need
to copy down the FORTRAN version of the code, compile it and then recompile
the FORTRAN code in this directory (see file cprog).

To successfully run the code you will need to add the current directory to
your MATLAB path variable. This can be automated by adjusting your matlab.rc
startup file.

The neutral_surface code does, on occasions, detect the existence of more
than one solution (sns,tns,pns) for particular input neutral surfaces.
In this case, the code returns with sns, tns and pns values corresponding to
the middle crossing, and dsns, dtns and dpns values giving the possible error
in this crossing. Also the file 'ns-multi.dat' is written, containing all
relevant information on the multiply defined surfaces. Specifically, for each
cast in the section for which a surface is not uniquely defined, the file
contains a line containing the triple (cast #, surface #, ncr = # crossings)
and then ncr lines containing the (sns,tns,pns) solutions. This situation
arises when the user's data is statically unstable. When such a problem cast
comes from a section of data with well defined surfaces on neighbouring
casts, the 'ns_multi.dat' file can be inspected to make an objective choice
of the most appropriate crossing.

We have also provided an M-file, 'example.m', which demonstrates the use of
the two MATLAB functions on a three cast section of data. The output from
running this example is contained in 'example.out'.

We are keen to hear of your experiences with the package, and of any problems
that you encounter. If you do install the code on your machine and use it or
intend using it in the future, would you please drop a short line to either
jackett@ml.csiro.au or mcdougal@ml.csiro.au saying so, and perhaps indicating
your particular application. In the likely event that there are updates to
the code, such a list of users will enable us to alert you to the
availability of the updates and indicate any improvements we have made to the
algorithms.

Finally, we have included a ConditionsOfUse file, which should be read prior
to running the code.





function [g,dg_lo,dg_hi] = gamma_n(s,t,p,along,alat)

%%% GAMMA_N:        Label hydrographic data with neutral density
%%%
%%% USAGE:          [g,dg_lo,dg_hi] = gamma_n(s,t,p,along,alat)
%%%
%%% DESCRIPTION:    Label a section of hydrographic data at a specified
%%%                 location with neutral density
%%%
%%% PRECISION:      Single
%%%
%%% INPUT:          s       matrix of salinity (each column being a cast)
%%%                 t       matrix of in-situ temperatures 
%%%                 p   	matrix of pressures
%%%                 along   vector of longitudes (0,360)
%%%                 alat    vector of latitudes (-90,90)
%%%
%%%                 NOTE:   missing values must be denoted by NaN's
%%%
%%% OUTPUT:         g   	matrix of gamma_n values
%%%                 dg_lo   matrix of gamma_n lower error estimates
%%%                 dg_hi   matrix of gamma_n upper error estimates
%%%
%%%                 NOTE:   NaN denotes missing input data
%%%                         -99.0 denotes algorithm failed
%%%                         -99.1 denotes input data is outside the valid
%%%                         range of the present equation of state
%%%
%%% UNITS:          salinity    psu (IPSS-78)
%%%                 temperature degrees C (IPTS-68)
%%%                 pressure    db
%%%                 gamma_n     kg m-3
%%%
%%%
%%% AUTHOR:         David Jackett
%%%
%%% CREATED:        October, 1994
%%%
%%% REVISION:       3.1     24/1/97
%%%






function [sns,tns,pns,dsns,dtns,dpns] = nsfcs(s,t,p,g,glevels)

%%%  NSFCS:  		Fit neutral surfaces to hydrographic data
%%%		
%%%  USAGE:         [sns,tns,pns,dsns,dtns,dpns] = 
%%%                                         nsfcs(s,t,p,g,glevels)
%%%
%%%  DESCRIPTION:   For a section of hydrographic data which has been 
%%%                 labelled with the neutral density variable gamma_n,
%%%                 find the salinities, temperatures and pressures
%%%                 on specified neutral density surfaces.
%%%
%%%  PRECISION:     Single
%%%
%%%  INPUT:         s   	matrix of salinity (each column being a cast)
%%%                 t   	matrix of in-situ temperatures 
%%%                 p   	matrix of pressures
%%%                 g   	matrix of labelled gamma_n values
%%%                 glevels vector of gamma_n values defining the
%%%                 		neutral surfaces
%%%
%%%                 NOTE:   missing values must be denoted by NaN's
%%%
%%%  OUTPUT:        sns 	matrix of salinities on neutral surfaces
%%%                 tns     matrix of surface in situ temperatures
%%%                 pns 	matrix of surface pressures
%%%                 dsns    matrix of surface salinity errors
%%%                 dtns    matrix of surface temperature errors
%%%                 dpns    matrix of surface pressure errors
%%%
%%%                 NOTE:	sns, tns and pns values of -99.0
%%%                 		denotes under or outcropping
%%%
%%%           				non-zero dsns, dtns and dpns values
%%%                 		indicate multiply defined surfaces,
%%%                 		and file 'ns_multi.dat' contains
%%%                 		information on the multiple solutions
%%%
%%% UNITS:          salinity    	psu (IPSS-78)
%%%                 temperature 	degrees C (IPTS-68)
%%%                 pressure    	db
%%%                 gamma_n     	kg m-3
%%%
%%%
%%% AUTHOR:         David Jackett
%%%
%%% CREATED:        October, 1994
%%%
%%% REVISION:       3.1     25/1/97
%%%

