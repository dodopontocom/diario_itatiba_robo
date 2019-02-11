FROM alpine:latest

ADD VERSION .

RUN apk add --update \
	pdfgrep \
	curl
	
RUN mkdir -p /usr/app/
ADD ./ /usr/app
WORKDIR /usr/app

ENTRYPOINT ["/bin/bash", "_scripts/entrypoint.sh"]
