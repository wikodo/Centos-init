#!/bin/bash
function getOldVersion() {
	echo $FUNCNAME
	oldVersion=$(awk -F= '{if($ARGC>1) print $2}' ./install.sh)
	echo oldVersion=$oldVersion
}
function deleteOldVersion() {
	echo $FUNCNAME
	git tag -d $oldVersion
	git push origin -d $oldVersion
}
function generatorNewVersion() {
	echo $FUNCNAME
	newVersion=$(date +%s)
	echo newVersion=$newVersion
}
function updateNewVersion() {
	echo $FUNCNAME
	sed -i "3s/.*/	version=$newVersion/g" ./install.sh
}

function deploy() {
	echo $FUNCNAME
	git add -A
	read -p "please input your commit message: " message
	git commit -am"$message"
	git push -f origin master
	git tag $newVersion
	git push -f origin $newVersion
}
function main() {
	getOldVersion
	deleteOldVersion
	generatorNewVersion
	updateNewVersion
	deploy
}
main
