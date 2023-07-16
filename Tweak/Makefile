INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Sepiida
$(TWEAK_NAME)_FILES = $(wildcard *.x) $(wildcard *.m) $(wildcard *.mm)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -include ../Prefix.h
$(TWEAK_NAME)_LIBRARIES = colorpicker
$(TWEAK_NAME)_FRAMEWORKS = IOKit
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = BluetoothManager

include $(THEOS_MAKE_PATH)/tweak.mk
