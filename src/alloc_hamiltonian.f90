!! PURPOSE:
!!
!!   This subroutine allocates memory for global variables defined
!!   in module `m_hamiltonian`
!!
!! AUTHOR:
!!
!!   Fadjar Fathurrahman

SUBROUTINE alloc_hamiltonian()
  USE m_hamiltonian, ONLY : V_ps_loc, V_Hartree, V_xc, Rhoe, betaNL_psi
  USE m_LF3d, ONLY : Npoints => LF3d_Npoints
  USE m_PsPot, ONLY : NbetaNL
  USE m_atoms, ONLY : Natoms
  USE m_states, ONLY : Nstates
  USE m_xc, ONLY : EPS_XC
  IMPLICIT NONE

  ALLOCATE( V_ps_loc( Npoints ) )
  ALLOCATE( V_Hartree( Npoints ) )
  ALLOCATE( V_xc( Npoints ) )

  ALLOCATE( Rhoe( Npoints ) )

  ! XXX allocate here ???
  ALLOCATE( betaNL_psi(Natoms,Nstates,NbetaNL) )

  V_ps_loc(:) = 0.d0
  V_Hartree(:) = 0.d0
  V_xc(:) = 0.d0

  Rhoe(:) = 0.d0

  ALLOCATE( EPS_XC(Npoints) )

END SUBROUTINE

