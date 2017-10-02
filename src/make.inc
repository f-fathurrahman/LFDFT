EXE_MAIN = ffr_LFDFT_sun.x
MAKE = make
AR = ar

F77 = sunf95
F77_OPTS = -O3

F90 = sunf95
F90_OPTS = -fpp -fast -dalign -w4        # already no warning message
F90_OPTS_NOWARN = -fpp -fast -dalign -w4

# needed for my Ubuntu laptop
CC = suncc -std=c99 -I /usr/include/x86_64-linux-gnu/

LIB_LINALG = -library=sunperf #-lblas -llapack
LIB_FFTW3 = -lfftw3
LIBS = $(LIB_LINALG) $(LIB_FFTW3)
