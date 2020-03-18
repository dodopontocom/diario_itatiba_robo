FROM alpine:latest

RUN apk add --update \
	pdfgrep \
	curl \
	bash
	
RUN mkdir -p /usr/app/
ADD ./ /usr/app
WORKDIR /usr/app

ENTRYPOINT ["bash", "scripts/entrypoint.sh"]
