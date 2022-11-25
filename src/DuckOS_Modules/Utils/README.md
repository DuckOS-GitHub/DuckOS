# Hashes of software we preinstall during setup

## Open-Shell

- Name: `OpenShellSetup_4_4_170.exe`
- Size: `7380480 bytes (7207 KiB)`
- SHA1: `d027a8b93d5f08b7e3aeaeebd73a41b3bcffba8c`
- SHA256: `0417041cffed3478f13a840e45ee304ccf8d1f9ca38e4126bc315161ac9f1669`
- Source: https://github.com/Open-Shell/Open-Shell-Menu/releases/tag/v4.4.170
- Last checked by fikinoob on 2022-07-08 (Format: Year - Day - Month)

**STATUS**: *Isn't being preinstalled anymore.*

## 7-zip

- Name: `7z2201-x64.msi`
- Size: `1912320 bytes (1867 KiB)`
- SHA1: `3209574e09ec235b2613570e6d7d8d5058a64971`
- SHA256: `f4afba646166999d6090b5beddde546450262dc595dddeb62132da70f70d14ca`
- Source: https://www.7-zip.org
- Last checked by fikinoob on 2022-07-08 (Format: Year - Day - Month)

**STATUS**: *Is being preinstalled today.*

## VCRedist

- Name: `vcredist.exe`
- Size: `28328234 bytes (27 MiB)`
- SHA1: `66b3fa4cf9d96146cada8292a30c44dec5894928`
- SHA256: `46efa4fe4cb445ecb0b50680c1de03f42a45666c80c9f3782f15b26d78675908`
- Last checked by fikinoob on 2022-07-08 (Format: Year - Day - Month)
- Source: https://github.com/abbodi1406/vcredist/releases/tag/v0.61.0
- Repository: https://github.com/abbodi1406/vcredist

no upload because it's 27MB, but github only allows 25mb max

**STATUS**: *Is being preinstalled today.*

# Arguments

## 7zip

- Arguments: `/quiet` or `/passive`
- We use: `/quiet`
- Source: `msiexec /?`

## OpenShell

- Arguments: `/qn ADDLOCAL=StartMenu`
- Source: `OpenShellSetup_4_4_170.exe /?`

## VCRedist

- Arguments: `/ai` or `/ai /gm2`
- We use: `/ai`
- Source: `vcredist.exe /?`
