FROM xtruder/terraform:0.11.1-goversion

WORKDIR /usr/local/deployer

ADD . /usr/local/deployer

ENTRYPOINT src/loop.sh
