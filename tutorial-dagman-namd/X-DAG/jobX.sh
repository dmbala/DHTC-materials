#!/bin/bash

tar xzf OutFilesFromNAMD_jobA0.tar.gz 
cd  OutFilesFromNAMD_jobA0 
EnergyA0=`grep ENERGY: namd_jobA0.log | awk '{print $12}' | tail -n 1`
TempA0=`grep "set temperature" namd_jobA0.conf | awk '{print $3}'`
cd ../

tar xzf OutFilesFromNAMD_jobB0.tar.gz 
cd  OutFilesFromNAMD_jobB0 
EnergyB0=`grep ENERGY: namd_jobB0.log | awk '{print $12}' | tail -n 1`
TempB0=`grep "set temperature" namd_jobB0.conf | awk '{print $3}'`
cd ../

echo "Energy and Temp Data before Exchange"   > Exhange.out
echo "TempA0 = $TempA0 "   >> Exhange.out
echo "TempB0 = $TempB0 "   >> Exhange.out


cp namd_jobA1.conf A1.conf
cp namd_jobB1.conf B1.conf

if [ "$EnergyA0" > "$EnergyB0" ] 
 then 
      TempStore=$TempA0 
      TempA0=$TempB0
      TempB0=$TempStore
      sed "s/set temperature.*/set temperature  $TempA0/g"  namd_jobA1.conf > A1confile
      sed "s/set temperature.*/set temperature  $TempB0/g"  namd_jobB1.conf > B1confile
      
      echo "Energy and Temp Data After Exchange"   >> Exhange.out
      echo "EnergyA0 = $EnergyA0 "   >> Exhange.out
      echo "EnergyB0 = $EnergyB0 "   >> Exhange.out
      echo "TempA0 = $TempA0 "   >> Exhange.out
      echo "TempB0 = $TempB0 "   >> Exhange.out
fi 



