FROM alpine:latest

ADD VERSION .

ENV TB_TOKEN=407633103:AAEtBhtw9En-Z_fcFil7bLbQHCXwxDwJAvA

RUN apk add --update \
	pdfgrep \
	curl
	
RUN mkdir -p /usr/app/
ADD ./ /usr/app
WORKDIR /usr/app

ENTRYPOINT ["sh", "_scripts/entrypoint.sh"]
