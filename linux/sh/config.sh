#!/bin/bash
#####
##############################################################
##
##  Copyright: (c) 2014-2016 Capsheaf, Inc. All rights reserved.
##
##############################################################
## Script for Capsheaf Server auto-config
## version 2.0.0
## 2016-07-13
## JustNanf
## 
## @change list:(date|action<create,modify>|programer|version|[change log])
##			   2016-07-13|create|JustNanf|2.0.1| 
#####

CapsheafInstallTempValue=`cat version | awk -F"-" '{print $2}'`
CapsheafInstallTempValue=${CapsheafInstallTempValue:0:1}
if [[ $CapsheafInstallTempValue == "0" ]];then
	CapsheafInstallTempValue=`cat version | awk -F"-" '{print $2}'`
	Major_Version=${CapsheafInstallTempValue:1:1}
else
	CapsheafInstallTempValue=`cat version | awk -F"-" '{print $2}'`
	Major_Version=${CapsheafInstallTempValue:0:2}
fi
#echo $Major_Version

CapsheafInstallTempValue=`cat version | awk -F"-" '{print $2}'`
CapsheafInstallTempValue=${CapsheafInstallTempValue:2:1}
if [[ $CapsheafInstallTempValue == "0" ]];then
	CapsheafInstallTempValue=`cat version | awk -F"-" '{print $2}'`
	Minor_Version=${CapsheafInstallTempValue:3:1}
else
	CapsheafInstallTempValue=`cat version | awk -F"-" '{print $2}'`
	Minor_Version=${CapsheafInstallTempValue:2:2}
fi
#echo $Minor_Version
echo 
echo "ZBJ Deployer (Kernel 6/Capsheaf-general) $Major_Version.$Minor_Version"
echo "Copyright (C) 2014 Sichuan Capsheaf, Inc." 

CONFIG_PATH=/etc/chinark/server

#config base info
echo -ne "base info config       ... "
CAPSHEAF_WEB_SERVICE_IP=`cat config | awk '/webServiceIp/{print $3}'`
CAPSHEAF_WEB_SERVICE_PORT=`cat config | awk '/webServicePort/{print $3}'`
CAPSHEAF_DATA_CONTROL_PORT=`cat config | awk '/dataControlPort/{print $3}'`
rm -fr /var/www/html/chinark/lib/FBRSConfig.php
rm -fr /var/www/html/conf/FBRSConfig.php
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/FBRSConfig.c.i.php /var/www/html/chinark/lib/FBRSConfig.php
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/FBRSConfig.c.php   /var/www/html/conf/FBRSConfig.php
chmod 755 /var/www/html/chinark/lib/FBRSConfig.php
chmod 755 /var/www/html/conf/FBRSConfig.php
chown nobody:nginx /var/www/html/chinark/lib/FBRSConfig.php
chown nobody:nginx /var/www/html/conf/FBRSConfig.php
sed -i "s/webServiceIp/$CAPSHEAF_WEB_SERVICE_IP/g"          /var/www/html/chinark/lib/FBRSConfig.php
sed -i "s/webServicePort/$CAPSHEAF_WEB_SERVICE_PORT/g"      /var/www/html/chinark/lib/FBRSConfig.php
sed -i "s/dataControlPort/$CAPSHEAF_DATA_CONTROL_PORT/g"    /var/www/html/chinark/lib/FBRSConfig.php
sed -i "s/webServiceIp/$CAPSHEAF_WEB_SERVICE_IP/g"          /var/www/html/conf/FBRSConfig.php
sed -i "s/webServicePort/$CAPSHEAF_WEB_SERVICE_PORT/g"      /var/www/html/conf/FBRSConfig.php
sed -i "s/dataControlPort/$CAPSHEAF_DATA_CONTROL_PORT/g"    /var/www/html/conf/FBRSConfig.php
echo "ok!"

#config deployment info
# TDRM (true)  : the traditional disaster recovery machine
# MYDRC(false) : my disaster recovery center
echo -ne "deployment info config ... "
CAPSHEAF_DEPLOYMENT_MODEL=`cat config | awk '/deploymentModel/{print $3}'`
rm -fr /var/www/html/chinark/lib/version.php
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/version.php /var/www/html/chinark/lib/version.php
chmod 755 /var/www/html/chinark/lib/version.php
chown nobody:nginx /var/www/html/chinark/lib/version.php
if [ "$CAPSHEAF_DEPLOYMENT_MODEL" = "MYDRC" ]
then
    CAPSHEAF_DEPLOYMENT_MODEL=false
else
    CAPSHEAF_DEPLOYMENT_MODEL=true
fi

