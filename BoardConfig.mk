#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Temporary base: LineageOS msm8974 common tree
-include device/oppo/msm8974-common/BoardConfigCommon.mk

DEVICE_PATH := device/nokia/bandit

TARGET_OTA_ASSERT_DEVICE := bandit,RM-937,RM-938,RM-939,RM-940

# Kernel
# Boot chain: Nokia UEFI -> bootmgr -> BootShim -> lk1st (lk2nd) -> boot.img.
# lk1st picks the single DTB appended to zImage-dtb. The Windows Phone
# TrustZone resets the SoC on SCM SMP bring-up and has no power collapse:
# the kernel handles it (msm_tz_restricted), single core until the UEFI
# parking backend is ported.
BOARD_KERNEL_IMAGE_NAME := zImage-dtb
BOARD_KERNEL_SEPARATED_DT := false
BOARD_KERNEL_CMDLINE := androidboot.hardware=bandit androidboot.bootdevice=msm_sdcc.1 \
    msm_tz_restricted=1 nosmp maxcpus=1 \
    console=tty0 fbcon=font:SUN12x22 androidboot.selinux=permissive
# lk1st loads the kernel at 0x10008000, ramdisk at 0x14000000, tags at
# 0x13e00000 (it ignores the header, these keep the image consistent);
# the kernel runs with PHYS_OFFSET 0x10000000.
BOARD_KERNEL_BASE := 0x10000000
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x04000000 --tags_offset 0x03e00000
TARGET_KERNEL_SOURCE := kernel/nokia/msm8974
TARGET_KERNEL_CONFIG := lineage_bandit_defconfig

# Display
TARGET_SCREEN_DENSITY := 400

# Partitions (provisional: Android partitions are created in Data, see README)
BOARD_BOOTIMAGE_PARTITION_SIZE     := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
BOARD_CACHEIMAGE_PARTITION_SIZE    := 268435456
BOARD_PERSISTIMAGE_PARTITION_SIZE  := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 8589934592
BOARD_ROOT_EXTRA_FOLDERS := firmware persist

# Init
SOONG_CONFIG_OPPO_MSM8974_INIT_DEVICE_LIB := //$(DEVICE_PATH):libinit_bandit

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.recovery

-include vendor/nokia/bandit/BoardConfigVendor.mk
