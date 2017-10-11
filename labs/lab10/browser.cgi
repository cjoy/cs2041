#!/bin/sh


# print HTTP header
# its best to print the header ASAP because 
# debugging is hard if an error stops a valid header being printed

echo Content-type: text/html
echo

# print page content

cat <<eof
<!DOCTYPE html>
<html lang="en">
<head>
<title>Browser IP, Host and User Agent</title>
</head>
<body>
eof

IP=`env|sed 's/&/\&amp;/;s/</\&lt;/g;s/>/\&gt;/g'|egrep "REMOTE_ADDR"|cut -d'=' -f2`
ID=`env|sed 's/&/\&amp;/;s/</\&lt;/g;s/>/\&gt;/g'|egrep "HTTP_USER_AGENT"|cut -d'=' -f2`
HOST=`host $IP | cut -d' ' -f5|sed 's/.$//g'`



echo "Your browser is running at IP address: <b>$IP</b>"
echo "<p>Your browser is running on hostname: <b>$HOST</b></p>"
echo "<p>Your browser identifies as: <b>$ID</b></p>"

cat <<eof
</body>
</html>
eof
