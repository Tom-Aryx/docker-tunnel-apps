#!/usr/bin/env bash

# required variables
CLIENT_HOST=${CLIENT_HOST}
CLIENT_SECRET=${CLIENT_SECRET}

WEB_USER=${WEB_USER:-"admin"}
WEB_PWD=${WEB_PWD:-'$2a$10$pGBH10RM.LDvQREgrz60G.cP77QlrIbQVRCJ3ygB2pwKMUN8GiucW'} # admin
UUID=${UUID:-"$(uuidgen)"}

# auto generated variables
CERT_DIR="$(pwd)/cert"
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

    # adguard cert
    mkdir -p $CERT_DIR
    openssl ecparam -out ${CERT_DIR}/adguard.key -name prime256v1 -genkey
    openssl req -new -subj "/CN=dns.adguard.com" -key ${CERT_DIR}/adguard.key -out ${CERT_DIR}/adguard.csr
    openssl x509 -req -days 36500 -in ${CERT_DIR}/adguard.csr -signkey ${CERT_DIR}/adguard.key -out ${CERT_DIR}/adguard.pem
    # adguard config
    sed -e "s#-user-#$WEB_USER#" \
        -e "s#-password-#$WEB_PWD#" \
        -i ${CONF_DIR}/AdGuardHome.yaml
    # adguard
    ADGUARD_CMD="$WORK_DIR/AdGuard --no-check-update -c $CONF_DIR/AdGuardHome.yaml -w $WORK_DIR"

    # caddy
    CADDY_CMD="$WORK_DIR/caddy run --config $CONF_DIR/Caddyfile --watch"

    # cloudflared
    CLOUDFLARED_CMD="$WORK_DIR/cloudflared tunnel --edge-ip-version auto --protocol http2 run --token $ARGO_TOKEN"

    # supervisor
    ## copy template
    cp ${CONF_DIR}/damon.conf /etc/supervisor/conf.d/damon.conf
    ## replace commands
    sed -e "s#-adguard-cmd-#$ADGUARD_CMD#g" \
        -e "s#-caddy-cmd-#$CADDY_CMD#g" \
        -e "s#-cloudflared-cmd-#$CLOUDFLARED_CMD#g" \
        -i /etc/supervisor/conf.d/damon.conf
fi

# RUN agent
$WORK_DIR/agent service -c ${CONF_DIR}/config.yml start
# RUN supervisor
supervisord -c /etc/supervisor/supervisord.conf
