#!/bin/sh
set -e
set -x
# This is a custom entrypoint for k8s designed to run ipfs nodes in an appropriate
# setup for production scenarios.

user=root
mkdir -p /data/ipfs && chown -R ipfs /data/ipfs

user=ipfs
if [ -f /data/ipfs/config ]; then
  if [ -f /data/ipfs/repo.lock ]; then
    rm /data/ipfs/repo.lock
  fi
fi

# if [ ! -f /data/ipfs/swarm.key ]; then
#   echo "$IPFS_SWARM_KEY" > /data/ipfs/swarm.key
# fi

if [ ! -f /data/ipfs/config ]; then
  ipfs init --profile=badgerds,server
  ipfs bootstrap rm --all
  ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
  ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
  ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin  '["*"]'
  ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST", "GET"]'
  ipfs config --json Swarm.ConnMgr.HighWater 2000
  ipfs config --json Datastore.BloomFilterSize 1048576
  ipfs config Datastore.StorageMax 100GB
fi

ipfs daemon
