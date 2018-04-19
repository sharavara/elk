#!/bin/sh
################################################################################
# Author: Vitalii Sharavara
# email: v.sharavara@gmail.com
################################################################################
source ./functions.sh

################################################################################
BASEDIR=~/docker/abc-elk            # Folder for persistant data
CONF_INSTANCEPREFIX=abc             # Containers' names will be xyz-esnode, xyz-kibana and xyz-nginx
CONF_SERVERNAME=vsbook.local        # server hostname
CONF_KIPORT=6603                    # kibana's port
CONF_ESPORT=6604                    # elasticsearch's port
CONF_TIMEZONE="TZ=Asia/Ho_Chi_Minh" # your timezone
ESADMIN=esadm                       # elasticsearch user
ESPASSWD=p@sswd                     # not longer that 8 characters
KIADMIN=kiadm                       # kibana user
KIPASSWD=p@sswd                     # not longer that 8 characters
FILEBEAT=true                       #f ilebeat container for ngnix monitoring and predefined dashboards
################################################################################

# Chech is the destination folder exists or not
if [ -d "$BASEDIR" ]; then
  echo "Destination folder already exists: $BASEDIR"
  ls -l $BASEDIR
  exit 1
fi

# Escape characters
CONF_BASEDIR=$( echo $BASEDIR | sed 's:/:\\/:g' )
CONF_TIMEZONE=$( echo $CONF_TIMEZONE | sed 's:/:\\/:g' )

# create docker-compose.yml file
setup_compose $FILEBEAT
# create containers elastic, kibana, nginx
create_es_ki_ng
# create filebeat
create_filebeat $FILEBEAT

mv docker-compose.yml  ${BASEDIR}/

#Run containers
cd  ${BASEDIR}
docker-compose up -d
echo ''
echo "Instances have been created! Please wait for a while, after open this url: http://$CONF_SERVERNAME:$CONF_KIPORT"
echo ''

