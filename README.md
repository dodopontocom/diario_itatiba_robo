`(travis-ci)` [![Build Status](https://travis-ci.org/dodopontocom/diario_itatiba_robo.svg?branch=develop)](https://travis-ci.org/dodopontocom/diario_itatiba_robo)
# diario_itatiba_robo
Repositório para o script que busca nomes/padrões no diário oficial(pdf) da cidade de Itatiba.  

## Requerimentos  

|Pacote| Descrição|  
|---------|--------------|  
|pdfgrep (versão 1.3.0 ou superior)|https://pdfgrep.org/|  
> Certifique-se que todos os pacotes estão instalados.    

# Descrição  
O diário oficial de itatiba é publicado todas as terças, quintas e sábados (segundo última atualização desse repositório dia 09 de Setembro de 2018) no site: http://www.itatiba.sp.gov.br  

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
