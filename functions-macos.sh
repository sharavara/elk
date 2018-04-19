################################################################################
# FUNCTIONS
################################################################################

# create filebeat container
function create_filebeat(){
  if [ $1 != true ]
  then
    return 0
  fi

  echo "Create filebeat configuration..."
  mkdir -p ${BASEDIR}/fb
  cp ./filebeat/filebeat.yml.template ./filebeat/filebeat.yml
  #configuration
  sed -i '' 's/%CONF_INSTANCEPREFIX%/'"$CONF_INSTANCEPREFIX"'/g' ./filebeat/filebeat.yml
  cp -r ./filebeat/*  ${BASEDIR}/fb/
  rm ${BASEDIR}/fb/filebeat.yml.template
}

# Create elastic, kibana and nginx containers
function create_es_ki_ng(){
  echo "Create elastic, kibana and nginx configurations..."
  
  #Create the folders for the persistant data
  mkdir -p ${BASEDIR}
  mkdir -p ${BASEDIR}/es/config
  mkdir -p ${BASEDIR}/es/config/data/nodes
  mkdir -p ${BASEDIR}/nginx

  cp ./nginx/default.conf.template ./nginx/default.conf
  cp ./elasticsearch/elasticsearch.yml.template ./elasticsearch/elasticsearch.yml
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
  
  #Copy files with settings to the persistant folder
  cp -r ./elasticsearch/*  ${BASEDIR}/es/config/
  rm ${BASEDIR}/es/config/elasticsearch.yml.template
  rm ./elasticsearch/elasticsearch.yml 
  mv ./nginx/default.conf ${BASEDIR}/nginx/
}

# create docer-compose.yml file
function setup_compose(){
  echo "Create docker-compose.yml file from the template..."
  if [ $1 = true ]
  then
    cat docker-compose.yml.template docker-compose.filebeat.template > docker-compose.yml 
  else
    cp docker-compose.yml.template docker-compose.yml
  fi
}