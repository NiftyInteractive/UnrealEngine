#!/bin/bash
# Copyright Epic Games, Inc. All Rights Reserved.

set -e
set -x

display_usage() {
	echo "usage: SignAndBuild DeveloperIDApplication [DeveloperIDInstaller]"
	echo -e 'examples:\n\tSignAndBuild "Epic Game International (X123456789)" "Epic Game International (X987654321)"'
	echo -e '\tSignAndBuild "Epic Game International (X123456789)"'
	exit 1
}

cd "`dirname "$0"`"

# $1 is Developer ID Application
# $2 is Developer ID Installer

if [ "$#" -lt 1 ]; then
	display_usage
fi
if [ "$#" -gt 2 ]; then
	display_usage
fi

DevAppId="$1"
if [ "$#" -eq 2 ]; then
	DevInsId="$2"
else
	DevInsId="$DevAppId"
fi

DevIdApplication="Developer ID Application: $DevAppId"
DevIdInstaller="Developer ID Installer: $DevInsId"

for i in {2019..2021}
do
	/usr/bin/codesign --force --deep --sign "$DevIdApplication" --timestamp=none "../../.build/${i}/Plugin/UnrealDatasmithSketchUp/DatasmithSketchUpRuby.bundle"
done

packagesbuild --keychain "$DevIdInstaller" "Datasmith DirectLink for SketchUp.pkgproj"
