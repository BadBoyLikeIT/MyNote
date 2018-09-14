#!/bin/bash
#####
##############################################################
##
##  Copyright: (c) 2001-2012 Great Capsheaf, Inc. All rights reserved.
##
##############################################################
## Script for Capsheaf DRC Platform Server pf.ui.fsdb auto-deployment
## version 2.0.1
## 2012-07-13
## Sky Huang, Jeff Zhou
## 
## @change list:(date|action<create,modify>|programer|version|[change log])
##			   2012-07-13|create|sky huang|2.0.1| 
#####

CapsheafInstallTempValue=`cat ../version | awk -F"-" '{print $2}'`
CapsheafInstallTempValue=${CapsheafInstallTempValue:0:1}
if [[ $CapsheafInstallTempValue == "0" ]];then
	CapsheafInstallTempValue=`cat ../version | awk -F"-" '{print $2}'`
	Major_Version=${CapsheafInstallTempValue:1:1}
else
	CapsheafInstallTempValue=`cat ../version | awk -F"-" '{print $2}'`
	Major_Version=${CapsheafInstallTempValue:0:2}
fi
#echo $Major_Version

CapsheafInstallTempValue=`cat ../version | awk -F"-" '{print $2}'`
CapsheafInstallTempValue=${CapsheafInstallTempValue:2:1}
if [[ $CapsheafInstallTempValue == "0" ]];then
	CapsheafInstallTempValue=`cat ../version | awk -F"-" '{print $2}'`
	Minor_Version=${CapsheafInstallTempValue:3:1}
else
	CapsheafInstallTempValue=`cat ../version | awk -F"-" '{print $2}'`
	Minor_Version=${CapsheafInstallTempValue:2:2}
fi
#echo $Minor_Version

INSTALL_PATH=/usr/local/chinark
SYS_LIB_PATH=/usr/lib
PHP_INC_PATH=inc
BIN_PATH=bin
LIB_PATH=lib
CONF_PATH=conf
SCRIPT_PATH=script
SERVER_SYS=
CONFIG_PATH=/etc/chinark/server
PLATFORM_SERVER_EXECUTE=drc_server
DVR_SERVER_EXECUTE=dvr_server
DVS_SERVER_EXECUTE=dvs_server
PLATFOR_CONFIG=config.server

DVR_LIBHCNETSDK_SO=libhcnetsdk.so
DVR_LIBHPR_SO=libhpr.so
DVS_LIBHHDECODER_A=libHHDecoder.a
DVS_LIBHHNET_A=libHHNet.a
ICE_PHP_SO=IcePHP.so

# packages needed to install
DB53=db53-5.3.21-1ice.el6.x86_64.rpm
DB53_UTILS=db53-utils-5.3.21-1ice.el6.x86_64.rpm
DB53_DEVELS=db53-devel-5.3.21-1ice.el6.x86_64.rpm
ICE=ice-3.5.1-1.el6.noarch.rpm
ICE_LIBS=ice-libs-3.5.1-1.el6.x86_64.rpm
ICE_UTILS=ice-utils-3.5.1-1.el6.x86_64.rpm
ICE_MCPP_DEVEL=mcpp-devel-2.7.2-2ice.el6.x86_64.rpm
ICE_CPP_DEVEL=ice-c++-devel-3.5.1-1.el6.x86_64.rpm
ICE_PHP=ice-php-3.5.1-1.el6.x86_64.rpm
ICE_PHP_DEVEL=ice-php-devel-3.5.1-1.el6.x86_64.rpm
ICE_SERVERS=ice-servers-3.5.1-1.el6.x86_64.rpm
#ICE_SQLDB=ice-sqldb-3.4.2-1.rhel6.x86_64.rpm

