SUBROUTINE setup_PsPot()

  USE m_input_vars, ONLY : pp_name, pseudo_dir
  USE m_atoms, ONLY : Nspecies, AtomicValences, &
                      atm2species, Natoms
  USE m_PsPot, ONLY : Ps_HGH_Params, PsPot_FilePath, PsPot_Dir, &
                      NbetaNL, prj2beta
  USE m_Ps_HGH, ONLY : init_Ps_HGH_Params

  IMPLICIT NONE 
  INTEGER :: isp, iprj, l, ia, m

  ! Use default
  ALLOCATE( PsPot_FilePath(Nspecies) )
  ALLOCATE( Ps_HGH_Params(Nspecies) )

  PsPot_Dir = trim(pseudo_dir)

  DO isp = 1,Nspecies

    PsPot_FilePath(isp) = trim(PsPot_Dir) // '/' // trim(pp_name(isp))
    CALL init_Ps_HGH_Params( Ps_HGH_Params(isp), PsPot_FilePath(isp) )
    
    AtomicValences(isp) = Ps_HGH_Params(isp)%zval

  ENDDO 


  ALLOCATE( prj2beta(1:3,1:Natoms,0:3,-3:3) )
  prj2beta(:,:,:,:) = -1
  NbetaNL = 0
  DO ia = 1,Natoms
    isp = atm2species(ia)
    DO l = 0,Ps_HGH_Params(isp)%lmax
!      WRITE(*,*)
      DO iprj = 1,Ps_HGH_Params(isp)%Nproj_l(l)
        DO m = -l,l
          NbetaNL = NbetaNL + 1
          prj2beta(iprj,ia,l,m) = NbetaNL
!          WRITE(*,*) NbetaNL, ia, '(',l, ',', m, ')', iprj, &
!                     prj2beta(iprj,ia,l,m), Ps_HGH_Params(isp)%h(l,iprj,iprj)                     
        ENDDO ! m
      ENDDO ! iprj
    ENDDO ! l
  ENDDO 
  !WRITE(*,*) 'NbetaNL = ', NbetaNL

  DEALLOCATE( pp_name )
  
END SUBROUTINE 

