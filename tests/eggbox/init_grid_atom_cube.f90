SUBROUTINE init_grid_atom_cube( center, cutoff, N_a )
  IMPLICIT NONE 
  REAL(8) :: center(3)
  REAL(8) :: cutoff
  INTEGER :: N_a
  !
  REAL(8), ALLOCATABLE :: grid_a(:,:)
  INTEGER :: Npoints_a, ip_a
  INTEGER :: ix, iy, iz
  REAL(8) :: x_start, y_start, z_start
  REAL(8) :: delta_x, delta_y, delta_z
  REAL(8) :: x, y, z

  WRITE(*,*) 'center = ', center(:)
  WRITE(*,*) 'cutoff = ', cutoff

  Npoints_a = N_a**3
  ALLOCATE( grid_a(3,Npoints_a) )

  x_start = -cutoff
  delta_x = 2.d0*cutoff/(N_a-1)
  
  ! FIXME: assume the same spacing
  y_start = x_start
  delta_y = delta_x
  !
  z_start = x_start
  delta_z = delta_x

  ip_a = 0
  DO iz = 1,N_a
  DO iy = 1,N_a
  DO ix = 1,N_a
    ip_a = ip_a + 1
    x = x_start + (ix-1)*delta_x
    y = y_start + (iy-1)*delta_y
    z = z_start + (iz-1)*delta_z
    grid_a(1:3,ip_a) = (/ x, y, z /) + center(1:3)
    WRITE(*,'(1x,I8,3F18.10)') ip_a, grid_a(1,ip_a), grid_a(2,ip_a), grid_a(3,ip_a)
  ENDDO 
  ENDDO 
  ENDDO 

END SUBROUTINE 

