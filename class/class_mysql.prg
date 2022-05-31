/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: class_mysql.prg
 Classe: TMySQL - Classe de Banco de Dados para conexão com MySQL
***********************************************************************************/

#include <hmg.ch>
#include 'hbclass.ch'

class TMySQL

      data dataBase readonly
      data address readonly
      data userName readonly
      data password readonly
      data iconStatus init 'waiting_server_icon' readonly
      data connected init false readonly
      data connectedStatus init 'Desconectado' readonly
      data server as object readonly

      method new(initialParameters) constructor
      method connect()
      method disconnect()
      method showDBStatus(item_msg, icon_status)
      method tryConnect()
end class

method new(initialParameters) class TMySQL
      ::address := hb_HGetDef(initialParameters, 'address', '')
      ::userName := hb_HGetDef(initialParameters, 'userName', '')
      ::dataBase := hb_HGetDef(initialParameters, 'dataBase', ::userName)
      ::password := hb_HGetDef(initialParameters, 'password', '')
return self

method connect() class TMySQL
      local error_msg, retValue

      if ! ::tryConnect()

         // Tenta de novo
         if ! ::tryConnect()
            if ::server == NIL
               PlayAsterisk()
               error_msg := "Não foi possível conectar ao servidor MySQL '" + ::address + "'"
               saveLog('Servidor indisponível' + hb_eol() + error_msg)
               MsgStop(error_msg, 'Servidor indisponível, tente mais tarde!')
               ::disconnect()
               return false
            elseif ::server:NetErr()
               PlayAsterisk()
               error_msg := 'Não foi possível conectar ao servidor MySQL "' + ::address + '"' + hb_eol() +;
                            '     Possíveis problemas:' + hb_eol() +;
                            '        - Login não permitido' + hb_eol() +;
                            '        - Senha do Banco de Dados inválida'+ hb_eol() +;
                            '        - Sem conexão com a Internet. Verifique sua internet' + hb_eol() +;
                            '     Erro: ' + ::server:Error()
               saveLog(error_msg)
               ::disconnect()
               retValue := MessageBoxTimeout(error_msg, 'Falha de Conexão!', MB_ICONERROR + MB_RETRYCANCEL, 600000)
               if (retValue == IDTIMEDOUT) .or. (retValue == IDRETRY)
                  if !::tryConnect()
                     MsgStop(error_msg, 'Falha de Conexão!')
                     return false
                  endif
               else // IDCANCEL
                  turnOFF(true)
               endif
            endif
         endif

      endif

      ::server:selectDB(::dataBase)
      ::connected := !::server:NetErr()

      if !::connected
         PlayAsterisk()

         error_msg := 'Não foi possível conectar ao Banco de Dados MySQL "' + ::dataBase + '"' + hb_eol()+hb_eol() +;
			'Servidor: ' + ::address

         saveLog(error_msg)
         ::disconnect()
         status_message('Banco de Dados indisponível')
         MessageBoxTimeout(error_msg, 'Banco de Dados indisponível!', MB_ICONERROR, 120000)

      else
         ::iconStatus := 'server_on_icon'
         ::connectedStatus := 'Conectado'
         ::showDBStatus()
         //MsgInfo(mysql_get_host_info( ::server:nSocket), 'Informações do Host') -- Traz o IP ou localhost
         //MsgInfo(mysql_get_server_info(::server:nSocket), 'Informações do Server') -- Traz a versão do MySQL
      endif

return ::connected

method disconnect() class TMySQL
      ::connected := false
      ::connectedStatus := 'Desconectado'
      ::iconStatus := 'server_off_icon'
      if ValType(::server) == 'O'
         ::server:Destroy()
      endif
      ::server := NIL
      ::showDBStatus()
return NIL

method tryConnect() class TMySQL
       ::disconnect()
       if !Empty(::dataBase) .and. !Empty(::address) .and. !Empty(::userName) .and. !Empty(::password)
          ::showDBStatus('Conectando...', 'waiting_server_icon')
          ::server := TMySQLServer():new(::address, ::userName, ::password)
       else
          saveLog('Parametros do banco de dados nao definidos!')
          status_message('Paramentros do Banco de Dados não definidos!', true, 'Conexão com Banco de Dados', MB_ICONWARNING, 30000)
          ::showDBStatus()
       endif
return ! ::server == NIL .and. ! ::server:NetErr()

method showDBStatus(item_msg, icon_status) class TMySQL
       if isWindowActive(Main)
          default item_msg := ::connectedStatus
          default icon_status := ::iconStatus
          SetProperty('Main', 'StatusBar', 'Item', 3, item_msg)
          SetProperty('Main', 'StatusBar', 'Icon', 3, icon_status)
          ::iconStatus := icon_status
       endif
return NIL