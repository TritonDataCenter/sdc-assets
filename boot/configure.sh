#!/bin/bash
# -*- mode: shell-script; fill-column: 80; -*-
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2014, Joyent, Inc.
#

set -o errexit
set -o pipefail

export PS4='[\D{%FT%TZ}] ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -o xtrace

cat >/opt/local/etc/nginx/nginx.conf.new <<NGINX
user  www  www;
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       /opt/local/etc/nginx/mime.types;
    default_type  application/octet-stream;

    sendfile        off;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  assets;

        location / {
            root   /assets;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   share/examples/nginx/html;
        }

    }
}
NGINX

if ! cmp /opt/local/etc/nginx/nginx.conf.new /opt/local/etc/nginx/nginx.conf; then
    cat /opt/local/etc/nginx/nginx.conf.new >/opt/local/etc/nginx/nginx.conf
    svcadm restart nginx
fi

# Just in case, create /var/logadm
if [[ ! -d /var/logadm ]]; then
  mkdir -p /var/logadm
fi

# Log rotation:
cat >> /etc/logadm.conf <<LOGADM
nginx -C 5 -c -s 100m '/var/log/nginx/{access,error}.log'
LOGADM

exit 0
