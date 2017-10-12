#/bin/bash
## Generates inputs for the pegasus calculations. 

if [ "$#" -eq 0 ]
   then
	echo "pls state give the number of serial jobs" 
	echo "Example: program.bash 10 " 
   exit
   fi 

njob=$1
mkdir -p ../inputs
cp ubq_gbis_eq_dag-S1.Jo0.conf_ref ../inputs/.
cp ubq_gbis_eq_dag-S1.Jo1.conf_ref ../inputs/.

cd ../inputs

# djob is the number of independent dags where each one is a linear dag. 
djob=2
for ((j=1;j<$djob;j++))
 do
   
   x=$(( RANDOM % 250 + 300 ))

   echo "temperature of dag-S$j.Jo0 is $x" 
   if [ $j -gt 1 ]; then        
     sed "s/dag-S1.Jo0/dag-S$j.Jo0/g" ubq_gbis_eq_dag-S1.Jo0.conf_ref | sed "s/dag-S1.Jo1/dag-S$j.Jo1/g" | sed "s/^set temperature    400/set temperature $x/g" > ubq_gbis_eq_dag-S$j.Jo0.conf

     sed "s/dag-S1.Jo0/dag-S$j.Jo0/g" ubq_gbis_eq_dag-S1.Jo1.conf_ref | sed "s/dag-S1.Jo1/dag-S$j.Jo1/g" | sed "s/^set temperature    400/set temperature $x/g" > ubq_gbis_eq_dag-S$j.Jo1.conf
   fi
# njob is the number of jobs in a linear dag

    for ((i=0;i<$njob;i++))
     do
# Here the variable S$j stands for Sub dags and Jo$i for the jobs 
   if [ $i -gt 0 ]; then        
       i1=$((i-1))
       sed "s/dag-S1.Jo1/dag-S$j.Jo$i/g" ubq_gbis_eq_dag-S1.Jo1.conf_ref | sed "s/dag-S1.Jo0/dag-S$j.Jo$i1/g" | sed "s/^set temperature    400/set temperature $x/g" > ubq_gbis_eq_dag-S$j.Jo$i.conf
   fi 
 
   if [ $i -eq 0 ]; then        
       sed "s/dag-S1.Jo0/dag-S$j.Jo0/g" ubq_gbis_eq_dag-S1.Jo0.conf_ref | sed "s/^set temperature    400/set temperature $x/g" > ubq_gbis_eq_dag-S$j.Jo0.conf
   fi 

    done

 done

rm ../inputs/*.conf_ref
echo -n "number of input files=   " 
ls *.conf | wc -l 
