#!/bin/bash

#UPDATE THE COMPARTMENT ID IN WHICH THE INSTANCES LIES. IF WE HAVE INSTANCES FROM DIFFERENT COMPARTMENTS, RUN THIS SCRIPT AFTER GROUPING THE INSTANCES COMPARTMENT WISE AS MUCH TIME AS NEEDED. 

#WHILE RUNNING THE SCRIPT, MAKE SURE THAT OCI SDK IS CONFIGURED TO POINT THE CORRECT REGION. CHECK IN THE ~/OCI/config in the Linux VM.

compid=ocid1.compartment.oc1..aaaaaaaabbbbbbbbbbbbbbbbbbcccccccccccccdddddddd


echo "This script is used to delete the instances in bulk in a particular compartment. Please make sure that you have changed the compartment as per the instances in the script before running it."

read -p "Are you sure to continue? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

#ADD ALL THE INSTANCES HOSTNAME WITH A SINGLE SPACE IN BELOW LINE 

for instances in  hostname1 hostname2 hostname3

do

echo "Deletion operation starting for instance $instances"

oci compute instance list --compartment-id $compid --output table --query "data [?\"display-name\" == '""$instances""'].{OCID:id}" >instanceid

INSTID=$(grep -i ocid1.instance.oc1* instanceid | awk '{print $2}')

echo "The Instance ID for $instances is $INSTID"

echo "Terminating $instances"

oci compute instance terminate --instance-id   $INSTID --preserve-boot-volume YES --force --wait-for-state TERMINATED

echo "Termination of instance $instances is completed."
done
