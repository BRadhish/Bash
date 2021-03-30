#!/bin/bash

data=( `aws ec2 describe-instances --filter "Name=tag:Name,Values=*jmeter*" --query "Reservations[*].Instances[*].[InstanceId,Tags[?Key=='Name'].Value]" --profile staging` )
count=${#data[*]}
mode=$1
for (( i=0; i<${count}; i=i+2))
do
   instanceId=${data[i]}
   ec2TagName=${data[i+1]}
   if [ ${mode} == "ON" ]
   then
     echo "STARTING.. Instance ID: ${instanceId}, Machine Name: ${ec2TagName}"
     aws ec2 start-instances --instance-ids ${instanceId} --profile staging
   elif [ ${mode} == "OFF" ]
   then
     echo "STOPPING.. Instance ID: ${instanceId}, Machine Name: ${ec2TagName}"
     aws ec2 stop-instances --instance-ids ${instanceId} --profile staging
   else
     echo "Incorrect option. Please use option ON (for starting the instances) and OFF (for stopping the instances)"
     break
   fi
done
