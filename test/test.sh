#!/bin/bash
function getOldVersion() {
	oldVersion=$(awk -F= '{if($ARGC>1) print $2}' ./install.sh)
	echo oldVersion=$oldVersion
}
function deleteOldVersion() {
	git tag -d $oldVersion
	git push origin -d $oldVersion
}
function generatorNewVersion() {
	newVersion=$(date +%s)
	echo newVersion=$newVersion
}
function updateNewVersion() {
	sed -i "4s/.*/	version=$newVersion/g" ./install.sh
}

function deploy() {
	git add -A
	read -p "please input your commit message: " message
	git commit -am"$message"
	git tag $newVersion
	git tag $newVersion
	git push -f origin master
}
function main() {
	getOldVersion
	deleteOldVersion
	# generatorNewVersion
	# updateNewVersion
	# deploy
}
main
