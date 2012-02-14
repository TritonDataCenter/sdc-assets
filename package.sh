#!/usr/bin/bash

set -o xtrace
set -o errexit

RELEASE_TARBALL=$1
echo "Building ${RELEASE_TARBALL}"

ROOT=$(pwd)

tmpdir="/tmp/assets.$$"
mkdir -p ${tmpdir}/root/assets
mkdir -p ${tmpdir}/site

( cd ${tmpdir}; tar -jcf ${ROOT}/${RELEASE_TARBALL} root site)

rm -rf ${tmpdir}
