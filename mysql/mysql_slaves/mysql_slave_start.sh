#! /bin/sh
port=3307
mysql_user="root"
mysql_pwd="123456"
CmdPath="/application/mysql/bin"
mysql_sock="/data/${port}/mysql.sock"
function_start_mysql()
{
  if [ ! -e "$mysql_sock" ];then
     printf "Starting MySQL...\n"
     /bin/sh ${CmdPath}/mysqld_safe --defaults-file=/data/${port}/my.cnf 2>&1 >/dev/null &
  else
     printf "MySQL is running..\n"
     exit
  fi
}
function_stop_mysql()
{
  if [ ! -e "$mysql_sock" ];then
     printf "MySQL is stopped..\n"
     exit
  else 
     printf "Stopping MySQL...\n"
     ${CmdPath}/mysqladmin -u ${mysql_user} -p${mysql_pwd} -S /data/${port}/mysql.sock shutdown
  fi
}
case $1 in
start)
    function_start_mysql
;;
stop)
    function_stop_mysql
;;
*)
  printf"Usage: /data/${port}/mysql {start|stop}\n"
esac
