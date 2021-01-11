ccc
ccc     program called from MATLAB to generate gamma
ccc     values for a section of hydrographic data
ccc

        parameter (nz=6000)

        implicit real (a-h,o-z)

        dimension s(nz),t(nz),p(nz),gamma(nz),dg_lo(nz),dg_hi(nz)


       
ccc
ccc         i/o files
ccc

        open(10,file='glab_m.in',status='old')
        open(11,file='glab_m.out',status='unknown')


ccc
ccc         loop over casts
ccc

        do while (.TRUE.)

ccc
ccc         read cast data from MATLAB ASCII file
ccc

          read(10,*,end=10) along,alat,xn
          n = nint(xn)
          if(n.gt.nz) 
     &      stop 'ERROR in glab_m.f: nz parameter too small'
          do k = 1,n
            read(10,*) s(k),t(k),p(k)
          end do

ccc
ccc         compute gamma values
ccc

    
          call gamma_n(s,t,p,n,along,alat,gamma,dg_lo,dg_hi)

ccc
ccc         write gamma values to ASCII file for MATLAB to read
ccc

          do k = 1,n
            write(11,'(f18.12,2e24.14)') gamma(k),dg_lo(k),dg_hi(k)
          end do

        end do


ccc
ccc         done
ccc


10      close(10)
        close(11)




        end