# dvr server packages needed to install
GLIBC_I686=glibc-2.12-1.47.el6.i686.rpm
GLIBC_DEVEL_I686=glibc-devel-2.12-1.47.el6.i686.rpm
GLIBC_X64=glibc-2.12-1.47.el6.x86_64.rpm
GLIBC_DEVEL_X64=glibc-devel-2.12-1.47.el6.x86_64.rpm
LIB_STDCPP_I686=libstdc++-4.4.6-3.el6.i686.rpm
LIB_STDCPP_DEVEL_I686=libstdc++-devel-4.4.6-3.el6.i686.rpm
LIB_UUID_I686=libuuid-2.17.2-12.4.el6.i686.rpm
LIB_UUID_DEVEL_I686=libuuid-devel-2.17.2-12.4.el6.i686.rpm

##
# check if the file is exist and do copy 
#
# $1 source file
# $2 target file
#
##
check_file_and_copy()
{
	if [ -e $2 ]
	then 
		rm -rf $2
	fi
	cp -rf $1 $2
	echo -ne "."
}

check_dir_and_copy()
{
	if [ -d $2 ]
	then 
		rm -rf $2
	fi
	cp -rf $1 $2
	echo -ne "."
}


check_and_install_package()
{
	rpm -qa|grep $1 >  /dev/null 2>&1
	if [ $? -ne 0 ]
	then 
		# shift out the first param
		shift 1
		rpm -ivh $* > /dev/null 2>&1
	fi
	echo -ne "."
}

# detected the essential environment
detected_environment()
{
	# detect OS Environment
	#lsb_release -d|grep "CentOS">/dev/null 2>&1
	#echo -ne "detecte your operating system...."
	#if [ $? -ne 0 ]
	#then
	#	echo "failed!"
	#	echo "this version only support CentOS 6.2 64bit\n"
	#	echo -n "your system is "
	#	lsb_release -d
	#fi
	#echo "ok"
	
	# detect php 
	echo -n "detecting your environment...."
	which php>/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "failed!"
		echo "php isn't installed!!"
		exit 1
	fi
	echo "ok"
     
}

