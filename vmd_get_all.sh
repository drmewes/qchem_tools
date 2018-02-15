#!/bin/bash

# This script allows you to visualise and plot all .cube files located
# in this folder using only a few calls and clicks with VMD. 
# Coloration of the files depends on the name of the respective .cubes
# (attachment and electron densities are colored in red, detachment and
# hole densities in blue) and should work with .cube files generated with
# libwfa as implemented in Q-Chem.
# You may use 1 2 or 3 surfaces with different isovalues per plot. This helps
# to tell major and minor contributions apart. I suggest 3 for small molecules 
# while 2 is the better choice for larger molecules. The number of surfaces 
# is the first argument after the script name. There are default iso values for all
# choiced but you should definitly play around a little to get the most telling plots.
# The second argument is the largest iso value (used for the solid, major contributions),
# while third argument is the factor used to obtain the second (and third iso value).

# 0. fill folder with .cube files of your choice and .xyz file with the geometry.
# 1. call this script
# 2. open the xyz file in VMD
# 3. to load the .plt/.cube files and some settings use the scripting of VMD:
#    - "Load state" load_all_plt.vmd
#    - click "Apply" in "Graphical Representations"
# 4. adjust perspective
# 5. to plot all orbits, call plot_all.vmd again via "Load state"
# 6. exit VMD and call ./convert.bash to turn tga files into png
# 7. open the .html file with the browser of your choice and profit

#~ Jan Mewes and Felix Plasser

###
ifmt=cube
ofmt=tga
out=load_all_plt.vmd
plot=plot_all.vmd
conv=convert.bash
html=vmd_plots.html
ncol=5
###



echo 'USAGE: '$0' [<# surfaces(2/3), STD = 3 >] [<high iso,
STD(2/3)=(0.1/0.128)>] [<iso_factor>]'

echo 'For 3-surface MO plots, an iso of 0.1 is'
echo 'a good idea, for 2 surfaces rather 0.08. '
echo 'For transition/difference density plots'
echo 'an isovalue of 0.015 to 0.01 is feasible.'

isotemp=$2
temp_factor=$3

isoFactor=${temp_factor:=3}

if [ $1 ]
then
if [ $1 -eq 1 ]
then
  isov=${isotemp:=0.01}
  isov2=0.99
  isov3=0.99
  echo 'Using 1 surfac for isovalue:'
  echo $isov
elif [ $1 -eq 2 ]
then
  isov=${isotemp:=0.01}
  isov2=`echo $isov'/'$isoFactor | bc -l`
  isov3=0.99
  echo 'Using 2 surfaces for isovalues:'
  echo $isov $isov2
  echo "material change opacity Ghost 0.150000" > $out
  echo "material change diffuse Ghost 0.10000" >> $out
elif [ $1 -eq 3 ]
then
  isov=${isotemp:=0.0128}
  isov2=`echo $isov'/'$isoFactor | bc -l`
  isov3=`echo $isov2'/'$isoFactor | bc -l`
  echo 'Using 3 surfaces for isovalues:'
  echo $isov $isov2 $isov3
  echo "material change opacity Ghost 0.400000" > $out
fi
else
   echo "No additional user input."
   echo "Falling back to 3 surfaces with standard values"
   isov=0.012
   isov2=0.004
   isov3=0.00133
  echo "Using standard isovalues: "
  echo "Values: "$isov $isov2 $isov3
  echo "material change opacity Ghost 0.400000" > $out
fi




