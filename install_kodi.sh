#!/bin/bash

# vars

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

#LOCALE SELECTOR {{{
language_selector(){
  #AUTOMATICALLY DETECTS THE SYSTEM LOCALE {{{
  #automatically detects the system language based on your locale
  #LOCALE=`locale | grep LANG | sed 's/LANG=//' | cut -c1-5`
  #KDE #{{{
  if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == zh_CN ]]; then
    LOCALE_KDE=`echo $LOCALE | tr '[:upper:]' '[:lower:]'`
  elif [[ $LOCALE == en_US ]]; then
    LOCALE_KDE="en_gb"
  else
    LOCALE_KDE=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}
  #FIREFOX #{{{
  if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == es_AR || $LOCALE == es_CL || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
    LOCALE_FF=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
  else
    LOCALE_FF=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}
  #THUNDERBIRD #{{{
  if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_US || $LOCALE == en_GB || $LOCALE == es_AR || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
    LOCALE_TB=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
  elif [[ $LOCALE == es_CL ]]; then
    LOCALE_TB="es-es"
  else
    LOCALE_TB=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}

  #HUNSPELL #{{{
  if [[ $LOCALE == pt_BR ]]; then
    LOCALE_HS=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
  elif [[ $LOCALE == en_US ]]; then
    LOCALE_HS=`echo $LOCALE | sed 's/_/-/'`
  fi
  #}}}

  #HYPHEN #{{{
  if [[ $LOCALE == pt_BR ]]; then
    LOCALE_HP=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
  elif [[ $LOCALE == en_US ]]; then
    LOCALE_HP=`echo $LOCALE | sed 's/_/-/'`
  fi
  #}}}

   #LIBMYTHES MYTHES #{{{
  if [[ $LOCALE == pt_BR ]]; then
    LOCALE_MT=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
  elif [[ $LOCALE == en_US ]]; then
    LOCALE_MT=`echo $LOCALE | sed 's/_/-/'`
  fi
  #}}}

  #ASPELL #{{{
  LOCALE_AS=`echo $LOCALE | cut -d\_ -f1`
  #}}}
  #LIBREOFFICE #{{{
  if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == zh_CN ]]; then
    LOCALE_LO=`echo $LOCALE | sed 's/_/-/'`
  else
    LOCALE_LO=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}
}
#}}}

