#!/bin/bash
set -eu

readonly ARG_1="${1:-}"
readonly HOME='/home/ubuntu'
readonly TARGET_ZIP=${ARG_1:-"${HOME}/minecraft_$(date +%Y%m%d).zip"}

function help() {
	echo 'Usage:'
	echo '  backup.sh'
	exit 1
}

function backup() {
	local MINECRAFT_ROOT='/var/tmp'
	local TARGET_FILES=(minecraft/allowlist.json \
	                    minecraft/server.properties \
	                    minecraft/permissions.json \
	                    minecraft/worlds \
	                    minecraft/world_templates \
	                    minecraft/env)

	cd ${MINECRAFT_ROOT}
	rm -f "${TARGET_ZIP}"
	zip -r "${TARGET_ZIP}" "${TARGET_FILES[@]}"
	aws s3 cp "${TARGET_ZIP}" s3://uribou123-backup-minecraft-world/
}

if [ "${ARG_1}" = "-h" ] || [ "${ARG_1}" = "--help" ]; then
	help
	exit 1
fi

sudo systemctl stop minecraft-user-monitor
sudo systemctl stop minecraft

backup
