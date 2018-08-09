# diario_itatiba_robo
Robô em shell com objetivo de buscar nomes/padrões no diário oficial da cidade de Itatiba.  

### pre requisito "pdfgrep"  
(sistemas ubuntu e derivados): # apt-get install pdfgrep  

# Descrição  
O diário oficial de itatiba é publicado todas as terças, quintas e sábados (segundo última atualização desse repositório dia 09 de agosto de 2018) no site: http://www.itatiba.sp.gov.br  

É publicado em versão de PDF(https://pt.wikipedia.org/wiki/Portable_Document_Format)  

A string da url é baseada na seguinte linha de padrão:  
dd.mm.aaaa.pdf ===== exemplo: 09.08.2018.pdf  
url completa:  
http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/aaaa/mm/dd.mm.aaaa.pdf  
exemplo: http://www.itatiba.sp.gov.br/templates/midia/Imprensa_Oficial/2018/08/09.08.2018.pdf  

# Cron Job  
cron job do linux para executar o script as 9:00am todos os dias que o diário é publicado no site  
**0 9 * * 2,4,6 /usr/bin/bash ~/diario_itatiba_robo/odificial.sh**    
