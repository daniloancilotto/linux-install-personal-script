#!/bin/bash
system="`lsb_release -sd`"
architecture="`uname -m`"

echo "LINUX PERSONAL SCRIPT (UBUNTU)"
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

desktopConf() {
  source_file="/usr/share/applications/$2"
  target_file="$1/$2"
  if [ -f "$source_file" ] && [ ! -f "$target_file" ]
  then
    cp "$source_file" "$target_file"
  fi
  if [ -f "$target_file" ]
  then
    crudini --set "$target_file" "Desktop Entry" "$3" "$4"
  fi
}

printLine "Update"
sudo apt update

desktop_dir="$HOME/.local/share/applications"
mkdir -pv "$desktop_dir"

autostart_dir="$HOME/.config/autostart"
mkdir -pv "$autostart_dir"

autostart_scripts_dir="$HOME/.config/autostart-scripts"
mkdir -pv "$autostart_scripts_dir"

portable_dir="$HOME/Applications"
mkdir -pv "$portable_dir"

printLine "Language Pack Pt"
sudo apt install language-pack-pt language-pack-gnome-pt -y

printLine "Snap"

sudo apt install snapd -y

sudo systemctl enable --now snapd.socket
sudo snap set system refresh.timer=mon,04:00

snap_cronjob="@reboot /usr/bin/sudo /usr/bin/snap refresh"
if [ -z "$(sudo crontab -l | grep -F "$snap_cronjob")" ]
then
  (sudo crontab -l 2>/dev/null; echo "$snap_cronjob") | sudo crontab -
fi

echo "snap have been configured"

printLine "Wget"
sudo apt install wget -y

printLine "Tar"
sudo apt install tar -y

printLine "Zip"
sudo apt install zip unzip -y

printLine "Rar"
sudo apt install rar unrar -y

printLine "7-Zip"
sudo apt install p7zip-full -y

printLine "Crudini"
sudo apt install crudini -y

printLine "FFmpeg"
sudo apt install ffmpeg -y

printLine "Seahorse"

sudo apt install seahorse -y

file="$autostart_dir/gnome-keyring-pkcs11.desktop"
if [ ! -f "$file" ]
then
  cp "/etc/xdg/autostart/gnome-keyring-pkcs11.desktop" "$autostart_dir"
  sed -i '/^OnlyShowIn.*$/d' "$file"
fi
file="$autostart_dir/gnome-keyring-secrets.desktop"
if [ ! -f "$file" ]
then
  cp "/etc/xdg/autostart/gnome-keyring-secrets.desktop" "$autostart_dir"
  sed -i '/^OnlyShowIn.*$/d' "$file"
fi
file="$autostart_dir/gnome-keyring-ssh.desktop"
if [ ! -f "$file" ]
then
  cp "/etc/xdg/autostart/gnome-keyring-ssh.desktop" "$autostart_dir"
  sed -i '/^OnlyShowIn.*$/d' "$file"
fi

echo "seahorse have been configured"

printLine "Kssh Askpass"

sudo apt install ksshaskpass -y

file="$autostart_scripts_dir/ssh-askpass.sh"
if [ ! -f "$file" ]
then
  conf=$'#!/bin/bash\n'
  conf+=$'export SSH_ASKPASS=/usr/bin/ksshaskpass\n'
  conf+=$'/usr/bin/ssh-add </dev/null\n'
  echo "$conf" | sudo tee "$file"
  sudo chmod +x "$file"
fi

echo "ksshaskpass have been configured"

printLine "Samba"
sudo apt install samba -y

printLine "OpenJDK"
sudo apt install openjdk-8-jdk -y
desktopConf "$desktop_dir" "openjdk-8-policytool.desktop" "NoDisplay" "true"
echo "openjdk have been configured"

java8_dir="/usr/lib/jvm/java-8-openjdk-amd64"

printLine "Htop"
sudo apt install htop -y
desktopConf "$desktop_dir" "htop.desktop" "NoDisplay" "true"
echo "htop have been configured"

printLine "Neofetch"
sudo apt install neofetch -y

printLine "4K Video Downloader"

portable_name="4kvideodownloader"
portable_subdir="$portable_dir/$portable_name"
portable_cversion="`cat "$portable_subdir/version.txt"`"
portable_version="4.15.0"

if [ "$portable_cversion" != "$portable_version" ]
then
  rm -rf "$portable_subdir"

  sudo apt remove 4kvideodownloader -y
fi

