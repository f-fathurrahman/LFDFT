MODULE m_atoms

  IMPLICIT NONE 

  INTEGER :: Natoms
  INTEGER :: Nspecies
  REAL(8), ALLOCATABLE :: AtomicCoords(:,:)
  INTEGER, ALLOCATABLE :: atm2species(:)
  CHARACTER(20), ALLOCATABLE :: SpeciesSymbols(:)  ! Nspecies

END MODULE 
