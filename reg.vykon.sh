#!/bin/bash

funkcia1 ()
{


IMP1=$(curl http://10.20.10.250/get_sys[592]/)
IMP2=$(curl http://10.20.10.249/get_sys[593]/)
IMP3=$(curl http://10.20.10.248/get_sys[599]/)
NP=$(cat /var/www/html/reg.frekvencie/nast.reg.P.txt)

VYK1=$(echo "scale=2; (((3600000)/$IMP1)/12800)*50" | bc)
VYK2=$(echo "scale=2; (((3600000)/$IMP2)/1000)" | bc)
VYK3=$(echo "scale=2; (((3600000)/$IMP3)/1000)" | bc)
VYK=$(echo " (($VYK1+$VYK2+$VYK3)*1.03)" | bc | sed 's/\./\n/' | head -n 1 )

echo odber A $VYK1 kW
echo odber B $VYK2 kW
echo odber C $VYK3 kW
echo $VYK

if [[ "$VYK" -ge "$NP" ]] ; then
date
echo výkon je vyšší ako nastavených $NP kW vypínam odber
curl "http://10.20.10.250/sdscep?p=0&sys145=1"
sleep 10

else
date
echo výkon je menší ako nastavených $NP kW zapínam odber
curl "http://10.20.10.250/sdscep?p=0&sys145=2"
sleep 10
fi;
funkcia1
}

funkcia1
