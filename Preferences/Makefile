include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SPDPrefs
$(BUNDLE_NAME)_FILES = $(shell find . -type f -name "*.m")
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc -include ../Prefix.h
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_LIBRARIES = colorpicker
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences OnBoardingKit
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)