if [ ! -f "/usr/bin/4kvideodownloader" ]
then
  dpkgInstall "4kvideodownloader.deb" "https://dl.4kdownload.com/app/4kvideodownloader_$portable_version-1_amd64.deb"

  mkdir -pv "$portable_subdir"
  echo "$portable_version" > "$portable_subdir/version.txt"
else
  echo "4kvideodownloader is already installed"
fi

printLine "Angry IP Scanner"

portable_name="angryipscanner"
portable_subdir="$portable_dir/$portable_name"
portable_cversion="`cat "$portable_subdir/version.txt"`"
portable_version="3.7.6"

if [ "$portable_cversion" != "$portable_version" ]
then
  rm -rf "$portable_subdir"

  sudo apt remove ipscan -y
fi

if [ ! -f "/usr/bin/ipscan" ]
then
  dpkgInstall "angryipscanner.deb" $'https://github.com/angryip/ipscan/releases/download/'$portable_version$'/ipscan_'$portable_version$'_amd64.deb'

  mkdir -pv "$portable_subdir"
  echo "$portable_version" > "$portable_subdir/version.txt"
else
  echo "angryipscanner is already installed"
fi

printLine "Arduino"

portable_name="arduino"
portable_subdir="$portable_dir/$portable_name"
portable_cversion="`cat "$portable_subdir/version.txt"`"
portable_version="1.8.13"

if [ "$portable_cversion" != "$portable_version" ]
then
  rm -rf "$portable_subdir"
fi

if [ ! -d "$portable_subdir" ]
then
  file="$portable_dir/arduino.tar.xz"
  wget -O "$file" "https://downloads.arduino.cc/arduino-$portable_version-linux64.tar.xz"
  mkdir -pv "$portable_subdir"
  tar -xJf "$file" -C "$portable_subdir"
  rm -fv "$file"

  mv -fv "$portable_subdir/arduino-$portable_version" "$portable_subdir/default"
  mkdir -pv "$portable_subdir/default/portable"
  cp -fr "$portable_subdir/default" "$portable_subdir/esp32"

  echo "$portable_version" > "$portable_subdir/version.txt"
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

file="$desktop_dir/arduino-arduinoide.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=Arduino IDE\n'
  desk+=$'GenericName=Arduino IDE\n'
  desk+=$'Comment=Open-source electronics prototyping platform\n'
  desk+=$'Comment[pt_BR]=Plataforma de prototipagem de eletrônicos de código aberto\n'
  desk+=$'Exec='$portable_subdir$'/default/arduino\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon='$portable_subdir$'/default/lib/arduino_icon.ico\n'
  desk+=$'Categories=Development;IDE;Electronics;\n'
  desk+=$'MimeType=text/x-arduino;\n'
  desk+=$'Keywords=embedded electronics;electronics;avr;microcontroller;\n'
  desk+=$'StartupWMClass=processing-app-Base\n'
  desk+=$'Actions=ESP32;\n'
  desk+=$'\n'
  desk+=$'[Desktop Action ESP32]\n'
  desk+=$'Name=ESP32\n'
  desk+=$'GenericName=ESP32\n'
  desk+=$'Exec='$portable_subdir$'/esp32/arduino\n'
  echo "$desk" > "$file"
fi

sudo usermod -aG dialout $USER

echo "$portable_name have been configured"

printLine "Audacity"
sudo apt install audacity -y

printLine "Balena Etcher"

portable_name="balena-etcher"
portable_subdir="$portable_dir/$portable_name"
portable_cversion="`cat "$portable_subdir/version.txt"`"
portable_version="1.5.116"

if [ "$portable_cversion" != "$portable_version" ]
then
  rm -rf "$portable_subdir"
fi

if [ ! -d "$portable_subdir" ]
then
  file="$portable_dir/balena-etcher.zip"
  wget -O "$file" "https://github.com/balena-io/etcher/releases/download/v$portable_version/balena-etcher-electron-$portable_version-linux-x64.zip"
  mkdir -pv "$portable_subdir"
  unzip -q "$file" -d "$portable_subdir"
  rm -fv "$file"

  file="$portable_subdir/balenaEtcher-$portable_version-x64.AppImage"
  ln -sv -T "$file" "$portable_subdir/balena-etcher.AppImage"
  chmod +x "$file"

  current_dir="`pwd`"
  cd "$portable_subdir"
  "$file" --appimage-extract
  cd "$current_dir"
  cp -fv "$portable_subdir/squashfs-root/balena-etcher-electron.png" "$portable_subdir/balena-etcher.png"
  rm -rf "$portable_subdir/squashfs-root"

  echo "$portable_version" > "$portable_subdir/version.txt"
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

