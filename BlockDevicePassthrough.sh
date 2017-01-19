#!/bin/bash
STORNAME=$1
DEVICE_NAME=$2

mkdir "/srv/$STORNAME" 
UUID = $( xe sr-create name-label=BlockStorage name-description="Block Storage Passthrough" type=udev content-type=disk device-config:location=/srv/block_storage )

ln -s "$DEVICE_NAME" "/srv/$STORNAME/sdb"

xe sr-scan uuid=$UUID
xe vdi-list sr-uuid=$UUID
