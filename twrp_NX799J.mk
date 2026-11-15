#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nubia/NX799J

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Device identifier
PRODUCT_DEVICE := NX799J
PRODUCT_NAME := twrp_NX799J
PRODUCT_BRAND := REDMAGIC
PRODUCT_MANUFACTURER := nubia
PRODUCT_MODEL := RedMagic 11 Air

# Assert
TARGET_OTA_ASSERT_DEVICE := NX799J

# Fingerprint (local build, 2025-12-24 RedMagicOS11.0.10MR)
BUILD_FINGERPRINT := REDMAGIC/NX799J/NX799J:16/BQ2A.250705.001-BP2A.250605.031.A3/20251224.170850:user/release-keys

# Theme
TW_STATUS_ICONS_ALIGN := center
