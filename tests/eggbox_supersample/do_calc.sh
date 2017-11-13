N=35
Rcuts=`seq 1.0 0.1 2.0`

for Rcut in $Rcuts
do

for ss in `seq 7.5 0.05 8.5`
do

LOGFIL=fort.log.$N_$ss
LOGFIL_STD=fort.log.$N_${ss}_STD

./test_ss.x $N ../../HGH/H.hgh 8.0 $ss $Rcut > $LOGFIL

str=`grep "E_ps_loc" $LOGFIL`
E_ps_loc_ss=`echo $str | awk '{split($0, a); print a[3]}'`

echo $ss $E_ps_loc_ss >> Ene_N_${N}_rcut_${Rcut}.dat

done
done