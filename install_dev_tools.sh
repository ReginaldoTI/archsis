#!/bin/bash

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

###################
# developer tools #
###################

# package_install "nodejs npm"
package_install "jre8-openjdk jdk8-openjdk openjdk8-doc"
package_install "readline ncurses lib32-readline lib32-ncurses"
package_install "freetds unixodbc"
package_install "meld"
aur_package_install "sublime-text-dev"

# ruby on rails

# RVM

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby
curl -sSL https://get.rvm.io | bash -s stable --rails
source /home/luis/.rvm/scripts/rvm

# NVM

wget https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh

# postgresql

# mysql

# mongodb

# sqlite
package_install "sqlite sqliteman"
