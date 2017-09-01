FROM hashicorp/terraform:0.10.2

WORKDIR /usr/local/deployer

ADD . /usr/local/deployer

ENTRYPOINT src/loop.sh
