#
# Copyright (C) 2026 The TWRP Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# TWRP for the Nokia Lumia 1520 (bandit, RM-937/938/939/940), MSM8974,
# booted by lk1st (lk2nd) loaded by BootShim from the Windows Phone UEFI.
#

DEVICE_PATH := device/nokia/bandit

# Platform
TARGET_BOARD_PLATFORM := msm8974
TARGET_BOOTLOADER_BOARD_NAME := MSM8974
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := krait

TARGET_OTA_ASSERT_DEVICE := bandit,RM-937,RM-938,RM-939,RM-940

# Kernel: prebuilt zImage with the appended DTB, from
# github.com/giannoccarol/android_kernel_nokia_msm8974 (lineage-18.1-bandit),
# lineage_bandit_defconfig; see prebuilt/README. The Windows Phone TrustZone
# needs msm_tz_restricted=1 (no SCM CPU boot address, no power collapse).
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/zImage-dtb
BOARD_KERNEL_CMDLINE := androidboot.hardware=bandit androidboot.bootdevice=msm_sdcc.1 \
    msm_tz_restricted=1 androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x04000000 --tags_offset 0x03e00000

# Partitions (installer layout)
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 8589934592
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Recovery
TARGET_RECOVERY_DEVICE_DIRS += $(DEVICE_PATH)
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_SUPPRESS_SECURE_ERASE := true
# The panel is driven by MDSS (fb0, MDP_RGBA_8888: R,G,B,X bytes)
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_QCOM_RTC_FIX := true

# TWRP
TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := 1
RECOVERY_SDCARD_ON_DATA := true
TW_EXTRA_LANGUAGES := true
TW_INCLUDE_CRYPTO := false
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 150
# No FBIOBLANK: the command mode panel has no power on/off sequence yet,
# so the screen is never blanked (the backlight still dims on timeout)
TW_NO_SCREEN_BLANK := true
TW_SCREEN_BLANK_ON_BOOT := false
TW_EXCLUDE_SUPERSU := true
TW_EXCLUDE_TWRPAPP := true
TW_USE_TOOLBOX := true

# USB: legacy android_usb gadget of the 3.4 kernel (adb on FunctionFS,
# MTP on /dev/mtp_usb). No USB mass storage: the kernel names its LUN "lun"
# and TWRP only builds paths with a LUN number.
# The TWRP MTP server opens TW_MTP_DEVICE and hands the descriptor to
# MtpDevHandle, whose start() opens /dev/mtp_usb again; f_mtp allows a
# single open (-EBUSY), so with the default the second open failed ("Failed
# to start usb driver"). Point the first open at /dev/null: start() then
# opens /dev/mtp_usb once.
TW_MTP_DEVICE := /dev/null
