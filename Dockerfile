FROM debian

WORKDIR /app

RUN apt-get update && \
    apt-get install -y git sudo && \
    git clone https://github.com/searxng/searxng.git searxng && \
    cd searxng && \
    sudo -H ./utils/searxng.sh install all && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY config.yml .

RUN wget -q https://github.com/cloudflare/cloudflared/releases/download/${CF_VERSION}/cloudflared-linux-amd64 && \
    mv cloudflared-linux-amd64 cloudflared && chmod +x cloudflared && \
    wget -q https://github.com/nezhahq/agent/releases/download/v1.2.0/nezha-agent_linux_amd64.zip && \
    unzip nezha-agent_linux_amd64.zip && rm nezha-agent_linux_amd64.zip && \
    mv nezha-agent agent && chmod +x agent

EXPOSE 8080

CMD sed -e "s#-secret-key-32-#$CLIENT_SECRET#" -e "s#-server-host-#$CLIENT_HOST#" -e "s#-uuid-#$UUID#" -i /app/config.yml && \
    /app/agent service -c /app/config.yml install && \
    /app/agent service -c /app/config.yml start && \
    /app/cloudflared tunnel --edge-ip-version auto --protocol http2 run --token $ARGO_TOKEN