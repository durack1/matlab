function[jlab]=jlab_list(varargin)
%JLAB_LIST  List of JLAB function properties.
%
%   JLAB=JLAB_LIST returns a structure whose fields are the names
%   of JLAB functions, e.g. 'jlab.aresame'.  The field contain an 't' 
%   if the function has an automated test and an 'f' if the function
%   will generate a sample figure.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J. Lilly --- type 'help jlab_license' for details
 
if nargin>0
    if strcmp(varargin{1}, '--t')
        jlab_list_test,return
    end
end

jlab.ab2kl='t';
jlab.ag2bc='t';
jlab.aquaplot='f';
jlab.aquasal='f';
jlab.aresame='t';
jlab.bandnorm='t';
jlab.bellpoly='t';
jlab.bellband='f';
jlab.ascii2num='t';
jlab.blocknum='t';
jlab.conflimit='f';
jlab.crossings='t';
jlab.cubeinterp='t';
jlab.dawson='t';
jlab.dawsonderiv='tf';
jlab.deg180='t';
jlab.deg2rad='t';
jlab.deg360='t';
jlab.dfun='t';
jlab.dmasym='t';
jlab.dmspec='t';
jlab.dmstd='t';
jlab.doublen='tf';
jlab.ecconv='tf';
jlab.ellconv='t';
jlab.elldiff='t';
jlab.ellipseplot='f';
jlab.ellvel='f';
jlab.ellridge='t';
jlab.fillbad='t';
jlab.findfiles='t';
jlab.gaussianeddy='f';
jlab.hermeig='f';
jlab.hermpoly='t';
jlab.hiltrans='f';
jlab.hfun='t';
jlab.hor2uvw='t';
jlab.inregion='t';
jlab.iscompat='t';
jlab.islargest='t';
jlab.iswavegrid='t';
jlab.jlab_settings='t';
%jlab.jlab_moretests='t';
jlab.k2sub='t';
jlab.kfun='t';
jlab.kl2ab='t';
jlab.latlon2uv='t';
jlab.latlon2xy='t';
jlab.latlon2xyz='t';
jlab.latlon2zeaz='t';
jlab.lonshift='t';
jlab.lookup='t';
jlab.make='t';
jlab.matmult='t';
jlab.matsave='t';
jlab.mjd2num='t';
jlab.mom2cum='t';
jlab.morlwave='tf';
jlab.morsea='t';
jlab.morsearea='tf';
jlab.morsebox='tf';
jlab.morsederiv='t';
jlab.morsexpand='t';
jlab.morsemax='tf';
jlab.morsemom='t';
jlab.morsecfun='t';
jlab.morsefreq='tf';
jlab.morseprops='t';
jlab.morseregion='t';
jlab.morsewave='tf';
jlab.mspec='tf';
jlab.msvd='t';
jlab.nd='t';
jlab.nnsd='t';
jlab.normform='t';
jlab.numslabs='t';
jlab.orbitbreaks='t';
jlab.pdfadd='f';
jlab.pdfconv='tf';
jlab.pdfdivide='f';
jlab.pdfinv='tf';
jlab.pdfmult='f';
jlab.pdfprops='t';
jlab.quadform='t';
jlab.quadinterp='t';
jlab.rad2deg='t';
jlab.randspecmat='t';
jlab.randkineeddy='f';
jlab.rescoeff='t';
%jlab.ridgerecon='t';
jlab.ridgewalk='t';
jlab.ridgedebias='f';
jlab.rot='t';
jlab.safeindex='t';
jlab.simplepdf='f';
jlab.slepwave='t';
jlab.slidetrans='tf';
jlab.smartsmooth='t';
jlab.specdiag='t';
jlab.spheredist='t';
jlab.spherediv='t';
jlab.sphere2uvw='t';
jlab.stickvect='f';
jlab.sub2k='t';
jlab.subset='t';
jlab.to_grab_from_caller='t';
jlab.trainwave='t';
jlab.triadevolve='f';
jlab.triadres='tf';
jlab.turningpoint='t';
jlab.twolayereddy='f';
jlab.twodhist='t';
jlab.twodmean='t';
jlab.twodmed='t';
jlab.uvw2sphere='t';
jlab.uvw2hor='t';
jlab.vadd='t';
jlab.vcellcat='t';
jlab.vcolon='t';
jlab.vdiff='t';
jlab.vectmult='t';
jlab.vectmult3='t';
jlab.vempty='t';
jlab.vfilt='t';
jlab.vindex='t';
jlab.vindexinto='t';
jlab.vmean='t';
jlab.vmoment='t';
jlab.vmult='t';
jlab.vnan='t';
jlab.vnd='t';
jlab.vpower='t';
jlab.vrep='t';
jlab.vshift='t';
jlab.vsize='t';
jlab.vsqueeze='t';
jlab.vstd='t';
jlab.vsum='t';
jlab.vswap='t';
jlab.vtrans='t';
jlab.vtriadres='f';
jlab.vzeros='t';
jlab.wavegrid='t';
jlab.waverecon='t';
jlab.wavespecplot='f';
jlab.wavetrans='t';
jlab.wigdist='tf';
jlab.xy2latlon='t';
jlab.xyz2latlon='t';
jlab.yf2num='t';
jlab.ze2dist='t';
jlab.ze2inc='tf';
jlab.zeaz2latlon='t';

function[]=jlab_list_test
 
%reporttest('JLAB_LIST',aresame())
