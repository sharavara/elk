#!/bin/sh
################################################################################
# Author: Vitalii Sharavara
# email: v.sharavara@gmail.com
################################################################################

BASEDIR=~/docker/xyz-elk            # Folder for persistant data
CONF_BASEDIR="~\/docker\/xyz-elk"   #!!!Should be the same with $BASEDIR
CONF_INSTANCEPREFIX=xyz             # Containers' names will be xyz-esnode, xyz-kibana and xyz-nginx
CONF_SERVERNAME=vsbook.local        # server hostname
CONF_KIPORT=6601                    # kibana's port
CONF_ESPORT=6602                    # elasticsearch's port
CONF_TIMEZONE="TZ=Asia/Ho_Chi_Minh" # your timezone

ESADMIN=esadm       # elasticsearch user
ESPASSWD=p@sswd     # not longer that 8 characters
KIADMIN=kiadm       # kibana user
KIPASSWD=p@sswd     # not longer that 8 characters
################################################################################

#Create the folders for the persistant data
mkdir -p ${BASEDIR}
mkdir -p ${BASEDIR}/es/config
mkdir -p ${BASEDIR}/es/config/data/nodes
mkdir -p ${BASEDIR}/nginx

cp docker-compose.yml.template docker-compose.yml
cp ./nginx/default.conf.template ./nginx/default.conf
cp ./elasticsearch/elasticsearch.yml.template ./elasticsearch/elasticsearch.yml

#docker-compose
sed -i 's/%BASEDIR%/'"$CONF_BASEDIR"'/g' docker-compose.yml
sed -i 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' docker-compose.yml
sed -i 's/%CONF_ESPORT%/'"$CONF_ESPORT"'/g' docker-compose.yml
sed -i 's/%CONF_KIPORT%/'"$CONF_KIPORT"'/g' docker-compose.yml
sed -i 's/%CONF_TIMEZONE%/'"$CONF_TIMEZONE"'/g' docker-compose.yml
#nginx config
sed -i 's/%CONF_SERVERNAME%/'"$CONF_SERVERNAME"'/g' ./nginx/default.conf
sed -i 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' ./nginx/default.conf
sed -i 's/%CONF_ESPORT%/'"$CONF_ESPORT"'/g' ./nginx/default.conf
sed -i 's/%CONF_KIPORT%/'"$CONF_KIPORT"'/g' ./nginx/default.conf
#elasticsearch
sed -i 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' ./elasticsearch/elasticsearch.yml

#Setup the passwords for elasticsearch and kibana
printf "${KIADMIN}:$(openssl passwd -crypt ${KIPASSWD})" > ${BASEDIR}/nginx/.ki_htpasswd
printf "${ESADMIN}:$(openssl passwd -crypt ${ESPASSWD})" > ${BASEDIR}/nginx/.es_htpasswd

#Copy files with settings to the persistant folder
cp -r ./elasticsearch/*  ${BASEDIR}/es/config/
rm  ${BASEDIR}/es/config/elasticsearch.yml.template
cp ./nginx/default.conf ${BASEDIR}/nginx/
#rm ${BASEDIR}/nginx/default.conf.template

#Run containers
docker-compose up -d
echo ''
echo "Instances have been created! Please wait a while, after open this url: http://$CONF_SERVERNAME:$CONF_KIPORT"
echo "!DO NOT USE THIS SCRIPT TWICE! PLEASE DELETE IT AFTER SUCCESSFUL START!"
echo ''
