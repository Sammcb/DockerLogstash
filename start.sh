echo "ADMIN_USER=$ADMIN_USER" >> /etc/sysconfig/logstash
echo "ADMIN_PASSWORD=$ADMIN_PASSWORD" >> /etc/sysconfig/logstash
$LS_HOME/bin/logstash --path.settings $LS_CONF
