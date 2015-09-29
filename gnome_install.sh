#!/bin/bash

# vars

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

# :: Repository extra

package_install "adwaita-icon-theme"
package_install "baobab" # A graphical directory tree analyzer
package_install "dconf-editor"
# empathy
package_install "eog"
# epiphany
package_install "evince"
package_install "gdm"
package_install "gnome-backgrounds"
package_install "gnome-calculator"
package_install "gnome-contacts"
package_install "gnome-control-center"
package_install "gnome-desktop"
package_install "gnome-dictionary"
package_install "gnome-disk-utility"
package_install "gnome-font-viewer"
package_install "gnome-keyring"
package_install "gnome-screenshot"
package_install "gnome-session"
package_install "gnome-settings-daemon"
package_install "gnome-shell"
package_install "gnome-shell-extensions"
package_install "gnome-system-log"
package_install "gnome-system-monitor"
package_install "gnome-terminal"
package_install "gnome-themes-standard"
package_install "gnome-user-docs"
package_install "gnome-user-share"
# grilo-plugins
package_install "gucharmap"
package_install "mousetweaks"
package_install "mutter"
package_install "nautilus"
package_install "sushi"
package_install "totem"
package_install "tracker"
# vino # a VNC server for the GNOME desktop
package_install "xdg-user-dirs-gtk"
package_install "yelp"
# accerciser
# aisleriot
# anjuta 
# atomix
# bijiben
package_install "brasero"
# cheese 
package_install "devhelp"
# evolution
package_install "file-roller"
# five-or-more
# four-in-a-row
package_install "gedit"
package_install "gedit-code-assistance"
# gitg 
# gnome-builder
package_install "gnome-calendar"
package_install "gnome-characters"
package_install "gnome-chess"
package_install "gnome-clocks"
package_install "gnome-code-assistance"
package_install "gnome-color-manager"
package_install "gnome-devel-docs"
package_install "gnome-documents"
package_install "gnome-getting-started-docs"
# gnome-klotski # Slide blocks to solve the puzzle
package_install "gnome-logs" 
# gnome-mahjongg 
package_install "gnome-maps"
# gnome-mines  
# gnome-music
package_install "gnome-nettool"
# gnome-nibbles 
# gnome-photos 
# gnome-robots 
package_install "gnome-sound-recorder"
# gnome-sudoku  
# gnome-taquin 
# gnome-tetravex 
package_install "gnome-tweak-tool"
package_install "gnome-weather"
# hitori # GTK+ application to generate and let you play games of Hitori
# iagno # Dominate the board in a classic version of Reversi
# lightsoff # Turn off all the lights
package_install "nautilus-sendto"
# orca # Screen reader for individuals who are blind or visually impaired
# polari # An IRC Client for GNOME
# quadrapassel # Fit falling blocks together (Tetris-like game for GNOME)
# rygel # UPnP AV MediaServer and MediaRenderer that allows you to easily share audio, video and pictures, and control of media player on your home network
package_install "seahorse"
# swell-foop # Clear the screen by removing groups of colored and shaped tiles
# tali # Beat the odds in a poker-style dice game
package_install "vinagre"
