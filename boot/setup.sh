#!/bin/bash
# -*- mode: shell-script; fill-column: 80; -*-
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2018, Joyent, Inc.
#

# set -o errexit
# set -o pipefail

export PS4='[\D{%FT%TZ}] ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -o xtrace

# Include common utility functions (then run the boilerplate)
source /opt/smartdc/boot/lib/util.sh
sdc_common_setup

# Cookie to identify this as a SmartDC zone and its role
mkdir -p /var/smartdc/assets

nginx_manifest="/opt/local/lib/svc/manifest/nginx.xml"

# Import nginx (config is already setup by configure above)
if [[ -z $(/usr/bin/svcs -a | grep nginx) ]]; then
  echo "Importing nginx service"
  /usr/sbin/svccfg import ${nginx_manifest}
  /usr/sbin/svcadm enable -s nginx
elif [[ -z $(/usr/bin/svcs -a | grep online.*nginx) ]]; then
  # have manifest, but not enabled, do that now
  echo "Enabling nginx service"
  /usr/sbin/svcadm disable -s nginx
  /usr/sbin/svcadm enable -s nginx
else
  fatal "Can't start nginx service in assets."
fi

# All done, run boilerplate end-of-setup
sdc_setup_complete

exit 0
