#!/usr/bin/env bash

ADGUARD_VERSION="$(curl -s https://api.github.com/repos/AdguardTeam/AdGuardHome/releases | grep -m 1 -oP '"tag_name":\s*"v\K[^"]+')"

wget -q https://github.com/AdguardTeam/AdGuardHome/releases/download/v${ADGUARD_VERSION}/AdGuardHome_linux_amd64.tar.gz
tar -xz -f AdGuardHome_linux_amd64.tar.gz && rm AdGuardHome_linux_amd64.tar.gz
mv ./AdGuardHome/AdGuardHome ./AdGuard && chmod +x ./AdGuard
rm -r ./AdGuardHome

AGENT_VERSION="$(curl -s https://api.github.com/repos/nezhahq/agent/releases | grep -m 1 -oP '"tag_name":\s*"v\K[^"]+')"

wget -q https://github.com/nezhahq/agent/releases/download/v${AGENT_VERSION}/nezha-agent_linux_amd64.zip
unzip nezha-agent_linux_amd64.zip
rm nezha-agent_linux_amd64.zip
mv nezha-agent agent

