#!/bin/bash
system="`lsb_release -sd`"
system_release="`lsb_release -sr`"
system_architecture="`uname -m`"

echo "LINUX PERSONAL SCRIPT (UBUNTU)"
echo "Version: 2023.7.25-1540"
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
  if [ -f "$source_file" ] && [ "$5" != "--no-replace-file" ]
  then
    cp -fv "$source_file" "$target_file"
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

home_autostart_dir="$HOME/.config/autostart"
mkdir -pv "$home_autostart_dir"

printLine "Update"
sudo apt update

printLine "Kernel"
sudo apt-mark auto $(apt-mark showmanual | grep -E "^linux-([[:alpha:]]+-)+[[:digit:].]+-[^-]+(|-.+)$")

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

printLine "Sensors"
sudo apt install lm-sensors -y

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
root_app_version="4.25.1"

if [ "$root_app_cversion" != "$root_app_version" ]
then
  sudo rm -rf "$root_app_subdir"

  sudo apt remove 4kvideodownloader -y
fi

if [ ! -f "/usr/bin/4kvideodownloader" ]
then
  dpkgInstall "4kvideodownloader.deb" "https://dl.4kdownload.com/app/4kvideodownloader_$root_app_version-1_amd64.deb"

  sudo mkdir -pv "$root_app_subdir"

  if [ -f "/usr/bin/4kvideodownloader" ]
  then
    echo "$root_app_version" | sudo tee "$root_app_subdir/version.txt"
  fi
else
  echo "$root_app_name is already installed"
fi

printLine "Angry IP Scanner"

root_app_name="angryipscanner"
root_app_subdir="$root_app_dir/$root_app_name"
root_app_cversion="`sudo cat "$root_app_subdir/version.txt"`"
root_app_version="3.9.1"

if [ "$root_app_cversion" != "$root_app_version" ]
then
  sudo rm -rf "$root_app_subdir"

  sudo apt remove ipscan -y
fi

if [ ! -f "/usr/bin/ipscan" ]
then
  dpkgInstall "angryipscanner.deb" $'https://github.com/angryip/ipscan/releases/download/'$root_app_version$'/ipscan_'$root_app_version$'_amd64.deb'

  sudo mkdir -pv "$root_app_subdir"

  if [ -f "/usr/bin/ipscan" ]
  then
    echo "$root_app_version" | sudo tee "$root_app_subdir/version.txt"
  fi
else
  echo "$root_app_name is already installed"
fi

printLine "Arduino IDE"

home_app_name="arduino-ide"
home_app_subdir="$home_app_dir/$home_app_name"
home_app_cversion="`cat "$home_app_subdir/version.txt"`"
home_app_version="2.1.1"

if [ "$home_app_cversion" != "$home_app_version" ]
then
  rm -rf "$home_app_subdir"
fi

if [ ! -d "$home_app_subdir" ]
then
  mkdir -pv "$home_app_subdir"
  file=$home_app_subdir$'/arduino-ide_'$home_app_version$'_Linux_64bit.AppImage'
  wget -O "$file" $'https://downloads.arduino.cc/arduino-ide/arduino-ide_'$home_app_version$'_Linux_64bit.AppImage'
  ln -sv -T "$file" "$home_app_subdir/arduino-ide.AppImage"
  chmod +x "$file"

  if [ -f "$home_app_subdir/arduino-ide.AppImage" ]
  then
    echo "$home_app_version" > "$home_app_subdir/version.txt"
  fi
else
  echo "$home_app_name is already installed"
fi

file="$home_menu_dir/arduino-ide.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=Arduino IDE\n'
  desk+=$'GenericName=Arduino IDE\n'
  desk+=$'Comment=Open-source electronics prototyping platform\n'
  desk+=$'Comment[pt_BR]=Plataforma de prototipagem de eletrônicos de código aberto\n'
  desk+=$'Exec="'$home_app_subdir$'/arduino-ide.AppImage" %U\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon=arduino-ide\n'
  desk+=$'StartupWMClass=Arduino IDE\n'
  desk+=$'Categories=Development;IDE;Electronics;\n'
  echo "$desk" > "$file"
fi

sudo usermod -aG dialout $USER

echo "$home_app_name have been configured"

printLine "Audacity"

sudo apt install audacity -y
menuConf "$home_menu_dir" "audacity.desktop" "Exec" "env GDK_BACKEND=x11 audacity %F"

echo "audacity have been configured"

printLine "balenaEtcher"

home_app_name="balena-etcher"
home_app_subdir="$home_app_dir/$home_app_name"
home_app_cversion="`cat "$home_app_subdir/version.txt"`"
home_app_version="1.18.11"

if [ "$home_app_cversion" != "$home_app_version" ]
then
  rm -rf "$home_app_subdir"
fi

if [ ! -d "$home_app_subdir" ]
then
  mkdir -pv "$home_app_subdir"
  file="$home_app_subdir/balenaEtcher-$home_app_version-x64.AppImage"
  wget -O "$file" "https://github.com/balena-io/etcher/releases/download/v$home_app_version/balenaEtcher-$home_app_version-x64.AppImage"
  ln -sv -T "$file" "$home_app_subdir/balena-etcher.AppImage"
  chmod +x "$file"

  current_dir="`pwd`"
  cd "$home_app_subdir"
  "$file" --appimage-extract
  cd "$current_dir"
  cp -fv "$home_app_subdir/squashfs-root/balena-etcher.png" "$home_app_subdir/balena-etcher.png"
  rm -rf "$home_app_subdir/squashfs-root"

  if [ -f "$home_app_subdir/balena-etcher.AppImage" ]
  then
    echo "$home_app_version" > "$home_app_subdir/version.txt"
  fi
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

