#!bin/bash
#Start OC
if [ "${OSNAME}" = "debian" ]; then
       apt-get -y install git
   else
      yum -y install git
      export VESTA=/usr/local/vesta/
fi
#Firs Conf
user=admin
domain="$(cat /etc/hostname)"
#
#
export VESTA=/usr/local/vesta/
SITEDIR="/home/$user/web/$domain/public_html"
rm -rf $SITEDIR/*
Opencart=opencart-3.0.3.2-ru.zip
# Change to dir
cd $SITEDIR/
# Get & unzip Opencart_latest
wget https://www.opencart.ru/$Opencart --no-check-certificate
unzip $Opencart
mv upload-3032-ru/* $SITEDIR/
#Generate database
echo "Generate Database"
DBUSERSUFB="opc";
i=0;
while [ $i -lt 99 ]
do
i=$((i+1));
DBUSERSUF="${DBUSERSUFB}${i}";
DBUSER=$user\_$DBUSERSUF;
if [ ! -d "/var/lib/mysql/$DBUSER" ]; then
break;
fi
done
PASSWDDB=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
 DBPREFIX="oc_"
/usr/local/vesta/bin/v-add-database $user $DBUSERSUF $DBUSERSUF $PASSWDDB mysql
#
#



#config.php
cat > $SITEDIR/config.php <<EOF
<?php
// HTTP
define('HTTP_SERVER', 'http://$domain');
// HTTPS
define('HTTPS_SERVER', 'http://$domain');
// DIR
define('DIR_APPLICATION', '$SITEDIR/catalog/');
define('DIR_SYSTEM', '$SITEDIR/system/');
define('DIR_IMAGE', '$SITEDIR/image/');
define('DIR_STORAGE', DIR_SYSTEM . 'storage/');
define('DIR_LANGUAGE', DIR_APPLICATION . 'language/');
define('DIR_TEMPLATE', DIR_APPLICATION . 'view/theme/');
define('DIR_CONFIG', DIR_SYSTEM . 'config/');
define('DIR_CACHE', DIR_STORAGE . 'cache/');
define('DIR_DOWNLOAD', DIR_STORAGE . 'download/');
define('DIR_LOGS', DIR_STORAGE . 'logs/');
define('DIR_MODIFICATION', DIR_STORAGE . 'modification/');
define('DIR_SESSION', DIR_STORAGE . 'session/');
define('DIR_UPLOAD', DIR_STORAGE . 'upload/');
// DB
define('DB_DRIVER', 'mysqli');
define('DB_HOSTNAME', 'localhost');
define('DB_USERNAME', '$DBUSER');
define('DB_PASSWORD', '$PASSWDDB');
define('DB_DATABASE', '$DBUSER');
define('DB_PORT', '3306');
define('DB_PREFIX', '$DBPREFIX');
EOF
#
#Change admin/config.php
cat > $SITEDIR/admin/config.php <<EOF
<?php
// HTTP
define('HTTP_SERVER', 'http://$domain/admin/');
define('HTTP_CATALOG', 'http://$domain/');
// HTTPS
define('HTTPS_SERVER', 'http://$domain/admin/');
define('HTTPS_CATALOG', 'http://$domain');
// DIR
define('DIR_APPLICATION', '$SITEDIR/admin/');
define('DIR_SYSTEM', '$SITEDIR/system/');
define('DIR_IMAGE', '$SITEDIR/image/');
define('DIR_STORAGE', DIR_SYSTEM . 'storage/');
define('DIR_CATALOG', '$SITEDIR/catalog/');
define('DIR_LANGUAGE', DIR_APPLICATION . 'language/');
define('DIR_TEMPLATE', DIR_APPLICATION . 'view/template/');
define('DIR_CONFIG', DIR_SYSTEM . 'config/');
define('DIR_CACHE', DIR_STORAGE . 'cache/');
define('DIR_DOWNLOAD', DIR_STORAGE . 'download/');
define('DIR_LOGS', DIR_STORAGE . 'logs/');
define('DIR_MODIFICATION', DIR_STORAGE . 'modification/');
define('DIR_SESSION', DIR_STORAGE . 'session/');
define('DIR_UPLOAD', DIR_STORAGE . 'upload/');
// DB
define('DB_DRIVER', 'mysqli');
define('DB_HOSTNAME', 'localhost');
define('DB_USERNAME', '$DBUSER');
define('DB_PASSWORD', '$PASSWDDB');
define('DB_DATABASE', '$DBUSER');
define('DB_PORT', '3306');

// OpenCart API
define('OPENCART_SERVER', 'https://www.opencart.com/');
EOF

# Place configuration.php
        # Change password
#        password="($PASS)"
#      mysql -uroot -e "USE $DBUSER; UPDATE oc_user set \`password\` = MD5('$password');"
        rm -rf $SITEDIR/install
        rm -rf /home/$user/web/$domain/$Opencart
#
#Change user/RWX
chown -R $user. $SITEDIR
chmod -R 755 $SITEDIR
exit 0
