#!/bin/bash
#script funciona apenas para o padrao do diario 
#oficial de itatiba, para outras cidades, ajustes devem ser feitos
#
#author: rodolfotiago@gmail.com
#script name: oficial.sh
#version: 0.6 - nao depende do odroid ficar ligado - mas tem que por no travis

BASEDIR=$(dirname "$0")
echo "$BASEDIR"

pTest="atos oficiais"
padrao="carvalho de oliveira neto"
pattern=$1
if [[ -z ${pattern} ]]; then
	pattern=${padrao}
fi

url="http://www.itatiba.sp.gov.br"
anoMes="$(date +%Y/%m)"
pdf_name="$(date +%d.%m.%Y).pdf"
pdf_itatiba="http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/${anoMes}/${pdf_name}"

token=${TB_TOKEN}

sendMessageBot() {
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
wget -O /tmp/Itatiba_${pdf_name} ${pdf_itatiba}
ec=$(echo $?)
if [[ "${ec}" -ne "0" ]]; then
	echo "======================================================="
	echo "Hoje não houve registro no diário oficial"
	echo "saída: err --- ${ec}"
	echo "enviando mensagem pelo bot..."
	echo "======================================================="
	sendMessageBot "AVISO ITATIBA - hoje não houve registro no diário oficial"
	else
		chmod 777 /tmp/Itatiba_${pdf_name}; /usr/bin/pdfgrep -i "${pTest}" /tmp/Itatiba_${pdf_name}
		echo "se igual a zero entao achou  (((( $? ))) "
		chmod 777 /tmp/Itatiba_${pdf_name}; /usr/bin/pdfgrep -i "${pattern}" /tmp/Itatiba_${pdf_name}
		exc=$(echo $?)
		echo "se igual a zero entao achou  (((( ${exc} ))) "
		if [[ "${exc}" -eq "0" ]]; then
			sendMessageBot "AVISO ITATIBA - Corra ver no site, seu nome saiu!!!"
			sendMessageBot "estou enviando o PDF para você poder confirmar..."
			sendDocumentBot "/tmp/Itatiba_${pdf_name}"
			else
				sendMessageBot "AVISO ITATIBA - Thaís, você ainda não foi chamada"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "/tmp/Itatiba_${pdf_name}"
		fi
fi
echo "script end"
sleep 1
exit 0
