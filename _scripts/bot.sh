#/bin/bash
#
BASEDIR=$(dirname "$0")
apiUrl="https://api.travis-ci.org/repo/dodopontocom%2Fdiario_itatiba_robo/requests"
branch="develop"
token=$(cat ${BASEDIR}/travis_token.txt)

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
	
	#send travis API request to trigger a build
	body='{
	"request": {
	"message": "${message_chat_id[$id]}:\"${message_text}\"",
	"branch":"${branch}",
	}}'

	curl -X POST -H "Content-Type: application/json" \
	-H "Travis-API-Version: 3" \
	-H "Accept: application/json" \
	-H "Authorization: token ${token}" \
	-d "${body}" \
	${apiUrl}
	
    ) &  # Criando thread
    done
done
