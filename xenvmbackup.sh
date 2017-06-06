#!/bin/bash
#
# Created by Nathan Morin nathanmorin.com
# Last Edited: June, 2017
# Version 2.0
# Built from original created by Mr Rahul Kumar. Visit: https://tecadmin.net/backup-running-virtual-machine-in-xenserver/


DATE=`date +%d%b%Y`
XSNAME=`echo $HOSTNAME`
NFS_SERVER_IP="stor_stark.dev.nathanmorin.com"
MOUNTPOINT="/backupmnt"
FILE_LOCATION_ON_NFS="/volume1/Backups/vms"
PIGZ_EXEC=/usr/local/bin/pigz

# Create mount point

mkdir -p "$MOUNTPOINT"

# Mounting remote nfs share backup drive

[ ! -d "$MOUNTPOINT" ]  && echo "No mount point found, kindly check" && exit 1
mount ${NFS_SERVER_IP}:"$FILE_LOCATION_ON_NFS" "$MOUNTPOINT"

BACKUPPATH="${MOUNTPOINT}/${XSNAME}/${DATE}"
mkdir -p "$BACKUPPATH"
[ ! -d "$BACKUPPATH" ]  && echo "No backup directory found" && exit 1

echo "starting backup"

# Fetching list UUIDs of all VMs running on XenServer & Creating backup for each

xe vm-list is-control-domain=false is-a-snapshot=false | grep uuid | cut -d":" -f2 | while read VMUUID
do
    VMNAME=`xe vm-list uuid=$VMUUID | grep name-label | cut -d":" -f2 | sed 's/^ *//g'`

    if [ ! -f "$BACKUPPATH/$VMNAME-$DATE.xva" ]
        then
            SNAPUUID=`xe vm-snapshot uuid=$VMUUID new-name-label="SNAPSHOT-$VMUUID-$DATE"`

            echo "Backing Up $VMNAME"

            xe template-param-set is-a-template=false ha-always-run=false uuid="$SNAPUUID"

            xe vm-export vm="$SNAPUUID" filename="$BACKUPPATH/$VMNAME-$DATE.xva"

            xe vm-uninstall uuid="$SNAPUUID" force=true
    fi


done

# Compress Files

for VM_BACKUP in "$BACKUPPATH"/*.xva
do
    echo "Compressing $VM_BACKUP"
    [ ! -f "$VM_BACKUP.tgz" ] && tar cf - "$VM_BACKUP" | $PIGZ_EXEC -9 -p 16 > "$VM_BACKUP.tgz"
    [ -f "$VM_BACKUP.tgz" ] && rm "$VM_BACKUP"
done

umount "$MOUNTPOINT"

echo "done backing up"