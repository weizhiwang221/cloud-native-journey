#!/bin/bash
export LANG=en_US.UTF-8
#返回脚本文件存放路径
script_path=$(cd `dirname $0`; pwd)
sys_date=`date +"%Y%m%d%H%M"`
monitor=/etc/profile.d/monitor.sh
monitorlog_path=/var/log/.hist 
user_name=admin
user_passwd='zxcvbnm!@#123'
#判断系统发行版本大版本号，centos 6、centos 7
release_el6=`uname -a|awk '{print $3}'|grep -v grep|grep el6|wc -l`
release_el7=`uname -a|awk '{print $3}'|grep -v grep|grep el7|wc -l`

#判断系统发行版本大版本号，centos 6、centos 7


#系统最大文件打开数
function sys_limits()
{
#修改系统最大文件打开数
limits=`cat /etc/security/limits.conf|grep -v grep|grep -v "^#"|grep -E "65536|65536"|wc -l`
if [ $limits -le 1 ] ;
then
echo -e "\n" >> /etc/security/limits.conf
echo -e "*       soft     nofile  65536" >> /etc/security/limits.conf
echo -e "*       soft     nproc  65536\n" >> /etc/security/limits.conf
echo -e "*       hard     nofile  65536\n" >> /etc/security/limits.conf
echo -e "*       hard     nproc  65536\n" >> /etc/security/limits.conf
wait
sed -i "/ulimit/d" /etc/profile
echo -e "ulimit -n 65536" >> /etc/profile
wait
#Java程序优化---20190904新增
#解决Java程序在Linux上运行虚拟内存耗用大的问题
sed -i '/'MALLOC_ARENA_MAX'/d' /etc/profile
echo -e "export MALLOC_ARENA_MAX=1" >> /etc/profile
wait
source  /etc/profile
echo "系统最大文件打开数修改完成！"
fi
}



function sys_timezone()
{
###检查时区配置
local time_zone=`date -R | awk '{print $6}'`
if [ "$time_zone" = "+0800" ] ;
then
echo ""
 echo -e "系统时区设置正确！\n"
 echo ""
else
 echo ""
 echo -e "\n系统时区设置错误！\n"
 echo -e "开始更改时区设置.........\n"
 sleep 2
 yes|cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
 sleep 2
 ###嵌套if函数 1***
   unset time_zone
   local time_zone=`date -R | awk '{print $6}'`
   if [ "$time_zone" = "+0800" ] ;
   then
   echo -e "\033[32m系统时区更改成功！\n\033[0m"
   #绿色字
   else
   echo -e "\033[31m系统时区更改失败！\n\033[0m"
   #红色字
   exit
   fi
 ###嵌套if函数 1***
fi

}


#内核优化
function kernel_optimize()
{
echo "执行内核优化.........."
#不管参数在不在，先删除，避免重复添加
sed -i '/'fs.file-max'/d' /etc/sysctl.conf 
sed -i '/'net.ipv4.tcp_max_tw_buckets'/d' /etc/sysctl.conf        
sed -i '/'net.ipv4.tcp_max_syn_backlog'/d' /etc/sysctl.conf     
sed -i '/'net.ipv4.tcp_timestamps'/d' /etc/sysctl.conf     
sed -i '/'net.ipv4.ip_local_port_range'/d' /etc/sysctl.conf    
sed -i '/'net.ipv4.tcp_tw_recycle'/d' /etc/sysctl.conf        
sed -i '/'net.ipv4.tcp_tw_reuse'/d' /etc/sysctl.conf 
sed -i '/'net.ipv4.tcp_fin_timeout'/d' /etc/sysctl.conf     
sed -i '/'vm.swappiness'/d' /etc/sysctl.conf
sed -i '/'net.core.netdev_max_backlog'/d' /etc/sysctl.conf     
sed -i '/'net.ipv4.tcp_syn_retries'/d' /etc/sysctl.conf     

wait

#添加内核优化参数
echo -e '
fs.file-max = 999999
net.core.netdev_max_backlog = 8096
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_max_syn_backlog = 10000
net.ipv4.tcp_timestamps = 0
net.ipv4.ip_local_port_range = 1024    65500
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
vm.swappiness = 0 ' >>  /etc/sysctl.conf

echo "------------------------"
sed -i '/'bridge'/d' /etc/rc.local
echo "modprobe bridge" >> /etc/rc.local
modprobe bridge

sysctl -p
echo "------------------------"

}

###调用函数

sys_limits

sys_timezone
kernel_optimize


