12:07 PM 11/06/02

Copied MLD stuff from Jeff:

dur041/bin> mkdir dunn
dur041/bin> cp -R ~dunn/mld/ dunn/

**
-----Original Message-----
From: Jeff Dunn [mailto:jeff.dunn@csiro.au] 
Sent: Thursday, June 02, 2011 11:58 AM
To: Durack, Paul (CMAR, Hobart)
Subject: Re: MLD

Sorry - done now.

- Jeff

On Thursday 02 June 2011 11:51, you wrote:
> Thanks Jeff..
>
> Can you open up the ~dunn/mld/progs subdir to execute access pretty 
> please :), seems like I can't see it..
>
> dunn/mld> cd progs/
> progs/: Permission denied.
> /home/dunn/mld
>
> Cheers,
>
> P
>
> -----Original Message-----
> From: Jeff Dunn [mailto:jeff.dunn@csiro.au]
> Sent: Thursday, June 02, 2011 11:14 AM
> To: Durack, Paul (CMAR, Hobart)
> Subject: MLD
>
> Hi Paul
>
> stuff in ~dunn/mld, esp ~dunn/mld/progs/
>
> ok. some of it is not so simple, but it has had a good workout over 
> the years
>
> mixld.m is probably all you need.
>
> Did lots of experimentation and the simpler measures seem to work 
> better - I normally use these are described in the note I put in storage files:
>
> MLD is min of mlds 1-2. This is designed for excluding ML waters',
>         'from T/S mapping - a better est for bio work maybe min([2 4])',
>         ['mlds(1) is interp depth of abs(t-t(10m))=' num2str(lms(1))],
>         ['mlds(2) is interp depth of abs(s-s(10m))=' num2str(lms(2))],
>         ['mlds(3) is first depth of abs(D-D(10m))=' num2str(lms(3))],
>         [' OR dDdz > ' num2str(lms(4)) ', where D=sw_dens0'],
>         ['mlds(4) is interp depth of abs(t-t(10m))=' num2str(lms(6))],
>         ['mlds(5) is first depth of abs(D-D(10m))=' num2str(lms(7))],
>
> where lims are lms = [.2 .03 .06 .003 20 .4 .06];
>
> (the above extracted from in drive_mixld_boa.m)
>
> Some of this discussed briefly in
>
> Scott A. Condie and Jeff R. Dunn (2006) Seasonal characteristics of 
> the surface mixed layer in the Australasian region: implications for 
> primary production regimes and biogeography. Marine and Freshwater 
> Research, 2006, 57, 1-22. http://dx.doi.org/10.1071/MF06009
>
> Cheers
>     Jeff
**