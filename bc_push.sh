#!/bin/bash
cat >  /data/original-mail.txt
echo $'\n' >> /data/original-mail.txt

### Collecting the metadata

 sed '/Content-Type:/q' /data/original-mail.txt > /data/meta/meta.txt

 from=$(cat /data/meta/meta.txt|grep ^From:|cut -d"<" -f2|cut -d">" -f1)
 to=$(cat /data/meta/meta.txt|grep ^To:|cut -d"<" -f2|cut -d">" -f1)
 ID=$(cat /data/meta/meta.txt|grep ^Message-ID:|cut -d"<" -f2|cut -d">" -f1|cut -d"@" -f1)
 sub=$(cat /data/meta/meta.txt|grep ^Subject:|cut -d":" -f2|sed -e 's/^[ \t]*//')
 file=$(cat /data/original-mail.txt|grep Content-Disposition:|cut -d"=" -f2|tr -d '"')

### Removing attachment extracted from previous mail

 ls -1 /data/extracted/ > /data/filedel

 for del in `cat /data/filedel`; do
  rm -f /data/extracted/$del
 done

### Renaming the original mail header with ID to push to REST API
 rm /data/extracted/*
 cp /data/original-mail.txt /data/extracted/"$ID"

### Upload full header to REST API

 ls -1 /data/extracted/ > /data/fileup

 for up in `cat /data/fileup`; do
  status=$(curl -v -F "name=$ID" -F "file=@/data/extracted/$up" http://IP:8080/REST)
  txt_id=$(echo "$status"|cut -d',' -f1)
  file_hash=$(echo "$status"|cut -d',' -f2)
 done

### Send ACK mail to original sender

 sed -e "s/replace_to_email_from_script/$from/g" -e "s/replace_this_string_with_ID/$txt_id/g" -e "s/replace_this_string_with_Filename/$file/g" -e "s/replace_this_string_with_Filehash/$file_hash/g" /var/www/html/mail.php > /var/vmail/tmp/ack_mail.php

 /usr/bin/php -f /var/vmail/tmp/ack_mail.php > /data/php-log
