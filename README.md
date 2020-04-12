# Linux Personal Script

### Supported Systems
* [Ubuntu - 20.04](https://ubuntu.com/)

### Supported Architectures
* Fully
  * amd64 (64-bit)
* Partially
  * i386 (32-bit)

<br/>

# Preparing to Run the Script

### Ubuntu
```bash
sudo apt install curl -y
```

<br/>

# Running the Script

### Ubuntu
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
  * Snap
* OpenJDK - 8
* [4K Video Downloader - 4.12.0 (Dpkg)](https://www.4kdownload.com/products/product-videodownloader)
* [Angry IP Scanner - 3.7.0 (Dpkg)](https://angryip.org/)
* [Arduino - 1.8.12 (Portable)](https://www.arduino.cc/)
  * Configurations
    * Preferences
      * ~/portable/arduino/default/portable/preferences.txt
      * ~/portable/arduino/esp32/portable/preferences.txt
    * Desktop
      * ~/.local/share/applications/arduino-arduinoide.desktop
      * ~/.local/share/applications/arduino-arduinoide-esp32.desktop
    * User Group
      * dialout
* Audacity - Latest
* [Balena Etcher - 1.5.80 (Portable)](https://www.balena.io/etcher/)
  * Configurations
    * Desktop
      * ~/.local/share/applications/appimagekit-balena-etcher-electron.desktop
* CPU-X - Latest
  * Configurations
    * Desktop
      * /usr/share/applications/cpu-x.desktop
      * /usr/share/applications/cpu-x-root.desktop
* [Dropbox - 2020.03.04 (Dpkg)](https://www.dropbox.com/install)
* [FreeRapid Downloader - 0.9.4 (Portable)](http://wordrider.net/freerapid/)
  * Configurations
    * Desktop
      * ~/.local/share/applications/freerapiddownloader.desktop
* GIMP - Latest
* [Google Chrome - Latest (Dpkg)](https://www.google.com/chrome/)
* GParted - Latest
* [LibreOffice - Latest (Snap)](https://snapcraft.io/libreoffice)
* [OBS Studio - Latest (Snap)](https://snapcraft.io/obs-studio)
* Oracle VM VirtualBox - Latest
  * Modules - Latest
    * Extension Pack
    * Guest Additions ISO
    * QT User Interface
  * Configurations
    * User Group
      * vboxusers
* Remmina - Latest
  * Plugins - Latest
    * RDP
    * VNC
* Rhythmbox - Latest
* [Scrcpy - Latest (Snap)](https://snapcraft.io/scrcpy)
  * Configurations
    * Script
      * ~/portable/scrcpy/scrcpy.sh
    * Desktop
      * ~/.local/share/applications/scrcpy.desktop
* [Spotify - Latest (Snap)](https://snapcraft.io/spotify)
* Transmission - Latest
* VLC - Lastest