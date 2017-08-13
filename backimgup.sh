#!/bin/bash
DROPBOX_DIR="/mnt/backup/$(date +%Y-%m-%d)" #Dropbox上的备份目录
WEB_DATA=/home/wwwroot/default #网站数据存放目录
BAK_DATA=/mnt/backup #本地备份文件存放目录，手动创建

#定义备份文件的名字和旧备份文件（7天前）的名字

WebBak=IFshow_Web_$(date +%Y%m%d).tar.gz
OldWebBak=IFshow_Web_$(date -d -7day +"%Y%m%d").tar.gz

#定义Dropbox旧数据的名字（7天前）
Old_DROPBOX_DIR=/mnt/backup/$(date -d -7day +%Y-%m-%d) #Dropbox上的备份目录

#删除本地旧数据
rm -rf $BAK_DATA/$OldWebBak

#压缩网站数据
cd $WEB_DATA
tar zcf $BAK_DATA/$WebBak ./*

cd /mnt
#开始上传

./dropbox_uploader.sh upload $BAK_DATA/$WebBak $DROPBOX_DIR/$WebBak

#删除远程旧数据
./dropbox_uploader.sh delete $Old_DROPBOX_DIR

echo -e "Backup Done!"