install_nigix_php()
{
    # detect lv: fbrs_lv
    echo -ne "detecte virtual volume : fbrs_lv "
    CDP_LV=`lvs | grep drcvg | awk '/fbrs_lv/{print $1}' 2>&1`
	if [ "$CDP_LV" = "" ]
	then
        clear 
        echo "please create virtual volume : fbrs_lv first! "
        echo "you can call us for help if need"
		exit 0
	fi
    echo "ok"   
	## nginx¡¢php¡¢php-fpm Installation
	echo -ne "Installing NGINX..."
	check_and_install_package "nginx-1.0.12-1" rpm/nginx-1.0.12-1.el6.ngx.x86_64.rpm
	echo "done"
	echo -ne "Installing PHP,FPM..."
	check_and_install_package "php-5.6.28" rpm/php-5.6.28-0.x86_64.rpm
	echo "done"
	# mysql Installation
	echo -ne "Installing MYSQL..."
	check_and_install_package "perl-DBD-MySQL-4.013-3" rpm/perl-DBD-MySQL-4.013-3.el6.x86_64.rpm 
	check_and_install_package "mysql-5.1.52-1" rpm/mysql-5.1.52-1.el6_0.1.x86_64.rpm --force --nodeps
	check_and_install_package "mysql-server-5.1.52-1" rpm/mysql-server-5.1.52-1.el6_0.1.x86_64.rpm
	check_and_install_package "pam_mysql-0.7-0.12.rc1.el6.x86_64" rpm/pam_mysql-0.7-0.12.rc1.el6.x86_64.rpm
	echo "done"
	echo -ne "Installing VSFTPD..."
	check_and_install_package "vsftpd-2.2.2-6" rpm/vsftpd-2.2.2-6.el6_0.1.x86_64.rpm
	echo "done"
	
	## Software Configuration
	echo -ne "Configurating NGINX...\r"
	check_file_and_copy conf/nginx/fastcgi_params /etc/nginx/fastcgi_params
	check_file_and_copy conf/nginx/default.conf /etc/nginx/conf.d/default.conf
	check_file_and_copy conf/nginx/nginx.conf /etc/nginx/nginx.conf
	rm -rf /var/www/html
	rm -rf /usr/share/nginx/html
	mkdir -p /var/www/html
	cp -rf webroot/* /var/www/html
	
	## delete old watch dog script
	rm -f /var/www/html/watch_dog.sh
	cp -rf script/watch_dog.sh /var/www/html
	ln -s /var/www/html /usr/share/nginx/html
	chown -R nobody:nginx /var/www/html
	chmod 777 /var/www/html/conf
	chmod 777 /var/www/html/app/php/systemconfig/alarm_config/alarmConfig.json
	chown nobody:nobody /var/www/html/app/php/systemconfig/alarm_config/alarmConfig.json
	
	echo -ne "\r"
	echo -ne "Configurating NGINX..."
    #DEFAULT_IP=`ifconfig | grep -m 1 -E '\s+inet addr:[0-9\.]+' | cut -d':' -f2 | cut -d' ' -f1`
	#read -p "Please specify the IP address of this server [$DEFAULT_IP]: " NEWIP
	#NEWIP=`echo $NEWIP | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$'`
	#if [ -z $NEWIP ] 
	#then 
	#	NEWIP=$DEFAULT_IP 
	#fi
	#sed -i 's/{ServerIPAddress}/'$NEWIP'/' /var/www/html/conf/FBRSConfig.php
	chkconfig nginx on
	service nginx start >/dev/null 2>&1
	echo "done"
	echo -ne "Configurating PHP,FPM..."
	check_file_and_copy conf/php/php.ini /usr/lib64/php.ini
	check_file_and_copy script/php-fpm /etc/init.d/php-fpm
	chmod +x /etc/init.d/php-fpm
	check_file_and_copy conf/php-fpm/php-fpm.conf /etc/php-fpm.conf
	chkconfig php-fpm on
	service php-fpm start >/dev/null 2>&1
	echo "done"
	cp -f conf/mysql/my.cnf /etc/my.cnf
	chkconfig mysqld on
	service mysqld restart >/dev/null 2>&1
	mysqladmin -u root password 'jcb410' >/dev/null 2>&1
	mysql -uroot -pjcb410 <script/chinark_drc_db.sql >/dev/null 2>&1
	cp -f conf/mysql/my2.cnf /etc/my.cnf
	service mysqld restart
	echo -ne "Configurating MYSQL..."
	echo "done"
	echo -ne "Configurating VSFTPD..."
	cp -f conf/vsftpd/vsftpd.conf /etc/vsftpd
	cp -f conf/vsftpd/vsftpd /etc/pam.d
    mkdir /home/sky
    mount /dev/drcvg/fbrs_lv /home/sky/
    echo "/dev/drcvg/fbrs_lv /home/sky xfs defaults 0 0" >> /etc/fstab 
	useradd -G users,nginx -o -u 99 -s /bin/false -d /home/sky sky >/dev/null 2>&1
	usermod -G nginx nobody >/dev/null 2>&1
	rm -rf /home/sky/*
	mkdir -p /home/sky/admin
	mkdir -p /home/sky/auditauth
	mkdir -p /home/sky/secretauth
	mkdir -p /home/sky/administrator
	chown -R nobody:nginx /home/sky
	chkconfig vsftpd on
	service vsftpd start >/dev/null 2>&1
	echo "done"
	echo -ne "Configurating Miscellaneous..."
	cp -f conf/misc/sudoers /etc/sudoers
	chmod 440 /etc/sudoers
	setenforce 0 >/dev/null 2>&1
	sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
	
	# check whether watchdog is in rc.local or not
	cat /etc/rc.d/rc.local |grep watch_dog
	if [ $? -ne 0 ]
	then 
		echo "nohup /bin/bash /var/www/html/watch_dog.sh >/dev/null 2>&1 &" >>/etc/rc.d/rc.local
	fi
	# check whether php-fpm is in rc.local or not
	cat /etc/rc.d/rc.local |grep php-fpm
	if [ $? -ne 0 ]
	then 
		echo "/etc/init.d/php-fpm restart" >>/etc/rc.d/rc.local
	fi
	
	iptables -I INPUT 1 -p tcp --dport 21 -j ACCEPT
	iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
	service iptables save >/dev/null 2>&1
	echo "done"
	echo -ne "Configurating crontab jobs..."
cat <<EOT >> /etc/crontab
 */30  *  *  *  * root php /var/www/html/app/php/systemconfig/alarm_config/CliWorkThread.php > /dev/null 2>&1
 */30  *  *  *  * root php /var/www/html/app/php/systemconfig/checkJobLog.php > /dev/null 2>&1
 
EOT
	
	echo "done"
}

