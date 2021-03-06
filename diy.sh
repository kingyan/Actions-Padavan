#!/bin/bash
#=================================================
# https://github.com/kingyan/Actions-Padavan
# Description: DIY script
# Lisence: MIT
# Author: kingyan
#=================================================
cd /opt/rt-n56u/trunk

# 优化编译脚本(删除9-15行)
sed -i '9,15d' build_firmware_modify

# 监测地址优化
sed -i '/di_poll_mode/{s/0/1/g}' user/shared/defaults.c
sed -i '/di_addr0/{s/114.114.114.114/218.2.2.2/g}' user/shared/defaults.c
sed -i '/di_addr1/{s/208.67.222.222/218.4.4.4/g}' user/shared/defaults.c
sed -i '/di_addr2/{s/14.17.42.40/223.5.5.5/g}' user/shared/defaults.c
sed -i '/di_addr3/{s/8.8.8.8/119.29.29.29/g}' user/shared/defaults.c
sed -i '/di_addr4/{s/8.8.4.4/114.114.114.114/g}' user/shared/defaults.c
sed -i '/di_addr5/{s/208.67.220.220/114.114.115.115/g}' user/shared/defaults.c
sed -i '/di_port2/{s/80/53/g}' user/shared/defaults.c

# WAN LED
sed -i '/front_led_wan/{s/2/3/g}' user/shared/defaults.c

# 区域代码
sed -i '/DEF_WLAN_2G_CC/{s/CN/US/g}' user/shared/defaults.h

# NTP 服务器 2
sed -i '/DEF_NTP_SERVER1/{s/2001:470:0:50::2/ntp2.aliyun.com/g}' user/shared/defaults.h

# 修改K2编译文件开始
cp -a configs/boards/PSG1218 configs/boards/K2
sed -i 's/PSG1218/K2/g' configs/boards/K2/board.h
sed -i 's/PSG1218/K2/g' configs/boards/K2/board.mk

cp -f configs/templates/PSG1218.config configs/templates/K2.config
sed -i 's/PSG1218/K2/g' configs/templates/K2.config
cp -f configs/templates/PSG1218_nano.config configs/templates/K2_nano.config
sed -i 's/PSG1218/K2/g' configs/templates/K2_nano.config

sed -i 's/BOARD_PSG1218/BOARD_K2/g' user/rc/detect_internet.c
sed -i 's/BOARD_PSG1218/BOARD_K2/g' user/rc/detect_link.c
sed -i 's/BOARD_PSG1218/BOARD_K2/g' user/rc/net_wan.c
# 修改K2配置文件结束

# MT7615驱动优化(关闭日志)
#sed -i '/Peer\x27s MPFC isn\x27t used\./{s/DBG_LVL_ERROR/DBG_LVL_TRACE/g}' proprietary/rt_wifi/rtpci/5.0.3.0/mt7615/embedded/security/pmf.c

if [ ! -f configs/templates/$TNAME.config ] ; then
    echo "configs/templates/$TNAME.config not found!"
    exit 1
fi
cp -f configs/templates/$TNAME.config .config

if  echo ${TNAME} | grep -qi "nano" ; then
    #====================================================================================#
    #自定义添加其它功能请参考源码configs/templates/目录下的config文件，按照下面的格式添加即可。#
    #sed -i '/自定义项/d' .config                                                         #
    #====================================================================================#
    sed -i '/CONFIG_FIRMWARE_INCLUDE_DOGCOM/d' .config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_MINIEAP/d' .config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_NJIT_CLIENT/d' .config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_VLMCSD/d' .config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_TTYD/d' .config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_SOCAT/d' .config
    sed -i '/CONFIG_FIRMWARE_INCLUDE_SRELAY/d' .config
    #====================================================================================#
    #以下选项是定义你需要的功能（y=集成,n=忽略），重新写入到.config文件。                     #
    #echo "自定义项=y" >> .config                                                         #
    #====================================================================================#
    echo "CONFIG_FIRMWARE_INCLUDE_DOGCOM=n" >> .config
    echo "CONFIG_FIRMWARE_INCLUDE_MINIEAP=n" >> .config
    echo "CONFIG_FIRMWARE_INCLUDE_NJIT_CLIENT=n" >> .config
    echo "CONFIG_FIRMWARE_INCLUDE_VLMCSD=n" >> .config
    echo "CONFIG_FIRMWARE_INCLUDE_TTYD=n" >> .config
    echo "CONFIG_FIRMWARE_INCLUDE_SOCAT=n" >> .config
    echo "CONFIG_FIRMWARE_INCLUDE_SRELAY=n" >> .config
    #====================================================================================#
fi
