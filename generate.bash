#!/bin/bash

set -eu

# get the correct commit from the tutanota repo
[ -d tutanota ] || git clone https://github.com/ganthern/tutanota.git
cd tutanota
TAG=`git describe --tags --abbrev=0 --match "flatpak*" HEAD`
VERSION=`echo ${TAG} | tail -c 8`
ARCHIVE="tutanota-desktop-${VERSION}-unpacked-linux.tar.gz"
URL="https://github.com/ganthern/tutanota/releases/download/${TAG}/${ARCHIVE}"
git fetch
git checkout -f "${TAG}"

# make a build to get the package-lock of the desktop client
# it's copied to the root of the repo automatically
echo $VERSION
echo $URL
echo $TAG
npm install
node dist --unpacked --custom-desktop-release
cd ..

# tar up the client
tar -czvf ${ARCHIVE} ./build/desktop/linux-unpacked

# get checksum
CHECKSUM=(`sha256sum ${ARCHIVE}`)

# generate manifest

# clean up
rm -rf ./.idea ./generate-cache ./tutanota