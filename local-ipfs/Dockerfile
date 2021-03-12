FROM ipfs/go-ipfs:v0.7.0

ENV LIBP2P_FORCE_PNET 1

ENV IPFS_FD_MAX 4096

WORKDIR /opt/scripts

COPY ./config-and-run.sh /opt/scripts/config-and-run.sh

COPY ./swarm.key /data/ipfs/swarm.key

ENTRYPOINT ["sh", "/opt/scripts/config-and-run.sh"]
