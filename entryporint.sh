#!/usr/bin/env bash

# required variables
CLIENT_HOST=${CLIENT_HOST}
CLIENT_SECRET=${CLIENT_SECRET}

WEB_USER=${WEB_USER:-"admin"}
WEB_PWD=${WEB_PWD:-'$2a$10$pGBH10RM.LDvQREgrz60G.cP77QlrIbQVRCJ3ygB2pwKMUN8GiucW'} # admin
UUID=${UUID:-"$(uuidgen)"}

# auto generated variables
CONF_DIR="$(pwd)/conf"
WORK_DIR="$(pwd)"

# first run
if [ ! -s /etc/supervisor/conf.d/damon.conf ]; then

    # agent config
    sed -e "s#-uuid-#$UUID#" \
        -e "s#-secret-key-32-#$CLIENT_SECRET#" \
        -e "s#-server-host-#$CLIENT_HOST#" \
        -i ${CONF_DIR}/config.yml
    # install agent
    ${WORK_DIR}/agent service -c ${CONF_DIR}/config.yml install

    # adguard config
    sed -e "s#-user-#$WEB_USER#" \
        -e "s#-password-#$WEB_PWD#" \
        -i ${CONF_DIR}/AdGuardHome.yaml
    # adguard
    ADGUARD_CMD="$WORK_DIR/AdGuard --no-check-update -c $CONF_DIR/AdGuardHome.yaml -w $WORK_DIR"

    # supervisor
    ## copy template
    cp ${CONF_DIR}/damon.conf /etc/supervisor/conf.d/damon.conf
    ## replace commands
    sed -e "s#-adguard-cmd-#$ADGUARD_CMD#g" \
        -i /etc/supervisor/conf.d/damon.conf
fi

# RUN agent
$WORK_DIR/agent service -c ${CONF_DIR}/config.yml start
# RUN supervisor
supervisord -c /etc/supervisor/supervisord.conf
