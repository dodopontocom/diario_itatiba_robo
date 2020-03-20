#!/bin/bash

# author: rodolfotiago@gmail.com
# script name: oficial.sh
# version: 1.56
# release notes: clean up
#

BASEDIR="$(cd "$(dirname "$0")" ; pwd -P)"

#load properties file
. ${BASEDIR}/urls.config
. ${BASEDIR}/functions.sh

pasta_destino=${BASEDIR}/pdfs
if [[ ! -d "${pasta_destino}" ]]; then
        mkdir ${pasta_destino}
fi

token=${TB_TOKEN}

pTest="atos oficiais"
padrao="carvalho de oliveira neto"

pattern=$1
if [[ -z ${pattern} ]]; then
	pattern=${padrao}
fi

pdfgrep.cerquilho "${cerquilho_url}" "CERQUILHO" "11504381 449542698"
