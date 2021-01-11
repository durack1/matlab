ccc
ccc     program called from Matlab to generate neutral
ccc     surfaces for a section of hydrographic data
ccc

        parameter (nz=6000,ngmax=1000)

        implicit real (a-h,o-z)

        dimension s(nz),t(nz),p(nz),gamma(nz)
        dimension glevels(ngmax),sns(ngmax),tns(ngmax),pns(ngmax)
        dimension dsns(ngmax),dtns(ngmax),dpns(ngmax)




ccc
ccc     gamma levels
ccc

        open(10,file='ns1.in',status='old')

        read(10,*) xng

        ng = nint(xng)

        if(ng.gt.ngmax)
     &      stop 'ERROR 1 in nsfc_m.f: ngmax parameter too small'

        do k = 1,ng
          read(10,*) glevels(k)
        end do

        close(10)


ccc
ccc     loop over the casts
ccc

        open(10,file='ns2.in',status='old')
        open(11,file='nsfcs1.out',status='unknown')
        open(12,file='nsfcs2.out',status='unknown')

        icast = 0
        ierr_wr = 0

        do while (.TRUE.)

          read(10,*,end=10) xn
          n = nint(xn)
          if(n.gt.nz)
     &      stop 'ERROR 2 in nsfc_m.f: nz parameter too small'
          do k = 1,n
            read(10,*) s(k),t(k),p(k),gamma(k)
          end do

          icast = icast+1


ccc
ccc         compute neutral surface positions
ccc

          call neutral_surfaces(s,t,p,gamma,n,glevels,ng,
     &                              sns,tns,pns,dsns,dtns,dpns)

          ierr = 0
          do k = 1,ng
            write(11,*) sns(k),tns(k),pns(k)
            write(12,*) dsns(k),dtns(k),dpns(k)
            if(dpns(k).ne.0.0) ierr = 1
          end do


cc
cc          assemble the error file
cc

          if(ierr.eq.1) then

            if(ierr_wr.eq.0) then
              open(13,file='ns_multi.dat',status='new')
              ierr_wr = 1
            else
              open(13,file='ns_multi.dat',status='old',
     &                                          access='append')
            end if

            open(14,file='ns-multi.dat',status='old')

            do while (.TRUE.)
              read(14,*,end=5) k0,nmul
              write(13,*) icast,k0,nmul
              do k = 1,nmul
                read(14,*) s0,t0,p0
                write(13,*) s0,t0,p0
              end do
            end do

5           close(13)

          end if

        end do


ccc
ccc         done
ccc


10      close(10)
        close(11)
        close(12)
        close(14)

        if(ierr_wr.ne.0) then
            open(10,file='ns-multi.dat',status='old')
            close(10,status='delete')
        end if



        end
