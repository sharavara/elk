# How to create elasticsearch and kibana containers

## 1\. Setup configuration in the file 'create-instance.sh':

You have to change these variables:

```
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
```

## 2\. Run script `create-instance.sh` to setup configuration and start containers

```
chmon 750 create-instance.sh
. create-instance.sh
```

## 3\. Stop containers

```
  docker-compose stop

```

## 4\. Run containers

```
docker-compose up -d
```
