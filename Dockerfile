FROM debian

WORKDIR /app

RUN apt-get update && \
    apt-get install -y cron curl openssl sed supervisor unzip uuid-runtime wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . .

RUN chmod +x *.sh && ./download.sh

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]