#VIDEO CARDS {{{
install_video_cards(){
  package_install "dmidecode"
  print_title "VIDEO CARD"
  check_vga
  #Virtualbox {{{
  if [[ ${VIDEO_DRIVER} == virtualbox ]]; then
    package_install "virtualbox-guest-utils mesa-libgl"
    add_module "vboxguest vboxsf vboxvideo" "virtualbox-guest"
    add_user_to_group ${USER_NAME} vboxsf
    system_ctl disable ntpd
    system_ctl enable vboxservice
  #}}}
  #Bumblebee {{{
  elif [[ ${VIDEO_DRIVER} == bumblebee ]]; then
    XF86_DRIVERS=$(pacman -Qe | grep xf86-video | awk '{print $1}')
    [[ -n $XF86_DRIVERS ]] && pacman -Rcsn $XF86_DRIVERS
    pacman -S --needed xf86-video-intel bumblebee nvidia
    [[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-nvidia-utils
    replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
    replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
    mkinitcpio -p linux
    gpasswd -a ${USER_NAME} bumblebee
  #}}}
  #NVIDIA {{{
  elif [[ ${VIDEO_DRIVER} == nvidia ]]; then
    XF86_DRIVERS=$(pacman -Qe | grep xf86-video | awk '{print $1}')
    [[ -n $XF86_DRIVERS ]] && pacman -Rcsn $XF86_DRIVERS
    pacman -S --needed nvidia{,-utils}
    [[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-nvidia-utils
    replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
    replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
    mkinitcpio -p linux
    nvidia-xconfig --add-argb-glx-visuals --allow-glx-with-composite --composite -no-logo --render-accel -o /etc/X11/xorg.conf.d/20-nvidia.conf;
  #}}}
  #Nouveau [NVIDIA] {{{
  elif [[ ${VIDEO_DRIVER} == nouveau ]]; then
    is_package_installed "nvidia" && pacman -Rdds --noconfirm nvidia{,-utils}
    [[ -f /etc/X11/xorg.conf.d/20-nvidia.conf ]] && rm /etc/X11/xorg.conf.d/20-nvidia.conf
    package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl"
    if [[ ${ARCHI} == x86_64 ]]; then
      is_package_installed "lib32-nvidia-utils" && pacman -Rdds --noconfirm lib32-nvidia-utils
    fi
    replace_line '#*options nouveau modeset=1' 'options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
    replace_line '#*MODULES="nouveau"' 'MODULES="nouveau"' /etc/mkinitcpio.conf
    mkinitcpio -p linux
  #}}}
  #ATI {{{
  elif [[ ${VIDEO_DRIVER} == ati ]]; then
    is_package_installed "catalyst-total" && pacman -Rdds --noconfirm catalyst-total
    [[ -f /etc/X11/xorg.conf.d/20-radeon.conf ]] && rm /etc/X11/xorg.conf.d/20-radeon.conf
    [[ -f /etc/modules-load.d/catalyst.conf ]] && rm /etc/modules-load.d/catalyst.conf
    [[ -f /etc/X11/xorg.conf ]] && rm /etc/X11/xorg.conf
    package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl"
    add_module "radeon" "ati"
  #}}}
  #Intel {{{
  elif [[ ${VIDEO_DRIVER} == intel ]]; then
    package_install "xf86-video-${VIDEO_DRIVER} libva-intel-driver mesa-libgl"
  #}}}
  #Vesa {{{
  else
    package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl"
  fi
  #}}}
  if [[ ${ARCHI} == x86_64 ]]; then
    is_package_installed "mesa-libgl" && package_install "lib32-mesa-libgl"
  fi
  # pause_function
}
#}}}
#CUPS {{{
install_cups(){
  package_install "cups cups-filters ghostscript gsfonts"
  package_install "gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters hplip splix cups-pdf"
  package_install "system-config-printer"
  system_ctl enable org.cups.cupsd
}
#}}}

install_virtualbox(){
  #Make sure we are not a VirtualBox Guest
  VIRTUALBOX_GUEST=`dmidecode --type 1 | grep VirtualBox`
  if [[ -z ${VIRTUALBOX_GUEST} ]]; then
    package_install "virtualbox virtualbox-host-modules virtualbox-guest-iso"
    # aur_package_install "virtualbox-ext-oracle"
    add_user_to_group ${USER_NAME} vboxusers
    add_module "vboxdrv vboxnetflt vboxnetadp" "virtualbox-host"
    modprobe vboxdrv vboxnetflt vboxnetadp
  else
    cecho " ${BBlue}[${Reset}${Bold}!${BBlue}]${Reset} VirtualBox was not installed as we are a VirtualBox guest."
  fi
}

## https://wiki.samba.org/index.php/Samba_&_Active_Directory#Setting_Up_Kerberos
#SAMBA {{{
install_samba(){
  print_title "SAMBA - https://wiki.archlinux.org/index.php/Samba"
  print_info "Samba is a re-implementation of the SMB/CIFS networking protocol, it facilitates file and printer sharing among Linux and Windows systems as an alternative to NFS."
  #read_input_text "Install Samba" $SAMBA
  #if [[ $OPTION == y ]]; then
    package_install "samba smbnetfs"
    [[ ! -f /etc/samba/smb.conf ]] && cp /etc/samba/smb.conf.default /etc/samba/smb.conf
    local CONFIG_SAMBA=`cat /etc/samba/smb.conf | grep usershare`
    if [[ -z $CONFIG_SAMBA ]]; then
      # configure usershare
      # export USERSHARES_DIR="/var/lib/samba/usershare"
      # export USERSHARES_GROUP="sambashare"
      export USERSHARES_DIR
      export USERSHARES_GROUP
      mkdir -p ${USERSHARES_DIR} # used by net usershare add <>...
      groupadd ${USERSHARES_GROUP}
      chown root:${USERSHARES_GROUP} ${USERSHARES_DIR}
      chmod 01770 ${USERSHARES_DIR}

      mkdir -p ${USERSHARES_PATH} # used by smb.conf
      chown ${USER_NAME}:${USER_GROUP} ${USERSHARES_PATH} # used by smb.conf

      # smbd -i - invalid permissions on directory '/var/cache/samba/msg': has 0700 should be 0755
      chmod 0755 /var/cache/samba/msg

      # delete desnecessary lines
      sed -i "\|printcap name = \/etc\/printcap|d" /etc/samba/smb.conf
      sed -i "\|load printers = yes|d" /etc/samba/smb.conf

      sed -i "\|\[homes\]|d" /etc/samba/smb.conf
      sed -i "\|comment = Home Directories|d" /etc/samba/smb.conf
      sed -i "\|browseable = no|d" /etc/samba/smb.conf
      sed -i "\|writable = yes|d" /etc/samba/smb.conf

      sed -i "\|\[printers\]|d" /etc/samba/smb.conf
      sed -i "\|comment = All Printers|d" /etc/samba/smb.conf
      sed -i "\|path = \/var\/spool\/samba|d" /etc/samba/smb.conf
      sed -i "\|browseable = no|d" /etc/samba/smb.conf
      sed -i "\|guest ok = no|d" /etc/samba/smb.conf
      sed -i "\|writable = no|d" /etc/samba/smb.conf
      sed -i "\|printable = yes|d" /etc/samba/smb.conf

      sed -i "s|Samba Server|${HOST_NAME}|" /etc/samba/smb.conf # %h

      sed -i 's|; name resolve order = wins lmhosts bcast| name resolve order = bcast lmhosts host wins|'

      sed -i 's|workgroup = MYGROUP|workgroup = '${WORK_GROUP}'\n|' /etc/samba/smb.conf
      sed -i -e '/\[global\]/a\\n   usershare path = /var/lib/samba/usershare\n   usershare max shares = 100\n   usershare allow guests = yes\n   usershare owner only = False\n   netbios name = '${NETBIOS_NAME}'\n' /etc/samba/smb.conf
      sed -i -e '/\[global\]/a\\n   socket options = IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE\n   write cache size = 2097152\n   use sendfile = yes\n' /etc/samba/smb.conf
      if [ $AUTHENTICATE_ON_DOMAIN == true ]; then # ???
        sed -i -e '/\[global\]/a\\n   realm = '${REALM}'\n   winbind separator = \\\n   winbind use default domain = yes\n   winbind enum users  = yes\n   winbind enum groups = yes\n' /etc/samba/smb.conf
        sed -i "s|security = user|security = ads|" /etc/samba/smb.conf
        sed -i "s|;  encrypt passwords|encrypt passwords|" /etc/samba/smb.conf

        sed -i 's/passwd:.*/& winbind/' /etc/nsswitch.conf
        sed -i 's/group:.*/& winbind/' /etc/nsswitch.conf
      fi

      # share settings
      sed -i -e "\$a\[${SHARED_NAME}\]\n  comment = ${SHARED_COMMENT}\n  path = ${USERSHARES_PATH}\n  writeable = yes\n  browseable = yes\n  guest ok = yes\n" /etc/samba/smb.conf

      # echo '['${SHARED_NAME}']\n comment = '${SHARED_COMMENT}'\n path = '${SHARED_DIRECTORY}'\n writeable = yes\n browseable = yes\n guest ok = yes\n' >>  /etc/samba/smb.conf
      usermod -a -G ${USERSHARES_GROUP} ${username}
      sed -i '/user_allow_other/s/^#//' /etc/fuse.conf
      modprobe fuse

    fi
    echo "Enter your new samba account password:"
    pdbedit -a -u ${username}
    while [[ $? -ne 0 ]]; do
      pdbedit -a -u ${username}
    done

    # smbpasswd ???

    # enable services
    system_ctl enable smbd && system_ctl start smbd
    system_ctl enable nmbd && system_ctl start nmbd
    if [ $AUTHENTICATE_ON_DOMAIN == true ]; then
      system_ctl enable winbindd && system_ctl start winbindd
    fi

    # smbclient -L localhost –U user1 ???
}
#}}}

# install
# setup keymap
export LANG=${LOCALE_UTF8} # ???
echo ${LANG}
loadkeys ${KEYMAP}
echo ${KEYMAP}

localectl set-locale LANG=${LOCALE_UTF8}
localectl set-keymap ${KEYMAP}
localectl set-x11-keymap ${X11KEYMAP}

# wired and wireless
setup_connection
check_connection

check_multilib

# language_selector

install_video_cards

#XFCE {{{
print_title "XFCE - https://wiki.archlinux.org/index.php/Xfce"
print_info "Xfce is a free software desktop environment for Unix and Unix-like platforms, such as Linux, Solaris, and BSD. It aims to be fast and lightweight, while still being visually appealing and easy to use."
package_install "xfce4 xfce4-goodies" # xarchiver mupdf"
# config xinitrc
config_xinitrc "startxfce4"
#pause_function
#install_display_manager
# install_themes "XFCE"
#}}}

# display manager
package_install gdm
system_ctl enable gdm

# Network Management and daemon
package_install "networkmanager dnsmasq network-manager-applet networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc"
is_package_installed "ntp" && package_install "networkmanager-dispatcher-ntpd"
system_ctl enable NetworkManager
system_ctl start NetworkManager

# create setup for network manager with nmcli
# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Using_the_NetworkManager_Command_Line_Tool_nmcli.html
# https://fedoraproject.org/wiki/Networking/CLI
# http://cgit.freedesktop.org/NetworkManager/NetworkManager/plain/man/nmcli-examples.xml
if [ $AUTOMATIC_IP == false ]; then
  echo "Setup networking manager on: ${CONNECTION_DEVICE}"
  nmcli con add type ethernet con-name $CONNECTION_NAME ifname $CONNECTION_DEVICE ip4 $IP_ADDR$CIDR gw4 $GATEWAY
  nmcli con mod $CONNECTION_NAME ipv4.dns $NAMESERVER # +ipv4.dns to add
  nmcli con mod $CONNECTION_NAME ipv4.dns-search $DNS_SEARCH
  nmcli con up $CONNECTION_NAME ifname $CONNECTION_DEVICE
fi

echo "BASH TOOLS - https://wiki.archlinux.org/index.php/Bash"
package_install "bc rsync mlocate bash-completion pkgstats"

echo "NTPd - https://wiki.archlinux.org/index.php/NTPd"
package_install "ntp"
is_package_installed "ntp" && ntpd -u ntp:ntp

echo "(UN)COMPRESS TOOLS - https://wiki.archlinux.org/index.php/P7zip"
package_install "zip unzip unrar p7zip"

echo "AVAHI - https://wiki.archlinux.org/index.php/Avahi"
package_install "avahi nss-mdns"
system_ctl enable avahi-daemon

echo "ALSA - https://wiki.archlinux.org/index.php/Alsa"
package_install "alsa-utils alsa-plugins"
package_install "lib32-alsa-plugins"

echo "PULSEAUDIO - https://wiki.archlinux.org/index.php/Pulseaudio"
package_install "pulseaudio pulseaudio-alsa pavucontrol"
package_install "lib32-libpulse"

echo "NTFS/FAT/exFAT - https://wiki.archlinux.org/index.php/File_Systems"
package_install "ntfs-3g dosfstools exfat-utils fuse fuse-exfat autofs"
is_package_installed "fuse" && add_module "fuse"

echo "NFS - https://wiki.archlinux.org/index.php/Nfs"
package_install  "nfs-utils"
system_ctl mask nfs-blkmap.service # get out with warning boot message
system_ctl enable rpcbind
system_ctl enable nfs-client.target
system_ctl enable remote-fs.target

# Advanced Configuration and Power Interface (ACPI)
echo "ACPID https://wiki.archlinux.org/index.php/Acpid"
package_install "acpi acpid"
system_ctl enable acpid

# tools
package_install "mc curl lynx wget terminator rdesktop gparted htop encfs"
package_install "rsync grsync"
package_install "file-roller"
# package_install "gnome-disk-utility"

# https://wiki.archlinux.org/index.php/Davfs
package_install "davfs2"

package_install "catfish"
package_install "gedit gedit-plugins vte3"
# package_install "xscreensaver"
package_install "git gsfonts tk"
# package_install "meld"
package_install "gvfs gvfs-smb gvfs-nfs smbclient sshfs" # gnome-vfs # cifs-utils
package_install "gvfs-afc" #: removable media (e.g. optical disks, USB data sticks, and cameras)
package_install "gvfs-mtp" #: phones and media players that require MTP
#package_install "gvfs-gphoto2" #: automatically transfer content from many digital cameras

# package_install "cherrytree"

# media player
# package_install "vlc"
# package_install "totem"
# package_install "parole"
# package_install "smplayer" # gui for mplayer
# package_install "audacious audacious-plugins"
# package_install "banshee"
package_install "kodi"

# package_install "filezilla"
# package_install "firefox firefox-i18n-$LOCALE_FF firefox-adblock-plus flashplugin"
# package_install "thunderbird thunderbird-i18n-$LOCALE_TB"
# package_install "chromium"
# package_install "opera"
# package_install "libreoffice-fresh libreoffice-fresh-$LOCALE_LO unoconv"
# package_install "inkscape python2-numpy python-lxml"
# package_install "gimp"
# package_install "evince"
# package_install "simple-scan"
package_install "transmission-gtk"
# package_install "skype"

# sound programs
package_install "audacity"
package_install "soundconverter"

package_install "easytag"
package_install "handbrake"
# package_install "gnome-calculator"

# https://www.archlinux.org/packages/community/x86_64/plank/
# package_install "plank"

# stream / codecs
package_install "gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-base-libs"
package_install "gstreamer0.10 gstreamer0.10-plugins"
package_install "libbluray libquicktime libdvdread libdvdnav libdvdcss cdrdao"
sudo -u ${USER_NAME} mkdir -p /home/${USER_NAME}/.config/aacs/ && cd /home/${USER_NAME}/.config/aacs/ && wget http://vlc-bluray.whoknowsmy.name/files/KEYDB.cfg

# gnome plus
package_install "gnome-keyring seahorse"

# font
package_install "ttf-droid ttf-dejavu"

# cursor
package_install "xcursor-themes"

# theme
# package_install "numix-themes"

# icons
package_install "adwaita-icon-theme gnome-icon-theme gnome-icon-theme-extras gnome-icon-theme-symbolic hicolor-icon-theme"
package_install "faenza-icon-theme faience-icon-theme"

# spell checking [HUNSPELL]
#package_install "hunspell hunspell-$LOCALE_HS"

# Hyphenation rules [HYPHEN]
#package_install "hyphen hyphen-$LOCALE_HP"

# Thesaurus [LIBMYTHES MYTHES]
# sudo pacman -S aspell aspell-en hunspell-en hyphen-en libmythes mythes-en
#package_install "libmythes mythes mythes-$LOCALE_MT"

# 3G modem
#package_install "usbutils usb_modeswitch modemmanager"

# clamav # freshclam
package_install clamav
cp /etc/clamav/clamd.conf.sample /etc/clamav/clamd.conf
cp /etc/clamav/freshclam.conf.sample /etc/clamav/freshclam.conf
sed -i '/Example/d' /etc/clamav/freshclam.conf
sed -i '/Example/d' /etc/clamav/clamd.conf
sed -i 's/#TCPSocket/TCPSocket/' /etc/clamav/clamd.conf
sed -i '/DatabaseDirectory/s/^#//' /etc/clamav/clamd.conf
sed -i '/DatabaseDirectory/s/^#//' /etc/clamav/freshclam.conf
# clamd.service: PID file /run/clamav/clamd.pid not readable (yet?) after start: No such file or directory
touch /run/clamav/clamd.pid
# chown luis:users /var/lib/clamav & chmod 755 /var/lib/clamav ???
system_ctl enable clamd
system_ctl enable freshclamd

# ssh
package_install openssh
system_ctl enable sshd

# if [ $INSTALL_VIRTUALBOX == true ]; then
#   install_virtualbox
# fi

if [ $INSTALL_SAMBA == true ]; then
  install_samba
fi

# if [ $INSTALL_CUPS == true ]; then
#   install_cups
# fi

# if [ $INSTALL_DOCKER == true ]; then
#   package_install "docker"
#   gpasswd -a ${USER_NAME} docker
#   system_ctl enable docker
#   system_ctl start docker
# fi

# aur
# aur_package_install "libgee06"
# aur_package_install "gnome-encfs-manager" # libgee06 as dependency
# aur_package_install "dropbox"
# aur_package_install "sublime-text-dev"
# aur_package_install "atom-editor"
# aur_package_install "visual-studio-code"

# install all video drivers for run on any desktop/laptop
# if [[ $INSTALL_ON_PENDRIVE == true ]]; then
#   package_install "xf86-video-vesa xf86-video-ati xf86-video-intel xf86-video-nouveau"
# fi

# Run thunar as deamon
echo "thunar --daemon &" > /etc/xprofile

# turn off, more secure
sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/' /etc/sudoers

rm -R /var/lib/pacman/sync
pacman -Syu

# if [ $AUTHENTICATE_ON_DOMAIN == true ]; then
#   sudo net rpc join -U ${USER_DOMAIN}
# fi

##############
# [customize]#
##############
# List the channels:
# xfconf-query -l
# List all of the properties and values of a channel:
# xfconf-query -c <CHANNEL> -lv
# Create a new property:
# xfconf-query -c <CHANNEL> -p <PROPERTY> -n -t <TYPE> -s <VALUE>
# Change an existing property (same as previous but without the -n):
# xfconf-query -c <CHANNEL> -p <PROPERTY> -s <VALUE>

# # Always uncheck save session for future logins
# xfconf-query -c xfce4-session -p /general/SaveOnExit -n -t bool -s false
# # change icon
# xfconf-query -c xsettings -p /Net/IconThemeName -s Faenza-Ambiance
# # settings -> windows manager -> style
# xfconf-query -c xfwm4 -p /general/theme -s Numix
# # settings -> appearance - style
# xfconf-query -c xsettings -p /Net/ThemeName -s Numix
# # change workspace numbers
# xfconf-query -c xfwm4 -p /general/workspace_count -s 1
# # change clock format
# xfconf-query -c xfce4-panel -p /plugins/plugin-5/digital-format -s "%R%n<span size='x-small'>%d-%m %Y</span>"

# reboot
