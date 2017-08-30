FROM hashicorp/terraform:0.10.2

# ENV JQ_VERSION 1.5
# RUN curl -SsL -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 \
#   && chmod 755 /usr/bin/jq && jq --version

# ENV JSON2HCL_VERSION 0.0.6
# RUN curl -SsL -o /usr/bin/json2hcl https://github.com/kvz/json2hcl/releases/download/v${JSON2HCL_VERSION}/json2hcl_v${JSON2HCL_VERSION}_linux_amd64 \
#   && chmod 755 /usr/bin/json2hcl && json2hcl -version

WORKDIR /usr/local/deployer

ADD . /usr/local/deployer

ENTRYPOINT src/loop.sh
