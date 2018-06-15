#!/bin/bash
FILES=~/paper2/data/wlc_*.dat
for f in $FILES ; do
	cp wlc${f:3:6}.dat wlce.dat
	for k in {0..35}; do
		##################################### FOR WAVELET ###############################################################
		xv=$(($k*4320)); 
		lb=$(($xv+1))
		le=$(($xv+4832))
		sed -n "${lb},${le}p" wlce.dat|awk '{print $1}' > wave.dat
		Rscript wave.R
		rm wave.dat
		sed -i 's/"/ /g' sampl.dat
		for p in {1..13}; do
			lb=4321
			le=4392
			sed -n "${lb},${le}p" sampl.dat|awk -v p=$p '{print $p}' > wlc.o
		
			for i in {1..15}; do            
				for j in {1..20}; do
					lfo-run  -l4320  -c$p  -m1,$i -d$j -L72 -k3200 sampl.dat  -o wlc.p
	   				echo -n  $(($xv+4320))  "  "  $i "    " $j "  ">> rms_min$p.dat  
					./myrms>> rms_min$p.dat 
				done
			done
			rm wlc.o
			rm wlc.p
			sed 's/-//' rms_min$p.dat | sed 's/inf/100000000.0/' | sed 's/nan/100000000.0/' > rms_min.dat 
			m=$(sort -gk 4 -r rms_min.dat |tail -1| awk '{print $2}' )
			d=$(sort -gk 4 -r rms_min.dat |tail -1| awk '{print $3}' )
			
			lfo-run  -l4320  -c$p  -m1,$m -d$d -L550 -k3200 sampl.dat  -o wlc0$p.p
			rm rms_min$p.dat
			rm rms_min.dat
			
		done

		paste  wlc0*.p | awk -F" " '{s=0; for (i=1; i<=NF; i++) s+=$i; print s;s=0 }' > S${f:3:6}with$(($xv+4320)).dat
		rm wlc0*.p
		cp S${f:3:6}with$(($xv+4320)).dat wlc.p
		lb=$((($xv+4320)+1))
		le=$((($xv+4320)+72))
		sed -n "${lb},${le}p" wlce.dat|awk  '{print $1}' > wlc.o
		max=$(sort -n wlc.o |tail -1 )
		min=$(sort -n wlc.o |head -1 )
			
		echo -n  $(($xv+4320))  "  " $max " " $min " " >> S${f:3:6}wrms.dat
		./myrms>> S${f:3:6}wrms.dat
		
		rm wlc.p
		rm sampl.dat

	#############################################################################################################################
	######################################  WITHOUT WAVELET  ####################################################################

		for i in {1..15}; do            
			for j in {1..20}; do
				lfo-run   -l$(($xv+4320))    -m1,$i -d$j -L72 -k3200 wlce.dat  -o wlc.p
   				echo -n  $(($xv+4320)) "  "  $i "    " $j "  " $max " " $min " ">> rms_min.dat  
				./myrms>> rms_min.dat 
			done
		done
		sed 's/-//' rms_min.dat | sed 's/inf/100000000.0/' | sed 's/nan/100000000.0/' > rms_mini.dat 
		m=$(sort -gk 6 -r rms_mini.dat |tail -1| awk '{print $2}' )
		d=$(sort -gk 6 -r rms_mini.dat |tail -1| awk '{print $3}' )
		lfo-run   -l$(($xv+4320))    -m1,$m -d$d -L550 -k3200 wlce.dat  -o S${f:3:6}wout$(($xv+4320)).dat
		sort -gk 6 -r rms_mini.dat |tail -1 >>S${f:3:6}rms.dat
		rm wlc.o
		rm rms_mini.dat
		rm rms_min.dat 
		rm wlc.p
	##############################################################################################################################
		lb=$((($xv+4320)+1))
		le=$((($xv+4320)+550))
		sed -n "${lb},${le}p" wlce.dat|awk  '{print $1}' > orginal.dat
		cp S${f:3:6}with$(($xv+4320)).dat with.dat
		cp S${f:3:6}wout$(($xv+4320)).dat without.dat
		gnuplot waves.gnu
		cp waves.eps S${f:3:6}_$(($xv+4320)).eps
		rm waves.eps
		rm orginal.dat
		rm without.dat
		rm with.dat
	done
	 
	rm wlce.dat
done





