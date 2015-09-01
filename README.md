# archsis

## Arch Simple Install Script

### download everything / baixe todos os arquivos
wget https://github.com/luisantoniojr/archsis/tarball/master -O - | tar xz

or

### Cloning...
git clone https://github.com/luisantoniojr/archsis.git

* WARNING!!!
Check setup file for all configurations! Otherwise you can lost your data!

+ AUTOMATIC_IP, determine fixed address
+ SEPARATE_HOME, create home directory on separate disk
+ INSTALL_VIRTUALBOX, install virtualbox on host, not on guest system
+ INSTALL_SAMBA, install and configure SAMBA.
+ INSTALL_DOCKER, install docker.

First run ./install, to install arch O.S
Then reboot
Enter in directory luisantoniojr* and run sudo ./install_programs to install all programs.

### Based on...
https://github.com/helmuthdu/aui ... [the master]
http://www.tecmint.com/install-cinnamon-desktop-in-arch-linux/
http://lifehacker.com/5680453/build-a-killer-customized-arch-linux-installation-and-learn-all-about-linux-in-the-process
http://www.linuxveda.com/2015/04/20/arch-linux-tutorial-manual/
http://www.evolutionlinux.com/
https://wiki.debian.org/DebianInstaller/GUI
https://wiki.archlinux.org/index.php/Archboot
https://projects.archlinux.org/archboot.git/
https://wiki.archlinux.org/index.php/Archiso