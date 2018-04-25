#!/bin/bash
#####
##############################################################
##
##  Copyright: (c) 2014-2016 Capsheaf, Inc. All rights reserved.
##
##############################################################
## Script for Capsheaf Server auto-install
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

cd /root/Capsheaf-Server-$Major_Version.$Minor_Version/Capsheaf-pf.ui.fsdb
chmod +x ./Capshef-pf.ui.fsdb-install.sh
./Capshef-pf.ui.fsdb-install.sh install

cd /root/Capsheaf-Server-$Major_Version.$Minor_Version/Capsheaf-os.vol.cdp
chmod +x ./Capsheaf-os.vol.cdp-install.sh
./Capsheaf-os.vol.cdp-install.sh install

echo 
echo -ne "depmod "
depmod 2.6.32-431.el6.x86_64
echo "ok!"

echo
echo "install successful!!!"
echo 