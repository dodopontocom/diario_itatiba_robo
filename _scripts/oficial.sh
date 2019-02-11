#!/bin/bash
#script funciona apenas para o padrao do diario 
#oficial de itatiba, para outras cidades, ajustes devem ser feitos
#
#author: rodolfotiago@gmail.com
#script name: oficial.sh
#version: 1.2 - com funcoes refatoradas
#
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
        ids=($3)
	for i in $(echo ${ids[@]}); do
		curl -s -X POST https://api.telegram.org/bot${token}/sendMessage -d chat_id=${i} -d text="${messageText}"
	done
}
#
sendDocumentBot(){
	documentPath=$1
	ids=($3)
	for d in $(echo ${ids[@]}); do
		curl -F chat_id=${d} -F document=@${documentPath} https://api.telegram.org/bot${token}/sendDocument
	done
}

itatiba() {
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        echo "procurando pelo edital de Itatiba --- url: $1"
        wget -q --spider $1
        if [[ "$?" -ne "0" ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial"
        else
                wget -O ${pdf_save} $1
                chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
		exc=$(echo $?)
		echo "se igual a zero entao achou  (((( ${exc} ))) "
		if [[ "${exc}" -eq "0" ]]; then
			sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!"
			sendMessageBot "estou enviando o PDF para você poder confirmar..."
			sendDocumentBot "${pdf_save}"
			else
				sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
		fi

        fi
        rm -vfr ${pasta_pdf}
}
boituva() {
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	url=$1
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        anoMesDia="$(date +%Y-%m-%d)"
        pdfs=($(curl -s ${url} | grep -E -o "${anoMesDia}.*\.pdf" | cut -d'>' -f2))
        if [[ -z ${pdfs[@]} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial"
        else
                for i in $(echo ${pdfs[@]}); do
                        
                       	wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			echo "se igual a zero entao achou  (((( ${exc} ))) "
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
                done
        fi
        rm -vfr ${pasta_pdf}

}
jundiai() {
        diaMesAno="$(date +%d-%m-%Y)"
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        url=$1
	pdf_save="${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf"
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
                        sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial"
                else
                        wget -O ${pdf_save} ${pdfName}
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			echo "se igual a zero entao achou  (((( ${exc} ))) "
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
                fi
        done
        rm -vfr ${pasta_pdf}

}
jandira() {
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        jandira_pdfs=($(curl -s ${jandira_url} | grep -E "$(date +%Y-%m-%d)" | grep -E -o "jopej_$(date +%Y)_ed_[0-9]{4}\.pdf" | sort -u))
        if [[ -z ${jandira_pdfs[@]} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial"
        else
                for i in $(echo ${jandira_pdfs[@]}); do
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje"
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
	cidade=$2
        diaAno="$(date +%d%y)"
        pasta_pdf=${pasta_destino}/${cidade}
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
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
                fi
        done
        rm -vfr ${pasta_pdf}
}
aracoiaba() {
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        diaMesAno="$(date +%d%m%Y)"
        url=$1
	pdf_save=${pasta_pdf}/Aracoiaba_$(date +%Y%m%d).pdf
        pdf="$(curl -s ${url} | grep -E "EDICAO" | grep -E "${diaMesAno}" | cut -d'"' -f4)"
        if [[ -z ${pdf} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial"
        else
                wget -q --spider ${pdf}
                if [[ "$?" -ne "0" ]]; then
                        sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial"
                else
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
                fi
        fi
        rm -vfr ${pasta_pdf}
}
fieb() {
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        url=$1
        diaMesAno="$(date +%d/%m/%Y)"
        new_url=($(curl -s ${url} | grep -E -B1 "${diaMesAno}" | grep href | cut -d'"' -f2))
        echo "++++++++++++++++ ${new_url[@]}"
        if [[ -z ${new_url[@]} ]]; then
		sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial"

        else
                for i in $(echo ${new_url[@]}); do
                        pdf=$(curl -s ${i} | grep -E "$(date +%Y)\/$(date +%m)" | grep -E "\.pdf" | head -1 | grep iframe | cut -d'"' -f2)
                        wget -O ${pdf_save} ${pdf}
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!"
				sendMessageBot "estou enviando o PDF para você poder confirmar..."
				sendDocumentBot "${pdf_save}"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje"
					sendMessageBot "estou enviando o PDF para você poder confirmar..."
					sendDocumentBot "${pdf_save}"
			fi
                done
        fi
        rm -vfr ${pasta_pdf}
}

fieb "${fieb_url}" "FIEB" "11504381"
itatiba "${itatiba_url}" "ITATIBA" "11504381"
boituva "${boituva_url}" "BOITUVA" "11504381"
jundiai "${jundiai_url}" "JUNDIAI" "11504381"
jandira "${jandira_url}" "JANDIRA" "11504381"
barueri "${barueri_url}" "BARUERI" "11504381"
aracoiaba "${aracoiaba_url}" "ARACOIABA" "11504381"

#adicionar mais cidades a cima
# Rodolfo 11504381
# Thais 449542698

echo "script end"
sleep 1
exit 0
