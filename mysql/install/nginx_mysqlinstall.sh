#! /bin/sh
yum install -y wget
[ ! -d /application ] && mkdir /application
cd /usr/local/src/
wget http://ftp.ntu.edu.tw/pub/MySQL/Downloads/MySQL-5.5/mysql-5.5.61-linux-glibc2.12-i686.tar.gz
tar zxf mysql-5.5.61-linux-glibc2.12-i686.tar.gz
mv mysql-5.5.61-linux-glibc2.12-i686 /application/mysql-5.5.61
ln -s /application/mysql-5.5.61 /application/mysql
cd /application/mysql
useradd mysql -s /sbin/nologin -M
chown -R mysql.mysql /application/mysql-5.5.61
/application/mysql/scripts/mysql_install_db --basedir=/application/mysql --datadir=/application/mysql/data --user=mysql
cp support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
sed -i 's#/usr/local/mysql#/application/mysql#g' /application/mysql/bin/mysqld_safe /etc/init.d/mysqld
