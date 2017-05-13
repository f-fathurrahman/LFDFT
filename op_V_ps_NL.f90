SUBROUTINE op_V_ps_NL( Nstates, Vpsi )
  USE m_LF3d, ONLY : Npoints => LF3d_Npoints
  USE m_PsPot, ONLY : NbetaNL, betaNL, w_NL
  USE m_atoms, ONLY : Natoms
  USE m_states, ONLY : Focc
  USE m_hamiltonian, ONLY : betaNL_psi
  IMPLICIT NONE 
  INTEGER :: Nstates
  REAL(8) :: Vpsi(Npoints,Nstates)
  INTEGER :: ia, ibeta, ist

  IF( NbetaNL <= 0 ) THEN 
    RETURN 
  ENDIF 

  Vpsi(:,:) = 0.d0

  DO ist = 1,Nstates
    DO ia = 1,Natoms
      DO ibeta = 1,NbetaNL
        Vpsi(:,ist) = w_NL(ibeta)*betaNL(:,ibeta)*betaNL_psi(ia,ist,ibeta) !*dVol
      ENDDO 
    ENDDO 
    Vpsi(:,ist) = 2.d0*Focc(ist)*Vpsi(:,ist) 
!    Vpsi(:,ist) = 2.d0*Vpsi(:,ist) 
  ENDDO 

END SUBROUTINE 



SUBROUTINE op_V_ps_NL_1col( ist, Vpsi )
  USE m_LF3d, ONLY : Npoints => LF3d_Npoints, dVol => LF3d_dVol
  USE m_PsPot, ONLY : NbetaNL, betaNL, w_NL
  USE m_atoms, ONLY : Natoms
  USE m_states, ONLY : Focc
  USE m_hamiltonian, ONLY : betaNL_psi
  IMPLICIT NONE 
  INTEGER :: ist
  REAL(8) :: Vpsi(Npoints)
  INTEGER :: ia, ibeta

  IF( NbetaNL <= 0 ) THEN 
    RETURN 
  ENDIF 

  Vpsi(:) = 0.d0

!  WRITE(*,*) 'ist = ', ist
  DO ia = 1,Natoms
    DO ibeta = 1,NbetaNL
      Vpsi(:) = Vpsi(:) + w_NL(ibeta)*betaNL(:,ibeta)*betaNL_psi(ia,ist,ibeta)  !*sqrt(dVol)
    ENDDO 
  ENDDO 
!  WRITE(*,*) 'betaNL_psi = ', betaNL_psi
!  Vpsi(:) = 2.d0*Focc(ist)*Vpsi(:) !*dVol
  Vpsi(:) = 2.d0*Vpsi(:)
!  WRITE(*,*) 'sum(Vpsi) = ', sum(abs(Vpsi))

END SUBROUTINE 

