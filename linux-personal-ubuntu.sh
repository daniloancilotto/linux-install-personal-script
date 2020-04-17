#!/bin/bash
system="`lsb_release -sd`"
architecture="`uname -m`"

echo "LINUX PERSONAL UBUNTU"
echo "Author: Danilo Ancilotto"
echo "System: $system"
echo "Architecture: $architecture"
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
sudo apt install wget unzip tar jq neofetch htop snapd -y
sudo systemctl enable --now snapd.socket

desktop_dir="$HOME/.local/share/applications"
mkdir -pv "$desktop_dir"
portable_dir="$HOME/portable"
mkdir -pv "$portable_dir"

printLine "OpenJDK"
sudo apt install openjdk-8-jdk -y
java8_dir="/usr/lib/jvm/java-8-openjdk-amd64"

printLine "4K Video Downloader"
if [ ! -f "/usr/bin/4kvideodownloader" ]
then
  dpkgInstall "4kvideodownloader.deb" "https://dl.4kdownload.com/app/4kvideodownloader_4.12.0-1_amd64.deb"
else
  echo "4kvideodownloader is already installed"
fi

printLine "Angry IP Scanner"
if [ ! -f "/usr/bin/ipscan" ]
then
  dpkgInstall "angryipscanner.deb" "https://github.com/angryip/ipscan/releases/download/3.7.0/ipscan_3.7.0_amd64.deb"
else
  echo "angryipscanner is already installed"
fi

printLine "Arduino"

portable_name="arduino"
portable_subdir="$portable_dir/$portable_name"
if [ ! -d "$portable_subdir" ]
then
  file="$portable_dir/arduino.tar.xz"
  wget -O "$file" "https://downloads.arduino.cc/arduino-1.8.12-linux64.tar.xz"
  mkdir -pv "$portable_subdir"
  tar -xJf "$file" -C "$portable_subdir"
  rm -fv "$file"

  mv -fv "$portable_subdir/arduino-1.8.12" "$portable_subdir/default"
  mkdir -pv "$portable_subdir/default/portable"
  cp -fr "$portable_subdir/default" "$portable_subdir/esp32"
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
  conf_default="$conf"
  echo "$conf_default" > "$file"
fi
file="$portable_subdir/esp32/portable/preferences.txt"
if [ ! -f "$file" ]
then
  conf_esp32="$conf"
  conf_esp32+=$'boardsmanager.additional.urls=https://dl.espressif.com/dl/package_esp32_index.json\n'
  echo "$conf_esp32" > "$file"
fi

desk=$'[Desktop Entry]\n'
desk+=$'Comment=Open-source electronics prototyping platform\n'
desk+=$'Comment[pt_BR]=Plataforma de prototipagem de eletrônicos de código aberto\n'
desk+=$'Terminal=false\n'
desk+=$'Type=Application\n'
desk+=$'Categories=Development;IDE;Electronics;\n'
desk+=$'MimeType=text/x-arduino;\n'
desk+=$'Keywords=embedded electronics;electronics;avr;microcontroller;\n'
desk+=$'StartupWMClass=processing-app-Base\n'
file="$desktop_dir/arduino-arduinoide.desktop"
if [ ! -f "$file" ]
then
  desk_default="$desk"
  desk_default+=$'Name=Arduino IDE\n'
  desk_default+=$'GenericName=Arduino IDE\n'
  desk_default+=$'Exec='$portable_subdir$'/default/arduino\n'
  desk_default+=$'Icon='$portable_subdir$'/default/lib/arduino_icon.ico\n'
  echo "$desk_default" > "$file"
fi
file="$desktop_dir/arduino-arduinoide-esp32.desktop"
if [ ! -f "$file" ]
then
  desk_esp32="$desk"
  desk_esp32+=$'Name=Arduino IDE - ESP32\n'
  desk_esp32+=$'GenericName=Arduino IDE - ESP32\n'
  desk_esp32+=$'Exec='$portable_subdir$'/esp32/arduino\n'
  desk_esp32+=$'Icon='$portable_subdir$'/esp32/lib/arduino_icon.ico\n'
  echo "$desk_esp32" > "$file"
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
  wget -O "$file" "https://github.com/balena-io/etcher/releases/download/v1.5.80/balena-etcher-electron-1.5.80-linux-x64.zip"
  mkdir -pv "$portable_subdir"
  unzip -q "$file" -d "$portable_subdir"
  rm -fv "$file"

  file="$portable_subdir/balenaEtcher-1.5.80-x64.AppImage"
  ln -sv -T "$file" "$portable_subdir/balena-etcher.AppImage"
  chmod +x "$file"

  current_dir="`pwd`"
  cd "$portable_subdir"
  "$file" --appimage-extract
  cd "$current_dir"
  cp -fv "$portable_subdir/squashfs-root/balena-etcher-electron.png" "$portable_subdir/balena-etcher.png"
  rm -rf "$portable_subdir/squashfs-root"
else
  echo "$portable_name is already installed"
fi

