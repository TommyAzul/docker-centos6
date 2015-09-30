# config_db.sh
# note that by default we do not need a password to connect to
# mysql as root
/etc/init.d/mysqld start
mysqladmin -u root password 'root'
mysql -u root -proot -e "CREATE DATABASE testapp"
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root'; FLUSH PRIVILEGES;"
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root'; FLUSH PRIVILEGES;"
mysql -u root -proot -e "SELECT user, host FROM mysql.user;"
