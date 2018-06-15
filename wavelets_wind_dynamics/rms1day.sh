#!/bin/bash
FILES=S*wrms.dat
for f in $FILES ; do
	for k in {1..36}; do
	xv=$(($k*4320));
	sed -n "1,144p" S${f:1:6}with$xv.dat|awk '{print $1}' > wlc.p
	lb=$(($xv+1))
	le=$(($xv+144))
	sed -n "${lb},${le}p" wlc${f:1:6}.dat|awk '{print $1}' > wlc.o
	echo -n  $xv   >>/home/drisya/wave/allrms1day/S${f:1:6}wrms.dat
	./myrms >>  /home/drisya/wave/allrms1day/S${f:1:6}wrms.dat
	echo -n  $xv   >>/home/drisya/wave/allrms1day/S${f:1:6}rms.dat
	sed -n "1,144p" S${f:1:6}wout$xv.dat|awk '{print $1}' > wlc.p
	./myrms >>  /home/drisya/wave/allrms1day/S${f:1:6}rms.dat
	done
done
