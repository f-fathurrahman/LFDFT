SUBROUTINE alloc_hamiltonian()
  USE m_hamiltonian, ONLY : V_ps_loc, V_Hartree, V_xc, Rhoe
  USE m_LF3d, ONLY : Npoints => LF3d_Npoints
  IMPLICIT NONE
  
  ALLOCATE( V_ps_loc( Npoints ) )
  ALLOCATE( V_Hartree( Npoints ) )
  ALLOCATE( V_xc( Npoints ) )
  
  ALLOCATE( Rhoe( Npoints ) )

  V_ps_loc(:) = 0.d0
  V_Hartree(:) = 0.d0
  V_xc(:) = 0.d0

  Rhoe(:) = 0.d0

END SUBROUTINE 