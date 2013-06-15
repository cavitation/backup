#! /bin/bash

echo
echo "Cleaning up..."
INCDIR="/Volumes/backup/backup_incr"

cd $INCDIR
if [ $? -ne 0 ]
then
	echo "cd to $INCDIR failed"
	exit
fi

dte_start=`date -v-8d "+%y%m%d"`
dte_end=`date -v-7d "+%y%m%d"`
echo "Target date range is $dte_start through $dte_end"

for i in `ls`
do
	#echo "Directory: $i"
	filedate=`echo $i | awk -F_ '{print $2}'`

	#echo "Filedate: $filedate"

	if [ $filedate -ge $dte_start ] && [ $filedate -le $dte_end ]
	then
		echo "Directory: $i"
		echo " gzip contents of $i..."
		gzip -qr $i
		if [ $? -ne 0 ]
		then
			echo "############ failure ############"
			echo "### gzip of files in $i failed ###"
			echo "############ failure ############"
		else
			echo "### gzip of files in $i complete ###"
			echo
		fi
	fi
done


exit
