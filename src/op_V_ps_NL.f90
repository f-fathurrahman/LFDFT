SUBROUTINE op_V_ps_NL( Nstates, Vpsi )
  USE m_LF3d, ONLY : Npoints => LF3d_Npoints
  USE m_PsPot, ONLY : NbetaNL, betaNL, prj2beta, Ps => Ps_HGH_Params
  USE m_atoms, ONLY : Natoms, atm2species
  USE m_hamiltonian, ONLY : betaNL_psi
  IMPLICIT NONE 
  INTEGER :: Nstates
  REAL(8) :: Vpsi(Npoints,Nstates)
  INTEGER :: ia, isp, ist, ibeta, jbeta, iprj, jprj
  INTEGER :: l, m
  REAL(8) :: hij

  IF( NbetaNL <= 0 ) THEN 
    RETURN 
  ENDIF 

  Vpsi(:,:) = 0.d0

  DO ist = 1,Nstates
    DO ia = 1,Natoms
      isp = atm2species(ia)
      DO l = 0,Ps(isp)%lmax
      DO m = -l,l
        DO iprj = 1,Ps(isp)%Nproj_l(l)
        DO jprj = 1,Ps(isp)%Nproj_l(l)
          ibeta = prj2beta(iprj,ia,l,m)
          jbeta = prj2beta(jprj,ia,l,m)
          hij = Ps(isp)%h(l,iprj,jprj)
! This operation should be localized around grid points near atoms          
          Vpsi(:,ist) = Vpsi(:,ist) + hij*betaNL(:,ibeta)*betaNL_psi(ist,jbeta)
        ENDDO ! jprj
        ENDDO ! iprj
      ENDDO ! m
      ENDDO ! l
    ENDDO 
  ENDDO 

END SUBROUTINE 



SUBROUTINE op_V_ps_NL_1col( ist, Vpsi )
  USE m_LF3d, ONLY : Npoints => LF3d_Npoints
  USE m_PsPot, ONLY : betaNL, Ps => Ps_HGH_Params, NbetaNL, prj2beta
  USE m_atoms, ONLY : Natoms, atm2species
  USE m_hamiltonian, ONLY : betaNL_psi
  IMPLICIT NONE 
  INTEGER :: ist
  REAL(8) :: Vpsi(Npoints)
  INTEGER :: ia, ibeta, jbeta, iprj, jprj, isp, l, m
  REAL(8) :: hij

  IF( NbetaNL <= 0 ) THEN 
    RETURN 
  ENDIF 

  Vpsi(:) = 0.d0

  DO ia = 1,Natoms
    isp = atm2species(ia)
    DO l = 0,Ps(isp)%lmax
    DO m = -l,l
      DO iprj = 1,Ps(isp)%Nproj_l(l)
      DO jprj = 1,Ps(isp)%Nproj_l(l)
        ibeta = prj2beta(iprj,ia,l,m)
        jbeta = prj2beta(jprj,ia,l,m)
        hij = Ps(isp)%h(l,iprj,jprj)
        Vpsi(:) = Vpsi(:) + hij*betaNL(:,ibeta)*betaNL_psi(ist,jbeta)
      ENDDO ! jprj
      ENDDO ! iprj
    ENDDO ! m
    ENDDO ! l
  ENDDO 

END SUBROUTINE 

