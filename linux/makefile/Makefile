#################################################
#
# Copyright: (c) 2001-2012 Great ChinArk, Inc. All rights reserved.
#
#################################################
# 
# ƽ̨������Makefile
# 
# @author: sky huang
# @date: 2012-10-29
# @current version: 0.1.0
# @change list:(date|action<create,modify>|programer|version|[change log])
#			   2012-10-25|create|sky huang|0.0.1| 
#			   2012-10-29|modify|sky huang|0.1.0|add tape controller src
#################################################
Target=drc_server
DVR_SERVER=dvr_server
CC=g++
CCXXFLAG=-I. -I/usr/include/drcplatform -I/usr/include -I/usr/include/mysql -I./dvr -DDRC_DEBUG -DLINUX
LD=-lIce -lIceUtil -L/usr/lib64/mysql -lmysqlclient -lcurl -L/lib/ /lib/DRCPlatform.a
DVR_LIBS=-lhcnetsdk -lpthread

SRC=DRCServer.cpp service.cpp TaskControlI.cpp DVRControlI.cpp dvr/DataTrans.cpp dvr/DvrClient.cpp \
	lib/ServerUtil.cpp Archive/ArchiveController.cpp Archive/DVRAlarmArchiveController.cpp Archive/DVRFullArchiveController.cpp \
	Archive/DVRPackageArchiveController.cpp Archive/RecyclebinArchiveController.cpp dvr/AXIS_CurlUTIL.cpp dvr/AXIS_Task.cpp \
	tape/TapeController.cpp tape/TapeTaskDispatcher.cpp tape/TapeControlI.cpp fs/FileTapeBKRSController.cpp \
	log/JobLogUpdater.cpp log/SystemLogUpdater.cpp ClientCleaner.cpp
INC=service.h TaskControlI.h DVRControlI.h include/public.h dvr/DvrClient.h dvr/DataTrans.h \
	lib/ServerUtil.h Archive/ArchiveController.h Archive/DVRAlarmArchiveController.h Archive/DVRFullArchiveController.h \
	Archive/DVRPackageArchiveController.h Archive/RecyclebinArchiveController.h dvr/AXIS_CurlUTIL.h \
	dvr/AXIS_Task.h fs/FileTapeBKRSController.h log/JobLogUpdater.h log/SystemLogUpdater.h ClientCleaner.h
OBJ=DRCServer.o service.o TaskControlI.o DVRControlI.o DvrClient.o DataTrans.o ServerUtil.o ArchiveController.o \
	DVRAlarmArchiveController.o DVRFullArchiveController.o DVRPackageArchiveController.o RecyclebinArchiveController.o \
	AXIS_CurlUTIL.o AXIS_Task.o TapeController.o TapeTaskDispatcher.o TapeControlI.o FileTapeBKRSController.o \
	JobLogUpdater.o SystemLogUpdater.o ClientCleaner.o
# dvr src
DVR_SRC=dvr/DeviceCFG.cpp dvr/DeviceOperate.cpp dvr/PlatformLink.cpp dvr/TaskOperate.cpp dvr/DvrServer.cpp 
DVR_INC=dvr/DeviceCFG.h dvr/DeviceOperate.h dvr/PlatformLink.h dvr/TaskOperate.h 
DVR_OBJ=DeviceCFG.o DeviceOperate.o TaskOperate.o PlatformLink.o DvrServer.o 


all:$(Target)
$(Target):$(OBJ)
	$(CC) -o $(Target) $(OBJ) $(LD)
$(OBJ):$(SRC)
	$(CC) -c $(SRC) $(CCXXFLAG)

clean:
	rm -rf *.o $(Target)
