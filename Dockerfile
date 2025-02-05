FROM debian

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl iproute2 sed supervisor unzip wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . .

RUN chmod +x *.sh && ./download.sh && mkdir data

EXPOSE 3000

CMD sed -e "s#-secret-key-32-#$CLIENT_SECRET#" -e "s#-server-host-#$CLIENT_HOST#" -e "s#-uuid-#$UUID#" -i /app/config.yml && \
    cp /app/damon.conf /etc/supervisor/conf.d/damon.conf && \
    sed -e "s#-memos-cmd-#/app/memos --data /app/data --driver postgres --dsn '${DB_URL}' --mode 'prod' --port 3000#g" -i /etc/supervisor/conf.d/damon.conf && \
    /app/agent service -c /app/config.yml install && \
    /app/agent service -c /app/config.yml start && \
    supervisord -c /etc/supervisor/supervisord.conf
