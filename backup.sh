#!/bin/bash
DROPBOX_DIR="/mnt/backup/$(date +%Y-%m-%d)" #Dropbox上的备份目录
MYSQL_USER="root" #数据库帐号
MYSQL_PASS="y@p#654321" #数据库密码
MYSQL_TABLE="video"   #数据库名称
BAK_DATA=/mnt/backup #本地备份文件存放目录，手动创建


#定义备份文件的名字和旧备份文件（7天前）的名字
DbBak=DB_$(date +"%Y%m%d").tar.gz
OldDbBak=DB_$(date -d -7day +"%Y%m%d").tar.gz

#定义Dropbox旧数据的名字（7天前）
Old_DROPBOX_DIR=/mnt/backup/$(date -d -7day +%Y-%m-%d) #Dropbox上的备份目录

#删除本地旧数据
rm -rf $BAK_DATA/$OldDbBak

cd $BAK_DATA

#使用命令导出SQL数据库,并且按数据库分个压缩

mysqldump --opt -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_TABLE|gzip > $MYSQL_TABLE.sql.gz

#压缩数据库文件合并为一个压缩文件
tar zcf $BAK_DATA/$DbBak $BAK_DATA/*.sql.gz
rm -rf $BAK_DATA/*.sql.gz


cd /mnt/upback
#开始上传
./dropbox_uploader.sh upload $BAK_DATA/$DbBak $DROPBOX_DIR/$DbBak

#删除远程旧数据
./dropbox_uploader.sh delete $Old_DROPBOX_DIR

echo -e "Backup Done!"
