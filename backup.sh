#! /bin/bash
DEST="ajwolf@192.168.11.120::backup"
RSYNC_OPTS="-av --delete --stats --exclude-from=$HOME/.backup_excludes -p --one-file-system"
DATEEXT=`date "+%y%m%d"`
TIMEEXT=`date "+%H%M"`

CURRMONTH=`date "+%m"`
CURRDAY=`date "+%d"`
CURRYR=`date "+%y"`

BKDIR="/Volumes/backup"
BACKUPDIR="backup_incr/backup_$DATEEXT"

cd $BKDIR
pwd

#######################################################################
#
# Create daily backup directory
#
#######################################################################

if [ ! -e $BACKUPDIR ]
then
	echo "Creating $BACKUPDIR"
	mkdir $BACKUPDIR
	if [ $? -ne 0 ]
	then
		echo "### Failed to create $BACKUPDIR ###"
		exit
	fi
fi

#######################################################################
#
# Create incremental backup directory.
#
#######################################################################

cd $BACKUPDIR
#echo "now in directory:"
pwd

INCDIR="b_$TIMEEXT"

echo
mkdir $INCDIR
if [ $? -ne 0 ]
then
	echo "### Failed to create $INCDIR ###"
	exit
fi

echo "Tracked changes in: $BACKUPDIR/$INCDIR"

# change directory back to $HOME
cd

#######################################################################
#
# Make backup.
#
#######################################################################

backuplist="$HOME"

for i in $backuplist
do
	echo "rsync $RSYNC_OPTS --backup --backup-dir=$BACKUPDIR/$INCDIR $i $DEST"
	rsync $RSYNC_OPTS --backup --backup-dir="$BACKUPDIR/$INCDIR" $i $DEST
done


#######################################################################
#
# Remove old incremental files
#
#######################################################################

echo
echo "Cleaning up..."

cd $BKDIR/backup_incr

if [ $? -ne 0 ]
then
	echo "cd to $BKDIR/backup_incr failed"
	exit
fi

for i in `ls`
do
	LASTMNTH=`date -v-1m "+%y%m%d"`

	#echo "File $i"

	B_EXT=`echo $i | awk -F_ '{ print $2}'`
	#echo "B_EXT = $B_EXT"
	#let B_EXT_YYMM=$B_EXT/100
	#let B_EXT_MM=$B_EXT_YYMM%100
	#let B_EXT_DD=$B_EXT%100

	#echo "YearMonth = $B_EXT_YYMM, Month = $B_EXT_MM, Day = $B_EXT_DD"

	if [ $B_EXT -lt $LASTMNTH ]
	then
		echo "Deleting old incremental file: $i"
		rm -rf $i
		if [ $? -ne 0 ]
		then
			echo "### clean-up failed ###"
			exit
		fi
	fi

done

exit
