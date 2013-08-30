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

# copy in sdc-boot scripts
mkdir -p ${tmpdir}/root/opt/smartdc/sdc-boot
cp -R ${ROOT}/deps/sdc-scripts/* ${tmpdir}/root/opt/smartdc/sdc-boot/
cp -R ${ROOT}/sdc-boot/* ${tmpdir}/root/opt/smartdc/sdc-boot/

( cd ${tmpdir}; tar -jcf ${ROOT}/${RELEASE_TARBALL} root site)

rm -rf ${tmpdir}
