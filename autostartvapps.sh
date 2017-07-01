# AutoStart XenServer vApps with the tag autostart in their description
# Script originally created by Raido Consultants - http://www.raido.be
# Script updated and shared by E.Y. Barthel - http://www.virtues.it
# Comments updated and added to XenServerScripts repo by Nathan Morin - https://nathanmorin.com
# SRC http://www.virtues.it/2014/12/step-by-step-guide-automatically-start-a-vapp-on-xenserver/

# Start script /opt/autostartvapps.sh on boot
# add @reboot /opt/autostartvapps.sh to crontab
# Add below tag to description of vApp and vApp with start on boot


TAG="autostart"
 
# helper function
function xe_param()
{
    PARAM=$1
    while read DATA; do
        LINE=$(echo $DATA | egrep "$PARAM")
        if [ $? -eq 0 ]; then
            echo "$LINE" | awk 'BEGIN{FS=": "}{print $2}'
        fi
    done
} # Get all Applicances
sleep 20
VAPPS=$(xe appliance-list | xe_param uuid)
for VAPP in $VAPPS
do
    # debug info
    # echo "Esther's AutoStart : Checking vApp $VAPP"
    VAPP_TAGS="$(xe appliance-param-get uuid=$VAPP param-name=name-description)"
    if [[ $VAPP_TAGS == *$TAG* ]]; then
        # action info:
        echo "starting vApp $VAPP";
        xe appliance-start uuid=$VAPP;
        sleep 20
    fi
done
