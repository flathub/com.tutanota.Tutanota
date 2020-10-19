#!/bin/bash

set -eu

# get the correct commit from the tutanota repo (last tag that matches tutanota-release*)
[ -d tutanota ] || git clone https://github.com/ganthern/tutanota.git
cd tutanota
TAG=`git describe --tags --abbrev=0 --match "tutanota-release-*" HEAD`
VERSION=`echo ${TAG} | tail -c 8`
ARCHIVE="tutanota-desktop-${VERSION}-unpacked-linux.tar.gz"
URL="https://github.com/tutao/tutanota/releases/download/${TAG}/${ARCHIVE}"
CHANGELOG_URL="https://github.com/tutao/tutanota/releases/${TAG}"
DATE=`date +"%Y-%m-%d"`
git fetch
git checkout -f "${TAG}"

# generate the client
npm install
node dist --unpacked --custom-desktop-release
cd ..

echo "packing client"
(cd ./tutanota/build/desktop && tar -czvf ../../${ARCHIVE} ./linux-unpacked > /dev/null)

CHECKSUM=`sha256sum ${ARCHIVE} | head -c64`
echo "${CHECKSUM}"

# generate manifest
node ./manifest-template.js $CHECKSUM $URL

# update appdata
node ./appdata-update.js $VERSION $DATE $CHANGELOG_URL
nano ./com.tutanota.Tutanota.appdata.xml.tmp
mv ./com.tutanota.Tutanota.appdata.xml.tmp ./com.tutanota.Tutanota.appdata.xml

# clean up
rm -rf ./.idea ./generate-cache ./tutanota ./com.tutanota.Tutanota.appdata.xml.tmp

# new branch, git commit & push to flathub repo
git checkout -b ${TAG}
git add .
git commit -m "update to v${VERSION}"
git push -uf origin ${TAG}
git checkout master

echo ""
echo ""
echo "Done! Please remember to upload"
echo "${ARCHIVE}"
echo "to the assets of github release ${TAG} at"
echo "${CHANGELOG_URL}"
echo "(file url should be ${URL})"