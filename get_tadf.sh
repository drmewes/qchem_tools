#!/bin/bash

	echo -e "Solv \tFosc. \t\tFluoresc \tPhospor \t dE(ST) \tE S1 \t\t\tE T1 \t\t\tdDip. \t\tDip. S1\t\tDip. T1"
for i in tda vac chx zeo tol mcp eth thf dcm acn  
	do soutfile=$(echo s1ems.adc2.$i.out) ; toutfile=$(echo t1ems.adc2.$i.out)
	if [ -e $soutfile ] 
		then
		if [ $(tail $soutfile | grep -o "nice") ] 
			then sconv=y
			else sconv=n
		fi
		if [ $(tail $toutfile | grep -o "nice") ] 
			then tconv=y
			else tconv=n
		fi
		Osc=$(tac $soutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1 -C15 | grep Osc | awk '{print $3}')
		DipS1=$(tac $soutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1 -C15 | grep "Total dipole" | awk '{print $4}')
		EmsS1=$(tac $soutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1  | awk '{print $8}')
		ES1=$(tac $soutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1 -C10 | grep "Total energy" | awk '{print $8}')
		DipT1=$(tac $toutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1 -C15 | grep "Total dipole" | awk '{print $4}')
		EmsT1=$(tac $toutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1  | awk '{print $8}')
		ET1=$(tac $toutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1 -C10 | grep "Total energy" | awk '{print $8}')
		dDip=$(echo "$DipS1 - $DipT1" | bc)
		gap=$(echo "-($ES1-($ET1))*27.2114" | bc )
		j=$(echo $i | cut -c 1-3)
		echo -e "$j $sconv $tconv\t$Osc\t$EmsS1\t$EmsT1\t$gap\t$ES1\t$ET1\t$dDip \t$DipS1\t$DipT1"
	else echo "" #$i calculation not yet started"
	fi
done 


	
