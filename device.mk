#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/nokia/bandit

# Screen (1080x1920, 6")
TARGET_SCREEN_HEIGHT := 1920
TARGET_SCREEN_WIDTH := 1080
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Rootdir
PRODUCT_PACKAGES += \
    fstab.bandit \
    init.bandit.rc \
    init.qcom.usb.rc \
    init.recovery.qcom.rc \
    ueventd.qcom.rc

# Bring-up debugging: adbd runs as root from the first boot (userdebug,
# ro.debuggable=1); adb is enabled by default on debuggable builds and
# SELinux is permissive from the kernel command line.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    service.adb.root=1

$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_k.mk)

# Vendor blobs specific to the 1520 (ADSP/WCNSS/modem firmware split from
# the stock Windows Phone image; never committed with personal data)
$(call inherit-product, vendor/nokia/bandit/bandit-vendor.mk)

# Temporary base: LineageOS msm8974 common tree (OnePlus One / Find 7).
# Oppo-specific pieces are replaced with bandit ones as bring-up proceeds.
$(call inherit-product, device/oppo/msm8974-common/msm8974.mk)
