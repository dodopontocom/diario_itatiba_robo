FROM alpine:latest

RUN apk add --update \
	pdfgrep
	
RUN mkdir -p /usr/app/
ADD ./ /usr/app
WORKDIR /usr/app

ENTRYPOINT ["sh", "_scripts/oficial.sh"]
