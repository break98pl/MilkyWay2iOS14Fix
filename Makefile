export TARGET = iphone:clang:14.5:15.0
export ARCHS = arm64e
export FINALPACKAGE=1
export THEOS_DEVICE_IP= 192.168.1.113

INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = MilkyWay2iOS14Fix

MilkyWay2iOS14Fix_FILES = Tweak.xm 3DTouch.x
MilkyWay2iOS14Fix_CFLAGS = -fobjc-arc

ADDITIONAL_CFLAGS += -Wno-error=unused-variable -Wno-error=unused-function -include Prefix.pch

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