sed -i "s/deploymentModel/$CAPSHEAF_DEPLOYMENT_MODEL/g"    /var/www/html/chinark/lib/version.php
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/version /var/www/html/version
Capsheaf_Version=`cat /root/Capsheaf-Server-$Major_Version.$Minor_Version/version`
echo $Capsheaf_Version
sed -i "s/capsheafServerVersion/'v2.0 $Capsheaf_Version'/g"    /var/www/html/chinark/lib/version.php
echo "ok!"


#config module info
echo -ne "module info config     ... "
rm -fr /var/www/html/app/stage2.js
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/stage2.js /var/www/html/app/stage2.js
chmod 755 /var/www/html/app/stage2.js
chown nobody:nginx /var/www/html/app/stage2.js
sed -i "s/deploymentModel/$CAPSHEAF_DEPLOYMENT_MODEL/g"    /var/www/html/app/stage2.js
CAPSHEAF_OS_MODULE=`cat config | awk '/OSModule/{print $3}'`
CAPSHEAF_FS_MODULE=`cat config | awk '/FSModule/{print $3}'`
CAPSHEAF_MYSQL_MODULE=`cat config | awk '/MysqlModule/{print $3}'`
CAPSHEAF_ORACLE_MODULE=`cat config | awk '/OracleModule/{print $3}'`
CAPSHEAF_SQLSERVER_MODULE=`cat config | awk '/SqlserverModule/{print $3}'`
CAPSHEAF_HA_MODULE=`cat config | awk '/HAModule/{print $3}'`
CAPSHEAF_VOLCDP_MODULE=`cat config | awk '/volCDPModule/{print $3}'`
CAPSHEAF_VOLREALTIME_MODULE=`cat config | awk '/volRealTimeModule/{print $3}'`
CAPSHEAF_VM_MODULE=`cat config | awk '/VMModule/{print $3}'`
CAPSHEAF_VIDEO_MODULE=`cat config | awk '/videoModule/{print $3}'`
CAPSHEAF_DATADESTORY_MODULE=`cat config | awk '/dataDestoryModule/{print $3}'`
CAPSHEAF_OSQUICKDEPLOY_MODULE=`cat config | awk '/OSQuickDeployModule/{print $3}'`
sed -i "s/OSModule/$CAPSHEAF_OS_MODULE/g"                   /var/www/html/app/stage2.js
sed -i "s/FSModule/$CAPSHEAF_FS_MODULE/g"                   /var/www/html/app/stage2.js
sed -i "s/MysqlModule/$CAPSHEAF_MYSQL_MODULE/g"             /var/www/html/app/stage2.js
sed -i "s/OracleModule/$CAPSHEAF_ORACLE_MODULE/g"           /var/www/html/app/stage2.js
sed -i "s/SqlserverModule/$CAPSHEAF_SQLSERVER_MODULE/g"     /var/www/html/app/stage2.js
sed -i "s/HAModule/$CAPSHEAF_HA_MODULE/g"                   /var/www/html/app/stage2.js
sed -i "s/volCDPModule/$CAPSHEAF_VOLCDP_MODULE/g"           /var/www/html/app/stage2.js
sed -i "s/volRealTimeModule/$CAPSHEAF_VOLREALTIME_MODULE/g" /var/www/html/app/stage2.js
sed -i "s/VMModule/$CAPSHEAF_VM_MODULE/g"                   /var/www/html/app/stage2.js
sed -i "s/videoModule/$CAPSHEAF_VIDEO_MODULE/g"             /var/www/html/app/stage2.js
sed -i "s/dataDestoryModule/$CAPSHEAF_DATADESTORY_MODULE/g" /var/www/html/app/stage2.js
sed -i "s/OSQuickDeployModule/$CAPSHEAF_OSQUICKDEPLOY_MODULE/g" /var/www/html/app/stage2.js
echo "ok!"

#config trans info
echo -ne "trans info config      ... "
rm -fr /etc/vsftpd/vsftpd.conf
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/vsftpd.conf /etc/vsftpd/vsftpd.conf
chmod 755 /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_address/pasv_address=$CAPSHEAF_WEB_SERVICE_IP/g" /etc/vsftpd/vsftpd.conf
CAPSHEAF_PASV_ENABLE=`cat config | awk '/pasv_enable/{print $3}'`
CAPSHEAF_PASV_ADDR_RESOLVE=`cat config | awk '/pasv_addr_resolve/{print $3}'`
CAPSHEAF_PASV_MIN_PORT=`cat config | awk '/pasv_min_port/{print $3}'`
CAPSHEAF_PASV_MAX_PORT=`cat config | awk '/pasv_max_port/{print $3}'`
sed -i "s/pasv_enable/pasv_enable=$CAPSHEAF_PASV_ENABLE/g" 					 /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_addr_resolve/pasv_addr_resolve=$CAPSHEAF_PASV_ADDR_RESOLVE/g" /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_min_port/pasv_min_port=$CAPSHEAF_PASV_MIN_PORT/g" 			 /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_max_port/pasv_max_port=$CAPSHEAF_PASV_MAX_PORT/g" 			 /etc/vsftpd/vsftpd.conf
echo "ok!"
service vsftpd restart &>/dev/null

