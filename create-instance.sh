#!/bin/sh
################################################################################
# Author: Vitalii Sharavara
# email: v.sharavara@gmail.com
################################################################################

#This is a section with the settings
BASEDIR=/docker/elk-iib
CONF_BASEDIR="\/docker\/elk-iib" #!!!Should be the same with $BASEDIR
CONF_INSTANCEPREFIX=iib
CONF_SERVERNAME=sandbox01
CONF_KIPORT=6601
CONF_ESPORT=6602

ESADMIN=esadm
ESPASSWD=p@sswd0
KIADMIN=kiadm
KIPASSWD=p@sswd1

#Create the folders for the persistant data
mkdir -p ${BASEDIR}
mkdir -p ${BASEDIR}/es/config
mkdir -p ${BASEDIR}/es/config/scripts
mkdir -p ${BASEDIR}/nginx

#Change the variables in the configuration files to the real names
#docker-compose
sed -i 's/%BASEDIR%/'"$CONF_BASEDIR"'/g' docker-compose.yml
sed -i 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' docker-compose.yml
sed -i 's/%CONF_ESPORT%/'"$CONF_ESPORT"'/g' docker-compose.yml
sed -i 's/%CONF_KIPORT%/'"$CONF_KIPORT"'/g' docker-compose.yml
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
cp ./elasticsearch/elasticsearch.yml  ${BASEDIR}/es/config/
cp ./elasticsearch/log4j2.properties  ${BASEDIR}/es/config/
cp ./nginx/default.conf ${BASEDIR}/nginx/

#Run containers
docker-compose up -d
echo ''
echo "Instances have been created! Please wait a while, after open this url: http://$CONF_SERVERNAME:$CONF_KIPORT"
echo "!DO NOT USE THIS SCRIPT TWICE! PLEASE DELETE IT AFTER SUCCESSFUL START!"
echo ''