# install the deps package which is needed by Chinark DRC Platform server
install_dep_package()
{
	# change the current path
	cd ./package/ice
	echo -ne "installing db53 packages ..."
	# install db53 
	check_and_install_package "db53" $DB53
	check_and_install_package "db53-utils" $DB53_UTILS
	check_and_install_package "db53-devel" $DB53_DEVELS
	echo "done"
	
	# install ICE_PACKAGE
	echo -ne "installing ice packages ..."
	check_and_install_package "ice-3" $ICE
	check_and_install_package "ice-utils" $ICE_UTILS $ICE_LIBS
	check_and_install_package "ice-servers" $ICE_SERVERS
	check_and_install_package "ice-sqldb" $ICE_SQLDB
	check_and_install_package "ice-c++" $ICE_CPP_DEVEL
	check_and_install_package "mcpp-devel" $ICE_MCPP_DEVEL
	check_and_install_package "ice-php-3" $ICE_PHP
	check_and_install_package "ice-php-devel" $ICE_PHP_DEVEL
	echo "done"
	# jump into dvr path
	cd ../dvr
	echo -ne "installing dvr packages ..."
	check_and_install_package "glibc-2.12-1.47.el6.i686" $GLIBC_I686
	check_and_install_package "glibc-devel-2.12-1.47.el6.i686" $GLIBC_DEVEL_I686
	check_and_install_package "glibc-2.12-1.47.el6.x86_64" $GLIBC_X64
	check_and_install_package "glibc-devel-2.12-1.47.el6.x86_64" $GLIBC_DEVEL_X64
	check_and_install_package "libstdc++-4.4.6-3.el6.i686" $LIB_STDCPP_I686
	check_and_install_package "libstdc++-devel-4.4.6-3.el6.i686" $LIB_STDCPP_DEVEL_I686
	check_and_install_package "libuuid-2.17.2-12.4.el6.i686" $LIB_UUID_I686
	check_and_install_package "libuuid-devel-2.17.2-12.4.el6.i686" $LIB_UUID_DEVEL_I686
	echo "done"
	cd ../..

}

# this function make sure all path is create before
prepare_install()
{
	echo -ne "preparing install ....\r"
	
	DRC_MYSQL_DIR=/usr/local/mysql

	mkdir -p $DRC_MYSQL_DIR
	ln -s /usr/lib64 $DRC_MYSQL_DIR/lib
	ln -s /usr/include $DRC_MYSQL_DIR/include
	ln -s /usr/bin $DRC_MYSQL_DIR/bin
	ln -s /usr/share $DRC_MYSQL_DIR/share
	
	# create the server's install path
	if [ ! -d $INSTALL_PATH ]
	then 
		mkdir -p $INSTALL_PATH
	fi
	
	if [ ! -d $INSTALL_PATH/$BIN_PATH ]
	then 
		mkdir -p $INSTALL_PATH/$BIN_PATH
	fi
	
	if [ ! -d $INSTALL_PATH/$PHP_INC_PATH ]
	then
		mkdir -p $INSTALL_PATH/$PHP_INC_PATH
	fi
	
	if [ ! -d $INSTALL_PATH/$LIB_PATH ]
	then 
		mkdir -p $INSTALL_PATH/$LIB_PATH
	fi
	
	if [ ! -d $INSTALL_PATH/$SCRIPT_PATH ]
	then
		mkdir -p $INSTALL_PATH/$SCRIPT_PATH
	fi
	
	# create config path
	if [ ! -d $CONFIG_PATH ]
	then 
		mkdir -p $CONFIG_PATH
	fi
	
	echo "preparing install ....done"
}

