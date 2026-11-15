# TWRP device tree for RedMagic 11 Air (NX799J)

- Device: Nubia RedMagic 11 Air
- Codename: NX799J
- SoC: Qualcomm Snapdragon 8 Elite (SM8750, platform `sun`)
- Kernel: 6.6.92-android15-8 (prebuilt from local `boot_a.img`)
- Android: 16 (API 36), virtual A/B, FBE policy 2 + inlinecrypt + wrappedkey_v0

## Status

Built from the SM8750 reference trees below. On-device validation proceeds in phases.

| Feature | State | Note |
| --- | --- | --- |
| ADB | configured | `ro.adb.secure=0` in system.prop |
| Display / backlight | configured, untested | panel0-backlight max 2047; rate 120 (165 reserved for P1 tuning) |
| Touch | configured, untested | gdix_input_agent kept out of the input blacklist; odm_tsc preloaded |
| Decryption | blocked on P2 | needs SPU-backed gatekeeper/keymint/weaver + aligned vendor libs extracted from the live vendor partition |
| Fastbootd | configured | |
| Flashing / MTP | configured | |
| Fan | configured | max31760_fan + soc_fan nodes written at post-fs |
| USB-OTG | configured | |
| Vibrator | configured, untested | /dev/awinic_haptic, RICHTAP env wired; firmware staged from reference tree, replace with local vendor copy in P2 |
| MicroSD | configured | 8804000.sdhci → /storage/sdcard1 |

## Known limits (do not assume working until tested)

1. Vendor partition image was not backed up during collection; recovery binaries and
   libraries are carried over from the NX789J reference (vendor fingerprint baseline AQ3A.240812.002).
   P2 must re-extract the local `vendor`, `vendor_dlkm`, `odm` partitions and align:
   - `android.hardware.weaver-service-spu-qti`
   - `android.hardware.security.keymint-service-spu-qti`
   - `vendor.qti.hardware.secureprocessor`, `vendor.qti.hardware.spu-service`
   - awinic haptic firmware and all keymint/gatekeeper dependencies.
2. Touch firmware lives in encrypted `/data/vendor/touchscreen/fw`; it is staged as a
   ramdisk overlay under `recovery/root/data/vendor/touchscreen/fw`.
3. A/B device: flash both `recovery_a` and `recovery_b`. Official recovery in place may
   restrict bootloader fastboot — use fastbootd when needed. Bootloader must be truly unlocked;
   efisp/GBL spoofing does not count.
4. Backup/restore on this generation can differ from the live system; do not rely on TWRP
   backup as the only rollback path.
5. `prebuilt/dtb/vendor_boot.dtb` is a reference-only copy of the local vendor_boot DTB
   extracted for later DTB overlay or device-tree tuning; the build does not reference it.

## Build

Manifest: [TWRP-Test/platform_manifest_twrp_aosp](https://github.com/TWRP-Test/platform_manifest_twrp_aosp), branch `twrp-16.0`.

```bash
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_NX799J-ap3a-userdebug
m recoveryimage
```

## Thanks

- [reminon/twrp_device_nubia_nx789j](https://github.com/reminon/twrp_device_nubia_nx789j) (main base tree, SM8750)
- [kindle4jerry/twrp_device_nubia_nx733j](https://github.com/kindle4jerry/twrp_device_nubia_nx733j) (sun platform secondary reference)
