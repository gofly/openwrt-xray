include $(TOPDIR)/rules.mk

PKG_NAME:=xray
PKG_VERSION:=25.9.11
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/xray
	SECTION:=net
	CATEGORY:=Network
	TITLE:=X-Ray
	DEPENDS:=+kmod-nft-socket +kmod-nft-tproxy
endef

define Package/xray/conffiles
/etc/config/xray
/etc/xray
endef

define Build/Prepare
	$(Build/Prepare/Default)
	rm -rf $(PKG_BUILD_DIR)/*
	mkdir -p $(PKG_BUILD_DIR)/root ./root/usr/share/xray
	$(CP) ./root/* $(PKG_BUILD_DIR)/root/
	wget -O $(DL_DIR)/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
	wget -O $(DL_DIR)/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
	wget -O $(DL_DIR)/wan_bp4_list.txt  https://raw.githubusercontent.com/mayaxcn/china-ip-list/master/chnroute.txt
	wget -O $(DL_DIR)/wan_bp6_list.txt  https://raw.githubusercontent.com/mayaxcn/china-ip-list/master/chnroute_v6.txt
	wget -O $(DL_DIR)/xray.gz https://github.com/gofly/openwrt-xray/releases/download/v$(PKG_VERSION)/xray_linux-arm64_$(PKG_VERSION).gz && \
		gunzip -f $(DL_DIR)/xray.gz
endef

define Build/Compile

endef

define Package/xray/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/root/etc/config/xray $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/xray
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/root/etc/xray/config.json $(1)/etc/xray
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/root/etc/init.d/xray $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(DL_DIR)/xray $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/share/xray
	$(INSTALL_DATA) $(DL_DIR)/geoip.dat $(1)/usr/share/xray
	$(INSTALL_DATA) $(DL_DIR)/geosite.dat $(1)/usr/share/xray
	$(INSTALL_DATA) $(DL_DIR)/wan_bp4_list.txt $(1)/usr/share/xray
	$(INSTALL_DATA) $(DL_DIR)/wan_bp6_list.txt $(1)/usr/share/xray
endef

$(eval $(call BuildPackage,xray))
