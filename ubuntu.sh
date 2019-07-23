#!/bin/bash
system="`lsb_release -sd`"

arch="amd64"
if [ "`uname -m`" != "x86_64" ]
then
  arch="i386"
fi

echo "PRODUCTION ENVIRONMENT SCRIPT - UBUNTU"
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

printLine "Base Apps"
sudo apt update
sudo apt install curl wget git unzip tar jq neofetch htop -y

printLine "App Hubs"
sudo apt install snapd flatpak -y
sudo systemctl enable --now snapd.socket
sudo flatpak remote-add --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
portable_dir="$HOME/portable"
mkdir -pv "$portable_dir"

printLine "OpenJDK"
sudo apt install openjdk-8-jdk -y
java_dir="/usr/lib/jvm/java-8-openjdk-$arch"

printLine "4K Video Downloader"
if [ ! -f "/usr/bin/4kvideodownloader" ]
then
  dpkgInstall "4kvideodownloader.deb" "https://dl.4kdownload.com/app/4kvideodownloader_4.8.0-1_$arch.deb"
else
  echo "4kvideodownloader is already installed"
fi

printLine "Angry IP Scanner"
if [ ! -f "/usr/bin/ipscan" ]
then
  dpkgInstall "angryipscanner.deb" "https://github.com/angryip/ipscan/releases/download/3.5.5/ipscan_3.5.5_$arch.deb"
else
  echo "angryipscanner is already installed"
fi

printLine "CPU-X"

portable_name="cpu-x"
portable_subdir="$portable_dir/$portable_name"
if [ ! -d "$portable_subdir" ]
then
  file="$portable_dir/cpu-x.tar.gz"
  wget -O "$file" "https://github.com/X0rg/CPU-X/releases/download/v3.2.4/CPU-X_v3.2.4_portable.tar.gz"
  mkdir -pv "$portable_subdir"
  tar -xf "$file" -C "$portable_subdir"
  ln -sv -T "$portable_subdir/CPU-X_v3.2.4_portable.linux64" "$portable_subdir/cpu-x.linux"
  rm -fv "$file"
else
  echo "$portable_name is already installed"
fi

file="$HOME/.local/share/applications/$portable_name.desktop"
if [ ! -f "$file" ]
then
  mkdir -pv "$HOME/.local/share/applications"
  conf=$'[Desktop Entry]\n'
  conf+=$'Name=CPU-X\n'
  conf+=$'GenericName=CPU-X\n'
  conf+=$'Comment=CPU, motherboard and more information\n'
  conf+=$'Comment[pt_BR]=CPU, placa-mãe e mais informações\n'
  conf+=$'Exec='$portable_subdir$'/cpu-x.linux\n'
  conf+=$'Terminal=false\n'
  conf+=$'Type=Application\n'
  conf+=$'Icon=cpuinfo\n'
  conf+=$'Categories=System;\n'
  echo "$conf" > "$file"
fi

echo "$portable_name have been configured"

printLine "Discord"
echo "Running snap, please wait..."
sudo snap install discord

printLine "Dropbox"
if [ ! -f "/usr/bin/dropbox" ]
then
  dpkgInstall "dropbox.deb" "https://linux.dropbox.com/packages/ubuntu/dropbox_2019.02.14_$arch.deb"
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

file="$HOME/.local/share/applications/$portable_name.desktop"
if [ ! -f "$file" ]
then
  mkdir -pv "$HOME/.local/share/applications"
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

printLine "Google Chrome"
if [ -z "`google-chrome --version`" ]
then
  dpkgInstall "google-chrome.deb" "https://dl.google.com/linux/direct/google-chrome-stable_current_$arch.deb"
else
  echo "google-chrome is already installed"
fi

printLine "GParted"
sudo apt install gparted -y

printLine "OBS Studio"
sudo flatpak install flathub com.obsproject.Studio -y

printLine "Oracle VM VirtualBox"
if [ -z "`vboxmanage --version`" ]
then
  dpkgInstall "oracle-vm-virtualbox.deb" "https://download.virtualbox.org/virtualbox/6.0.10/virtualbox-6.0_6.0.10-132072~Ubuntu~bionic_$arch.deb"
else
  echo "vbox is already installed"
fi
if [ -z "`vboxmanage list extpacks | grep -i 'version'`" ]
then
  file="$HOME/Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack"
  wget -O "$file" "https://download.virtualbox.org/virtualbox/6.0.10/Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack"
  echo y | sudo vboxmanage extpack install "$file"
  rm -fv "$file"
else
  echo "vbox-extpack is already installed"
fi
sudo usermod -aG vboxusers $USER

printLine "Remmina"
sudo apt install remmina remmina-plugin-rdp remmina-plugin-vnc -y

printLine "Spotify"
echo "Running snap, please wait..."
sudo snap install spotify

printLine "Steam"
sudo apt install steam -y

printLine "HexChat"
sudo apt remove hexchat -y

printLine "Thunderbird"
sudo apt remove thunderbird -y

printLine "Finished"
echo "Done, please reboot your system."
echo ""