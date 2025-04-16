#!/bin/bash
SERVER_DETAILS=/u01/app/oracle/newmiddleware/devops/scripts/server_list
MAIL_FILE=mail.txt
TABLE_FILE=/tmp/status
func_sendMail()
{
echo "Mime-Version: 1.0" > $MAIL_FILE
echo "Content-type: text/html; charset="iso-8859-1"" >> $MAIL_FILE
echo "To: oracle@localhost" >> $MAIL_FILE
echo "Subject: Servers Down " >> $MAIL_FILE
echo " " >> $MAIL_FILE
cat $TABLE_FILE >> $MAIL_FILE
cat $MAIL_FILE | /usr/sbin/sendmail -t -F "Servers Alert"
}

func_check_servers()
{
while read info name port
do
if [ -n "$port" ];then
     status=`telnet $name $port < /dev/null 2>/dev/null | grep -w Connected`
     if [ -z "$status" ];then
     echo "$info SHUTDOWN" >> $TABLE_FILE
     else
     echo "$info RUNNING" >> $TABLE_FILE
     fi
 else
   echo "$info" >> $TABLE_FILE
fi
done < "$SERVER_DETAILS"
}
rm $TABLE_FILE 2>/dev/null

echo 'Server Status' >> $TABLE_FILE
func_check_servers
send_mail_flag=`grep "SHUTDOWN" $TABLE_FILE | wc -l`
if [ "$send_mail_flag" -gt 0 ];then
 func_sendMail
fi

