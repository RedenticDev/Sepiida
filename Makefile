export TARGET = iphone:clang:14.4:13.3
export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Tweak Preferences

include $(THEOS_MAKE_PATH)/aggregate.mk
