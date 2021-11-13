#!/bin/bash
system="`lsb_release -sd`"
system_release="`lsb_release -sr`"
system_architecture="`uname -m`"

echo "LINUX PERSONAL SCRIPT (UBUNTU)"
echo "Author: Danilo Ancilotto"
echo "System: $system"
echo "Architecture: $system_architecture"
echo "Home: $HOME"
echo "User: $USER"
sudo echo -n ""

printLine() {
  text="$1"
  if [ ! -z "$text" ]
  then
    text="$text "
  fi
  length=${#text}
  sudo echo ""
  echo -n "$text"
  for i in {1..80}
  do
    if [ $i -gt $length ]
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

menuConf() {
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

java8_dir="/usr/lib/jvm/java-8-openjdk-amd64"

root_app_dir="/root/Applications"
sudo mkdir -pv "$root_app_dir"

home_app_dir="$HOME/Applications"
mkdir -pv "$home_app_dir"

home_menu_dir="$HOME/.local/share/applications"
mkdir -pv "$home_menu_dir"

printLine "Update"
sudo apt update

printLine "Kernel"

swappiness="10"
if [ "`cat /proc/sys/vm/swappiness`" != "$swappiness" ]
then
  file="/etc/sysctl.d/60-swappiness.conf"
  echo "vm.swappiness=$swappiness" | sudo tee "$file"
  sudo sysctl -p "$file"
fi

cache_pressure="50"
if [ "`cat /proc/sys/vm/vfs_cache_pressure`" != "$cache_pressure" ]
then
  file="/etc/sysctl.d/60-cache-pressure.conf"
  echo "vm.vfs_cache_pressure=$cache_pressure" | sudo tee "$file"
  sudo sysctl -p "$file"
fi

inotify_watches="524288"
if [ "`cat /proc/sys/fs/inotify/max_user_watches`" != "$inotify_watches" ]
then
  file="/etc/sysctl.d/60-inotify-watches.conf"
  echo "fs.inotify.max_user_watches=$inotify_watches" | sudo tee "$file"
  sudo sysctl -p "$file"
fi

echo "kernel have been configured"

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

printLine "Samba"
sudo apt install samba -y

printLine "OpenJDK"

sudo apt install openjdk-8-jdk -y
menuConf "$home_menu_dir" "openjdk-8-policytool.desktop" "NoDisplay" "true"

echo "openjdk have been configured"

printLine "Htop"

sudo apt install htop -y
menuConf "$home_menu_dir" "htop.desktop" "NoDisplay" "true"

echo "htop have been configured"

printLine "Neofetch"
sudo apt install neofetch -y

printLine "4K Video Downloader"

root_app_name="4kvideodownloader"
root_app_subdir="$root_app_dir/$root_app_name"
root_app_cversion="`sudo cat "$root_app_subdir/version.txt"`"
root_app_version="4.18.5"

if [ "$root_app_cversion" != "$root_app_version" ]
then
  sudo rm -rf "$root_app_subdir"

  sudo apt remove 4kvideodownloader -y
fi

if [ ! -f "/usr/bin/4kvideodownloader" ]
then
  dpkgInstall "4kvideodownloader.deb" "https://dl.4kdownload.com/app/4kvideodownloader_$root_app_version-1_amd64.deb"

  sudo mkdir -pv "$root_app_subdir"
  echo "$root_app_version" | sudo tee "$root_app_subdir/version.txt"
else
  echo "$root_app_name is already installed"
fi

printLine "Angry IP Scanner"

root_app_name="angryipscanner"
root_app_subdir="$root_app_dir/$root_app_name"
root_app_cversion="`sudo cat "$root_app_subdir/version.txt"`"
root_app_version="3.7.6"

if [ "$root_app_cversion" != "$root_app_version" ]
then
  sudo rm -rf "$root_app_subdir"

  sudo apt remove ipscan -y
fi

if [ ! -f "/usr/bin/ipscan" ]
then
  dpkgInstall "angryipscanner.deb" $'https://github.com/angryip/ipscan/releases/download/'$root_app_version$'/ipscan_'$root_app_version$'_amd64.deb'

  sudo mkdir -pv "$root_app_subdir"
  echo "$root_app_version" | sudo tee "$root_app_subdir/version.txt"
else
  echo "$root_app_name is already installed"
fi

printLine "Arduino"

home_app_name="arduino"
home_app_subdir="$home_app_dir/$home_app_name"
home_app_cversion="`cat "$home_app_subdir/version.txt"`"
home_app_version="1.8.16"

if [ "$home_app_cversion" != "$home_app_version" ]
then
  rm -rf "$home_app_subdir"
fi

if [ ! -d "$home_app_subdir" ]
then
  file="$home_app_dir/arduino.tar.xz"
  wget -O "$file" "https://downloads.arduino.cc/arduino-$home_app_version-linux64.tar.xz"
  mkdir -pv "$home_app_subdir"
  tar -xJf "$file" -C "$home_app_subdir"
  rm -fv "$file"

  mv -fv "$home_app_subdir/arduino-$home_app_version" "$home_app_subdir/default"
  mkdir -pv "$home_app_subdir/default/portable"
  cp -fr "$home_app_subdir/default" "$home_app_subdir/esp32"

  echo "$home_app_version" > "$home_app_subdir/version.txt"
else
  echo "$home_app_name is already installed"
fi

conf=$'build.verbose=true\n'
conf+=$'compiler.warning_level=default\n'
conf+=$'editor.code_folding=true\n'
conf+=$'editor.linenumbers=true\n'
conf+=$'upload.verbose=true\n'
file="$home_app_subdir/default/portable/preferences.txt"
if [ ! -f "$file" ]
then
  conf_default="$conf"
  echo "$conf_default" > "$file"
fi
file="$home_app_subdir/esp32/portable/preferences.txt"
if [ ! -f "$file" ]
then
  conf_esp32="$conf"
  conf_esp32+=$'boardsmanager.additional.urls=https://dl.espressif.com/dl/package_esp32_index.json\n'
  echo "$conf_esp32" > "$file"
fi

file="$home_menu_dir/arduino-arduinoide.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=Arduino IDE\n'
  desk+=$'GenericName=Arduino IDE\n'
  desk+=$'Comment=Open-source electronics prototyping platform\n'
  desk+=$'Comment[pt_BR]=Plataforma de prototipagem de eletrônicos de código aberto\n'
  desk+=$'Exec='$home_app_subdir$'/default/arduino\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon='$home_app_subdir$'/default/lib/arduino_icon.ico\n'
  desk+=$'Categories=Development;IDE;Electronics;\n'
  desk+=$'MimeType=text/x-arduino;\n'
  desk+=$'Keywords=embedded electronics;electronics;avr;microcontroller;\n'
  desk+=$'StartupWMClass=processing-app-Base\n'
  desk+=$'Actions=ESP32;\n'
  desk+=$'\n'
  desk+=$'[Desktop Action ESP32]\n'
  desk+=$'Name=ESP32\n'
  desk+=$'GenericName=ESP32\n'
  desk+=$'Exec='$home_app_subdir$'/esp32/arduino\n'
  echo "$desk" > "$file"
fi

sudo usermod -aG dialout $USER

echo "$home_app_name have been configured"

printLine "Audacity"
sudo apt install audacity -y

printLine "Balena Etcher"

home_app_name="balena-etcher"
home_app_subdir="$home_app_dir/$home_app_name"
home_app_cversion="`cat "$home_app_subdir/version.txt"`"
home_app_version="1.7.0"

if [ "$home_app_cversion" != "$home_app_version" ]
then
  rm -rf "$home_app_subdir"
fi

if [ ! -d "$home_app_subdir" ]
then
  file="$home_app_dir/balena-etcher.zip"
  wget -O "$file" "https://github.com/balena-io/etcher/releases/download/v$home_app_version/balena-etcher-electron-$home_app_version-linux-x64.zip"
  mkdir -pv "$home_app_subdir"
  unzip -q "$file" -d "$home_app_subdir"
  rm -fv "$file"

  file="$home_app_subdir/balenaEtcher-$home_app_version-x64.AppImage"
  ln -sv -T "$file" "$home_app_subdir/balena-etcher.AppImage"
  chmod +x "$file"

  current_dir="`pwd`"
  cd "$home_app_subdir"
  "$file" --appimage-extract
  cd "$current_dir"
  cp -fv "$home_app_subdir/squashfs-root/balena-etcher-electron.png" "$home_app_subdir/balena-etcher.png"
  rm -rf "$home_app_subdir/squashfs-root"

  echo "$home_app_version" > "$home_app_subdir/version.txt"
else
  echo "$home_app_name is already installed"
fi

file="$home_menu_dir/appimagekit-balena-etcher-electron.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=balenaEtcher\n'
  desk+=$'GenericName=balenaEtcher\n'
  desk+=$'Comment=Flash OS images to SD cards and USB drives, safely and easily.\n'
  desk+=$'Comment[pt_BR]=Gravar imagens de SO em cartões SD e drives USB, com segurança e facilidade.\n'
  desk+=$'Exec="'$home_app_subdir$'/balena-etcher.AppImage" %U\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon='$home_app_subdir$'/balena-etcher.png\n'
  desk+=$'StartupWMClass=balenaEtcher\n'
  desk+=$'Categories=Utility;\n'
  echo "$desk" > "$file"
fi

echo "$home_app_name have been configured"

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

home_app_name="freerapiddownloader"
home_app_subdir="$home_app_dir/$home_app_name"
home_app_cversion="`cat "$home_app_subdir/version.txt"`"
home_app_dropbox_path="swyleflcmtqxpch"
home_app_version="0.9u4"

if [ "$home_app_cversion" != "$home_app_version" ]
then
  rm -rf "$home_app_subdir"
fi

if [ ! -d "$home_app_subdir" ]
then
  file="$home_app_dir/freerapiddownloader.zip"
  wget -O "$file" "https://www.dropbox.com/s/$home_app_dropbox_path/FreeRapid-$home_app_version.zip"
  unzip -q "$file" -d "$home_app_dir"
  rm -fv "$file"

  mv -fv "$home_app_dir/FreeRapid-$home_app_version" "$home_app_subdir"

  echo "$home_app_version" > "$home_app_subdir/version.txt"
else
  echo "$home_app_name is already installed"
fi

file="$home_menu_dir/$home_app_name.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=FreeRapid Downloader\n'
  desk+=$'GenericName=FreeRapid Downloader\n'
  desk+=$'Comment=Download from file-sharing services\n'
  desk+=$'Comment[pt_BR]=Download de serviços de compartilhamento de arquivos\n'
  desk+=$'Exec='$java8_dir$'/bin/java -jar '$home_app_subdir$'/frd.jar\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon='$home_app_subdir$'/frd.ico\n'
  desk+=$'Categories=Network;\n'
  echo "$desk" > "$file"
fi

echo "$home_app_name have been configured"

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
sudo apt install kdenlive -y

printLine "LibreOffice"
sudo apt install libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-help-pt-br -y

printLine "OBS Studio"
sudo apt install obs-studio -y

printLine "Remmina"
sudo apt install remmina remmina-plugin-rdp remmina-plugin-vnc -y

printLine "Scrcpy"

sudo apt install scrcpy -y

file="$home_menu_dir/scrcpy.desktop"
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

printLine "Transmission"
sudo apt install transmission -y

printLine "Ventoy"

home_app_name="ventoy"
home_app_subdir="$home_app_dir/$home_app_name"
home_app_cversion="`cat "$home_app_subdir/version.txt"`"
home_app_version="1.0.60"

if [ "$home_app_cversion" != "$home_app_version" ]
then
  rm -rf "$home_app_subdir"
fi

if [ ! -d "$home_app_subdir" ]
then
  file="$home_app_dir/ventoy.tar.gz"
  wget -O "$file" "https://github.com/ventoy/Ventoy/releases/download/v$home_app_version/ventoy-$home_app_version-linux.tar.gz"
  tar -xzf "$file" -C "$home_app_dir"
  rm -fv "$file"

  mv -fv "$home_app_dir/ventoy-$home_app_version" "$home_app_subdir"

  echo "$home_app_version" > "$home_app_subdir/version.txt"
else
  echo "$home_app_name is already installed"
fi

printLine "Virt-Manager"
sudo apt install virt-manager -y

printLine "VLC"
sudo apt install vlc -y

printLine "Language Pack Pt"
sudo apt install language-pack-pt language-pack-gnome-pt -y
sudo apt install `check-language-support` -y

printLine "Finished"
echo "Please reboot your system."
echo ""