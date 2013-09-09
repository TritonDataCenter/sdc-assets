#!/usr/bin/bash

set -o xtrace
set -o errexit

RELEASE_TARBALL=$1
echo "Building ${RELEASE_TARBALL}"

ROOT=$(pwd)

tmpdir="/tmp/assets.$$"
mkdir -p ${tmpdir}/root/assets
mkdir -p ${tmpdir}/site

# update/create sdc-scripts
git submodule update --init ${ROOT}/deps/sdc-scripts

# copy in boot scripts
mkdir -p ${tmpdir}/root/opt/smartdc/boot
cp -R ${ROOT}/deps/sdc-scripts/* ${tmpdir}/root/opt/smartdc/boot/
cp -R ${ROOT}/boot/* ${tmpdir}/root/opt/smartdc/boot/

( cd ${tmpdir}; tar -jcf ${ROOT}/${RELEASE_TARBALL} root site)

rm -rf ${tmpdir}
