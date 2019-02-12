FROM alpine:latest

ADD VERSION .

RUN apk add --update \
	pdfgrep \
	curl \
	bash
	
RUN mkdir -p /usr/app/
ADD ./ /usr/app
WORKDIR /usr/app

ENTRYPOINT ["bash", "_scripts/entrypoint.sh"]
