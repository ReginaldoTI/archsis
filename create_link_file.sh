#!/bin/bash

HOME_DEVICE="/dev/sda"
HOME_ROOT_MOUNT_POINT="/dev/sda2"
HOME_CRYPT_NAME="cryptsys"
HOME_VG_CREATE_NAME="vgsystem"
KEYFILE=true # use keyfile, if not, you will need to insert twice passwords, one for each encrypted device
KEYFILE_NAME="/run/media/luis/0d101295-902c-4a23-88a8-3143960f764b/keyfile"

# open encrypt disk home
cryptsetup luksOpen $HOME_ROOT_MOUNT_POINT $HOME_CRYPT_NAME

# set key file to home, if it is separated

echo "create ${KEYFILE_NAME}"
dd bs=1024 count=4 if=/dev/urandom of=$KEYFILE_NAME iflag=fullblock
chmod 0400 $KEYFILE_NAME # only root can read
echo "set ${KEYFILE_NAME} to ${HOME_ROOT_MOUNT_POINT}"
cryptsetup luksAddKey $HOME_ROOT_MOUNT_POINT $KEYFILE_NAME

HOME_UUID=$(blkid $HOME_ROOT_MOUNT_POINT -s UUID -o value)

echo "${HOME_VG_CREATE_NAME} UUID=${HOME_UUID} ${KEYFILE_NAME} luks,timeout=05" >> ${MOUNT_POINT}/etc/crypttab
