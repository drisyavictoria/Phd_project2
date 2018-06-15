#!/bin/bash
######################################## Arrange Data into Correct Format############################################
FILES=S_*wrms.dat
for f in $FILES ; do
	cut  -d' '  -f1-11  S${f:1:6}rms.dat >test1.dat
	cut -d' '  -f5-11  S${f:1:6}wrms.dat >test2.dat
	cut  -d' '  -f22  S${f:1:6}rms.dat >test3.dat
	awk '{print $1-$2}' test2.dat > test4.dat
	
	paste test1.dat test2.dat test3.dat test4.dat > S${f:1:6}no.dat

	rm test1.dat
	rm test2.dat
	rm test3.dat
	
paste S${f:1:6}wrms.dat test4.dat > S${f:1:6}with.dat
rm test4.dat
done
######################################################################################################################
#######################################All sites with wavelet into One file###########################################
FILES=S_*with.dat
echo "Time" > Allwith.dat
awk '{print $1}' S_00001with.dat >>Allwith.dat
for f in $FILES ; do
echo S${f:1:6} > aaa.dat
awk '{print $4/$5}' S${f:1:6}with.dat >>aaa.dat
cp Allwith.dat flag.dat
paste flag.dat aaa.dat > Allwith.dat
rm aaa.dat
rm flag.dat
done
#######################################################################################################################
#######################################All sites without wavelet into One file#########################################
FILES=S_*no.dat
echo "Time" > Allno.dat
awk '{print $1}' S_00001no.dat >>Allno.dat
for f in $FILES ; do
echo S${f:1:6} > aaa.dat
awk '{print $6/$7}' S${f:1:6}no.dat >>aaa.dat
cp Allno.dat flag.dat
paste flag.dat aaa.dat > Allno.dat
rm aaa.dat
rm flag.dat
done
#######################################################################################################################
Rscript Trans.R
sed "1d" TAllwith.dat > tmp
rm TAllwith.dat
cp tmp TAllwith.dat
rm tmp
sed "1d" TAllno.dat > tmp
rm TAllno.dat
cp tmp TAllno.dat
rm tmp
#######################################Time & location Averaged nrmse for with wavelet###########################################
rm timeavg
for p in {2..32}; do
	sed '1d' Allwith.dat | awk -v p=$p '{print $p}' > testt
	gnuplot ff.gnu
	rm testt
	echo `awk -v p=$p '{print $p}' Allwith.dat|sed -n '1,1p'` "  " `grep "+/-" fit.log`>>timeavg
	rm fit.log
	k=$(($k+1));
done
rm locavg
k=1
for p in {2..37}; do
	xv=$(($k*4320));
	sed '1d' TAllwith.dat | awk -v p=$p '{print $p}' > testt
	gnuplot ff.gnu
	rm testt
	echo $xv "  " `grep "+/-" fit.log`>>locavg
	rm fit.log
	k=$(($k+1));
done
#######################################################################################################################################
#######################################Time & location Averaged nrmse for without wavelet###########################################
rm timeavg_no
for p in {2..32}; do
	sed '1d' Allno.dat | awk -v p=$p '{print $p}' > testt
	gnuplot ff.gnu
	rm testt
	echo `awk -v p=$p '{print $p}' Allno.dat|sed -n '1,1p'` "  " `grep "+/-" fit.log`>>timeavg_no
	rm fit.log
	k=$(($k+1));
done
rm locavg_no
k=1
for p in {2..37}; do
	xv=$(($k*4320));
	sed '1d' TAllno.dat | awk -v p=$p '{print $p}' > testt
	gnuplot ff.gnu
	rm testt
	echo $xv "  " `grep "+/-" fit.log`>>locavg_no
	rm fit.log
	k=$(($k+1));
done
#######################################################################################################################################

