# archsis

* Arch Simple Install Script

# download everything
wget https://github.com/luisantoniojr/archsis/tarball/master -O - | tar xz

or

# install separated
wget -qO- https://raw.githubusercontent.com/luisantoniojr/archsis/master/install | bash
wget -qO- https://raw.githubusercontent.com/luisantoniojr/archsis/master/install_programs | bash

* WARNING!!!
check setup file for all configurations! Otherwise you can lost data!

First run ./install, to install arch O.S
Then reboot
enter directory luisantoniojr* and run sudo ./install_programs to install all programs.

# Based on...
https://github.com/helmuthdu/aui ... [the master]
http://www.tecmint.com/install-cinnamon-desktop-in-arch-linux/
http://lifehacker.com/5680453/build-a-killer-customized-arch-linux-installation-and-learn-all-about-linux-in-the-process
http://www.linuxveda.com/2015/04/20/arch-linux-tutorial-manual/
http://www.evolutionlinux.com/
https://wiki.debian.org/DebianInstaller/GUI
https://wiki.archlinux.org/index.php/Archboot
https://projects.archlinux.org/archboot.git/
https://wiki.archlinux.org/index.php/Archiso

# TODO
ip address in network manager applet using nmcli.
