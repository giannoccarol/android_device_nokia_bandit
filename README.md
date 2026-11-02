# TWRP device tree for the Nokia Lumia 1520 (bandit)

TWRP 3.7.0_9 for the Nokia Lumia 1520 (RM-937, RM-938, RM-939, RM-940,
Snapdragon 800 / MSM8974) running Android through the Windows Phone boot
chain: Windows Phone UEFI → bootmgr → BootShim → lk1st (lk2nd) → boot or
recovery partition.

## Build

Minimal TWRP manifest, `twrp-9.0` branch:

```bash
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0
repo sync
git clone https://github.com/giannoccarol/twrp_device_nokia_bandit -b twrp-9.0 device/nokia/bandit
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
lunch omni_bandit-eng
mka recoveryimage
```

The Android 9 build system needs python2 as `python` and `LC_ALL=C` on newer
hosts (Ubuntu 20.04 used here).

## Kernel

`prebuilt/zImage-dtb` is built from
[android_kernel_nokia_msm8974](https://github.com/giannoccarol/android_kernel_nokia_msm8974),
branch `lineage-18.1-bandit` (commit in `prebuilt/README`), with
`lineage_bandit_defconfig`. It is the same kernel as the LineageOS 18.1 build:
MDSS display (continuous splash of the panel left on by the UEFI), Synaptics
RMI4 touch, PM8941 WLED backlight, 4 CPUs through the UEFI parking protocol.
The Windows Phone TrustZone needs `msm_tz_restricted=1` on the command line.

## Notes

- Partitions follow the Android layout written by the bandit installer.
  The modem EFS partitions (modemst1, modemst2, fsg, fsc) are backed up
  together as "EFS"; lk1st (aboot) and persist can be backed up too.
- No data encryption support: the LineageOS 18.1 build does not encrypt
  `/data`.
- The screen is never blanked (no panel power sequence yet); the backlight
  dims on timeout.

## Credits

- [TeamWin](https://github.com/TeamWin) — TWRP.
- [LineageOS](https://github.com/LineageOS) — MSM8974 kernel and device trees
  the bandit trees are based on.
- KorelisLabs, [lumia-1520-mainline](https://github.com/KorelisLabs/lumia-1520-mainline)
  — boot chain, TrustZone quirks, framebuffer and firmware research on the 1520.
- Markynose (Mark Buchok), [lumia930-linux](https://github.com/Markynose/lumia930-linux)
  — SMP through the UEFI mailboxes, touch and graphics on the Lumia 930.
- imbushuo, [boot-shim](https://github.com/imbushuo/boot-shim).
- msm8916-mainline, [lk2nd](https://github.com/msm8916-mainline/lk2nd).
- René Lergner (HeathCliff), [WPinternals](https://github.com/ReneLergner/WPinternals)
  — bootloader unlock.
- Android4Lumia950 — the Lumia 950 XL installer and TWRP, used as the model for
  the Windows Phone boot chain.
