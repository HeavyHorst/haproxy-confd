FROM alpine

ENV VERSION 0.12.0-alpha
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV GO15VENDOREXPERIMENT 1
RUN mkdir -p "$GOPATH/src/" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN apk --update add --no-cache haproxy && \
    apk --update add --virtual build-deps go curl git bash && \
	go get github.com/kelseyhightower/confd && go install github.com/kelseyhightower/confd && \
	apk del build-deps

ADD configuration.toml /etc/confd/conf.d/configuration.toml
ADD haproxy.cfg /etc/confd/templates/haproxy.cfg

ENTRYPOINT ["confd"]
