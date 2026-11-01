# Device tree for the Nokia Lumia 1520 (bandit) — LineageOS 18.1

**Status: bring-up skeleton. Not built, not booted.**

| | |
|---|---|
| SoC | Qualcomm MSM8974 (Snapdragon 800), 4x Krait 400, ARMv7 |
| GPU | Adreno 330 |
| RAM / storage | 2 GB / 16-32 GB eMMC |
| PMIC / codec | PM8941 + PM8841 / WCD9320 |
| Wi-Fi / BT | WCNSS Pronto (WCN3680) |
| Display | 1080x1920 DSI, 6" |
| Variants | RM-937, RM-938, RM-939, RM-940 |

## Boot chain

The 1520 has no Android bootloader. Android is started from the Windows
Phone boot manager:

```
Nokia UEFI -> bootmgr -> BCD entry "Android (lk1st)" -> BootShim -> lk1st -> boot.img
```

- lk1st: [giannoccarol/lk2nd](https://github.com/giannoccarol/lk2nd), branch `bandit`.
- BootShim: imbushuo's `elf-loader-pre3` release.
- The bootloader must be unlocked with WPinternals first. Holding volume up
  at power-on still reaches flash mode for recovery.

## Known platform constraints

The Windows Phone TrustZone does not implement the SCM calls Android
kernels use on MSM8974:

- SMP bring-up through SCM resets the SoC: single core (`nosmp`) until the
  UEFI parking-mailbox backend (proven on the Lumia 930) is ported;
- deep idle (power collapse) goes through TrustZone: disabled;
- PAS/PIL works (the ADSP boots), so remote processors can be loaded.

## Layout

- `BoardConfig.mk`, `device.mk`: inherit LineageOS `device/oppo/msm8974-common`
  for now; Oppo-specific parts will be replaced.
- Kernel: [giannoccarol/android_kernel_nokia_msm8974](https://github.com/giannoccarol/android_kernel_nokia_msm8974),
  branch `lineage-18.1-bandit`.
- Vendor: [giannoccarol/android_vendor_nokia_bandit](https://github.com/giannoccarol/android_vendor_nokia_bandit).
- Manifest: [giannoccarol/bandit-manifests](https://github.com/giannoccarol/bandit-manifests).

## Credits

- [LineageOS](https://github.com/LineageOS): `android_device_oneplus_bacon`,
  `android_device_oppo_msm8974-common`, `android_device_oppo_common` and
  `android_kernel_oppo_msm8974`, used as the base of this tree and kernel.
- KorelisLabs, [lumia-1520-mainline](https://github.com/KorelisLabs/lumia-1520-mainline):
  boot chain, hardware map and TrustZone findings for the 1520.
- Markynose (Mark Buchok), [lumia930-linux](https://github.com/Markynose/lumia930-linux):
  SMP through the stock UEFI parking mailboxes on MSM8974 Lumias.
- imbushuo, [boot-shim](https://github.com/imbushuo/boot-shim).
- msm8916-mainline, [lk2nd](https://github.com/msm8916-mainline/lk2nd).
- René Lergner (HeathCliff), [WPinternals](https://github.com/ReneLergner/WPinternals).
- Android4Lumia950 (djokcho, EpicLPer, j0sh1x and the community): the Lumia
  950/950 XL Android port this project follows.
