#!/bin/bash
set -eu

readonly ARG_1="${1:-}"
readonly HOME='/home/ubuntu'
readonly TARGET_ZIP="${HOME}/minecraft_$(date +%Y%m%d).zip"

function help() {
	echo 'Usage:'
	echo '  update.sh bedrock-server-1.19.50.02.zip'
	exit 1
}

function update() {
	local TARGET="${1}"

	cd /var/tmp
	if [ -d minecraft.old ]; then
		mv minecraft.old minecraft.old.old
	fi
	mv minecraft minecraft.old

	mkdir -p minecraft
	cd minecraft
	unzip "${TARGET}"

	cd -
}

function restore() {
	cd /var/tmp
	unzip -o "${TARGET_ZIP}"
}

if [ "${#@}" -le 0 ] || [ "${ARG_1}" = "-h" ] || [ "${ARG_1}" = "--help" ]; then
	help
	exit 1
fi

if [ -f "$(pwd -P)/${ARG_1}" ]; then
	TARGET="$(pwd -P)/${ARG_1}"
else
	echo "${1} not found"
	exit 1
fi

if [ -f "backup.sh" ]; then
	bash backup.sh "${TARGET_ZIP}"
else
	sudo systemctl stop minecraft-user-monitor
	sudo systemctl stop minecraft
fi
update "${TARGET}"
restore

sudo systemctl start minecraft
sudo systemctl status minecraft
sudo systemctl start minecraft-user-monitor.service
sudo systemctl status minecraft-user-monitor.service

sudo rm -rf /var/tmp/minecraft.old.old

