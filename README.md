# Linux Personal Script

### Supported Systems
- [Ubuntu - 20.04 (Base)](https://ubuntu.com/download)

### Supported Architectures
- x86_64 (amd64)

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
curl -H 'Cache-Control: no-cache' -sSL https://raw.githubusercontent.com/daniloancilotto/linux-personal-script/master/ubuntu.sh | bash
```

<br/>

# Installations and Configurations

### Ubuntu
- Kernel (Configuration Only)
  - Parameters
    - /etc/sysctl.d/60-swappiness.conf
    - /etc/sysctl.d/60-cache-pressure.conf
    - /etc/sysctl.d/60-inotify-watches.conf
- Snap - Latest (Repository)
- Wget - Latest (Repository)
- Tar - Latest (Repository)
- Zip - Latest (Repository)
- Rar - Latest (Repository)
- 7-Zip - Latest (Repository)
- Crudini - Latest (Repository)
- FFmpeg - Latest (Repository)
- Samba - Latest (Repository)
- OpenJDK - 8 (Repository)
  - Menu
    - ~/.local/share/applications/openjdk-8-policytool.desktop
- Htop - Latest (Repository)
  - Menu
    - ~/.local/share/applications/htop.desktop
- Neofetch - Latest (Repository)
- [4K Video Downloader - 4.19.3 (Dpkg)](https://www.4kdownload.com/products/product-videodownloader)
- [Angry IP Scanner - 3.7.6 (Dpkg)](https://angryip.org/download/)
- [Arduino - 1.8.19 (Portable)](https://www.arduino.cc/en/Main/Software)
  - Preferences
    - ~/Applications/arduino/default/portable/preferences.txt
    - ~/Applications/arduino/esp32/portable/preferences.txt
  - Menu
    - ~/.local/share/applications/arduino-arduinoide.desktop
  - User Groups
    - dialout
- Audacity - Latest (Repository)
- [Balena Etcher - 1.7.3 (AppImage)](https://www.balena.io/etcher/)
  - Menu
    - ~/.local/share/applications/appimagekit-balena-etcher-electron.desktop
- [Dropbox - 2020.03.04 (Dpkg)](https://www.dropbox.com/install)
- Flameshot - Latest (Repository)
- [FreeRapid Downloader - 0.9u4 (Portable)](http://wordrider.net/freerapid/download.htm)
  - Menu
    - ~/.local/share/applications/freerapiddownloader.desktop
- GIMP - Latest (Repository)
- GNOME Calculator - Latest (Repository)
- [Google Chrome - Latest (Dpkg)](https://www.google.com/chrome/)
- Kdenlive - Latest (Repository)
- LibreOffice - Latest (Repository)
- OBS Studio - Latest (Repository)
- Remmina - Latest (Repository)
  - Plugins
    - RDP
    - VNC
- Scrcpy - Latest (Repository)
  - Menu
    - ~/.local/share/applications/scrcpy.desktop
- Transmission - Latest (Repository)
- [Ventoy - 1.0.63 (Portable)](https://www.ventoy.net/en/download.html)
  - Menu
    - ~/.local/share/applications/ventoy.desktop
- Virt-Manager - Latest (Repository)
- VLC - Lastest (Repository)
- [Zoiper5 - 5.5.9 (Dpkg)](https://www.zoiper.com/en/voip-softphone/download/current)
  - Autostart
    - ~/.config/autostart/Zoiper5.desktop
- Language Pack Pt - Latest (Repository)