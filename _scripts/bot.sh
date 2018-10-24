#/bin/bash

#chamar o bot
source ${BASEDIR}/../ShellBot.sh

ShellBot.init --token $(cat ${BASEDIR}/token.txt) --monitor --return value

while :
do
    # Lista as atualizações.
    for id in $(ShellBot.ListUpdates)
    do
    # bloco de instruções
    (
	if [[ -s ${sourceFile} ]]; then
		ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(cat ${sourceFile})"
		if [[ -s ${pdfFile} ]]; then
			ShellBot.sendDocument --chat_id $usuario_id --document @${pdfFile}
		fi
		else
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "😔 ops, nao foi encontrado registro no diário oficial ainda hoje"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "aguarde nas terças/quintas ou sábados, eu vou te atualizar com certeza!"	
		fi
    ) &  # Criando thread
    done
done
