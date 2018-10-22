FROM alpine:latest

ADD VERSION .

RUN apk add --update \
	pdfgrep \
	curl
	
RUN mkdir -p /usr/app/
ADD ./ /usr/app
WORKDIR /usr/app

CMD echo "Hello docker! from itatiba bot diário oficial"
#ENTRYPOINT ["sh", "_scripts/entrypoint.sh"]
