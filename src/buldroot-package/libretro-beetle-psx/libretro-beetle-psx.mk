################################################################################
#
# LIBRETRO_BEETLE_PSX
#
################################################################################
# Version.: Commits on Feb 11, 2022
LIBRETRO_BEETLE_PSX_VERSION = 88929ae90b4807a41b1b240377ab440e39ecf2cc
LIBRETRO_BEETLE_PSX_SITE = $(call github,libretro,beetle-psx-libretro,$(LIBRETRO_BEETLE_PSX_VERSION))
LIBRETRO_BEETLE_PSX_LICENSE = GPLv2

LIBRETRO_BEETLE_PSX_EXTRAOPT  = HAVE_OPENGL=1
LIBRETRO_BEETLE_PSX_EXTRAOPT += HAVE_VULKAN=1
LIBRETRO_BEETLE_PSX_EXTRAOPT += HAVE_CDROM=0

LIBRETRO_BEETLE_PSX_OUTFILE=mednafen_psx_libretro.so

ifeq ($(BR2_PACKAGE_XORG7),y)
	LIBRETRO_BEETLE_PSX_EXTRAOPT += HAVE_HW=1
    LIBRETRO_BEETLE_PSX_OUTFILE=mednafen_psx_hw_libretro.so
endif

define LIBRETRO_BEETLE_PSX_BUILD_CMDS
    CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) LD="$(TARGET_CXX)" CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		AR="$(TARGET_AR)" -C $(@D) -f Makefile $(LIBRETRO_BEETLE_PSX_EXTRAOPT) platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_PSX_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/$(LIBRETRO_BEETLE_PSX_OUTFILE) \
		$(TARGET_DIR)/usr/lib/libretro/mednafen_psx_libretro.so
endef

$(eval $(generic-package))
