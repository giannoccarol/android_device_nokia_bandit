/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <string>

#include <android-base/file.h>
#include <android-base/strings.h>

#include "DeviceLibinit.h"
#include "init_msm8974.h"
#include "vendor_init.h"

// The Lumia UEFI passes the product code (RM-937/938/939/940) on the
// command line. Until its exact key is read from a real boot log, only the
// generic model is set here.
void vendor_load_device_properties()
{
    property_override("ro.product.model", "Lumia 1520");
    property_override("ro.product.vendor.model", "Lumia 1520");
}
