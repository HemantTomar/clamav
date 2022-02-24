#!/bin/bash

# initialize default values for parameters
export SCAN_AT_STARTUP=${SCAN_AT_STARTUP:='1'}
export SCAN_ONLY_NEW_FILES=${SCAN_ONLY_NEW_FILES:='1'}
export FRESHCLAM_AT_STARTUP=${FRESHCLAM_AT_STARTUP:='1'}
#export FOLDER_TO_SCAN=${FOLDER_TO_SCAN:=/folder-to-scan/}
export CRON_CLAMSCAN=${CRON_CLAMSCAN:='0 1 * * *'}
#export CLAMSCAN_OPTIONS=${CLAMSCAN_OPTIONS:='--recursive=yes --allmatch=yes --remove=no --suppress-ok-results'}
export CRON_FRESHCLAM=${CRON_FRESHCLAM:='0 * * * *'}


# load crontab from template
envsubst < /etc/cron.d/tasks.tmpl > /etc/cron.d/tasks
echo "-> Installing crontab:"
cat /etc/cron.d/tasks
crontab /etc/cron.d/tasks

if [ "$FRESHCLAM_AT_STARTUP" = "1" ]; then
  echo "-> Running freshclam (updating virus database)"
  freshclam -F
fi

if [ "$SCAN_AT_STARTUP" = "1" ]; then
  /scripts/do-clamscan.sh
fi

# start the scheduler (force env needed by cron scripts juste before)
env > /etc/environment
exec cron -f
