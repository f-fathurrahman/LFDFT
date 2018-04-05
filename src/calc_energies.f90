!! PURPOSE:
!!
!!   This subroutine calculates total energy components.
!!
!! AUTHOR:
!!
!!   Fadjar Fathurrahman
!!
!! MODIFIES:
!!   
!!   Global variables defined in module `m_energies`
!!
!! IMPORTANT:
!!
!!   The input `psi` is assumed to be orthonormalized.
!!
SUBROUTINE calc_energies( psi )

  USE m_LF3d, ONLY : Npoints => LF3d_Npoints, &
                     dVol => LF3d_dVol
  USE m_states, ONLY : Nstates, Focc, Nstates_occ
  USE m_hamiltonian, ONLY : V_ps_loc, V_Hartree, Rhoe, betaNL_psi
  USE m_atoms, ONLY : atm2species, Natoms
  USE m_PsPot, ONLY : prj2beta, Ps => Ps_HGH_Params, NbetaNL
  USE m_energies
  IMPLICIT NONE
  !
  REAL(8) :: psi(Npoints, Nstates)
  !
  REAL(8), ALLOCATABLE  :: nabla2_psi(:)
  INTEGER :: ist, ia, isp
  INTEGER :: l, m, iprj, jprj, ibeta, jbeta
  REAL(8) :: enl1, hij
  !
  REAL(8) :: ddot

  ALLOCATE( nabla2_psi(Npoints) )

  E_total   = 0.d0
  E_kinetic = 0.d0
  E_ps_loc  = 0.d0
  E_Hartree = 0.d0
  E_xc      = 0.d0

  ! assume all states are occupied
  DO ist = 1, Nstates_occ
    CALL op_nabla2( psi(:,ist), nabla2_psi(:) )
    E_kinetic = E_kinetic + Focc(ist) * (-0.5d0) * ddot( Npoints, psi(:,ist),1, nabla2_psi(:),1 ) * dVol
  ENDDO

  E_ps_loc = sum( Rhoe(:) * V_ps_loc(:) )*dVol

  E_Hartree = 0.5d0*sum( Rhoe(:) * V_Hartree(:) )*dVol

  CALL calc_Exc()

  !
  IF( NbetaNL > 0 ) THEN 
  E_ps_NL = 0.d0
  DO ist = 1,Nstates_occ
    enl1 = 0.d0
    DO ia = 1,Natoms
      isp = atm2species(ia)
      DO l = 0,Ps(isp)%lmax
      DO m = -l,l
        DO iprj = 1,Ps(isp)%Nproj_l(l)
        DO jprj = 1,Ps(isp)%Nproj_l(l)
          ibeta = prj2beta(iprj,ia,l,m)
          jbeta = prj2beta(jprj,ia,l,m)
          hij = Ps(isp)%h(l,iprj,jprj)
          enl1 = enl1 + hij*betaNL_psi(ist,ibeta)*betaNL_psi(ist,jbeta)
        ENDDO ! jprj
        ENDDO ! iprj
      ENDDO ! m
      ENDDO ! l
    ENDDO 
    E_ps_NL = E_ps_NL + Focc(ist)*enl1
  ENDDO 
  ENDIF 

  E_total = E_kinetic + E_ps_loc + E_Hartree + E_xc + E_nn + E_ps_NL

!  CALL info_energies()

  DEALLOCATE( nabla2_psi )

END SUBROUTINE
