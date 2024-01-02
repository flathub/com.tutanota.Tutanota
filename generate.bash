#!/bin/bash

set -eu

# get the correct commit from the tutanota repo (last tag that matches tutanota-release*)
rm -rf ./tutanota/ && git clone https://github.com/tutao/tutanota.git
cd tutanota
git fetch
# Get the last desktop tag in tutanota. abbrev=0 is needed because if the tag is not on the top
# then git-describe will add some identifier do denote that. We don't want any of that.
TAG=`git describe --tags $(git rev-list --tags --max-count=1) --match "tutanota-desktop-release-*" --abbrev=0`
if [[ $TAG == tutanota-desktop-release-* ]]; then
   echo $TAG
 else
   echo "tag ${TAG} doesn't match tutanota-desktop-release-*"
   exit 1
fi
VERSION=`echo ${TAG:25}`
ARCHIVE="tutanota-desktop-${VERSION}-unpacked-linux.tar.gz"
URL="https://github.com/tutao/tutanota/releases/download/${TAG}/${ARCHIVE}"
CHANGELOG_URL="https://github.com/tutao/tutanota/releases/${TAG}"
DATE=`date +"%Y-%m-%d"`
git checkout -f "${TAG}"

# generate the client
npm install
npm run build-packages
node desktop --unpacked --custom-desktop-release
cd ..

echo "packing client"
(cd ./tutanota/artifacts/desktop && tar -czvf ../../../${ARCHIVE} ./linux-unpacked > /dev/null)

CHECKSUM=`sha256sum ${ARCHIVE} | head -c64`
echo SHA256 CHECKSUM:
echo "${CHECKSUM}"

# generate manifest
node ./manifest-template.js $CHECKSUM $URL

# update appdata
node ./appdata-update.js $VERSION $DATE $CHANGELOG_URL
${VISUAL:-${EDITOR:-vi}} ./com.tutanota.Tutanota.metainfo.xml.tmp
mv ./com.tutanota.Tutanota.metainfo.xml.tmp ./com.tutanota.Tutanota.metainfo.xml

# clean up
rm -rf ./.idea ./generate-cache ./tutanota ./com.tutanota.Tutanota.metainfo.xml.tmp

# new branch, git commit & push to flathub repo
git branch -D ${TAG} || true
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
