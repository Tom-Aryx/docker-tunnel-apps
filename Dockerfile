FROM freshrss/freshrss:latest

RUN apt-get update && \
    apt-get install -y curl iproute2 sed unzip wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/nezhahq/agent/releases/download/v$(curl -s https://api.github.com/repos/nezhahq/agent/releases | grep -m 1 -oP '"tag_name":\s*"v\K[^"]+')/nezha-agent_linux_amd64.zip && \
    unzip nezha-agent_linux_amd64.zip && rm nezha-agent_linux_amd64.zip && mv nezha-agent /agent && chmod +x /agent

COPY config.yml /

EXPOSE 80

CMD sed -e "s#-secret-key-32-#$CLIENT_SECRET#" -e "s#-server-host-#$CLIENT_HOST#" -e "s#-uuid-#$UUID#" -i /config.yml && \
    /agent service -c /config.yml install && \
    /agent service -c /config.yml start && \
    ([ -z "$CRON_MIN" ] || cron) && \
	. /etc/apache2/envvars && \
	exec apache2 -D FOREGROUND $([ -n "$OIDC_ENABLED" ] && [ "$OIDC_ENABLED" -ne 0 ] && echo '-D OIDC_ENABLED')