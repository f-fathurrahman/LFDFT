!!>
!!> \section{Subroutine \texttt{Sch\_solve\_Emin\_pcg}}
!!>
!!> This subroutine solves one-particle Schrodinger equations by minimizing band energy.
!!> functional using conjugate gradient algorithm.
!!> The algorithm is based on T.A. Arias notes.
!!>
!!> ILU0 preconditioner from SPARSKIT is used as preconditioner.
!!>
!!> AUTHOR: Fadjar Fathurrahman

SUBROUTINE Sch_solve_Emin_pcg( alpha_t, restart )
!!>
!!> The following variables are imported.
!!>
  USE m_LF3d, ONLY : Npoints => LF3d_Npoints
  USE m_states, ONLY : Nstates, &
                       Focc, &
                       v => KS_evecs
  USE m_options, ONLY : I_CG_BETA, Emin_NiterMax, Emin_ETOT_CONV_THR
  USE m_options, ONLY : T_WRITE_RESTART

  IMPLICIT NONE
  !
  REAL(8) :: alpha_t  ! step size
  LOGICAL :: restart
  REAL(8), ALLOCATABLE :: g(:,:), g_old(:,:), g_t(:,:)
  REAL(8), ALLOCATABLE :: d(:,:), d_old(:,:)
  REAL(8), ALLOCATABLE :: Kg(:,:), Kg_old(:,:) ! preconditioned
  REAL(8), ALLOCATABLE :: tv(:,:)
  REAL(8) :: alpha, beta, denum, Ebands_old, Ebands
  !
  INTEGER :: iter, ist

!!> Here we allocate all working arrays
  ALLOCATE( g(Npoints,Nstates) )  ! gradient
  ALLOCATE( g_old(Npoints,Nstates) ) ! old gradient
  ALLOCATE( g_t(Npoints,Nstates) )  ! trial gradient
  ALLOCATE( d(Npoints,Nstates) )  ! direction
  ALLOCATE( d_old(Npoints,Nstates) )  ! old direction

  ALLOCATE( Kg(Npoints,Nstates) )  ! preconditioned gradient
  ALLOCATE( Kg_old(Npoints,Nstates) ) ! old preconditioned gradient

  ALLOCATE( tv(Npoints,Nstates) )  ! temporary vector for calculating trial gradient


  ! Read starting eigenvectors from file
  ! FIXME: This is no longer relevant
  IF( restart ) THEN
    READ(112) v   ! FIXME Need to use file name
  ENDIF

!!> Calculate initial total energy from given initial guess of wave function
  CALL calc_Ebands( Nstates, v, Ebands )

!!> Save the initial Ebands
  Ebands_old = Ebands

!!> initialize alpha and beta
  alpha = 0.d0
  beta  = 0.d0

!!> zero out all working arrays
  g(:,:)     = 0.d0
  g_t(:,:)   = 0.d0
  d(:,:)     = 0.d0
  d_old(:,:) = 0.d0
  Kg(:,:)    = 0.d0
  Kg_old(:,:) = 0.d0


!!> Here the iteration starts:
  DO iter = 1, Emin_NiterMax
!!>
!!> Evaluate gradient at current trial vectors
    CALL calc_grad( Nstates, v, g )
    !
!!> Precondition the gradient using ILU0 preconditioner from SPARSKIT
!!>
    DO ist = 1, Nstates
      CALL prec_ilu0( g(:,ist), Kg(:,ist) )
    ENDDO
!!
!!> set search direction
!
    IF( iter /= 1 ) THEN
      SELECT CASE ( I_CG_BETA )
      CASE(1)
!!> Fletcher-Reeves formula
        beta = sum( g * Kg ) / sum( g_old * Kg_old )
      CASE(2)
!!> Polak-Ribiere formula
        beta = sum( (g-g_old)*Kg ) / sum( g_old * Kg_old )
      CASE(3)
!!> Hestenes-Stiefeld formula
        beta = sum( (g-g_old)*Kg ) / sum( (g-g_old)*d_old )
      CASE(4)
!!> Dai-Yuan formula
        beta = sum( g * Kg ) / sum( (g-g_old)*d_old )
      END SELECT
    ENDIF
!!>
!!> Reset CG is beta is found to be smaller than zero
!!>
    IF( beta < 0 ) THEN
      WRITE(*,'(1x,A,F18.10,A)') 'beta is smaller than zero: ', beta, ': setting it to zero'
    ENDIF
    beta = max( 0.d0, beta )
!!>
!!> Compute new direction
!!>
    d(:,:) = -Kg(:,:) + beta*d_old(:,:)
!!>
!!> Evaluate gradient at trial step
!!>
    tv(:,:) = v(:,:) + alpha_t * d(:,:)
    CALL orthonormalize( Nstates, tv )

    CALL calc_grad( Nstates, tv, g_t )
    !
    ! Compute estimate of best step and update current trial vectors
    denum = sum( (g - g_t) * d )
    IF( denum /= 0.d0 ) THEN  ! FIXME: use abs ?
      alpha = abs( alpha_t * sum( g * d )/denum )
    ELSE
      alpha = 0.d0
    ENDIF
    !WRITE(*,*) 'iter, alpha_t, alpha, beta', iter, alpha_t, alpha, beta

    v(:,:) = v(:,:) + alpha * d(:,:)
    CALL orthonormalize( Nstates, v )

    CALL calc_Ebands( Nstates, v, Ebands )
    !
    WRITE(*,'(1x,I5,F18.10,ES18.10)') iter, Ebands, Ebands_old-Ebands
    !
    IF( abs(Ebands - Ebands_old) < Emin_ETOT_CONV_THR ) THEN
      WRITE(*,*) 'Sch_solve_Emin_pcg converged in iter', iter
      EXIT
    ENDIF
    !
    Ebands_old = Ebands
    g_old(:,:) = g(:,:)
    d_old(:,:) = d(:,:)
    Kg_old(:,:) = Kg(:,:)
    flush(6)
  ENDDO

  IF( T_WRITE_RESTART ) THEN
    WRITE(111) v
  ENDIF

  DEALLOCATE( g, g_old, g_t, d, d_old, tv, Kg, Kg_old )
END SUBROUTINE


