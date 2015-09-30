#!/bin/sh

yum install --enablerepo=remi,remi-php56,epel gcc make php-devel

## get src phalcon
git clone git://github.com/phalcon/cphalcon.git

cd cphalcon/build
chmod 755 ./install
sudo ./install

cat << EOF > /etc/php.d/50-phalcon.ini
extension=phalcon.so

EOF

/etc/init.d/httpd restart

## phalcon devtools
pear config-set preferred_state beta
pear channel-discover pear.phalconphp.com
pear install phalcon/Devtools

