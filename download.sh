#!/usr/bin/env bash

#AGENT_VERSION="$(curl -s https://api.github.com/repos/nezhahq/agent/releases | grep -m 1 -oP '"tag_name":\s*"\K[^"]+')"
AGENT_VERSION="v1.2.0"

wget -q https://github.com/nezhahq/agent/releases/download/${AGENT_VERSION}/nezha-agent_linux_amd64.zip
unzip nezha-agent_linux_amd64.zip && rm nezha-agent_linux_amd64.zip
mv nezha-agent agent && chmod +x agent

MEMOS_VERISON="$(curl -s https://api.github.com/repos/usememos/memos/releases | grep -m 1 -oP '"tag_name":\s*"\K[^"]+')"

wget -q https://github.com/usememos/memos/releases/download/${MEMOS_VERISON}/memos_${MEMOS_VERISON}_linux_amd64.tar.gz
tar -xzf memos_${MEMOS_VERISON}_linux_amd64.tar.gz && rm memos_${MEMOS_VERISON}_linux_amd64.tar.gz LICENSE README.md && chmod +x memos
