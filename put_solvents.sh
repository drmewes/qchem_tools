#!/bin/bash
# This very simiple script puts values for dielectric constants and refractive indeces 
# in for the placeholders EPS and NSQ in all input-files in the folder depending on the 
# name (endding) of the respective files.

for i in *mecn.in *acn.in ; do echo mecn ; sed -i s/NSQ/1.81/ $i ; sed -i s/EPS/35.7/ $i ; done
for i in *eth.in *et2o.in ; do echo et2o ; sed -i s/NSQ/1.83/ $i ; sed -i s/EPS/4.33/ $i ; done
for i in *dcm.in ; do echo dcm ; sed -i s/NSQ/2.03/ $i ; sed -i s/EPS/8.93/ $i ; done
for i in *chex.in *chx.in ; do echo chex ; sed -i s/NSQ/2.02/ $i ; sed -i s/EPS/2.03/ $i ; done
for i in *h2o.in ; do echo h2o ; sed -i s/NSQ/1.78/ $i ; sed -i s/EPS/80.1/ $i ; done
for i in *ccl4.in ; do echo ccl4 ; sed -i s/NSQ/2.13/ $i ; sed -i s/EPS/2.24/ $i ; done
for i in *vac.in ; do echo vac ; sed -i s/NSQ/1.00009/ $i ; sed -i s/EPS/1.0001/ $i ; done
for i in *tol.in ; do echo tol ; sed -i s/NSQ/2.25/ $i ; sed -i s/EPS/2.38/ $i ; done