install_platform_file()
{
	echo -ne "installing platform server ..."
	# copy exe server to bin_path
	check_file_and_copy ./$BIN_PATH/$PLATFORM_SERVER_EXECUTE $INSTALL_PATH/$BIN_PATH/$PLATFORM_SERVER_EXECUTE 
	chmod +x $INSTALL_PATH/$BIN_PATH/$PLATFORM_SERVER_EXECUTE 
	# copy config.server to /etc/chinark/server
	check_file_and_copy ./$CONF_PATH/$PLATFOR_CONFIG $CONFIG_PATH/$PLATFOR_CONFIG
	# copy example mysql script to $INSTALL_PATH/script
	check_file_and_copy ./$SCRIPT_PATH/chinark_drc_db.sql $INSTALL_PATH/$SCRIPT_PATH/mysql_default.sql
	check_file_and_copy ./conf/mysql/my.cnf $INSTALL_PATH/$SCRIPT_PATH/my.cnf
	check_file_and_copy ./conf/mysql/my2.cnf $INSTALL_PATH/$SCRIPT_PATH/my2.cnf
	# copy include files to php inc path
	check_dir_and_copy ./$PHP_INC_PATH $INSTALL_PATH/$PHP_INC_PATH
	# copy dvr dependencies so files to /usr/lib
	check_file_and_copy ./$LIB_PATH/$DVR_LIBHCNETSDK_SO $SYS_LIB_PATH/$DVR_LIBHCNETSDK_SO
	check_file_and_copy ./$LIB_PATH/$DVR_LIBHPR_SO $SYS_LIB_PATH/$DVR_LIBHPR_SO
	check_file_and_copy ./$LIB_PATH/$DVS_LIBHHNET_A $SYS_LIB_PATH/$DVS_LIBHHNET_A
	check_file_and_copy ./$LIB_PATH/$DVS_LIBHHDECODER_A $SYS_LIB_PATH/$DVS_LIBHHDECODER_A
    check_file_and_copy ./$LIB_PATH/$ICE_PHP_SO /usr/lib64/php/modules/IcePHP.so
    check_file_and_copy ./$LIB_PATH/pdo_mysql.so /usr/lib64/php/modules/pdo_mysql.so
    check_file_and_copy ./$LIB_PATH/php_screw.so /usr/lib64/php/modules/php_screw.so
	check_file_and_copy ./$LIB_PATH/ssh2.so /usr/lib64/php/modules/ssh2.so
	
	
	chmod +x /usr/lib64/php/modules/IcePHP.so
    chmod +x /usr/lib64/php/modules/pdo_mysql.so
    chmod +x /usr/lib64/php/modules/php_screw.so
	chmod +x /usr/lib64/php/modules/ssh2.so
	
	echo "done"
}

install_dvr_file()
{
	echo -ne "installing dvr server ..."
	# copy exe dvr_server to bin_path
	check_file_and_copy ./$BIN_PATH/$DVR_SERVER_EXECUTE $INSTALL_PATH/$BIN_PATH/$DVR_SERVER_EXECUTE
	check_file_and_copy ./$BIN_PATH/$DVS_SERVER_EXECUTE $INSTALL_PATH/$BIN_PATH/$DVS_SERVER_EXECUTE
	chmod +x $INSTALL_PATH/$BIN_PATH/$DVR_SERVER_EXECUTE
	chmod +x $INSTALL_PATH/$BIN_PATH/$DVS_SERVER_EXECUTE
	echo -ne "."
	# mount the path and make sure the path mounted when system started	
	mkdir -p /home/sky/DVR_FULL
	mkdir -p /home/sky/DVR_ALARM
	mkdir -p /var/www/html/tempvideo
	chown -R nginx:nobody /var/www/html/tempvideo
	#mount --bind /home/sky /var/www/html/tempvideo
	chown -R nobody:nginx /var/www/html/tempvideo
	echo -ne "."
	cat /etc/rc.d/rc.local|grep tempvideo 1>&2>/dev/null

	#if [ $? -ne 0 ]
	#then 
	#	echo 'mount --bind /home/sky /var/www/html/tempvideo'>>/etc/rc.d/rc.local
	#fi
	touch /usr/local/chinark/bin/config.cnf
	echo "done"
}

