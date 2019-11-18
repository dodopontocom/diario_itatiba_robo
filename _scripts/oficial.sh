#!/bin/bash
#author: rodolfotiago@gmail.com
#script name: oficial.sh
#version: 1.11 - com funcoes refatoradas
#

BASEDIR=$(dirname "$0")

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

#load properties file
. ${SCRIPTPATH}/urls.config
. ${SCRIPTPATH}/functions.sh

pasta_destino=${SCRIPTPATH}/pdfs
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

sendMessageBot() {
	messageText=$1
        ids=($2)
	for i in $(echo ${ids[@]}); do
		curl -s -X POST https://api.telegram.org/bot${token}/sendMessage -d chat_id=${i} -d text="${messageText}"
	done
}
#
sendDocumentBot(){
	documentPath=$1
	ids=($2)
	for d in $(echo ${ids[@]}); do
		curl -F chat_id=${d} -F document=@${documentPath} https://api.telegram.org/bot${token}/sendDocument
	done
}

pdfgrep.campinas "${campinas_url}" "CAMPINAS" "11504381"
#fieb "${fieb_url}" "FIEB" "11504381 449542698"
#sleep 3
#itatiba "${itatiba_url}" "ITATIBA" "11504381"
#sleep 3
#boituva "${boituva_url}" "BOITUVA" "11504381"
#sleep 3
#jundiai "${jundiai_url}" "JUNDIAI" "11504381 449542698"
#sleep 3
#jandira "${jandira_url}" "JANDIRA" "11504381"
#sleep 3
#barueri "${barueri_url}" "BARUERI" "11504381 449542698"
#sleep 3
#aracoiaba "${aracoiaba_url}" "ARACOIABA" "11504381 449542698"
#sleep 3

#adicionar mais cidades a cima
# Rodolfo 11504381
# Thais 449542698
# Josilene 772609694