printLine "DOSBox"
sudo apt install dosbox -y

printLine "Dropbox"
if [ ! -f "/usr/bin/dropbox" ]
then
  dpkgInstall "dropbox.deb" "https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb"
else
  echo "dropbox is already installed"
fi

printLine "FileZilla"
sudo apt install filezilla -y

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

  if [ -f "$home_app_subdir/frd.jar" ]
  then
    echo "$home_app_version" > "$home_app_subdir/version.txt"
  fi
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
menuConf "$home_menu_dir" "google-chrome.desktop" "Exec" "/usr/bin/google-chrome-stable %U --disable-gpu-driver-bug-workarounds --disable-accelerated-2d-canvas"

echo "google-chrome have been configured"

printLine "Kdenlive"
sudo apt install kdenlive -y

printLine "LibreOffice"

sudo apt install libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-help-pt-br -y
menuConf "$home_menu_dir" "libreoffice-startcenter.desktop" "NoDisplay" "true"

echo "libreoffice have been configured"

printLine "OBS Studio"
sudo apt install obs-studio -y

printLine "Remmina"
sudo apt install remmina remmina-plugin-rdp remmina-plugin-vnc -y

printLine "TeamViewer"
if [ -z "`teamviewer --version`" ]
then
  dpkgInstall "teamviewer.deb" "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
else
  echo "teamviewer is already installed"
fi

printLine "Transmission"
sudo apt install transmission -y

printLine "Ventoy"

home_app_name="ventoy"
home_app_subdir="$home_app_dir/$home_app_name"
home_app_cversion="`cat "$home_app_subdir/version.txt"`"
home_app_version="1.0.94"

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

  if [ -f "$home_app_subdir/VentoyGUI.x86_64" ]
  then
    echo "$home_app_version" > "$home_app_subdir/version.txt"
  fi
else
  echo "$home_app_name is already installed"
fi

file="$home_menu_dir/ventoy.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Name=Ventoy\n'
  desk+=$'GenericName=Ventoy\n'
  desk+=$'Comment=Tool to create bootable USB drive for ISO/WIM/IMG/VHD(x)/EFI files.\n'
  desk+=$'Comment[pt_BR]=Ferramenta para criar unidade USB inicializável para arquivos ISO/WIM/IMG/VHD(x)/EFI.\n'
  desk+=$'Exec='$home_app_subdir$'/VentoyGUI.x86_64\n'
  desk+=$'Terminal=false\n'
  desk+=$'Type=Application\n'
  desk+=$'Icon='$home_app_subdir$'/WebUI/static/img/VentoyLogo.png\n'
  desk+=$'Categories=Utility;\n'
  echo "$desk" > "$file"
fi

echo "$home_app_name have been configured"

printLine "Virt-Manager"

sudo apt install virt-manager -y
menuConf "$home_menu_dir" "remote-viewer.desktop" "NoDisplay" "true"

echo "virt-manager have been configured"

printLine "VLC"
sudo apt install vlc -y

printLine "Zoiper5"

root_app_name="zoiper5"
root_app_subdir="$root_app_dir/$root_app_name"
root_app_cversion="`sudo cat "$root_app_subdir/version.txt"`"
root_app_dropbox_path="wpqz7bh5efnwfnk"
root_app_version="5.6.1"

if [ "$root_app_cversion" != "$root_app_version" ]
then
  sudo rm -rf "$root_app_subdir"

  sudo apt remove zoiper5 -y
fi

if [ ! -f "/usr/local/applications/Zoiper5/zoiper" ]
then
  dpkgInstall "zoiper5.deb" $'https://www.dropbox.com/s/'$root_app_dropbox_path$'/Zoiper5_'$root_app_version$'_x86_64.deb'

  sudo mkdir -pv "$root_app_subdir"

  if [ -f "/usr/local/applications/Zoiper5/zoiper" ]
  then
    echo "$root_app_version" | sudo tee "$root_app_subdir/version.txt"
  fi
else
  echo "$root_app_name is already installed"
fi

file="$home_autostart_dir/Zoiper5.desktop"
if [ ! -f "$file" ]
then
  desk=$'[Desktop Entry]\n'
  desk+=$'Encoding=UTF-8\n'
  desk+=$'Name=Zoiper5\n'
  desk+=$'Comment=VoIP Softphone\n'
  desk+=$'Exec=/usr/local/applications/Zoiper5/zoiper\n'
  desk+=$'Terminal=false\n'
  desk+=$'Icon=/usr/share/pixmaps/Zoiper5.png\n'
  desk+=$'Type=Application\n'
  echo "$desk" > "$file"
else
  crudini --set "$file" "Desktop Entry" "Icon" "/usr/share/pixmaps/Zoiper5.png"
fi

echo "$root_app_name have been configured"

printLine "Language Pack"
sudo apt install language-pack-pt language-pack-gnome-pt -y
sudo apt install language-selector-common -y
sudo apt install `check-language-support` -y

printLine "Finished"
echo "Please reboot your system."
echo ""