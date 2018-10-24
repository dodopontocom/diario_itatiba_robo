[![Build Status](https://travis-ci.org/dodopontocom/diario_itatiba_robo.svg?branch=develop)](https://travis-ci.org/dodopontocom/diario_itatiba_robo)
[![Docker Automated build](https://img.shields.io/docker/automated/rodolfoneto/diario_itatiba_robo.svg)](https://hub.docker.com/r/rodolfoneto/diario_itatiba_robo/)
[![Docker Build Status](https://img.shields.io/docker/build/rodolfoneto/diario_itatiba_robo.svg)](https://hub.docker.com/r/rodolfoneto/diario_itatiba_robo/)
[![Docker Pulls](https://img.shields.io/docker/pulls/rodolfoneto/diario_itatiba_robo.svg)](https://hub.docker.com/r/rodolfoneto/diario_itatiba_robo/)

# diario_itatiba_robo
Ferramenta para buscar nomes/padrões na Imprensa Oficial de Prefeituras do Brasil.  

### Atualmente disponível para as cidades:

- [x] Itatiba
- [ ] Outras...

## Requerimentos  

|Pacote| Descrição|  
|---------|--------------|  
|telegram|https://telegram.org|  

> Registre-se no Telegram.    

# Descrição  
* Para você que passou em concurso e aguarda o seu nome ser chamado  
* Ou precisa pesquisar outros padrões (frases) no diário oficial da sua cidade

É publicado em versão de PDF(https://pt.wikipedia.org/wiki/Portable_Document_Format)  

A string da url para o nome do pdf é baseada na seguinte linha de padrão:  
dd.mm.aaaa.pdf =====> exemplo: 09.08.2018.pdf  
url completa:  
http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/aaaa/mm/dd.mm.aaaa.pdf  
exemplo: http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/2018/08/09.08.2018.pdf  

# Cron Job  
cron job do linux para executar o script as 9:00am todos os dias que o diário é publicado no site  
**0 9 * * 2,4,6 /usr/bin/bash ~/diario_itatiba_robo/oficial.sh**  

# Anotações do autor  

baixar ubuntu para odroid-c2 - https://wiki.odroid.com/odroid-c2/os_images/ubuntu/v3.0  
sudo dd if=ubuntu-18.04-3.10-mate-odroid-c1-20180726.img of=/dev/mmcblk0 bs=1M conv=fsync    
sudo sync  
https://etcher.io  

locale-gen pt_BR pt_BR.UTF-8 en_US en_US.UTF-8  

set date as SAO_PAULO ...  
sudo mv /etc/localtime /etc/localtime_bkp  
sudo ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime 
date  

wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64  
chmod +x jq-linux64  
sudo mv jq-linux64 $(which jq)

possível erro pode acontecer com pdfgrep, how to fix:    
export LC_ALL="en_US.UTF-8"
