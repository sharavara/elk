#!/bin/sh
################################################################################
# Author: Vitalii Sharavara
# email: v.sharavara@gmail.com
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
################################################################################

#TODO Chech is the destination folder exists or not
if [ -d "$BASEDIR" ]; then
  echo "Destination folder already exists: $BASEDIR"
  ls -l $BASEDIR
  exit 1
fi

# Escape characters
CONF_BASEDIR=$( echo $BASEDIR | sed 's:/:\\/:g' )
CONF_TIMEZONE=$( echo $CONF_TIMEZONE | sed 's:/:\\/:g' )

#Create the folders for the persistant data
mkdir -p ${BASEDIR}
mkdir -p ${BASEDIR}/es/config
mkdir -p ${BASEDIR}/es/config/data/nodes
mkdir -p ${BASEDIR}/nginx
mkdir -p ${BASEDIR}/fb

cp docker-compose.yml.template docker-compose.yml
cp ./nginx/default.conf.template ./nginx/default.conf
cp ./elasticsearch/elasticsearch.yml.template ./elasticsearch/elasticsearch.yml
cp ./filebeat/filebeat.yml.template ./filebeat/filebeat.yml

#docker-compose
sed -i '' 's/%BASEDIR%/'"$CONF_BASEDIR"'/g' docker-compose.yml
sed -i '' 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' docker-compose.yml
sed -i '' 's/%CONF_ESPORT%/'"$CONF_ESPORT"'/g' docker-compose.yml
sed -i '' 's/%CONF_KIPORT%/'"$CONF_KIPORT"'/g' docker-compose.yml
sed -i '' 's/%CONF_TIMEZONE%/'"$CONF_TIMEZONE"'/g' docker-compose.yml
#nginx config
sed -i '' 's/%CONF_SERVERNAME%/'"$CONF_SERVERNAME"'/g' ./nginx/default.conf
sed -i '' 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' ./nginx/default.conf
sed -i '' 's/%CONF_ESPORT%/'"$CONF_ESPORT"'/g' ./nginx/default.conf
sed -i '' 's/%CONF_KIPORT%/'"$CONF_KIPORT"'/g' ./nginx/default.conf
printf "${KIADMIN}:$(openssl passwd -crypt ${KIPASSWD})" > ${BASEDIR}/nginx/.ki_htpasswd
printf "${ESADMIN}:$(openssl passwd -crypt ${ESPASSWD})" > ${BASEDIR}/nginx/.es_htpasswd
#elasticsearch
sed -i '' 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' ./elasticsearch/elasticsearch.yml
#filebeat
sed -i '' 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' ./filebeat/filebeat.yml

#Copy files with settings to the persistant folder
cp -r ./elasticsearch/*  ${BASEDIR}/es/config/
rm ${BASEDIR}/es/config/elasticsearch.yml.template
cp ./nginx/default.conf ${BASEDIR}/nginx/
rm ./nginx/default.conf
rm ./elasticsearch/elasticsearch.yml

cp -r ./filebeat/*  ${BASEDIR}/fb/
rm ${BASEDIR}/fb/filebeat.yml.template

mv docker-compose.yml  ${BASEDIR}/

#Run containers
cd  ${BASEDIR}
docker-compose up -d
echo ''
echo "Instances have been created! Please wait for a while, after open this url: http://$CONF_SERVERNAME:$CONF_KIPORT"
echo ''
