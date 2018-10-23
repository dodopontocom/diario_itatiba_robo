FROM alpine:latest

ADD VERSION .

ENV TB_TOKEN=${TB_TOKEN}

RUN apk add --update \
	pdfgrep \
	curl
	
RUN mkdir -p /usr/app/
ADD ./ /usr/app
WORKDIR /usr/app

ENTRYPOINT ["sh", "_scripts/entrypoint.sh", "${TB_TOKEN}"]
