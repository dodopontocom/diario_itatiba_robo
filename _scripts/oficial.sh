#!/bin/bash
#author: rodolfotiago@gmail.com
#script name: oficial.sh
#version: 1.11 - com funcoes refatoradas
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

#função para verificar no diário oficial de campinas
pdfgrep.campinas "${campinas_url}" "CAMPINAS" "11504381"

# Rodolfo 11504381
# Thais 449542698
# Josilene 772609694