file="$desktop_dir/appimagekit-balena-etcher-electron.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=balenaEtcher\n'
  desk+=$'GenericName=balenaEtcher\n'
  desk+=$'Comment=Flash OS images to SD cards and USB drives, safely and easily.\n'
  desk+=$'Comment[pt_BR]=Gravar imagens de SO em cartões SD e drives USB, com segurança e facilidade.\n'
  desk+=$'Exec="'$portable_subdir$'/balena-etcher.AppImage" %U\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon='$portable_subdir$'/balena-etcher.png\n'
  desk+=$'StartupWMClass=balenaEtcher\n'
  desk+=$'Categories=Utility;\n'
  echo "$desk" > "$file"
fi

echo "$portable_name have been configured"

printLine "CPU-X"

sudo apt install cpu-x -y

file="cpu-x.desktop"
origin_file="/usr/share/applications/$file"
target_file="$desktop_dir/$file"
if [ -f "$origin_file" ] && [ ! -f "$target_file" ]
then
  cp "$origin_file" "$target_file"
fi
if [ -f "$target_file" ]
then
  sed -i '/^Exec=/{h;s/=.*/=\/usr\/bin\/cpu-x_polkit/};${x;/^$/{s//Exec=\/usr\/bin\/cpu-x_polkit/;H};x}' "$target_file"
fi

file="cpu-x-root.desktop"
origin_file="/usr/share/applications/$file"
target_file="$desktop_dir/$file"
if [ -f "$origin_file" ] && [ ! -f "$target_file" ]
then
  cp "$origin_file" "$target_file"
fi
if [ -f "$target_file" ]
then
  sed -i '/^NoDisplay=/{h;s/=.*/=true/};${x;/^$/{s//NoDisplay=true/;H};x}' "$target_file"
fi

echo "$portable_name have been configured"

printLine "Dropbox"
if [ ! -f "/usr/bin/dropbox" ]
then
  dpkgInstall "dropbox.deb" "https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb"
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
  rm -fv "$file"

  mv -fv "$portable_dir/FreeRapid-0.9u4" "$portable_subdir"
else
  echo "$portable_name is already installed"
fi

file="$desktop_dir/$portable_name.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=FreeRapid Downloader\n'
  desk+=$'GenericName=FreeRapid Downloader\n'
  desk+=$'Comment=Download from file-sharing services\n'
  desk+=$'Comment[pt_BR]=Download de serviços de compartilhamento de arquivos\n'
  desk+=$'Exec='$java8_dir$'/bin/java -jar '$portable_subdir$'/frd.jar\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon='$portable_subdir$'/frd.ico\n'
  desk+=$'Categories=Network;\n'
  echo "$desk" > "$file"
fi

echo "$portable_name have been configured"

printLine "GIMP"
sudo apt install gimp -y

printLine "Google Chrome"
if [ -z "`google-chrome --version`" ]
then
  dpkgInstall "google-chrome.deb" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
else
  echo "google-chrome is already installed"
fi

printLine "GParted"
sudo apt install gparted -y

printLine "LibreOffice"
echo "Running snap, please wait..."
sudo snap install libreoffice

printLine "OBS Studio"
sudo apt install obs-studio -y

printLine "Oracle VM VirtualBox"
echo virtualbox-ext-pack virtualbox-ext-pack/license select true | sudo debconf-set-selections
sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-qt -y
sudo usermod -aG vboxusers $USER

printLine "Remmina"
sudo apt install remmina remmina-plugin-rdp remmina-plugin-vnc -y

printLine "Rhythmbox"
sudo apt install rhythmbox -y

printLine "Scrcpy"

sudo apt install scrcpy -y

portable_subdir="$portable_dir/scrcpy"
if [ ! -d "$portable_subdir" ]
then
  mkdir -pv "$portable_subdir"

  file="$portable_subdir/scrcpy.sh"
  desk=$'#!/bin/bash\n'
  desk+=$'nohup "scrcpy" >/dev/null 2>&1 &\n'
  desk+=$'sleep 1\n'
  echo "$desk" > "$file"
  chmod +x "$file"
fi

file="$desktop_dir/scrcpy.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=Scrcpy\n'
  desk+=$'GenericName=Scrcpy\n'
  desk+=$'Comment=Display and control of Android devices connected on USB\n'
  desk+=$'Comment[pt_BR]=Exibição e controle de dispositivos Android conectados via USB\n'
  desk+=$'Exec='$portable_subdir$'/scrcpy.sh\n'
  desk+=$'Terminal=true\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon=phone\n'
  desk+=$'Categories=Utility;\n'
  desk+=$'Actions=Terminal;\n'
  desk+=$'\n'
  desk+=$'[Desktop Action Terminal]\n'
  desk+=$'Name=Open with Terminal\n'
  desk+=$'Name[pt_BR]=Abrir com Terminal\n'
  desk+=$'GenericName=Open with Terminal\n'
  desk+=$'GenericName[pt_BR]=Abrir com Terminal\n'
  desk+=$'Exec=scrcpy\n'
  echo "$desk" > "$file"
fi

echo "scrcpy have been configured"

printLine "Spotify"
echo "Running snap, please wait..."
sudo snap install spotify

printLine "Transmission"
sudo apt install transmission -y

printLine "VLC"
echo "Running snap, please wait..."
sudo apt install vlc -y

printLine "Finished"
echo "Done, please reboot your system."
echo ""