install_drc_server()
{
	cat /etc/rc.d/rc.local|grep "iscsi-target" 1>&2>/dev/null
	if [ $? != 0 ]
	then 
		echo '/etc/init.d/iscsi-target start'>>/etc/rc.d/rc.local
	fi
	#/etc/init.d/iscsi-target restart
}

start_drc_service()
{
	nohup /bin/bash /var/www/html/watch_dog.sh >/dev/null 2>&1 &
}

install()
{
	install_nigix_php
	detected_environment
	prepare_install
	install_dep_package
	install_platform_file
	install_drc_server
	start_drc_service
	install_dvr_file
}

uninstall()
{
	echo -n "uninstalling..."
	# stop service 
    WATDOG_PID=`ps -ef | grep watch_dog | awk '/watch_dog/{if(($11 !~ /awk/)&&($8 !~ /grep/))print $2}' | tail -1`
    if [ "$WATDOG_PID" != "" ]
	then
		kill -9 $WATDOG_PID >/dev/null 2>&1
	fi
    WATDOG_PID=`ps -ef | grep watch_dog | awk '/watch_dog/{if(($11 !~ /awk/)&&($8 !~ /grep/))print $2}' | tail -1`
    if [ "$WATDOG_PID" != "" ]
	then
		kill -9 $WATDOG_PID >/dev/null 2>&1
	fi
    
	service php-fpm stop >/dev/null 2>&1
	echo -n "."
	service nginx stop >/dev/null 2>&1
	echo -n "."
	service vsftpd stop >/dev/null 2>&1
	echo -n "." 
	
	# make sure that drc server and dvr server processes isn't running!
	DRC_SERVER_PID=`ps aux|grep drc_ser |awk  '/drc_server/{if($11 !~ /awk/)print $2}' 2>&1`
	DVR_SERVER_PID=`ps aux|grep dvr_ser |awk  '/dvr_server/{if($11 !~ /awk/)print $2}' 2>&1`
	DVS_SERVER_PID=`ps aux|grep dvs_ser |awk  '/dvs_server/{if($11 !~ /awk/)print $2}' 2>&1`
	
	if [ "$DRC_SERVER_PID" = "" ]
	then
		kill -9 $DRC_SERVER_PID >/dev/null 2>&1
	fi
	
	if [ "$DVR_SERVER_PID" = "" ]
	then
		kill -9 $DVR_SERVER_PID >/dev/null 2>&1
	fi
	if [ "$DVS_SERVER_PID" = "" ]
	then
		kill -9 $DVS_SERVER_PID >/dev/null 2>&1
	fi
	echo -n "."
	# remove install file
	rm -rf  $INSTALL_PATH 
	rm -rf  $CONFIG_PATH
	rm -rf  $SYS_LIB_PATH/$DVR_LIBHCNETSDK_SO
	rm -rf  $SYS_LIB_PATH/$DVR_LIBHPR_SO
	rm -rf  $SYS_LIB_PATH/$DVS_LIBHHNET_A
	rm -rf  $SYS_LIB_PATH/$DVS_LIBHHDECODER_A
    
    sed -i "s?/dev/drcvg/fbrs_lv /home/sky ext4 defaults 0 0??g" /etc/rc.d/rc.local
    sed -i "s?nohup /bin/bash /var/www/html/watch_dog.sh >/dev/null 2>&1 &??g" /etc/rc.d/rc.local
    sed -i "s?/etc/init.d/php-fpm restart??g" /etc/rc.d/rc.local
    sed -i "s?/etc/init.d/iscsi-target start??g" /etc/rc.d/rc.local
    
	echo "done"
	
	echo "uninstall successfully! please enter any key to continue!"
	#read NONE
}


echo "ZBJ Deployer (Kernel 6/Capsheaf-general) $Major_Version.$Minor_Version"
echo "Copyright (C) 2012 Sichuan Capsheaf, Inc."
echo

case "$1" in
	install)
		install
		;;
	uninstall)
		uninstall
		;;
	*)
		echo $"Usage: $0 (install|uninstall)";
esac