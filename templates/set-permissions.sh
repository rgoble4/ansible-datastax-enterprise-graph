#!/bin/bash -x

# Sane Defaults
USER={{dseg_user_name}}
LOG_DIR=/var/log/{{app_name}}
APP_LOG=${LOG_DIR}/{{app_name}}.log
APP_DIR=/usr/local/{{app_install_dir}}
DATA_DIR=/var/lib/{{dseg_user_name}}
PORT={{app_port}}
DEFAULT_DB=default

function setLogPermissions() {
    # fix permissions on the log and pid files
    if [ ! -d ${LOG_DIR} ]; then
        mkdir -p ${LOG_DIR}
        chmod 0755 ${LOG_DIR}
        chown ${USER}:${USER} ${LOG_DIR}
    fi
}

function setLibDirPermissions() {
    # fix permissions on the log and pid files
    if [ ! -d ${DATA_DIR} ]; then
        mkdir -p ${DATA_DIR}
    fi

    if [ ! -d ${DATA_DIR}/data ]; then
        # Unbundle default cassandra data folder
        tar --directory=/ -xvzf /usr/local/var-lib-cassandra.tgz
    fi
    chmod 0755 ${DATA_DIR}
    chown -R ${USER}:${USER} ${DATA_DIR}
}

function setSeedIp() {
    IP_ADDRESS=`hostname -I | tr -d '[[:space:]]'`
    FIND="^\s*- seeds:.*$"
    LINE="          - seeds: \"${IP_ADDRESS}\""
    CONFIG=/etc/dse/cassandra/cassandra.yaml
    sed -i -e "s/${FIND}/${LINE}/" $CONFIG
}

setLogPermissions
setLibDirPermissions
setSeedIp

# CMD="${APP_DIR}/dseg-server --loc=${DATA_DIR} --port=${PORT} --update /${DEFAULT_DB}"
# echo "`date` - Executing: ${CMD}"
# exec /bin/su - ${USER} -c "cd ${APP_DIR}; ${CMD} >> ${APP_LOG} 2>&1"

