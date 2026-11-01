#
# Copyright (C) 2014 The CyanogenMod Project
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nokia/bandit

# Generic MSM8974 files (Wi-Fi/audio/media configuration, sepolicy) still
# come from the LineageOS msm8974 common tree of the OnePlus One / Find 7.
# Its BoardConfigCommon.mk is no longer included: the settings below are the
# generic ones, without the Oppo pieces (BOARD_VENDOR oppo, Oppo TrustZone
# OTA assertion and recovery updater, Oppo libinit, Oppo LED HAL,
# /proc/touchpanel double tap).
MSM8974_COMMON_PATH := device/oppo/msm8974-common

BOARD_VENDOR := nokia

TARGET_OTA_ASSERT_DEVICE := bandit,RM-937,RM-938,RM-939,RM-940

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8974
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Platform
TARGET_BOARD_PLATFORM := msm8974

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := krait

# Kernel
# Boot chain: Nokia UEFI -> bootmgr -> BootShim -> lk1st (lk2nd) -> boot.img.
# lk1st picks the single DTB appended to zImage-dtb. The Windows Phone
# TrustZone resets the SoC on SCM SMP bring-up and has no power collapse:
# the kernel handles it (msm_tz_restricted), single core until the UEFI
# parking backend is ported.
# No kernel console on the panel: Android draws on the same framebuffer, so
# fbcon is mapped to a framebuffer that does not exist (fbcon=map:9) and no
# console=tty0; the log stays in dmesg, ramoops and adb.
BOARD_KERNEL_IMAGE_NAME := zImage-dtb
BOARD_KERNEL_SEPARATED_DT := false
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_CMDLINE := androidboot.hardware=bandit androidboot.bootdevice=msm_sdcc.1 \
    msm_tz_restricted=1 nosmp maxcpus=1 \
    fbcon=map:9 androidboot.selinux=permissive
# lk1st loads the kernel at 0x10008000, ramdisk at 0x14000000, tags at
# 0x13e00000 (it ignores the header, these keep the image consistent);
# the kernel runs with PHYS_OFFSET 0x10000000.
BOARD_KERNEL_BASE := 0x10000000
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x04000000 --tags_offset 0x03e00000
BOARD_RAMDISK_USE_XZ := true
TARGET_KERNEL_SOURCE := kernel/nokia/msm8974
TARGET_KERNEL_CONFIG := lineage_bandit_defconfig
TARGET_KERNEL_ADDITIONAL_FLAGS := \
    HOSTCFLAGS="-fuse-ld=lld -Wno-unused-command-line-argument"

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# Audio
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := false
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_EXTN_POST_PROC := true
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_HFP := true
AUDIO_FEATURE_ENABLED_HWDEP_CAL := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_NEW_SAMPLE_RATE := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
BOARD_USES_ALSA_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1

# Binder
TARGET_USES_64_BIT_BINDER := true

# Bluetooth
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# Build
BUILD_BROKEN_DUP_RULES := true

# Charger
BOARD_HEALTHD_CUSTOM_CHARGER_RES := $(MSM8974_COMMON_PATH)/charger/images

# Dexpreopt
WITH_DEXPREOPT_DEBUG_INFO := false

# Display
TARGET_SCREEN_DENSITY := 400

# Encryption: software only. Hardware FDE (cryptfshw) needs a QSEE app
# that the Windows Phone TrustZone does not have.

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/config.fs
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Fonts
EXCLUDE_SERIF_FONTS := true
SMALLER_FONT_FOOTPRINT := true

# Graphics
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS := 0x02000000U
TARGET_CONTINUOUS_SPLASH_ENABLED := true
TARGET_DISABLE_POSTRENDER_CLEANUP := true
TARGET_USES_ION := true

# HIDL
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_bandit
TARGET_RECOVERY_DEVICE_MODULES := libinit_bandit

# Lights (backlight-only HAL in liblight/)
TARGET_PROVIDES_LIBLIGHT := true

# Legacy memfd
TARGET_HAS_MEMFD_BACKPORT := true

# Partitions (provisional: Android partitions are created in Data, see README)
BOARD_BOOTIMAGE_PARTITION_SIZE     := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
BOARD_CACHEIMAGE_PARTITION_SIZE    := 268435456
BOARD_PERSISTIMAGE_PARTITION_SIZE  := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 8589934592
BOARD_ROOT_EXTRA_FOLDERS := firmware persist

# Power
TARGET_USES_INTERACTION_BOOST := true

# Properties
TARGET_SYSTEM_PROP += $(MSM8974_COMMON_PATH)/system.prop $(DEVICE_PATH)/system.prop

# QCOM hardware
BOARD_USES_QCOM_HARDWARE := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.recovery
# The UEFI framebuffer (simple-framebuffer) is a8r8g8b8 and cannot blank
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# TWRP (built from a twrp-11 manifest with WITH_TWRP=true)
ifeq ($(WITH_TWRP),true)
TARGET_RECOVERY_DEVICE_DIRS += $(DEVICE_PATH)/twrp
RECOVERY_SDCARD_ON_DATA := true
TW_THEME := portrait_hdpi
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 255
TW_NO_SCREEN_BLANK := true
TW_EXTRA_LANGUAGES := true
TW_INCLUDE_CRYPTO := false
endif

# SELinux (permissive from the command line during bring-up)
include device/qcom/sepolicy-legacy/sepolicy.mk
BOARD_SEPOLICY_DIRS += \
    $(MSM8974_COMMON_PATH)/sepolicy \
    $(DEVICE_PATH)/sepolicy

# Shims
TARGET_LD_SHIM_LIBS := \
    /system/vendor/lib/libril-qc-qmi-1.so|libaudioclient_shim.so

# Wifi
BOARD_HAS_QCOM_WLAN              := true
BOARD_WLAN_DEVICE                := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_qcwcn
PRODUCT_VENDOR_MOVE_ENABLED      := true
TARGET_DISABLE_WCNSS_CONFIG_COPY := true
TARGET_USES_QCOM_WCNSS_QMI       := true
TARGET_USES_WCNSS_MAC_ADDR_REV   := true
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION           := VER_0_8_X

-include vendor/nokia/bandit/BoardConfigVendor.mk
