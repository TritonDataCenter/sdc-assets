#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2019, Joyent, Inc.
#

NAME=assets

ifeq ($(VERSION), "")
    @echo "Use gmake"
endif

TAR = gtar

ifeq ($(TIMESTAMP),)
    TIMESTAMP=$(shell date -u "+%Y%m%dT%H%M%SZ")
endif

ASSETS_PUBLISH_VERSION := $(shell git symbolic-ref HEAD | \
      awk -F / '{print $$3}')-$(TIMESTAMP)-g$(shell \
                git describe --all --long | awk -F '-g' '{print $$NF}')

RELEASE_TARBALL=assets-pkg-$(ASSETS_PUBLISH_VERSION).tar.gz

#
# Stuff used for buildimage
#
BASE_IMAGE_UUID		= a9368831-958e-432d-a031-f8ce6768d190
BUILDIMAGE_NAME		= assets
BUILDIMAGE_DESC		= SDC Assets
BUILDIMAGE_PKGSRC	= nginx

AGENTS = amon

DISTCLEAN_FILES += root

ENGBLD_USE_BUILDIMAGE	= true
ENGBLD_REQUIRE		:= $(shell git submodule update --init deps/eng)
include ./deps/eng/tools/mk/Makefile.defs
TOP ?= $(error Unable to access eng.git submodule Makefiles.)

ifeq ($(shell uname -s),SunOS)
	include ./deps/eng/tools/mk/Makefile.agent_prebuilt.defs
endif


.PHONY: all

all:

release: $(RELEASE_TARBALL)

$(RELEASE_TARBALL):
	TAR=$(TAR) bash package.sh $(RELEASE_TARBALL)

publish:
	mkdir -p $(ENGBLD_BITS_DIR)/assets
	cp $(RELEASE_TARBALL) $(ENGBLD_BITS_DIR)/assets/$(RELEASE_TARBALL)

include ./deps/eng/tools/mk/Makefile.targ
ifeq ($(shell uname -s),SunOS)
	include ./deps/eng/tools/mk/Makefile.agent_prebuilt.targ
endif
