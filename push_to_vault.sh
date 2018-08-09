#!/bin/bash
cat >  /data/original-mail.txt

ID=$(cat /data/original-mail.txt|grep ^Message-ID:|cut -d"<" -f2|cut -d">" -f1)
curl -v -F "ID=$ID"" -F "file=@/data/original-mail.txt" http://bcmail.inapp.com:8000/mail-php/upload.php
sed -e "s/replace_to_email_from_script/"$from"/g" -e "s/replace_this_string_with_ID/"$ID"/g" /var/www/html/mail.php > /var/vmail/tmp/ack_mail.php
/usr/bin/php -f /var/vmail/tmp/ack_mail.php > /data/php-log
