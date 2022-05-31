/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: open_logs.prg
 Rotinas: open_log_folder() Invoca o Explorer do Windows na pasta de logs
***********************************************************************************/

#include <hmg.ch>

procedure open_log_folder()
          local path := hb_cwd() + 'log\'
          saveLog('Acesso a pasta de Logs')
          EXECUTE FILE 'Explorer' PARAMETERS (path)
return