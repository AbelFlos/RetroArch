LOCAL_PATH := $(call my-dir)
PERF_TEST := 0
HAVE_NEON := 1
HAVE_LOGGER := 1

include $(CLEAR_VARS)
ifeq ($(TARGET_ARCH),arm)
   LOCAL_CFLAGS += -DANDROID_ARM -marm
   LOCAL_ARM_MODE := arm
endif

ifeq ($(TARGET_ARCH),x86)
   LOCAL_CFLAGS += -DANDROID_X86 -DHAVE_SSSE3
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)

ifeq ($(HAVE_NEON),1)
   LOCAL_CFLAGS += -DHAVE_NEON
   LOCAL_SRC_FILES += ../../../audio/utils_neon.S.neon
endif

ifeq ($(HAVE_NEON),1)
   LOCAL_SRC_FILES += ../../../audio/sinc_neon.S.neon
endif
LOCAL_CFLAGS += -DSINC_LOWER_QUALITY

LOCAL_CFLAGS += -DANDROID_ARM_V7
endif


ifeq ($(TARGET_ARCH),mips)
   LOCAL_CFLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
endif

LOCAL_MODULE := retroarch-activity

RARCH_PATH  := ../../..
LOCAL_SRC_FILES  +=	$(RARCH_PATH)/griffin/griffin.c

ifeq ($(HAVE_LOGGER), 1)
   LOCAL_CFLAGS += -DHAVE_LOGGER
   LOGGER_LDLIBS := -llog
endif

ifeq ($(PERF_TEST), 1)
   LOCAL_CFLAGS += -DPERF_TEST
endif

LOCAL_CFLAGS += -Wall -pthread -Wno-unused-function -O3 -fno-stack-protector -funroll-loops -DNDEBUG -DRARCH_MOBILE -DHAVE_GRIFFIN -DANDROID -DHAVE_DYNAMIC -DHAVE_OPENGL -DHAVE_FBO -DHAVE_OVERLAY -DHAVE_OPENGLES -DHAVE_VID_CONTEXT -DHAVE_OPENGLES2 -DGLSL_DEBUG -DHAVE_GLSL -DHAVE_RGUI -DHAVE_SCREENSHOTS -DWANT_MINIZ -DHAVE_ZLIB -DINLINE=inline -DLSB_FIRST -DHAVE_THREADS -D__LIBRETRO__ -I../../../deps/miniz

LOCAL_LDLIBS	:= -L$(SYSROOT)/usr/lib -landroid -lEGL -lGLESv2 $(LOGGER_LDLIBS) -ldl

LOCAL_CFLAGS += -DHAVE_SL
LOCAL_LDLIBS += -lOpenSLES

include $(BUILD_SHARED_LIBRARY)

