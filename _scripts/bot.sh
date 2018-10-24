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
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "${chat_id}"
    ) &  # Criando thread
    done
done
