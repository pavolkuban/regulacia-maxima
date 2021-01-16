#!/bin/bash

funkcia1 ()
{
IMP1=$(curl http://10.20.10.250/get_sys[592]/)
IMP2=$(curl http://10.20.10.249/get_sys[593]/)
IMP3=$(curl http://10.20.10.248/get_sys[599]/)
NP1=$(cat /var/www/html/reg.frekvencie/reg.Pmax.txt)

VYK1=$(echo "scale=2; (((3600000)/$IMP1)/12800)*50" | bc)
VYK2=$(echo "scale=2; (((3600000)/$IMP2)/1000)" | bc)
VYK3=$(echo "scale=2; (((3600000)/$IMP3)/1000)" | bc)
VYK=$(echo " (($VYK1+$VYK2+$VYK3)*1.03)" | bc | sed 's/\./\n/' | head -n 1 )

echo odber EUB $VYK1 kW
echo odber Oles $VYK2 kW
echo odber Jaško $VYK3 kW
echo $VYK
echo $VYK > ./aktualny-vykon.txt

if [[ "$VYK" -ge "$NP1" ]] ; then
date
echo Odoberaný výkon je vyšší ako nastavených $NP1 kW vypínam odber
curl "http://10.20.10.250/sdscep?p=0&sys145=1"
echo vypnutý
sleep 300
else
date
echo Výkon $VYK kW je nižší ako mastavené maximum
sleep 5
fi;


funkcia2
}

funkcia2 ()
{
IMP1=$(curl http://10.20.10.250/get_sys[592]/)
IMP2=$(curl http://10.20.10.249/get_sys[593]/)
IMP3=$(curl http://10.20.10.248/get_sys[599]/)
NP2=$(cat /var/www/html/reg.frekvencie/reg.Pmin.txt)

VYK1=$(echo "scale=2; (((3600000)/$IMP1)/12800)*50" | bc)
VYK2=$(echo "scale=2; (((3600000)/$IMP2)/1000)" | bc)
VYK3=$(echo "scale=2; (((3600000)/$IMP3)/1000)" | bc)
VYK=$(echo " (($VYK1+$VYK2+$VYK3)*1.03)" | bc | sed 's/\./\n/' | head -n 1 )

echo odber EUB $VYK1 kW
echo odber Oles $VYK2 kW
echo odber Jaško $VYK3 kW
echo $VYK
echo $VYK > ./aktualny-vykon.txt

if [[ "$VYK" -le "$NP2" ]] ; then
date
echo Odoberaný výkon je nižší ako nastavených $NP2 kW zapínam odber
curl "http://10.20.10.250/sdscep?p=0&sys145=2"
echo zapnutý
sleep 20

else
date
echo Výkon $VYK kW je vyšší ako nastavené minimum
sleep 5

fi;
funkcia1
}

funkcia2
funkcia1
