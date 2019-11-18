#!/bin/bash


pdfgrep.itatiba() {
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        echo "procurando pelo edital de Itatiba --- url: $1"
        wget -q --spider $1
        if [[ "$?" -ne "0" ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        else
                wget -O ${pdf_save} $1
                chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
		exc=$(echo $?)
		echo "se igual a zero entao achou  (((( ${exc} ))) "
		if [[ "${exc}" -eq "0" ]]; then
			sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
			sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
			sendDocumentBot "${pdf_save}" "$3"
			else
				sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
		fi

        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.boituva() {
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
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        else
                for i in $(echo ${pdfs[@]}); do
                        
                       	wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			echo "se igual a zero entao achou  (((( ${exc} ))) "
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
					sendDocumentBot "${pdf_save}" "$3"
			fi
                done
        fi
        rm -vfr ${pasta_pdf}

}
pdfgrep.jundiai() {
        diaMesAno="$(date +%d-%m-%Y)"
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        url=$1
	pdf_save="${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf"
        counter=($(curl -s ${url} | grep -E "${diaMesAno//-/\/}" | grep -v span | grep -E -o "\ [0-9]{4}\ " | tr -d ' '))
        if [[ -z ${counter[@]} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        else
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
                                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
                        else
                                wget -O ${pdf_save} ${pdfName}
                                chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
                                exc=$(echo $?)
                                echo "se igual a zero entao achou  (((( ${exc} ))) "
                                if [[ "${exc}" -eq "0" ]]; then
                                        sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
                                        sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
                                        sendDocumentBot "${pdf_save}" "$3"
                                        else
                                                sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
                                                sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
                                                sendDocumentBot "${pdf_save}" "$3"
                                fi
                        fi
                done
        fi
        rm -vfr ${pasta_pdf}

}
pdfgrep.jandira() {
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        jandira_pdfs=($(curl -s ${jandira_url} | grep -E "$(date +%Y-%m-%d)" | grep -E -o "jopej_$(date +%Y)_ed_[0-9]{4}\.pdf" | sort -u))
        if [[ -z ${jandira_pdfs[@]} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        else
                for i in $(echo ${jandira_pdfs[@]}); do
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
					sendDocumentBot "${pdf_save}" "$3"
			fi
                done
        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.barueri() {
        diaMesAno="$(date +%d-%m-%Y)"
        url=$1
	cidade=$2
        diaAno="$(date +%d%y)"
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        pdf=($(curl -s ${url} | grep servicos | grep JOB | grep "ACESSAR JORNAL" | cut -d'"' -f4 | head -4))
        flag=0
        for i in $(echo ${pdf[@]}); do
                echo "--------------- $i"
                if [[ "$(echo $i | grep -E -o '[0-9]{2}.*[a-zA-Z][-/_]' | tr -d '_/a-zA-Z' | tr -d '-' | sed 's/^....//' | sed 's/2019/19/' | sed 's/^0*//')" == "$(echo ${diaAno} | sed 's/^0*//')" ]]; then
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
					sendDocumentBot "${pdf_save}" "$3"
			fi
                        else
                                flag=$((flag+1))
                fi
        done
        if [[ "${flag}" -eq "4" ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.aracoiaba() {
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        diaMesAno="$(date +%d%m%Y)"
        url=$1
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        pdf="$(curl -s ${url} | grep -E "EDICAO" | grep -E "${diaMesAno}" | cut -d'"' -f4)"
        if [[ -z ${pdf} ]]; then
                sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
        else
                wget -q --spider ${pdf}
                if [[ "$?" -ne "0" ]]; then
                        sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"
                else
                        wget -O ${pdf_save} $i
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
					sendDocumentBot "${pdf_save}" "$3"
			fi
                fi
        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.fieb() {
	local cidade pasta_pdf url pdf_save diaMesAno new_url
	cidade=$2
        pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
        url=$1
        pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
        diaMesAno="$(date +%d/%m/%Y)"
	
        new_url=($(curl -s ${url} | grep -E -B1 "${diaMesAno}" | grep href | cut -d'"' -f2))
        echo "++++++++++++++++ ${new_url[@]}"
        if [[ -z ${new_url[@]} ]]; then
		sendMessageBot "AVISO ${cidade} - hoje não houve registro no diário oficial" "$3"

        else
                for i in $(echo ${new_url[@]}); do
                        pdf=$(curl -s ${i} | grep -E "$(date +%Y)\/$(date +%m)" | grep -E "\.pdf" | head -1 | grep iframe | cut -d'"' -f2)
			
                        wget -O ${pdf_save} ${pdf}
			chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
			exc=$(echo $?)
			if [[ "${exc}" -eq "0" ]]; then
				sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
				else
					sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
					sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
					sendDocumentBot "${pdf_save}" "$3"
			fi
                done
        fi
        rm -vfr ${pasta_pdf}
}
pdfgrep.campinas() {
	local url cidade id pdf_save extra_date extra_pdf
	
	url=$1
	cidade=$2
	id=$3
	extra_date=$(date +%Y-%m-%d)
	extra_pdf="${url}arquivos/dom-extra/dom-extra-${extra_date}.pdf"
	
	pasta_pdf=${pasta_destino}/${cidade}
        if [[ ! -d "${pasta_pdf}" ]]; then
                mkdir ${pasta_pdf}
        fi
	
	pdf_save=${pasta_pdf}/${cidade}_$(date +%Y%m%d).pdf
	extra_pdf_save=${pasta_pdf}/EXTRA_${cidade}_$(date +%Y%m%d).pdf
	
	#Primeira verificação para saber se houve edital extra do dia
	wget -O ${extra_pdf_save} ${url_final}
	exc=$(echo $?)
	if [[ "${exc}" -eq "0" ]]; then
		chmod 777 ${extra_pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${extra_pdf_save}
		exc=$(echo $?)
		if [[ "${exc}" -eq "0" ]]; then
			sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
			sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
			sendDocumentBot "${extra_pdf_save}" "$3"
			else
				sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital extra de hoje" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${extra_pdf_save}" "$3"
		fi
	else
		sendMessageBot "Não houve edital EXTRA de ${cidade} hoje" "$3"
	fi
	
	#Segunda verificação se houve edital normal no dia
	pdf_day=$(curl -sS ${url} | grep -E -o "uploads/pdf/[0-9].*.pdf")
	if [[ ${pdf_day} ]]; then
		url_final="${url}${pdf_day}"
		wget -O ${pdf_save} ${url_final}
		chmod 777 ${pdf_save}; /usr/bin/pdfgrep -i "${pattern}" ${pdf_save}
		exc=$(echo $?)
		if [[ "${exc}" -eq "0" ]]; then
			sendMessageBot "AVISO ${cidade} - Corra ver no site, seu nome foi citado no edital de hoje!!!" "$3"
			sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
			sendDocumentBot "${pdf_save}" "$3"
			else
				sendMessageBot "AVISO ${cidade} - Seu nome não foi citado no edital de hoje" "$3"
				sendMessageBot "estou enviando o PDF para você poder confirmar..." "$3"
				sendDocumentBot "${pdf_save}" "$3"
		fi
	fi

}