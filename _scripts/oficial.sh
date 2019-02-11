#!/bin/bash
#script funciona apenas para o padrao do diario 
#oficial de itatiba, para outras cidades, ajustes devem ser feitos
#
#author: rodolfotiago@gmail.com
#script name: oficial.sh
#version: 0.6 - nao depende do odroid ficar ligado - mas tem que por no travis

BASEDIR=$(dirname "$0")
#echo "$BASEDIR"

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
#echo ${SCRIPTPATH}

#properties file
. ${SCRIPTPATH}/urls.config

pasta_destino=${SCRIPTPATH}/pdfs
if [[ ! -d "${pasta_destino}" ]]; then
        mkdir ${pasta_destino}
fi

itatiba() {
        pasta_pdf=${pasta_destino}/itatiba
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        echo "procurando pelo edital de Itatiba --- url: $1"
        wget -q --spider $1
        if [[ "$?" -ne "0" ]]; then
                echo "itatiba - não houve edital"
        else
                #wget -q -O ${pasta_destino}/$(echo "$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 13).pdf") $1
                wget -q $1 -P ${pasta_pdf}
                gsutil cp ${pasta_pdf}/*.pdf gs://passei-pdf-storage/itatiba/

        fi
        rm -vfr ${pasta_pdf}
}
boituva() {
        url=$1
        pasta_pdf=${pasta_destino}/boituva
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        anoMesDia="$(date +%Y-%m-%d)"
        pdfs=($(curl -s ${url} | grep -E -o "${anoMesDia}.*\.pdf" | cut -d'>' -f2))
        if [[ -z ${pdfs[@]} ]]; then
                echo "boituva - nao houve edital"
        else
                for i in $(echo ${pdfs[@]}); do
                        echo "baixando edital de Boituva --- url: ${url}$i"
                        wget -q ${url}$i -P ${pasta_pdf}
                        gsutil cp ${pasta_pdf}/*.pdf gs://passei-pdf-storage/boituva/
                done
        fi
        rm -vfr ${pasta_pdf}

}
jundiai() {
        diaMesAno="$(date +%d-%m-%Y)"
        pasta_pdf=${pasta_destino}/jundiai
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        url=$1
        counter=($(curl -s ${url} | grep -E "${diaMesAno//-/\/}" | grep -v span | grep -E -o "\ [0-9]{4}\ " | tr -d ' '))
        #counter=($(curl -s ${url} | grep -E "${diaMesAno//-/\/}" | grep -v span | tail -2 | grep -E -o "Edição\ [0-9]*" | sed 's/Edição\ //'))
        echo "counter --- ${counter[@]}"
        for i in $(echo ${counter[@]}); do
                echo "counter i ----- $i"
                jundiai="https://imprensaoficial.jundiai.sp.gov.br/edicao-$i/"
                jundiaiExtra="https://imprensaoficial.jundiai.sp.gov.br/edicao-extra-$i/"

                pdfName=$(curl -s ${jundiai} | grep "${counter[$i]}" | grep -E "\.pdf" | cut -d'"' -f2)
                if [[ -z ${pdfName} ]]; then
                        pdfName=$(curl -s ${jundiaiExtra} | grep "$i" | grep -E "\.pdf" | cut -d'"' -f2)
                fi
                echo "procurando pelo edital de Jundiai --- url: ${url}"
                wget -q --spider ${pdfName}
                if [[ "$?" -ne "0" ]]; then
                        echo "jundiai - nao houve edital"
                else
                        wget -q ${pdfName} -P ${pasta_pdf}
                        gsutil cp ${pasta_pdf}/*.pdf gs://passei-pdf-storage/jundiai/
                fi
        done
        rm -vfr ${pasta_pdf}

}
jandira() {
        pasta_pdf=${pasta_destino}/jandira
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        fake="2019-02-09"
        jandira_pdfs=($(curl -s ${jandira_url} | grep -E "$(date +%Y-%m-%d)" | grep -E -o "jopej_$(date +%Y)_ed_[0-9]{4}\.pdf" | sort -u))
        #jandira_pdfs=($(curl -s ${jandira_url} | grep -E "${fake}" | grep -E -o "jopej_2019_ed_[0-9]{4}\.pdf" | sort -u))
        if [[ -z ${jandira_pdfs[@]} ]]; then
                echo "jandira - nao houve edital"
        else
                for i in $(echo ${jandira_pdfs[@]}); do
                        echo "baixando edital de Jandira --- url: ${jandira_url}$i"
                        wget -q ${jandira_url}$i -P ${pasta_pdf}
                        gsutil cp ${pasta_pdf}/*.pdf gs://passei-pdf-storage/jandira/
                done
        fi
        rm -vfr ${pasta_pdf}
}
barueri() {
        diaMesAno="$(date +%d-%m-%Y)"
        url=$1
        diaAno="$(date +%d%y)"
        pasta_pdf=${pasta_destino}/barueri
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        pdf=($(curl -s ${url} | grep servicos | grep JOB | grep "ACESSAR JORNAL" | cut -d'"' -f4 | head -4))
        for i in $(echo ${pdf[@]}); do
                echo "--------------- $i"
                if [[ "$(echo $i | grep -E -o '[0-9]{2}.*[a-zA-Z][-/_]' | tr -d '_/a-zA-Z' | tr -d '-' | sed 's/^....//' | sed 's/2019/19/' | sed 's/^0*//')" == "$(echo ${diaAno} | sed 's/^0*//')" ]]; then
                        echo "baixando edital de Barueri --- url: $url"
                        wget -q $i -P ${pasta_pdf}
                        gsutil cp ${pasta_pdf}/*.pdf gs://passei-pdf-storage/barueri/
                fi
        done
        rm -vfr ${pasta_pdf}
}
aracoiaba() {
        pasta_pdf=${pasta_destino}/aracoiaba
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        diaMesAno="$(date +%d%m%Y)"
        url=$1
        pdf="$(curl -s ${url} | grep -E "EDICAO" | grep -E "${diaMesAno}" | cut -d'"' -f4)"
        if [[ -z ${pdf} ]]; then
                echo "aracoiaba - nao houve edital"
        else
                wget -q --spider ${pdf}
                if [[ "$?" -ne "0" ]]; then
                        echo "aracoiaba - nao houve edital"
                else
                        wget -q ${pdf} -P ${pasta_pdf}
                        gsutil cp ${pasta_pdf}/*.pdf gs://passei-pdf-storage/aracoiaba/
                fi
        fi
        rm -vfr ${pasta_pdf}
}
fieb() {
        pasta_pdf=${pasta_destino}/fieb
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        url=$1
        diaMesAno="$(date +%d/%m/%Y)"
        new_url=($(curl -s ${url} | grep -E -B1 "${diaMesAno}" | grep href | cut -d'"' -f2))
        echo "++++++++++++++++ ${new_url[@]}"
        if [[ -z ${new_url[@]} ]]; then
                echo "FIEB - nao houve edital"
        else
                for i in $(echo ${new_url[@]}); do
                        echo "baixando edital de FIEB --- url: ${i}"
                        pdf=$(curl -s ${i} | grep -E "$(date +%Y)\/$(date +%m)" | grep -E "\.pdf" | head -1 | grep iframe | cut -d'"' -f2)
                        wget -q ${pdf} -P ${pasta_pdf}
                        gsutil cp ${pasta_pdf}/*.pdf gs://passei-pdf-storage/fieb/
                done
        fi
        rm -vfr ${pasta_pdf}
}

fieb "${fieb_url}"
itatiba "${itatiba_url}"
boituva "${boituva_url}"
jundiai "${jundiai_url}"
jandira "${jandira_url}"
barueri "${barueri_url}"
aracoiaba "${aracoiaba_url}"

#adicionar mais cidades a cima

#endscript

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
			sendMessageBot "AVISO ITATIBA - Corra ver no site, seu nome foi citado no edital de hoje!!!"
			sendMessageBot "estou enviando o PDF para você poder confirmar..."
			sendDocumentBot "/tmp/Itatiba_${pdf_name}"
			else
				sendMessageBot "AVISO ITATIBA - Seu nome não foi citado no edital de hoje"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "/tmp/Itatiba_${pdf_name}"
		fi
fi
echo "script end"
sleep 1
exit 0
