#!/bin/bash
mkdir -p /opt/sandbox/iroha-config
while [[ ! -d /root/client && ! -f /opt/sandbox/iroha-config/__init__.py ]]; do
  sleep 1
done
mv /opt/sandbox/iroha-config/__init__.py /root/client
pip3 install iroha