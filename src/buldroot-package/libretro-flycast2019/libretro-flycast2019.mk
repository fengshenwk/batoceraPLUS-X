################################################################################
#
# LIBRETRO-FLYCAST2019
#
################################################################################
# Version.: Commits on Aug 13, 2019
LIBRETRO_FLYCAST2019_VERSION = 6baf827fc6ab650e9776681b0b1b4da3063f71e8
LIBRETRO_FLYCAST2019_SITE = $(call github,libretro,flycast,$(LIBRETRO_FLYCAST2019_VERSION))
LIBRETRO_FLYCAST2019_LICENSE = GPLv2

LIBRETRO_FLYCAST2019_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_FLYCAST2019_EXTRA_ARGS  = HAVE_OPENMP=1
LIBRETRO_FLYCAST2019_EXTRA_ARGS += LDFLAGS=-lpthread
LIBRETRO_FLYCAST2019_EXTRA_ARGS += HAVE_VULKAN=1
LIBRETRO_FLYCAST2019_EXTRA_ARGS += HAVE_OIT=1


# LIBRETRO_PLATFORM is not good for this core, because
# for rpi, it contains "unix rpi" and this core do an "if unix elif rpi ..."

# special cases for special plateform then...
# an other proper way may be to redo the Makefile to do "if rpi elif unix ..." (from specific to general)
# the Makefile imposes that the platform has gles (or force FORCE_GLES is set) to not link with lGL

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
	LIBRETRO_FLYCAST2019_PLATFORM = rpi3
	LIBRETRO_FLYCAST2019_EXTRA_ARGS += FORCE_GLES=1 ARCH=arm
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_XU4)$(BR2_PACKAGE_BATOCERA_TARGET_LEGACYXU4),y)
	LIBRETRO_FLYCAST2019_PLATFORM = odroid
	LIBRETRO_FLYCAST2019_EXTRA_ARGS += BOARD=ODROID-XU4 FORCE_GLES=1 ARCH=arm
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_ROCKPRO64),y)
	LIBRETRO_FLYCAST2019_PLATFORM = rockpro64
	LIBRETRO_FLYCAST2019_EXTRA_ARGS += ARCH=arm
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_ODROIDN2),y)
	LIBRETRO_FLYCAST2019_PLATFORM = odroidn2
	LIBRETRO_FLYCAST2019_EXTRA_ARGS += ARCH=arm
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_TINKERBOARD),y)
	LIBRETRO_FLYCAST2019_PLATFORM = tinkerboard
	LIBRETRO_FLYCAST2019_EXTRA_ARGS += ARCH=arm
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_MIQI),y)
	LIBRETRO_FLYCAST2019_PLATFORM = tinkerboard
	LIBRETRO_FLYCAST2019_EXTRA_ARGS += ARCH=arm
endif

define LIBRETRO_FLYCAST2019_BUILD_CMDS
    CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" AR="$(TARGET_AR)" -C $(@D)/ -f Makefile $(LIBRETRO_FLYCAST2019_EXTRA_ARGS) platform="$(LIBRETRO_FLYCAST2019_PLATFORM)"
endef

define LIBRETRO_FLYCAST2019_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/flycast_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/flycast2019_libretro.so
endef

$(eval $(generic-package))
