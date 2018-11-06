#! /bin/sh
yum install -y epel-release gcc gcc-c++
yum install -y ncurses-devel libaio-devel cmake
cd /usr/local/src/
wget http://mirrors.163.com/mysql/Downloads/MySQL-5.5/mysql-5.5.62.tar.gz
[ $? -eq 0 ]|| exit 1
tar zxf mysql-5.5.62.tar.gz
cd mysql-5.5.62
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.5.62 \
-DMYSQL_DATADIR=/usr/local/mysql-5.5.62/data \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DEXTRA_CHARSETS=gbl,gb2312,utf8,ascii \
-DENABLD_LOCAL_INFILE=ON \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_EXAMPLE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FAST_MUTEXES=1 \
-DWITH_ZLIB=bundled \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_READLINE=1 \
-DWITH_EMBEDDER_SERVER=1 \
-DWITH_DEBUG=0
make && make install
ln -s /usr/local/mysql-5.5.62/ /usr/local/mysql
mkdir /data/mysql/3306/data/ -p
useradd mysql -M -s /sbin/nologin
cd /usr/local/mysql
./scripts/mysql_install_db --user=mysql --group=mysql --datadir=/data/mysql/3306/data/
chown -R mysql.mysql /data/mysql/
cp support-files/mysql.server /etc/init.d/mysqld
/bin/cp support-files/my-medium.cnf /etc/my.cnf 
chmod 755 /etc/init.d/mysqld 
sed -i '46c basedir=/usr/local/mysql' /etc/init.d/mysqld
sed -i '47c datadir=/data/mysql/3306/data' /etc/init.d/mysqld
