#!/usr/bin/bash
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2019, Joyent, Inc.
#

set -o xtrace
set -o errexit

RELEASE_TARBALL=$1
echo "Building ${RELEASE_TARBALL}"

if [[ -z "$TAR" ]]; then
	TAR=gtar
fi

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

( cd ${tmpdir}; ${TAR} -I pigz -cf ${ROOT}/${RELEASE_TARBALL} root site)

rm -rf ${tmpdir}
