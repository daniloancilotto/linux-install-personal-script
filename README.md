# Linux Personal Script

### Supported Systems
* Ubuntu and Derivatives
  * [Ubuntu - 18.04 ~ 19.10](https://ubuntu.com/)
  * [Linux Mint - 19.1 ~ 19.2](https://linuxmint.com/)

### Supported Architectures
* Fully
  * amd64 (64-bit)
* Partially
  * i386 (32-bit)

<br/>

# Preparing to Run the Script

### Ubuntu and Derivatives
```bash
sudo apt install curl snapd flatpak -y
```

<br/>

# Running the Script

### Ubuntu and Derivatives
```bash
curl -H 'Cache-Control: no-cache' -sSL https://raw.githubusercontent.com/daniloancilotto/linux-personal-script/master/linux-personal-ubuntu.sh | bash
```

<br/>

# Installations and Configurations

### Apps
* Base - Latest
  * Wget
  * Unzip
  * Tar
  * Jq
  * Neofetch
  * Htop
  * Configurations
    * Repositories
      * https://dl.flathub.org/repo/flathub.flatpakrepo
    * Directories
      * ~/.local/share/applications
      * ~/portable
* OpenJDK - 8
* [4K Video Downloader - 4.9.3 (Dpkg)](https://www.4kdownload.com/products/product-videodownloader)
* [Angry IP Scanner - 3.6.2 (Dpkg)](https://angryip.org/)
* [Arduino - 1.8.10 (Portable)](https://www.arduino.cc/)
  * Modules - Latest
    * Default
    * ESP32
  * Configurations
    * Desktop
      * ~/.local/share/applications/arduino-arduinoide.desktop
      * ~/.local/share/applications/arduino-arduinoide-esp32.desktop
    * Txt
      * ~/portable/arduino/default/portable/preferences.txt
      * ~/portable/arduino/esp32/portable/preferences.txt
* [Balena Etcher - 1.5.63 (Portable)](https://www.balena.io/etcher/)
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
* GIMP - Latest
* [Google Chrome - Latest (Dpkg)](https://www.google.com/chrome/)
* GParted - Latest
* [LibreOffice - Latest (Snap)](https://snapcraft.io/libreoffice)
* [OBS Studio - Latest (Flatpak)](https://flathub.org/apps/details/com.obsproject.Studio)
* Oracle VM VirtualBox - Latest
  * Modules - Latest
    * Extension Pack
    * Guest Additions ISO
    * QT User Interface
  * Configurations
    * User Groups
      * vboxusers
* Remmina - Latest
  * Plugins - Latest
    * RDP
    * VNC
* [Spotify - Latest (Snap)](https://snapcraft.io/spotify)
* Steam - Latest
* Transmission - Latest
* VLC - Lastest

<br/>

# Uninstallations

### Apps
* Bloatwares
  * HexChat
  * Rhythmbox
  * Thunderbird
  * LibreOffice