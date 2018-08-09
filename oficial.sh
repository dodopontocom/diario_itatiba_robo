#/bin/bash
#script funciona apenas para o padrao do diario 
#oficial de itatiba, para outras cidades, ajustes devem ser feitos

#author: rodolfotaigo@gmail.com
#script name: oficial.sh
#version: 0.1

pTest="atos oficiais"
padrao="carvalho de oliveira neto"
pattern=$1
if [[ -z ${pattern} ]]; then
	pattern=${padrao}
fi
url_exemplo="http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/2018/08/09.08.2018.pdf"
anoMes="$(date +%Y/%m)"
pdf_name="$(date +%d.%m.%Y).pdf"
pdf_itatiba="http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/${anoMes}/${pdf_name}"
echo "buscando informacoes do site:"
echo "${pdf_itatiba}"

#if ls ./*.pdf* 1> /dev/null 2>&1; then
#if ls | grep -E "[0-9]{2}.[0-9]{2}.[0-9]{4}.pdf" 1> /dev/null 2>&1; then
if ls "${pdf_name}" 1> /dev/null 2>&1; then
	echo "pdf de hoje encontrado..."
	echo "executando primeiro teste..."
	find . -iname '*.pdf' -exec pdfgrep -i "${pTest}" {} + 1> /dev/null 2>&1
	if [[ "$?" -eq "0" ]]; then
		echo "primeiro teste executado com sucesso!!!"
		else
			echo "houve algum erro ao baixar o pdf, tente novamente mais tarde..."
			exit -1	
	fi
	echo "procurando padrao: ${pattern}..."
	find . -iname '*.pdf' -exec pdfgrep -i "${pattern}" {} +
	if [[ "$?" -ne "0" ]]; then
		echo "padrao nao foi encontrado!!!"
	fi
	else 
		echo "baixando o pdf de hoje..."
		echo "executando primeiro teste..."
		find . -iname '*.pdf' -exec pdfgrep -i "${pTest}" {} +
		if [[ "$?" -eq "0" ]]; then
			echo "primeiro teste executado com sucesso!!!"
			else
				echo "houve algum erro ao baixar o pdf, tente novamente mais tarde..."
				exit -1
		fi
		echo "procurando padrao: ${pattern}..."
		wget ${pdf_itatiba} 1> /dev/null 2>&1
		if [[ "$?" -ne "0" ]]; then
			echo "hoje nao houve registro no diario oficial de itatiba"
			exit -1
		fi
		find . -iname '*.pdf' -exec pdfgrep -i "${pTest}" {} + 1> /dev/null 2>&1
		if [[ "$?" -ne "0" ]]; then
			echo "padrao nao foi encontrado!!!"
		fi
fi

