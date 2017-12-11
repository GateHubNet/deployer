FROM xtruder/terraform:0.11.1-goversion

WORKDIR /usr/local/deployer

ADD . /usr/local/deployer

RUN git clone https://github.com/xtruder/terraform-provider-mysql.git $GOPATH/src/github.com/terraform-providers/terraform-provider-mysql
RUN cd $GOPATH/src/github.com/terraform-providers/terraform-provider-mysql && go install
RUN mkdir -p /root/.terraform.d/plugins && cp $GOPATH/bin/terraform-provider-mysql /root/.terraform.d/plugins

ENTRYPOINT src/loop.sh
