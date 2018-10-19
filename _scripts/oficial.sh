#/bin/bash
#script funciona apenas para o padrao do diario 
#oficial de itatiba, para outras cidades, ajustes devem ser feitos

#author: rodolfotiago@gmail.com
#script name: oficial.sh
#version: 0.1

BASEDIR=$(dirname "$0")
echo "$BASEDIR"

bkpFolder=~/gitfolder/diarioPDFs
flagLog=/tmp/findornot.log
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

#criando pasta de bkp para os pdfs
if [[ ! -f ${bkpFolder} ]]; then
	mkdir -p ${bkpFolder}
fi

echo "buscando informacoes do site:"
echo "${pdf_itatiba}"

if [[ -f "${BASEDIR}/${pdf_name}" ]]; then
	echo "pdf de hoje encontrado..."
	echo "executando primeiro teste..."
	chmod 777 ${BASEDIR}/${pdf_name}; /usr/bin/pdfgrep -i "${pTest}" ${BASEDIR}/${pdf_name}
	if [[ "$?" -eq "0" ]]; then
		echo "primeiro teste executado com sucesso!!!"
		else
			echo "houve um erro ao baixar o pdf, tente diretamente no site:" > ${flagLog}
			echo "${url}" >> ${flagLog}
			exit -1	
	fi
	echo "procurando padrao: ${pattern}..."
	chmod 777 ${BASEDIR}/${pdf_name}; /usr/bin/pdfgrep -i "${pattern}" ${BASEDIR}/${pdf_name}
	if [[ "$?" -eq "0" ]]; then
		echo "padrao encontrado..."
		echo "oi Thaís, 💖 seu nome foi encontrado no diario oficial de Itatiba, corra ver no site:" > ${flagLog}
		echo "${pdf_itatiba}" >> ${flagLog}
		else
			echo "padrao nao foi encontrado!!!"
			echo "oi Thaís, 😔 por enquanto seu nome nao saiu no diário oficial de Itatiba" > ${flagLog}
			echo "...pode ficar tranquila que eu te aviso quando vc for chamada ;)" >> ${flagLog}
	fi
	else 
		echo "baixando o pdf de hoje..."
		wget ${pdf_itatiba} -P ${BASEDIR}
		if [[ "$?" -ne "0" ]]; then
			echo "hoje nao houve registro no diario oficial de itatiba" > ${flagLog}
			exit 0
		fi
		echo "copiando pdf para a tmp"
		cp ${BASEDIR}/${pdf_name} /tmp/
		echo "executando primeiro teste..."
		chmod 777 ${BASEDIR}/${pdf_name}; /usr/bin/pdfgrep -i "${pTest}" ${BASEDIR}/${pdf_name}
		if [[ "$?" -eq "0" ]]; then
			echo "primeiro teste executado com sucesso!!!"
			else
				echo "erro ao executar comando pdfgrep, tente diretamente no site:" > ${flagLog}
				echo "${url}" >> ${flagLog}
				exit -1
		fi
		echo "procurando padrao: ${pattern}..."
		chmod 777 ${BASEDIR}/${pdf_name}; /usr/bin/pdfgrep -i "${pattern}" ${BASEDIR}/${pdf_name}
		if [[ "$?" -eq "0" ]]; then
			echo "padrao encontrado..."
			echo "oi Thaís, 💖 seu nome foi encontrado no diário oficial de Itatiba, corra ver no site:" > ${flagLog}
			echo "${pdf_itatiba}" >> ${flagLog}
			else
				echo "padrao nao foi encontrado!!!"
				echo "oi Thaís, 😔 por enquanto seu nome nao saiu no diário oficial de Itatiba" > ${flagLog}
				echo "...pode ficar tranquila que eu te aviso quando vc for chamada ;)" >> ${flagLog}
		fi
fi
echo "script end"
sleep 1
exit 0