echo "axes location Off" >> $out
echo "display projection Orthographic" >> $out
echo "display rendermode GLSL" >> $out
echo "display depthcue off" >> $out
echo "color Display Background white" >> $out
echo "menu graphics on" >> $out
echo "material change diffuse Ghost 0.000000" >> $out
echo "material change ambient Ghost 0.300000" >> $out
echo "material change opacity Ghost 0.100000" >> $out
echo "material change shininess Ghost 0.000000" >> $out
echo "mol modstyle 0 0 DynamicBonds 1.600000 0.200000 42.000000" >> $out
echo "mol addrep 0" >> $out
echo "mol modstyle 1 0 VDW 0.200000 42.000000" >> $out 
echo "mol addrep 0" >> $out
echo "mol addrep 0" >> $out
echo "mol addrep 0" >> $out
echo "mol addrep 0" >> $out
echo "mol addrep 0" >> $out
echo "mol addrep 0" >> $out
echo "mol modmaterial 2 0 Opaque" >> $out
echo "mol modmaterial 3 0 Opaque" >> $out
echo "mol modmaterial 4 0 Glass3" >> $out
echo "mol modmaterial 5 0 Glass3" >> $out
echo "mol modmaterial 6 0 Ghost" >> $out
echo "mol modmaterial 7 0 Ghost" >> $out
echo "mol modstyle 2 0 Isosurface  $isov 0 0 0 1 1" >> $out
echo "mol modstyle 3 0 Isosurface -$isov 0 0 0 1 1" >> $out
echo "mol modstyle 4 0 Isosurface  $isov2 0 0 0 1 1" >> $out
echo "mol modstyle 5 0 Isosurface -$isov2 0 0 0 1 1" >> $out
echo "mol modstyle 6 0 Isosurface  $isov3 0 0 0 1 1" >> $out
echo "mol modstyle 7 0 Isosurface -$isov3 0 0 0 1 1" >> $out
echo "mol modcolor 2 0 ColorID 0" >> $out
echo "mol modcolor 3 0 ColorID 1" >> $out
echo "mol modcolor 4 0 ColorID 0" >> $out
echo "mol modcolor 5 0 ColorID 1" >> $out
echo "mol modcolor 6 0 ColorID 0" >> $out
echo "mol modcolor 7 0 ColorID 1" >> $out
echo "" > $plot

echo "#!/bin/bash" > $conv
chmod +x $conv

echo -e "<html>\n<head></head>\n<body>" > $html
echo -e "<table>\n<tr>" >> $html

N=0
for I in *$ifmt
 do echo "mol addfile $I" >> $out
    echo "mol modstyle 2 0 Isosurface  $isov $N 0 0 1 1" >> $plot
    echo "mol modstyle 3 0 Isosurface -$isov $N 0 0 1 1" >> $plot
    echo "mol modstyle 4 0 Isosurface  $isov2 $N 0 0 1 1" >> $plot
    echo "mol modstyle 5 0 Isosurface -$isov2 $N 0 0 1 1" >> $plot
    echo "mol modstyle 6 0 Isosurface  $isov3 $N 0 0 1 1" >> $plot
    echo "mol modstyle 7 0 Isosurface -$isov3 $N 0 0 1 1" >> $plot
    if [ `echo $I | grep 'att'` ] || [ `echo $I | grep 'elec'` ]
   then echo "mol modcolor 2 0 ColorID 1" >> $plot
        echo "mol modcolor 3 0 ColorID 1" >> $plot
        echo "mol modcolor 4 0 ColorID 1" >> $plot
        echo "mol modcolor 5 0 ColorID 1" >> $plot
        echo "mol modcolor 6 0 ColorID 1" >> $plot
        echo "mol modcolor 7 0 ColorID 1" >> $plot
    elif [ `echo $I | grep 'det'` ] || [ `echo $I | grep 'hole'` ]
   then echo "mol modcolor 2 0 ColorID 0" >> $plot
        echo "mol modcolor 3 0 ColorID 0" >> $plot
        echo "mol modcolor 4 0 ColorID 0" >> $plot
        echo "mol modcolor 5 0 ColorID 0" >> $plot
        echo "mol modcolor 6 0 ColorID 0" >> $plot
        echo "mol modcolor 7 0 ColorID 0" >> $plot
    else
        echo "mol modcolor 2 0 ColorID 1" >> $plot
        echo "mol modcolor 3 0 ColorID 0" >> $plot
        echo "mol modcolor 4 0 ColorID 1" >> $plot
        echo "mol modcolor 5 0 ColorID 0" >> $plot
        echo "mol modcolor 6 0 ColorID 1" >> $plot
        echo "mol modcolor 7 0 ColorID 0" >> $plot
    fi
    echo "render TachyonInternal $I.$ofmt" >> $plot

    echo "convert $I.$ofmt $I.png" >> $conv
    echo "rm $I.$ofmt" >> $conv

   echo "<td><img src=\"$I.png\" border=\"1\" width=\"400\">" >> $html
   echo "$I<br></td>" >> $html

   N=$(($N+1))

   if [ $((N%$ncol)) -eq 0 ]; then
      echo "</tr><tr>" >> $html
   fi
done

echo -e "</tr></table>" >> $html
echo -e "</body>\n</html>" >> $html

echo "... finished."


