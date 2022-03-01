#!/usr/bin/env bash

 

CRUSH_FTP_BASE_DIR="/home/jboss/CrushFTP9"

 

if [[ -f /tmp/CrushFTP9.zip ]] ; then

    echo "Unzipping CrushFTP..."

    unzip -o -q /tmp/CrushFTP9.zip -d /home/jboss/

    rm -f /tmp/CrushFTP9.zip

fi

 

[ -z ${CRUSH_ADMIN_USER} ] && CRUSH_ADMIN_USER=crushadmin

if [ -z ${CRUSH_ADMIN_PASSWORD} ] && [ -f ${CRUSH_FTP_BASE_DIR}/admin_user_set ]; then

    CRUSH_ADMIN_PASSWORD="NOT DISPLAYED!"

elif [ -z ${CRUSH_ADMIN_PASSWORD} ] && [ ! -f ${CRUSH_FTP_BASE_DIR}/admin_user_set ]; then

    CRUSH_ADMIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

fi

[ -z ${CRUSH_ADMIN_PROTOCOL} ] && CRUSH_ADMIN_PROTOCOL=http

[ -z ${CRUSH_ADMIN_PORT} ] && CRUSH_ADMIN_PORT=8080

 

if [[ ! -d ${CRUSH_FTP_BASE_DIR}/users/MainUsers/${CRUSH_ADMIN_USER} ]] || [[ -f ${CRUSH_FTP_BASE_DIR}/admin_user_set ]] ; then

    echo "Creating default admin..."

    cd ${CRUSH_FTP_BASE_DIR} && java -jar ${CRUSH_FTP_BASE_DIR}/CrushFTP.jar -a "${CRUSH_ADMIN_USER}" "${CRUSH_ADMIN_PASSWORD}"

    touch ${CRUSH_FTP_BASE_DIR}/admin_user_set

fi

sleep 1

echo "########################################"

echo "# User:       ${CRUSH_ADMIN_USER}"

echo "# Password:   ${CRUSH_ADMIN_PASSWORD}"

echo "########################################"

 

chmod +x crushftp_init.sh

# ln -sf /proc/self/fd/1 /home/jboss/CrushFTP9/CrushFTP.log
# ln -sf /proc/self/fd/1 /home/jboss/CrushFTP.log

${CRUSH_FTP_BASE_DIR}/crushftp_init.sh start &

sleep 30 # give testServer time to create the newest log
exec tail -f $( ls -Art CrushFTP9/*.log | tail -n 1 )

