#! /bin/bash

# Creates new terminal command (backup.command) from the backup script (backup.sh).
# I could just rename the file back and forth, but that's just lazy and dumb.
# Don't believe me?  Then why did I create this script to do it?
# Doesn't make sense?  Well, then I've got a piece of already-chewed bubble gum for you.

SCRIPTS="$HOME/scripts"
BACKUP_SH="backup.sh"
BACKUP_CMD="backup.command"

cd $SCRIPTS

if [ ! -e $BACKUP_SH ]
then
	echo "ERROR: $BACKUP_SH does not exist!"
	exit -1
fi

if [ -e $BACKUP_CMD ]
then
	echo "Removing old $BACKUP_CMD"
	rm -f $BACKUP_CMD
	if [ $? -ne 0 ]
	then
		echo "ERROR removing old $BACKUP_CMD"
		exit -1
	else
		echo "Removal of old $BACKUP_CMD was successful"
	fi
fi

echo "Creating $BACKUP_CMD"
cp $BACKUP_SH $BACKUP_CMD
if [ $? -ne 0 ]
then
	echo "ERROR creating new $BACKUP_CMD"
	exit -1
else
	echo "Creation of new $BACKUP_CMD was successful"
fi

exit

