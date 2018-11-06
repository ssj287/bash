#! /bin/sh
PORT=$1
WORK_PATH='/usr/local/mysql_slaves'
function install_mysql()
{
   cd /usr/local/mysql
   ./scripts/mysql_install_db --user=mysql --group=mysql --datadir=/data/mysql/${PORT}/data/
   if [ -f $WORK_PATH/my.cnf ];then
     cp $WORK_PATH/my.cnf /data/mysql/${PORT}/my.cnf
     sed -i "s/3306/${PORT}/" /data/mysql/${PORT}/my.cnf
     sed -i "s/mysql_3306/mysql_${PORT}/" /data/mysql/${PORT}/my.cnf
     touch /data/mysql/${PORT}/mysql_${PORT}.err
   else
     echo "安装目录my.cnf文件不存在" && exit 1
   fi 
   if [ -f $WORK_PATH/mysqld ];then
     cp $WORK_PATH/mysqld /data/mysql/${PORT}/mysqld
     sed -i "s/3306/${PORT}/" /data/mysql/${PORT}/mysqld
     chmod u+x /data/mysql/${PORT}/mysqld
   else
     echo "启动文件mysqld不存在" && exit 1
   fi
   chown -R mysql.mysql /data/mysql
}
function env(){
if [ `pwd` == $WORK_PATH ];then
  echo "环境配置成功."
else
  echo "你应该将本安装文件夹移动到/usr/local/mysql_slaves目录下" && exit 1
fi
[ -L /usr/local/mysql ] || exit 1
[ -d /data/mysql/${PORT} ] && rm -rf /data/mysql/${PORT}
}
function password(){
  /data/mysql/${PORT}/mysqld start
  read -s -p "请输入密码:" va1
  echo ""
  read -s -p "请在输入一次密码:" va2
  echo ""
  if [ $va1 == $va2 ];then
     /usr/local/mysql/bin/mysqladmin -uroot -S /data/mysql/${PORT}/mysql.sock password $va1
     sed -i "s/123456/${va1}/" /data/mysql/${PORT}/mysqld
  else
    echo "错误!两次密码输入不一致" && exit 1
  fi
}
case $PORT in
[1-9]*)
   env
   install_mysql
   password
   if [ $? -eq 0 ];then 
    echo "安装成功"
   fi
;;
*)
  printf "Useage:$0 + PORT\n" 
;;
esac
