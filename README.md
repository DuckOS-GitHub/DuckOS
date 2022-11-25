<h1 align="center">
  <br>
  <img src="https://github.com/DuckOS-GitHub/DuckOS/blob/main/banner_new.png?raw=true" alt="DuckOS" width="900">
  <br>
  DuckOS
  <br>
</h1>
<h4 align="center">An open modification of Windows 10, designed to reduce latency and increase performance.</h4>

<p align="center">
  <a href="https://github.com/DuckOS-GitHub/DuckOS/blob/main/src/DuckOS_Modules/DuckOS-post_script.bat"><img src="https://img.shields.io/badge/post%20install%20script-download-green" alt="Post Install Script"></a>
  <a href="https://dsc.gg/duckos"><img src="https://img.shields.io/discord/998645880368410694.svg?label=discord" alt="DuckOS Discord"></a>
</p>

<p align="center">
  <a href="https://github.com/DuckOS-GitHub/DuckOS/graphs/contributors"><img src="https://img.shields.io/github/contributors/DuckOS-GitHub/DuckOS.svg" alt="Contributors"></a>
  <a href="https://github.com/DuckOS-GitHub/DuckOS/network/members"><img src="https://img.shields.io/github/forks/DuckOS-GitHub/DuckOS?style=flat" alt="Forks"></a>
  <a><img src="https://img.shields.io/github/stars/DuckOS-GitHub/DuckOS" alt="Stars"></a>
  <a href="https://github.com/DuckOS-GitHub/DuckOS/issues"><img src="https://img.shields.io/github/issues/DuckOS-GitHub/DuckOS" alt="Issues"></a>
  <a href="https://github.com/DuckOS-GitHub/DuckOS/pulls"><img src="https://img.shields.io/github/issues-pr/DuckOS-GitHub/DuckOS" alt="Pull requests"></a>
  <a href="https://github.com/DuckOS-GitHub/DuckOS/blob/main/LICENSE"><img src="https://img.shields.io/github/license/DuckOS-GitHub/DuckOS" alt="License"></a>
</p>

# DuckOS

## Notes & Disclaimers

⚠️ **- This ISO is in the development. This means that bugs will occur, but DuckOS is stable enough!**
**🐧 - If the Windows image is not good for you for some reason, check out our Linux version**

## **What do we offer?**

DuckOS is **pre-tweaked**. While maintaining compatibility, it is also good for performance. Here is a good list of what we did to make the image very fast:

- Disabled powersavings of PCIe devices
- Automatically enabled MSI Mode (Message Signaled Interrupts)
- Minimized drivers and services
- Disabled most of Microsoft' telemetry, you do not have to worry about anyone spying on you
- Disabled unneeded devices
- Optimized boot configuration
- Optimized process scheduling
- Removed almost every unneeded Windows boot entry, including clearing scheduled tasks

## **Debloated**

DuckOS is debloated and de-cluttered, pre-installed applications and other unneccesary components are removed. Although this can break some compatibility of Microsoft apps, it significantly reduces ISO and install size. Programs such as Windows Defender, and such are stripped completely. This modification is for gaming and latency enthusiasts.

## **Security**

Since there are a lot of features disabled for performance, we also care about security.

**What do we do?**

We disable features that can leak personal information or be exploited and be used in a large attack.
Those features are:

- [Spectre](https://spectreattack.com/spectre.pdf)
- [Meltdown](https://meltdownattack.com/meltdown.pdf)
- [DMA Remapping](https://docs.microsoft.com/en-us/windows/security/information-protection/kernel-dma-protection-for-thunderbolt)
- [(Patched) ATMFD Exploit](https://msrc.microsoft.com/update-guide/en-US/vulnerability/CVE-2020-1020)
- [(Patched) Print Nightmare](https://us-cert.cisa.gov/ncas/current-activity/2021/06/30/printnightmare-critical-windows-print-spooler-vulnerability)
- [Remote Desktop](https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=Windows+Remote+Desktop)
- [NetBIOS](https://en.wikipedia.org/wiki/NetBIOS)

*NOTE: Clicking on the blue text will re-direct you to a link with an explanation for each and every feature.*
