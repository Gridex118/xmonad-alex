#!/bin/bash

# Assume that a backup device is mounted at /mnt/backup
BACKUP_MOUNT_STATUS=0

if timeout 3s bash -c "[[ -f /mnt/backup/config ]]"; then
   BACKUP_MOUNT_STATUS=1
fi

if niri msg windows| grep -q "PopupPanelBackupWindow"; then
    BACKUP_MOUNT_STATUS=2
fi

GETOPTS_OUT=$(getopt -o rs -l run-backup,status -n "backup.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

while true; do
	case "$1" in
		-r | --run-backup )
            alacritty --hold --class "PopupPanelBackupWindow" -e sudo /usr/local/bin/backup.sh --ask
            exit 0 ;;
        -s | --status )
            echo "$BACKUP_MOUNT_STATUS"
            shift ;;
        * )
            shift; break ;;
	esac
done
