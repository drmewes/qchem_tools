#!/bin/bash

	echo -e "Solv \tFosc. \t\tFluoresc \tPhospor \t dE(ST) \t Lambda \t Lambda2 \t\t\t dDip. \t\tDip. S1\t\tDip. T1"
for i in tda vac chx tol mcp eth dcm acn 
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
		ES1_T1=$(tac $toutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1 -C500 | grep "Term symbol:  2 (1) A" -B20 | grep "Total energy (PCM 0th order):" -m 1  | awk '{print $6}')
                ET1_S1=$(tac $soutfile | grep "Emission energy (PCM 1st order, incl. ptSS/GS):" -m 1 -C500 | grep "Term symbol:  1 (3) A" -B20 | grep "Total energy (PCM 0th order):" -m 1  | awk '{print $6}')
		dDip=$(echo "$DipS1 - $DipT1" | bc)
		gap=$(echo "($ES1-($ET1))*27.2114" | bc )
		lambda=$(echo "($ES1_T1-($ES1))*27.2114" | bc )
                lambda2=$(echo "($ET1_S1-($ET1))*27.2114" | bc )
		echo -e "$i $sconv $tconv\t$Osc\t$EmsS1\t$EmsT1\t$gap\t$lambda\t$lambda2\t$dDip\t$DipS1\t$DipT1"
	else echo "" #$i calculation not yet started"
	fi
done 

