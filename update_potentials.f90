SUBROUTINE update_potentials()

  USE m_LF3d, ONLY : Npoints => LF3d_Npoints
  USE m_hamiltonian, ONLY : Rhoe, V_Hartree, V_xc
  IMPLICIT NONE 
  REAL(8), ALLOCATABLE :: epsxc(:), depsxc(:)
  
  ALLOCATE( epsxc(Npoints) )
  ALLOCATE( depsxc(Npoints) )

  CALL solve_poisson_fft( Rhoe, V_Hartree )

  CALL excVWN( Npoints, Rhoe, epsxc )
  CALL excpVWN( Npoints, Rhoe, depsxc )

  V_xc(:) = epsxc(:) + Rhoe(:)*depsxc(:)

  DEALLOCATE( epsxc )
  DEALLOCATE( depsxc )

END SUBROUTINE 