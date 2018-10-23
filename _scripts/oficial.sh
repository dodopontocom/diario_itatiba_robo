#!/bin/bash
#script funciona apenas para o padrao do diario 
#oficial de itatiba, para outras cidades, ajustes devem ser feitos
#
#author: rodolfotiago@gmail.com
#script name: oficial.sh
#version: 0.6 - nao depende do odroid ficar ligado - mas tem que por no travis

BASEDIR=$(dirname "$0")
echo "$BASEDIR"
echo "${TRAVIS_EVENT_TYPE} <--"

pTest="atos oficiais"
padrao="carvalho de oliveira neto"
pattern=$1
if [[ -z ${pattern} ]]; then
	pattern=${padrao}
fi

url="http://www.itatiba.sp.gov.br"
url_exemplo="http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/2018/08/09.08.2018.pdf"
anoMes="$(date +%Y/%m)"
pdf_name="$(date +%d.%m.%Y).pdf"
pdf_itatiba="http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/${anoMes}/${pdf_name}"
token=${TB_TOKEN}

sendMessageBot() {
	#ids=(11504381 449542698)
	messageText=$1
	for i in 11504381 449542698; do
		curl -s -X POST https://api.telegram.org/bot${token}/sendMessage -d chat_id=${i} -d text="${messageText}"
	done
}
#
sendDocumentBot(){
	documentPath=$1
	for d in 11504381 449542698; do
		curl -F chat_id=${d} -F document=@${documentPath} https://api.telegram.org/bot${token}/sendDocument
	done
}
#baixar pdf
ec=0
echo "baixando PDF do site oficial..."
wget ${pdf_itatiba} -P /tmp/
ec=$(echo $?)
if [[ "${ec}" -ne "0" ]]; then
	echo "======================================================="
	echo "Hoje não houve registro no diário oficial"
	echo "saída: err --- ${ec}"
	echo "enviando mensagem pelo bot..."
	echo "======================================================="
	sendMessageBot "hoje não houve registro no diário oficial de Itatiba"
	else
		chmod 777 /tmp/${pdf_name}; /usr/bin/pdfgrep -i "${pTest}" /tmp/${pdf_name}
		/usr/bin/pdfgrep -i "${pattern}" /tmp/${pdf_name}
		if [[ "$?" -eq "0" ]]; then
			sendMessageBot "Thaís, corra ver no site, seu nome saiu!!!"
			sendMessageBot "estou enviando o PDF para você poder confirmar..."
			sendDocumentBot "/tmp/${pdf_name}"
			else
				sendMessageBot "Thaís, você ainda não foi chamada em Itatiba"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "/tmp/${pdf_name}"
		fi
fi
echo "script end"
sleep 1
exit 0
