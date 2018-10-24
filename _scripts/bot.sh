#/bin/bash
#
BASEDIR=$(dirname "$0")
#chamar o bot
source ./ShellBot.sh

ShellBot.init --token $(cat ${BASEDIR}/token.txt) --monitor --return value

while :
do
    # Obtem as atualizações
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
    
    # Lista as atualizações.
    for id in $(ShellBot.ListUpdates)
    do
    # bloco de instruções
    (
    	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "${message_chat_id[$id]}"
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "\"${message_text}\""
    ) &  # Criando thread
    done
done
