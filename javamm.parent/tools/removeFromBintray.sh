#!/bin/bash
# remove p2 metadata artifacts from bintray remote path
#Sample Usage: removeFromBintray.sh apikey version {snapshots}
API=https://api.bintray.com

BINTRAY_API_KEY=$1
PCK_VERSION=$2

if [ -z $3 ]; then PACKAGE="releases"; else PACKAGE="snapshots"; fi

if [ -z $3 ]; then BASE_PATH="/"; else BASE_PATH="snapshots/"; fi

PATH_TO_REPOSITORY="${BASE_PATH}releases/${PCK_VERSION}"

# fixed for this repo
BINTRAY_USER=lorenzobettini
BINTRAY_REPO=javamm

function main() {
remove_p2_metadata
}

function remove_p2_metadata() {
echo "user    : ${BINTRAY_USER}"
echo "key     : ${BINTRAY_API_KEY}"
echo "repo    : ${BINTRAY_REPO}"
echo "package : ${PACKAGE}"
echo "version : ${PCK_VERSION}"
echo "path    : ${PATH_TO_REPOSITORY}"

echo "Removing release ${PCK_VERSION}..."
curl -X DELETE -u${BINTRAY_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/packages/${BINTRAY_USER}/${BINTRAY_REPO}/${PACKAGE}/versions/${PCK_VERSION}"
echo ""

echo "Removing metadata content.xml.xz..."
curl -X DELETE -u${BINTRAY_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PATH_TO_REPOSITORY}/content.xml.xz"
echo ""
echo "Removing metadata artifacts.xml.xz..."
curl -X DELETE -u${BINTRAY_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PATH_TO_REPOSITORY}/artifacts.xml.xz"
echo ""
echo "Removing metadata content.jar..."
curl -X DELETE -u${BINTRAY_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PATH_TO_REPOSITORY}/content.jar"
echo ""
echo "Removing metadata artifacts.jar..."
curl -X DELETE -u${BINTRAY_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PATH_TO_REPOSITORY}/artifacts.jar"
echo ""
echo "Removing metadata compositeContent.xml..."
curl -X DELETE -u${BINTRAY_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PATH_TO_REPOSITORY}/compositeContent.xml"
echo ""
echo "Removing metadata compositeArtifacts.xml..."
curl -X DELETE -u${BINTRAY_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PATH_TO_REPOSITORY}/compositeArtifacts.xml"
echo ""
echo "Removing metadata p2.index..."
curl -X DELETE -u${BINTRAY_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PATH_TO_REPOSITORY}/p2.index"
echo ""

}

main "$@"
