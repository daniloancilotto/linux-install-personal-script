#!/bin/bash
system="`lsb_release -sd`"
machine="`uname -m`"

arch="amd64"
arch2="x64"
arch3="64"
if [ "$machine" != "x86_64" ]
then
  arch="i386"
  arch2="ia32"
  arch3="32"
fi

echo "LINUX PERSONAL UBUNTU"
echo "Author: Danilo Ancilotto"
echo "System: $system"
echo "Architecture: $arch"
echo "Home: $HOME"
echo "User: $USER"

printLine() {
  text="$1"
  if [ ! -z "$text" ]
  then
    text="$text "
  fi
  lenght=${#text}
  sudo echo ""
  echo -n "$text"
  for i in {1..80}
  do
    if [ $i -gt $lenght ]
    then
      echo -n "="
    fi
  done
  echo ""
}

dpkgInstall() {
  file="$HOME/$1"
  wget -O "$file" "$2"
  sudo dpkg -i "$file"
  rm -fv "$file"
  sudo apt install -fy
}

printLine "Base"

sudo apt update
sudo apt install wget unzip tar jq neofetch htop -y

sudo systemctl enable --now snapd.socket
sudo flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"

desktop_dir="$HOME/.local/share/applications"
mkdir -pv "$desktop_dir"
portable_dir="$HOME/portable"
mkdir -pv "$portable_dir"

printLine "OpenJDK"
sudo apt install openjdk-8-jdk -y
java_dir="/usr/lib/jvm/java-8-openjdk-$arch"

printLine "4K Video Downloader"
if [ ! -f "/usr/bin/4kvideodownloader" ]
then
  dpkgInstall "4kvideodownloader.deb" "https://dl.4kdownload.com/app/4kvideodownloader_4.12.0-1_$arch.deb"
else
  echo "4kvideodownloader is already installed"
fi

printLine "Angry IP Scanner"
if [ ! -f "/usr/bin/ipscan" ]
then
  dpkgInstall "angryipscanner.deb" "https://github.com/angryip/ipscan/releases/download/3.7.0/ipscan_3.7.0_$arch.deb"
else
  echo "angryipscanner is already installed"
fi

printLine "Arduino"

portable_name="arduino"
portable_subdir="$portable_dir/$portable_name"
if [ ! -d "$portable_subdir" ]
then
  file="$portable_dir/arduino.tar.xz"
  wget -O "$file" "https://downloads.arduino.cc/arduino-1.8.12-linux$arch3.tar.xz"
  mkdir -pv "$portable_subdir"
  tar -xJf "$file" -C "$portable_subdir"
  mv -fv "$portable_subdir/arduino-1.8.12" "$portable_subdir/default"
  mkdir -pv "$portable_subdir/default/portable"
  cp -fr "$portable_subdir/default" "$portable_subdir/esp32"
  rm -fv "$file"
else
  echo "$portable_name is already installed"
fi

conf=$'build.verbose=true\n'
conf+=$'compiler.warning_level=default\n'
conf+=$'editor.code_folding=true\n'
conf+=$'editor.linenumbers=true\n'
conf+=$'upload.verbose=true\n'
file="$portable_subdir/default/portable/preferences.txt"
if [ ! -f "$file" ]
then
  echo "$conf" > "$file"
fi
file="$portable_subdir/esp32/portable/preferences.txt"
if [ ! -f "$file" ]
then
  conf+=$'boardsmanager.additional.urls=https://dl.espressif.com/dl/package_esp32_index.json\n'
  echo "$conf" > "$file"
fi

conf=$'[Desktop Entry]\n'
conf+=$'Comment=Open-source electronics prototyping platform\n'
conf+=$'Comment[pt_BR]=Plataforma de prototipagem de eletrônicos de código aberto\n'
conf+=$'Terminal=false\n'
conf+=$'Type=Application\n'
conf+=$'Categories=Development;IDE;Electronics;\n'
conf+=$'MimeType=text/x-arduino;\n'
conf+=$'Keywords=embedded electronics;electronics;avr;microcontroller;\n'
conf+=$'StartupWMClass=processing-app-Base\n'
file="$desktop_dir/arduino-arduinoide.desktop"
if [ ! -f "$file" ]
then
  conf+=$'Name=Arduino IDE\n'
  conf+=$'GenericName=Arduino IDE\n'
  conf+=$'Exec='$portable_subdir$'/default/arduino\n'
  conf+=$'Icon='$portable_subdir$'/default/lib/arduino_icon.ico\n'
  echo "$conf" > "$file"
fi
file="$desktop_dir/arduino-arduinoide-esp32.desktop"
if [ ! -f "$file" ]
then
  conf+=$'Name=Arduino IDE - ESP32\n'
  conf+=$'GenericName=Arduino IDE - ESP32\n'
  conf+=$'Exec='$portable_subdir$'/esp32/arduino\n'
  conf+=$'Icon='$portable_subdir$'/esp32/lib/arduino_icon.ico\n'
  echo "$conf" > "$file"
fi

sudo usermod -aG dialout $USER

echo "$portable_name have been configured"

printLine "Audacity"
sudo apt install audacity -y

printLine "Balena Etcher"

portable_name="balena-etcher"
portable_subdir="$portable_dir/$portable_name"
if [ ! -d "$portable_subdir" ]
then
  file="$portable_dir/balena-etcher.zip"
  wget -O "$file" "https://github.com/balena-io/etcher/releases/download/v1.5.80/balena-etcher-electron-1.5.80-linux-$arch2.zip"
  mkdir -pv "$portable_subdir"
  unzip -q "$file" -d "$portable_subdir"
  ln -sv -T "$portable_subdir/balenaEtcher-1.5.80-$arch2.AppImage" "$portable_subdir/balenaEtcher.AppImage"
  rm -fv "$file"
else
  echo "$portable_name is already installed"
fi

file="$desktop_dir/appimagekit-balena-etcher-electron.desktop"
if [ ! -f "$file" ]
then
  conf=$'[Desktop Entry]\n'
  conf+=$'Name=balenaEtcher\n'
  conf+=$'Comment=Flash OS images to SD cards and USB drives, safely and easily.\n'
  conf+=$'Comment[pt_BR]=Gravar imagens de SO em cartões SD e drives USB, com segurança e facilidade.\n'
  conf+=$'Exec="'$portable_subdir$'/balenaEtcher.AppImage" %U\n'
  conf+=$'Terminal=false\n'
  conf+=$'Type=Application\n'
  conf+=$'Icon=appimagekit-balena-etcher-electron\n'
  conf+=$'StartupWMClass=balenaEtcher\n'
  conf+=$'Categories=Utility;\n'
  conf+=$'TryExec='$portable_subdir$'/balenaEtcher.AppImage\n'
  echo "$conf" > "$file"
fi

echo "$portable_name have been configured"

printLine "CPU-X"

portable_name="cpu-x"
portable_subdir="$portable_dir/$portable_name"
if [ ! -d "$portable_subdir" ]
then
  mkdir -pv "$portable_subdir"
  file="$portable_subdir/CPU-X_v3.2.4_$machine.AppImage"
  wget -O "$file" "https://github.com/X0rg/CPU-X/releases/download/v3.2.4/CPU-X_v3.2.4_$machine.AppImage"
  chmod +x "$file"
  ln -sv -T "$file" "$portable_subdir/cpu-x.AppImage"
  current_dir="`pwd`"
  cd "$portable_subdir"
  "$file" --appimage-extract
  cd "$current_dir"
  mv -fv "$portable_subdir/squashfs-root/cpu-x.png" "$portable_subdir/cpu-x.png"
  rm -rf "$portable_subdir/squashfs-root"
else
  echo "$portable_name is already installed"
fi

file="$desktop_dir/$portable_name.desktop"
if [ ! -f "$file" ]
then
  conf=$'[Desktop Entry]\n'
  conf+=$'Name=CPU-X\n'
  conf+=$'GenericName=CPU-X\n'
  conf+=$'Comment=CPU, motherboard and more information\n'
  conf+=$'Comment[pt_BR]=CPU, placa-mãe e mais informações\n'
  conf+=$'Exec=sudo '$portable_subdir$'/cpu-x.AppImage\n'
  conf+=$'Terminal=true\n'
  conf+=$'Type=Application\n'
  conf+=$'Icon='$portable_subdir$'/cpu-x.png\n'
  conf+=$'Categories=System;\n'
  echo "$conf" > "$file"
fi

echo "$portable_name have been configured"

printLine "Dropbox"
if [ ! -f "/usr/bin/dropbox" ]
then
  dpkgInstall "dropbox.deb" "https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_$arch.deb"
else
  echo "dropbox is already installed"
fi

printLine "FreeRapid Downloader"

portable_name="freerapiddownloader"
portable_subdir="$portable_dir/$portable_name"
if [ ! -d "$portable_subdir" ]
then
  file="$portable_dir/freerapiddownloader.zip"
  wget -O "$file" "https://www.dropbox.com/s/swyleflcmtqxpch/FreeRapid-0.9u4.zip"
  unzip -q "$file" -d "$portable_dir"
  mv -fv "$portable_dir/FreeRapid-0.9u4" "$portable_subdir"
  rm -fv "$file"
else
  echo "$portable_name is already installed"
fi

file="$desktop_dir/$portable_name.desktop"
if [ ! -f "$file" ]
then
  conf=$'[Desktop Entry]\n'
  conf+=$'Name=FreeRapid Downloader\n'
  conf+=$'GenericName=FreeRapid Downloader\n'
  conf+=$'Comment=Download from file-sharing services\n'
  conf+=$'Comment[pt_BR]=Download de serviços de compartilhamento de arquivos\n'
  conf+=$'Exec='$java_dir$'/bin/java -jar '$portable_subdir$'/frd.jar\n'
  conf+=$'Terminal=false\n'
  conf+=$'Type=Application\n'
  conf+=$'Icon='$portable_subdir$'/frd.png\n'
  conf+=$'Categories=Network;\n'
  echo "$conf" > "$file"
fi

echo "$portable_name have been configured"

printLine "Furius ISO Mount"
sudo apt install furiusisomount -y

printLine "GIMP"
sudo apt install gimp -y

printLine "Google Chrome"
if [ -z "`google-chrome --version`" ]
then
  dpkgInstall "google-chrome.deb" "https://dl.google.com/linux/direct/google-chrome-stable_current_$arch.deb"
else
  echo "google-chrome is already installed"
fi

printLine "GParted"
sudo apt install gparted -y

printLine "LibreOffice"
echo "Running snap, please wait..."
sudo snap install libreoffice

printLine "OBS Studio"
sudo flatpak install flathub com.obsproject.Studio -y

printLine "Oracle VM VirtualBox"
sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-qt -y
sudo usermod -aG vboxusers $USER

printLine "Remmina"
sudo apt install remmina remmina-plugin-rdp remmina-plugin-vnc -y

printLine "Rhythmbox"
sudo apt install rhythmbox -y

printLine "Scrcpy"
echo "Running snap, please wait..."
sudo snap install scrcpy

file="$desktop_dir/scrcpy.desktop"
if [ ! -f "$file" ]
then
  conf=$'[Desktop Entry]\n'
  conf+=$'Name=Scrcpy\n'
  conf+=$'GenericName=Scrcpy\n'
  conf+=$'Comment=Display and control of Android devices connected on USB\n'
  conf+=$'Comment[pt_BR]=Exibição e controle de dispositivos Android conectados via USB\n'
  conf+=$'Exec=snap run scrcpy\n'
  conf+=$'Terminal=true\n'
  conf+=$'Type=Application\n'
  conf+=$'Icon=application-vnd.android.package-archive\n'
  conf+=$'Categories=Utility;\n'
  echo "$conf" > "$file"
fi

echo "scrcpy have been configured"

printLine "Spotify"
echo "Running snap, please wait..."
sudo snap install spotify

printLine "Steam"
sudo apt install steam -y

printLine "Transmission"
sudo apt install transmission -y

printLine "VLC"
echo "Running snap, please wait..."
sudo apt install vlc -y

printLine "Bloatwares"
sudo apt remove libreoffice libreoffice* hexchat thunderbird -y

printLine "Finished"
echo "Done, please reboot your system."
echo ""