#!/bin/bash
#script funciona apenas para o padrao do diario 
#oficial de itatiba, para outras cidades, ajustes devem ser feitos
#
#author: rodolfotiago@gmail.com
#script name: oficial.sh
#version: 1.2 - com funcoes refatoradas

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

token=${TB_TOKEN}

pTest="atos oficiais"
padrao="carvalho de oliveira neto"
pattern=$1
if [[ -z ${pattern} ]]; then
	pattern=${padrao}
fi

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

itatiba() {
        pasta_pdf=${pasta_destino}/itatiba
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/Itatiba_$(date +%Y%m%d).pdf
        echo "procurando pelo edital de Itatiba --- url: $1"
        wget -q --spider $1
        if [[ "$?" -ne "0" ]]; then
                sendMessageBot "AVISO ITATIBA - hoje não houve registro no diário oficial"
        else
                wget -O ${pdf_save} $i
                chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
		exc=$(echo $?)
		echo "se igual a zero entao achou  (((( ${exc} ))) "
		if [[ "${exc}" -eq "0" ]]; then
			sendMessageBot "AVISO ITATIBA - Corra ver no site, seu nome foi citado no edital de hoje!!!"
			sendMessageBot "estou enviando o PDF para você poder confirmar..."
			sendDocumentBot "${pdf_save}"
			else
				sendMessageBot "AVISO ITATIBA - Seu nome não foi citado no edital de hoje"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
		fi

        fi
        rm -vfr ${pasta_pdf}
}
boituva() {
        pasta_pdf=${pasta_destino}/boituva
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	url=$1
	pdf_save=${pasta_pdf}/Boituva_$(date +%Y%m%d).pdf
        anoMesDia="$(date +%Y-%m-%d)"
        pdfs=($(curl -s ${url} | grep -E -o "${anoMesDia}.*\.pdf" | cut -d'>' -f2))
        if [[ -z ${pdfs[@]} ]]; then
                sendMessageBot "AVISO BOITUVA - hoje não houve registro no diário oficial"
        else
                for i in $(echo ${pdfs[@]}); do
                        
                       	wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			echo "se igual a zero entao achou  (((( ${exc} ))) "
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO Boituva - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO Boituva - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
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
	pdf_save=${pasta_pdf}/Jundiai_$(date +%Y%m%d).pdf
        counter=($(curl -s ${url} | grep -E "${diaMesAno//-/\/}" | grep -v span | grep -E -o "\ [0-9]{4}\ " | tr -d ' '))
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
                        sendMessageBot "AVISO JUNDIAI - hoje não houve registro no diário oficial"
                else
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			echo "se igual a zero entao achou  (((( ${exc} ))) "
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO Jundiai - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO Jundiai - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
                fi
        done
        rm -vfr ${pasta_pdf}

}
jandira() {
        pasta_pdf=${pasta_destino}/jandira
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/Jandira_$(date +%Y%m%d).pdf
        jandira_pdfs=($(curl -s ${jandira_url} | grep -E "$(date +%Y-%m-%d)" | grep -E -o "jopej_$(date +%Y)_ed_[0-9]{4}\.pdf" | sort -u))
        if [[ -z ${jandira_pdfs[@]} ]]; then
                sendMessageBot "AVISO Jandira - hoje não houve registro no diário oficial"
        else
                for i in $(echo ${jandira_pdfs[@]}); do
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO Jandira - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO Jandira - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
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
	pdf_save=${pasta_pdf}/Barueri_$(date +%Y%m%d).pdf
        pdf=($(curl -s ${url} | grep servicos | grep JOB | grep "ACESSAR JORNAL" | cut -d'"' -f4 | head -4))
        for i in $(echo ${pdf[@]}); do
                echo "--------------- $i"
                if [[ "$(echo $i | grep -E -o '[0-9]{2}.*[a-zA-Z][-/_]' | tr -d '_/a-zA-Z' | tr -d '-' | sed 's/^....//' | sed 's/2019/19/' | sed 's/^0*//')" == "$(echo ${diaAno} | sed 's/^0*//')" ]]; then
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO Barueri - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO Barueri - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
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
	pdf_save=${pasta_pdf}/Aracoiaba_$(date +%Y%m%d).pdf
        pdf="$(curl -s ${url} | grep -E "EDICAO" | grep -E "${diaMesAno}" | cut -d'"' -f4)"
        if [[ -z ${pdf} ]]; then
                echo "aracoiaba - nao houve edital"
        else
                wget -q --spider ${pdf}
                if [[ "$?" -ne "0" ]]; then
                        sendMessageBot "AVISO Aracoiaba - hoje não houve registro no diário oficial"
                else
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO Aracoiaba - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO Aracoiaba - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
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
		sendMessageBot "AVISO FIEB - hoje não houve registro no diário oficial"

        else
                for i in $(echo ${new_url[@]}); do
                        pdf=$(curl -s ${i} | grep -E "$(date +%Y)\/$(date +%m)" | grep -E "\.pdf" | head -1 | grep iframe | cut -d'"' -f2)
                        wget -O ${pdf_save} ${pdf}
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO FIEB - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO FIEB - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
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

echo "script end"
sleep 1
exit 0
