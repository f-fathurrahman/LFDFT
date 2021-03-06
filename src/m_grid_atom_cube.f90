MODULE m_grid_atom_cube
  IMPLICIT NONE 
  INTEGER :: Npoints_a
  REAL(8), ALLOCATABLE :: lingrid_a(:,:)
  INTEGER, ALLOCATABLE :: lin2xyz_a(:,:)
  REAL(8) :: dVol_a
END MODULE 


! This subroutine is not generalized for periodic case
SUBROUTINE init_grid_atom_cube( center, cutoff, N_a, is_debug )
  USE m_grid_atom_cube
  IMPLICIT NONE 
  REAL(8) :: center(3)  ! atomic center
  REAL(8) :: cutoff ! cutoff radius, the cube's side length is 2*cutoff
  INTEGER :: N_a  ! sampling point, taken to be the same for x, y, and z direction
  LOGICAL :: is_debug
  !
  INTEGER :: ip_a
  INTEGER :: ix, iy, iz
  REAL(8) :: x_start, y_start, z_start
  REAL(8) :: delta_x, delta_y, delta_z
  REAL(8) :: x, y, z

  Npoints_a = N_a**3

  ALLOCATE( lingrid_a(3,Npoints_a) )
  ALLOCATE( lin2xyz_a(3,Npoints_a) )

  x_start = -cutoff
  delta_x = 2.d0*cutoff/(N_a-1)
  
  ! FIXME: assume the same spacing
  y_start = x_start
  delta_y = delta_x
  !
  z_start = x_start
  delta_z = delta_x

  ! dVol element
  dVol_a = delta_x**3

  ip_a = 0
  DO iz = 1,N_a
  DO iy = 1,N_a
  DO ix = 1,N_a
    ip_a = ip_a + 1
    x = x_start + (ix-1)*delta_x
    y = y_start + (iy-1)*delta_y
    z = z_start + (iz-1)*delta_z
    lingrid_a(1:3,ip_a) = (/ x, y, z /) + center(1:3)
    lin2xyz_a(1:3,ip_a) = (/ ix, iy, iz /)
    IF( is_debug ) THEN 
      WRITE(*,'(1x,I8,3F18.10)') ip_a, lingrid_a(:,ip_a)
    ENDIF 
  ENDDO 
  ENDDO 
  ENDDO 

  WRITE(*,*)
  WRITE(*,*) 'Atomic grid cube:'
  WRITE(*,'(1x,A,3F18.10)') 'center = ', center(:)
  WRITE(*,'(1x,A,F18.10)')  'cutoff = ', cutoff
  WRITE(*,'(1x,A,ES18.10)') 'dVol_a = ', dVol_a

END SUBROUTINE 