printLine "Dropbox"
if [ ! -f "/usr/bin/dropbox" ]
then
  dpkgInstall "dropbox.deb" "https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb"
else
  echo "dropbox is already installed"
fi

printLine "Flameshot"
sudo apt install flameshot -y

printLine "FreeRapid Downloader"

portable_name="freerapiddownloader"
portable_subdir="$portable_dir/$portable_name"
portable_cversion="`cat "$portable_subdir/version.txt"`"
portable_dropbox_path="swyleflcmtqxpch"
portable_version="0.9u4"

if [ "$portable_cversion" != "$portable_version" ]
then
  rm -rf "$portable_subdir"
fi

if [ ! -d "$portable_subdir" ]
then
  file="$portable_dir/freerapiddownloader.zip"
  wget -O "$file" "https://www.dropbox.com/s/$portable_dropbox_path/FreeRapid-$portable_version.zip"
  unzip -q "$file" -d "$portable_dir"
  rm -fv "$file"

  mv -fv "$portable_dir/FreeRapid-$portable_version" "$portable_subdir"

  echo "$portable_version" > "$portable_subdir/version.txt"
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

printLine "GNOME Calculator"
sudo apt install gnome-calculator -y

printLine "Google Chrome"
if [ -z "`google-chrome --version`" ]
then
  dpkgInstall "google-chrome.deb" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
else
  echo "google-chrome is already installed"
fi

printLine "Kdenlive"

portable_name="kdenlive"
portable_subdir="$portable_dir/$portable_name"
portable_cversion="`cat "$portable_subdir/version.txt"`"
portable_rversion="20.12"
portable_version="20.12.2"

if [ "$portable_cversion" != "$portable_version" ]
then
  rm -rf "$portable_subdir"
fi

if [ ! -d "$portable_subdir" ]
then
  mkdir -pv "$portable_subdir"

  file="$portable_subdir/kdenlive-$portable_version-x86_64.appimage"
  wget -O "$file" "https://download.kde.org/stable/kdenlive/$portable_rversion/linux/kdenlive-$portable_version-x86_64.appimage"

  ln -sv -T "$file" "$portable_subdir/kdenlive.appimage"
  chmod +x "$file"

  echo "$portable_version" > "$portable_subdir/version.txt"
else
  echo "$portable_name is already installed"
fi

file="$desktop_dir/kdenlive.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=Kdenlive\n'
  desk+=$'GenericName=Video Editor\n'
  desk+=$'GenericName[pt_BR]=Editor de Vídeo\n'
  desk+=$'Comment=Nonlinear video editor by KDE\n'
  desk+=$'Comment[pt_BR]=Editor de vídeo não-linear do KDE\n'
  desk+=$'Exec="'$portable_subdir$'/kdenlive.appimage" %U\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'MimeType=application/x-kdenlive;\n'
  desk+=$'Icon=kdenlive\n'
  desk+=$'Categories=Qt;KDE;AudioVideo;AudioVideoEditing;\n'
  echo "$desk" > "$file"
fi

echo "$portable_name have been configured"

printLine "OBS Studio"
sudo apt install obs-studio -y

printLine "Oracle VM VirtualBox"
echo virtualbox-ext-pack virtualbox-ext-pack/license select true | sudo debconf-set-selections
sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-qt -y
sudo usermod -aG vboxusers $USER

printLine "Remmina"
sudo apt install remmina remmina-plugin-rdp remmina-plugin-vnc -y

printLine "Scrcpy"

sudo apt install scrcpy -y

file="$desktop_dir/scrcpy.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=Scrcpy\n'
  desk+=$'GenericName=Scrcpy\n'
  desk+=$'Comment=Display and control of Android devices connected on USB\n'
  desk+=$'Comment[pt_BR]=Exibição e controle de dispositivos Android conectados via USB\n'
  desk+=$'Exec=scrcpy\n'
  desk+=$'Terminal=true\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon=phone\n'
  desk+=$'Categories=Utility;\n'
  echo "$desk" > "$file"
fi

echo "scrcpy have been configured"

printLine "Spotify"
echo "Running snap, please wait..."
sudo snap install spotify

printLine "Transmission"
sudo apt install transmission -y

printLine "VLC"
sudo apt install vlc -y

desktopConf "$desktop_dir" "info.desktop" "NoDisplay" "true"
desktopConf "$desktop_dir" "org.kde.kdeconnect_open.desktop" "NoDisplay" "true"
desktopConf "$desktop_dir" "org.kde.kdeconnect.sms.desktop" "NoDisplay" "true"

printLine "Finished"
echo "Please reboot your system."
echo ""