#config dhcp
echo -ne "dhcpd info config      ... "
rm -fr /etc/dhcp/dhcpd.conf
rm -fr /var/lib/tftpboot/pxelinux.cfg/default
rm -fr /var/lib/tftpboot/pxelinux.cfg/deploy.conf
rm -fr /var/lib/tftpboot/pxelinux.cfg/recover.conf
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/dhcpd.conf	 /etc/dhcp/dhcpd.conf
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/default 	 /var/lib/tftpboot/pxelinux.cfg/default
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/deploy.conf  /var/lib/tftpboot/pxelinux.cfg/deploy.conf
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/recover.conf /var/lib/tftpboot/pxelinux.cfg/recover.conf
chmod 755 /etc/dhcp/dhcpd.conf
chmod 755 /var/lib/tftpboot/pxelinux.cfg/default
chmod 755 /var/lib/tftpboot/pxelinux.cfg/deploy.conf
chmod 755 /var/lib/tftpboot/pxelinux.cfg/recover.conf
CAPSHEAF_DHCP_SUBNET=`cat config | awk '/dhcp_subnet/{print $3}'`
CAPSHEAF_DHCP_NETMASK=`cat config | awk '/dhcp_netmask/{print $3}'`
CAPSHEAF_DHCP_RANGE_FROM=`cat config | awk '/dhcp_rangeFrom/{print $3}'`
CAPSHEAF_DHCP_RANGE_TO=`cat config | awk '/dhcp_rangeTo/{print $3}'`
sed -i "s/dhcp_subnet/$CAPSHEAF_DHCP_SUBNET/g" 			/etc/dhcp/dhcpd.conf
sed -i "s/dhcp_netmask/$CAPSHEAF_DHCP_NETMASK/g" 		/etc/dhcp/dhcpd.conf
sed -i "s/dhcp_rangeFrom/$CAPSHEAF_DHCP_RANGE_FROM/g" 	/etc/dhcp/dhcpd.conf
sed -i "s/dhcp_rangeTo/$CAPSHEAF_DHCP_RANGE_TO/g" 		/etc/dhcp/dhcpd.conf
sed -i "s/webServiceIp/$CAPSHEAF_WEB_SERVICE_IP/g" 		/var/lib/tftpboot/pxelinux.cfg/default
sed -i "s/webServiceIp/$CAPSHEAF_WEB_SERVICE_IP/g" 		/var/lib/tftpboot/pxelinux.cfg/deploy.conf
sed -i "s/webServiceIp/$CAPSHEAF_WEB_SERVICE_IP/g" 		/var/lib/tftpboot/pxelinux.cfg/recover.conf
echo "ok!"
service dhcpd restart &>/dev/null
service xinetd restart &>/dev/null

#error code fix for php_screw
rm -fr /var/www/html/SQLServerController/mssqlcontroller/SQ_GlobalError.php
cp /root/Capsheaf-Server-$Major_Version.$Minor_Version/configData/SQ_GlobalError.php /var/www/html/SQLServerController/mssqlcontroller/SQ_GlobalError.php
chmod 755 /var/www/html/SQLServerController/mssqlcontroller/SQ_GlobalError.php
chown nobody:nginx /var/www/html/SQLServerController/mssqlcontroller/SQ_GlobalError.php


# create config path
if [ ! -d $CONFIG_PATH ]
then 
		mkdir -p $CONFIG_PATH
fi
	
#if smscat work localy, need ssh localhost without username and password 
echo "Config ssh keygen"

rm -f capsheaf.rsa capsheaf.rsa.pub
ssh-keygen -f capsheaf.rsa -t rsa -N ''

if [ ! -d ~/.ssh/ ]
then
        mkdir ~/.ssh/
        touch ~/.ssh/authorized_keys
fi
cat capsheaf.rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys

cp -f capsheaf.rsa $CONFIG_PATH/capsheaf.rsa
cp -f capsheaf.rsa.pub $CONFIG_PATH/capsheaf.rsa.pub
chmod 755 $CONFIG_PATH/capsheaf.rsa
chmod 755 $CONFIG_PATH/capsheaf.rsa.pub
mv -f capsheaf.rsa ~/.ssh/id_rsa
mv -f capsheaf.rsa.pub ~/.ssh/id_rsa.pub

echo "complete, success!"
echo





