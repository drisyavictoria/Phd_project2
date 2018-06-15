#!/bin/bash
FILES=S*wrms.dat
for f in $FILES ; do
	for k in {1..36}; do
		xv=$(($k*4320));
		lb=$(($xv+1))
		le=$(($xv+174))
		sed -n "${lb},${le}p" wlc${f:1:6}.dat|awk '{print $1}' > wlc.o

		sed -n "1,174p" S${f:1:6}with$xv.dat|awk '{print $1}' > wlc.p
		echo -n  $xv \  >>/home/drisya/paper2/wave/MAE/allmae29hr/S${f:1:6}wmae.dat
		echo -n  $xv \  >>/home/drisya/paper2/wave/MAPE/allmape29hr/S${f:1:6}wmape.dat
		Rscript error.R 
		head -1 error >> /home/drisya/paper2/wave/MAE/allmae29hr/S${f:1:6}wmae.dat
		tail -1 error >> /home/drisya/paper2/wave/MAPE/allmape29hr/S${f:1:6}wmape.dat
		rm error

		sed -n "1,174p" S${f:1:6}wout$xv.dat|awk '{print $1}' > wlc.p
		echo -n  $xv \  >>/home/drisya/paper2/wave/MAE/allmae29hr/S${f:1:6}mae.dat
		echo -n  $xv \  >>/home/drisya/paper2/wave/MAPE/allmape29hr/S${f:1:6}mape.dat
		Rscript error.R
		head -1 error >> /home/drisya/paper2/wave/MAE/allmae29hr/S${f:1:6}mae.dat
		tail -1 error >> /home/drisya/paper2/wave/MAPE/allmape29hr/S${f:1:6}mape.dat
		rm error
	done
done
