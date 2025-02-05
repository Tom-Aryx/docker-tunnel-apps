#!/usr/bin/env bash

cd /

MEMOS_VERISON="$(curl -s https://api.github.com/repos/usememos/memos/releases | grep -m 1 -oP '"tag_name":\s*"\K[^"]+')"

wget -q https://github.com/usememos/memos/releases/download/${MEMOS_VERISON}/memos_${MEMOS_VERISON}_linux_amd64.tar.gz
tar -xzf memos_${MEMOS_VERISON}_linux_amd64.tar.gz && rm memos_${MEMOS_VERISON}_linux_amd64.tar.gz LICENSE README.md && chmod +x memos

mv /memos /app/memos

supervisorctl restart memos
