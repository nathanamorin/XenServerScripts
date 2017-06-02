#!/bin/bash
#
# Written By: Mr Rahul Kumar
# Visit: https://tecadmin.net/backup-running-virtual-machine-in-xenserver/
#
# Edited by Nathan Morin nathanmorin.com
# Last Edited: Jun 2, 2017
# Version 2.0

DATE=`date +%d%b%Y`
XSNAME=`echo $HOSTNAME`
UUIDFILE="/tmp/xen-uuids.txt"
NFS_SERVER_IP="IP_ADDR"
MOUNTPOINT="/backupmnt"
FILE_LOCATION_ON_NFS="/volume1/Backups/vms"

### Create mount point

mkdir -p "$MOUNTPOINT"

### Mounting remote nfs share backup drive

[ ! -d "$MOUNTPOINT" ]  && echo "No mount point found, kindly check"; exit 0
mount ${NFS_SERVER_IP}:"$FILE_LOCATION_ON_NFS" "$MOUNTPOINT"

BACKUPPATH="${MOUNTPOINT}/${XSNAME}/${DATE}"
mkdir -p "$BACKUPPATH"
[ ! -d "$BACKUPPATH" ]  && echo "No backup directory found"; exit 0


# Fetching list UUIDs of all VMs running on XenServer & Creating backup for each
xe vm-list is-control-domain=false is-a-snapshot=false | grep uuid | cut -d":" -f2 | while read VMUUID
do
    VMNAME=`xe vm-list uuid=$VMUUID | grep name-label | cut -d":" -f2 | sed 's/^ *//g'`

    SNAPUUID=`xe vm-snapshot uuid=$VMUUID new-name-label="SNAPSHOT-$VMUUID-$DATE"`

    xe template-param-set is-a-template=false ha-always-run=false uuid="$SNAPUUID"

    xe vm-export vm="$SNAPUUID" filename="$BACKUPPATH/$VMNAME-$DATE.xva"

    xe vm-uninstall uuid="$SNAPUUID" force=true

done

umount "$MOUNTPOINT"
