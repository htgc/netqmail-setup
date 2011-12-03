#!/bin/sh

if ! [ -d ./package ]; then
    mkdir package
fi
cd package

# check groups
! [ `getent group nofiles`] && groupadd nofiles
! [ `getent group qmail` ] && groupadd qmail

# check users
! [ `getent passwd qmaild` ] && useradd -g nofiles -d /var/qmail -s /sbin/nologin qmaild
! [ `getent passwd qmaill` ] && useradd -g nofiles -d /var/qmail -s /sbin/nologin qmaill
! [ `getent passwd qmailp` ] && useradd -g nofiles -d /var/qmail -s /sbin/nologin qmailp
! [ `getent passwd alias` ] && useradd -g nofiles -d /var/qmail/alias -s /sbin/noligin alias
! [ `getent passwd qmailq` ] && useradd -g qmail -d /var/qmail -s /sbin/nologin qmailq
! [ `getent passwd qmailr` ] && useradd -g qmail -d /var/qmail -s /sbin/nologin qmailr
! [ `getent passwd qmails` ] && useradd -g qmail -d /var/qmail -s /sbin/nologin qmails

# download netqmail-1.06
wget http://qmail.org/netqmail-1.06.tar.gz
tar xvfz netqmail-1.06.tar.gz
rm -f netqmail-1.06.tar.gz
cd netqmail-1.06

# patching 
echo "gcc -O2 -include /usr/include/errno.h" >conf-cc

# make
make setup check

hostname=`hostname`
./config-fast $hostname

exit 0
