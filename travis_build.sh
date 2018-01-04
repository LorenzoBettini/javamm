#!/bin/bash

set -ev
if [ "$TRAVIS_OS_NAME" == "osx" ]; then
	if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
		echo "Build on MacOSX: Pull Request"
		mvn -f javamm.releng/pom.xml clean verify -Pide-tests
	else
		echo "Skipping build on MacOSX for standard commit"
	fi
else
	echo "Build on Linux"
	mvn -f javamm.releng/pom.xml clean verify -Pide-tests $ADDITIONAL
fi 
