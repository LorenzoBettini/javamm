#!/bin/bash

set -ev
if [ "${TRAVIS_OS_NAME}" = "linux" ]; then
	sh -e /etc/init.d/xvfb start
	sleep 5
	mutter --sm-disable --replace 2> mutter.err &
fi 
