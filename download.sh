#!/usr/bin/env bash

ADGUARD_VERSION="$(curl -s https://api.github.com/repos/AdguardTeam/AdGuardHome/releases | grep -m 1 -oP '"tag_name":\s*"\K[^"]+')"

wget -q https://github.com/AdguardTeam/AdGuardHome/releases/download/${ADGUARD_VERSION}/AdGuardHome_linux_amd64.tar.gz
tar -xz -f AdGuardHome_linux_amd64.tar.gz && rm AdGuardHome_linux_amd64.tar.gz
mv ./AdGuardHome/AdGuardHome ./AdGuard && chmod +x ./AdGuard
rm -r ./AdGuardHome

#AGENT_VERSION="$(curl -s https://api.github.com/repos/nezhahq/agent/releases | grep -m 1 -oP '"tag_name":\s*"\K[^"]+')"
AGENT_VERSION="v1.2.0"

wget -q https://github.com/nezhahq/agent/releases/download/${AGENT_VERSION}/nezha-agent_linux_amd64.zip
unzip nezha-agent_linux_amd64.zip && rm nezha-agent_linux_amd64.zip
mv nezha-agent agent && chmod +x agent

CADDY_VERSION="$(curl -s https://api.github.com/repos/caddyserver/caddy/releases | grep -m 1 -oP '"tag_name":\s*"v\K[^"]+')"

wget -q https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_linux_amd64.tar.gz
tar -xz -f caddy_${CADDY_VERSION}_linux_amd64.tar.gz && rm caddy_${CADDY_VERSION}_linux_amd64.tar.gz LICENSE README.md

CF_VERSION="$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases | grep -m 1 -oP '"tag_name":\s*"\K[^"]+')"

wget -q https://github.com/cloudflare/cloudflared/releases/download/${CF_VERSION}/cloudflared-linux-amd64
mv cloudflared-linux-amd64 cloudflared && chmod +x cloudflared
