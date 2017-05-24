#!/bin/bash

set -ev
if [ "$TRAVIS_OS_NAME" == "osx" ]; then
	if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
		echo "Build on MacOSX: Pull Request"
		mvn -f javamm.releng/pom.xml clean verify -U -Dfindbugs.skip=true -Pide-tests -Dtycho.disableP2Mirrors=true
	else
		echo "Build on MacOSX for standard commit"
		mvn -f javamm.releng/pom.xml clean verify -U -Dfindbugs.skip=true -Pide-tests -Dtycho.disableP2Mirrors=true
	fi
else
	echo "Build on Linux"
	mvn -f javamm.releng/pom.xml clean verify -U -Dfindbugs.skip=true -Pide-tests -Pjacoco-report coveralls:report -Dtycho.disableP2Mirrors=true
fi 
