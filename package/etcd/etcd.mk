################################################################################
#
# etcd
#
################################################################################
ETCD_VERSION = v3.0.14
ETCD_SITE = https://github.com/coreos/etcd/archive
ETCD_SOURCE = $(ETCD_VERSION).tar.gz

ETCD_LICENSE = Apache-2.0
ETCD_LICENSE_FILES = LICENSE

ETCD_DEPENDENCIES = host-go

ETCD_MAKE_ENV = \
	$(HOST_GO_TARGET_ENV) \
	GOBIN="$(@D)/bin" \
	GOPATH="$(@D)/gopath" \
	CGO_ENABLED=0

ETCD_REPO_PATH = github.com/coreos/etcd

ETCD_GO_BUILD_FLAGS = \
	-v -x -installsuffix cgo

ETCD_GLDFLAGS = \
	-X $(ETCD_REPO_PATH)/cmd/vendor/$(ETCD_REPO_PATH)/version.GitSHA=$(ETCD_VERSION) \

define ETCD_CONFIGURE_CMDS
	# Put sources at prescribed GOPATH location.
	mkdir -p $(@D)/gopath/src
	ln -s $(@D)/cmd/vendor/* $(@D)/gopath/src/
endef

define ETCD_BUILD_CMDS
	cd $(@D) && $(ETCD_MAKE_ENV) $(HOST_GO_ROOT)/bin/go \
		build $(ETCD_GO_BUILD_FLAGS) -ldflags "$(ETCD_GLDFLAGS)" \
		-o $(@D)/gopath/bin/etcd $(ETCD_REPO_PATH)/cmd/
	cd $(@D) && $(ETCD_MAKE_ENV) $(HOST_GO_ROOT)/bin/go \
		build $(ETCD_GO_BUILD_FLAGS) -ldflags "$(ETCD_GLDFLAGS)" \
		-o $(@D)/gopath/bin/etcdctl $(ETCD_REPO_PATH)/etcdctl
endef

define ETCD_INSTALL_TARGET_CMDS
	mkdir -p $(@D)/usr/local/bin
	$(INSTALL) -D -m 0755 $(@D)/gopath/bin/etcd $(TARGET_DIR)/usr/local/bin/etcd
	$(INSTALL) -D -m 0755 $(@D)/gopath/bin/etcdctl $(TARGET_DIR)/usr/local/bin/etcdctl
endef

define ETCD_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(ETCD_PKGDIR)/etcd2_sysv.conf \
		$(TARGET_DIR)/etc/etcd2.conf
	$(INSTALL) -m 0755 -D $(ETCD_PKGDIR)/S80etcd2 \
		$(TARGET_DIR)/etc/init.d/S80etcd2
endef

define ETCD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(ETCD_PKGDIR)/etcd2.service \
		$(TARGET_DIR)/usr/lib/systemd/system/etcd2.service

	$(INSTALL) -D -m 644 $(ETCD_PKGDIR)/etcd2_tmpfiles.conf \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/etcd2.config

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -sf $(TARGET_DIR)/usr/lib/systemd/system/etcd2.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/etcd2.service
endef

$(eval $(generic-package))
