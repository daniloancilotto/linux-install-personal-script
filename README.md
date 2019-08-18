# Production Environment Script

### Supported Systems
* Ubuntu and Derivatives
  * [Ubuntu - 18.04 ~ 19.04](https://ubuntu.com/)
  * [Linux Mint - 19.1 ~ 19.2](https://linuxmint.com/)

### Supported Architectures
* 64-bit - Fully
  * amd64
* 32-bit - Partially
  * i386

### Install Apps
* Base Apps - Latest
  * Wget
  * Unzip
  * Tar
  * Jq
  * Neofetch
  * Htop
* App Hubs - Latest
  * [Snap](https://snapcraft.io/store)
  * [Flatpak](https://flathub.org/home)
    * Repositories
      * Flathub
* OpenJDK - 8
* [4K Video Downloader - 4.8.2 (Dpkg)](https://www.4kdownload.com/products/product-videodownloader)
* [Angry IP Scanner - 3.6.0 (Dpkg)](https://angryip.org/)
* [Balena Etcher - 1.5.53 (Portable)](https://www.balena.io/etcher/)
  * Configurations
    * Desktop
      * ~/.local/share/applications/appimagekit-balena-etcher-electron.desktop
* [CPU-X - 3.2.4 (Portable)](https://github.com/X0rg/CPU-X)
  * Configurations
    * Desktop
      * ~/.local/share/applications/cpu-x.desktop
* [Discord - Latest (Snap)](https://snapcraft.io/discord)
* [Dropbox - 2019.02.14 (Dpkg)](https://www.dropbox.com/install)
* [FreeRapid Downloader - 0.9.4 (Portable)](http://wordrider.net/freerapid/)
  * Configurations
    * Desktop
      * ~/.local/share/applications/freerapiddownloader.desktop
* Furius ISO Mount - Latest
* [Google Chrome - Latest (Dpkg)](https://www.google.com/chrome/)
* GParted - Latest
* [LibreOffice - Latest (Snap)](https://snapcraft.io/libreoffice)
* [OBS Studio - Latest (Flatpak)](https://flathub.org/apps/details/com.obsproject.Studio)
* [Oracle VM VirtualBox - 6.0.10 (Dpkg)](https://www.virtualbox.org/)
  * Extension Pack - 6.0.10
  * User Groups
    * vboxusers
* Remmina - Latest
  * Plugins - Latest
    * RDP
    * VNC
* [Spotify - Latest (Snap)](https://snapcraft.io/spotify)
* Steam - Latest

### Uninstall Apps
* HexChat
* Thunderbird

<br/>

# Preparing to Run the Script

### Ubuntu and Derivatives
```bash
sudo apt install curl -y
```

<br/>

# Running the Script

### Ubuntu and Derivatives
```bash
curl -H 'Cache-Control: no-cache' -sSL https://raw.githubusercontent.com/daniloancilotto/production-environment-script/master/ubuntu.sh | bash
```