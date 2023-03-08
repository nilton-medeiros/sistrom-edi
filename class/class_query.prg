/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 12-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: class_query.prg
 Classe: TSQLQuery - Classe de Banco de Dados para consulta SQL do MySQL
***********************************************************************************/

#include <hmg.ch>
#include "hbclass.ch"

class TSQLQuery

      data query as object readonly
      data sql readonly
      data cargo        // Usado para armazenar qualquer informação

      method new(sql) constructor
      method executeQuery()
      method isExecuted(warning) setget
      method getQuery() inline ::query  // Manter por compatibilidade
      method getRow(nRow)
      method goTop() inline ::query:goTop()
      method goTo(nRow) inline ::query:goTo(nRow)
      method eof() inline ::query:EOF()
      method skip(nRows) inline ::query:Skip(nRows)
      method recNo() inline ::query:RecNo()
      method lastRec() inline ::query:LastRec()
      method fCount() inline ::query:FCount()
      method getField(field, format_command)
      method lenField(field)
      method destroy() setget
      method serverBusy()
      method padCenter(field_by_name_or_number, width, fill)
      method padLeft(field_by_name_or_number, width, fill)
      method padRight(field_by_name_or_number, width, fill)
      method zeroFill(field_by_name_or_number, width)

end class

method new(sql) class TSQLQuery
       local msg

       with object MemVar->app
            ::sql := sql

            if ! :mysql:connected
               if ! :mysql:connect()
                  return self
               endif
            endif

            msg := status_message('Executando consulta no banco de dados...')

            if ::executeQuery()
               ::query:GoTop()
               status_message(msg)
            endif

       end with

return self

method executeQuery() class TSQLQuery
       local y as numeric

       with object MemVar->app:mysql

           ::query := :server:Query(::sql)

           if ::query == NIL

               if ! :connect()
                   status_message('Banco de Dados não conectado!')
                   saveLog('Banco de Dados não conectado!')
                   return false
               endif

               ::query := :server:Query(::sql)

               if ::query == NIL
                   status_message('Erro de SQL!', true, 'Aviso ao Suporte', MB_ICONERROR)
                   System.Clipboard := 'Erro ao executar ::query![Query is NIL]' + hb_eol() + hb_eol()
                   System.Clipboard := System.Clipboard + ProcName(2) + '(' + hb_NToS(ProcLine(2)) + ')' + hb_eol()
                   System.Clipboard := System.Clipboard + ProcName(1) + '(' + hb_NToS(ProcLine(1)) + ')' + hb_eol()
                   System.Clipboard := System.Clipboard + ProcName(0) + '(' + hb_NToS(ProcLine(0)) + ')' + hb_eol() + hb_eol()
                   System.Clipboard := System.Clipboard + hb_eol() + hb_eol() + sql
                   saveLog(System.Clipboard)
                   msg_debug_info({'Erro ao executar ::query, avise ao suporte!', hb_eol()+hb_eol(), 'Ver Clipboard, Erro: Query is NIL'})
                   return false
               endif

           endif

           if ::serverBusy()
               ::query:destroy()
               status_message('Servidor ocupado...')

               if ! :connect()
                   saveLog('Banco de Dados não conectado!')
                   status_message('Banco de Dados não conectado!')
                   return false
               endif

               for y := 1 to 2  // Tenta consultar DB por duas vezes
                   ::query := :server:Query(::sql)
                   if ! ::serverBusy()
                       exit
                   endif
                   pause_system(1)
               next

               if ::serverBusy()
                   System.Clipboard := 'Servidor ocupado, tente mais tarde!' + hb_eol()+hb_eol()
                   System.Clipboard := System.Clipboard + ProcName(2) + '(' + hb_NToS(ProcLine(2)) + ')' + hb_eol()
                   System.Clipboard := System.Clipboard + ProcName(1) + '(' + hb_NToS(ProcLine(1)) + ')' + hb_eol()
                   System.Clipboard := System.Clipboard + ProcName(0) + '(' + hb_NToS(ProcLine(0)) + ')' + hb_eol() + hb_eol()
                   System.Clipboard := System.Clipboard + ::query:Error()
                   saveLog(System.Clipboard)
                   status_message('Servidor ocupado!')
                   msg_debug_info({'Servidor ocupado, tente mais tarde!', hb_eol()+hb_eol(), 'Ver Clipboard, mensagem: ', hb_eol(), ::query:Error()})
                   ::query:destroy()
                   return false
               endif

           endif

       end with

return true

method serverBusy() class TSQLQuery
return (::query:NetErr() .and. 'server has gone away' $ ::query:Error())

method isExecuted(warning) class TSQLQuery
       local executed := false
       local table as character
       local mode as character
       local command as character
       default warning := true

       if (::query == NIL)
           status_message('Banco de Dados Sem conexão')
       else
           command := hmg_Upper(first_word(StrTran(::query:cQuery, ";")))
           do case
           case command $ "SELECT|DELETE"
               table := hb_USubStr(::query:cQuery, hb_UAt(' FROM ', ::query:cQuery))
               table := first_word(hb_USubStr(table, 7))
               mode := iif(command == 'SELECT', 'selecionar', 'excluir')
           case command == "INSERT"
               table := hb_USubStr(::query:cQuery, hb_UAt(' INTO ', ::query:cQuery))
               table := first_word(hb_USubStr(table, 7))
               mode := "incluir"
           case command == "UPDATE"
               table := hb_USubStr(::query:cQuery, hb_UAt(' ', ::query:cQuery))
               table := first_word(table)
               mode := 'alterar'
           OTHERWISE   // START, ROOLBACK ou COMMIT
               table := ''
               mode :=  'executar transação'
           endcase
           if ! Empty(table)
               table := Capitalize(table)
           endif
           if ::query:NetErr()
               if 'Duplicate entry' $ ::query:Error()
                   saveLog('Erro de duplicidade ao ' + mode + ' ' + table + hb_eol() + ansi_to_unicode(::sql))
               else
                   saveLog('Erro ao ' + mode + iif(Empty(table), ' ', ' na tabela de ' + table) + hb_eol() + ::query:Error() + hb_eol() + hb_eol() + ansi_to_unicode(::query:cQuery))
               endif
               ::query:destroy()
               status_message('Erro de SQL!', true, 'Aviso ao Suporte', MB_ICONERROR)
           elseif (command $ "SELECT|START|ROOLBACK|COMMIT")
               // Query SELECT executada com sucesso!
               executed := true
               ::query:goTop()
           else
               // Query INSERT, UPDATE ou DELETE executada com sucesso!
               if (mysql_affected_rows(::query:nSocket) == 0)
                 status_message('Não foi possível ' + mode + ' na tabela de ' + table)

                 /* ATENÇÃO: NÃO SALVAR NO LOG ::query:cQuery, pois expõe todo o SQL podendo conter senha de usuário */
                 /* Para Debugar use: System.Clipboard := ::query:cQuery */

                  if warning
                     MsgExclamation({'Não foi possível ' + mode + ' na tabela de ' + table + '.Talvez você NÃO tenha alterado nada ou alguém já o tenha feito um momento antes.', hb_eol()+hb_eol(),;
                                      'Erro: ', 'Registros afetados: ', mysql_affected_rows(::query:nSocket), hb_eol(), mysql_error(::query:nSocket)},;
                                      iif(command == 'INSERT', 'Inclusão', IF(command == 'UPDATE', 'Alteração', 'Exclusão')) + ' não efetuada!')
                  endif
                  saveLog('Não foi possível ' + mode + ' na tabela de ' + table + hb_eol() + 'Registros afetados: ' + hb_NToS(mysql_affected_rows(::query:nSocket)) + ' - Error: ' + mysql_error(::query:nSocket))
                  ::query:destroy()
                elseif (mysql_affected_rows(::query:nSocket) < 0)
                    saveLog('Não foi possível ' + mode + ' na tabela de ' + table + hb_eol() + 'Erro de SQL - Registros afetados: ' + hb_NToS(mysql_affected_rows(::query:nSocket)) + hb_eol() + 'Error: ' + mysql_error(::query:nSocket))
                    status_message('Não foi possível ' + mode + ' na tabela de ' + table)
                    MsgExclamation({'Não foi possível ' + mode + ' na tabela de ' + table + '; Erro de SQL, avise ao suporte.',CRLF+CRLF,'Erro: ', 'Registros afetados: ', mysql_affected_rows(::query:nSocket), hb_eol(), mysql_error(::query:nSocket)}, IF(command == 'INSERT', 'Inclusão', IF(command == 'UPDATE', 'Alteração', 'Exclusão')) + ' não efetuada!')
                    ::query:Destroy()
               else
                  executed := true
               endif
           endif
       endif

return executed

method getField(field, format_command) class TSQLQuery
       local result_field, obtained_field
       default field := 1
       default format_command := ''

       // Verifica se o campo solicitado realmente existe na query
       if ValType(field) == 'C'
          if ::query:FieldPos(field) == 0
            msg_debug_info({'Campo inexistente: ', field, hb_eol(), 'Avise o suporte!'})
            saveLog('Campo <' + field + '> inexistente! SQL-> ' + ::query:cQuery)
            return NIL
          endif
       elseif ValType(field) == 'N' .and. Empty(::query:FieldName(field))
            saveLog('Campo <' + hb_NToS(field) + '> inexistente! SQL-> ' + ::query:cQuery)
            msg_debug_info({'Campo inexistente: ', hb_NToS(field), hb_eol(), 'Avise o suporte!'})
            return NIL
       endif

       // ATENÇÃO! ::query é FIELDGET e NÃO getField
       obtained_field := ::query:FieldGet(field)

       if ValType(obtained_field) == "C"
          result_field := ansi_to_unicode(obtained_field)
          if ! Empty(format_command)
             result_field := format_text(result_field, format_command)
          endif
       elseif ValType(obtained_field) == "N"
            result_field := obtained_field
            if ! Empty(format_command)
               result_field := format_number(obtained_field, format_command)
            endif
       elseif ValType(obtained_field) == "D" .and. format_command == 'as string'
            result_field := Transform(DToS(obtained_field), "@R 9999-99-99")
       else
            result_field := obtained_field
       endif

return result_field

method lenField(field) class TSQLQuery
return ::query:FieldLen(iif(ValType(field) == "N", field, ::query:FieldPos(field)))

method padCenter(field_by_name_or_number, width, fill) class TSQLQuery
       // Pega o FieldLen da estrutura do campo não importando em que posição está o row na query
       default width := ::lenField(field_by_name_or_number)
       default fill := " "
       // Retorna o campo formatado na posição corrente da query
return hb_UPadC(::getField(field_by_name_or_number), width, fill)

method padLeft(field_by_name_or_number, width, fill) class TSQLQuery
       local x
       default width := ::lenField(field_by_name_or_number)
       default fill := " "
       x := ::getField(field_by_name_or_number)
       if ValType(x) == "C"
          x := AllTrim(Right(x, width))
       endif
return hb_UPadL(x, width, fill)

method padRight(field_by_name_or_number, width, fill) class TSQLQuery
    default width := ::lenField(field_by_name_or_number)
    default fill := " "
return hb_UPadR(::getField(field_by_name_or_number), width, fill)

method zeroFill(field_by_name_or_number, width) class TSQLQuery
    local result := ::getField(field_by_name_or_number)
    default width := ::lenField(field_by_name_or_number)
    if ValType(result) == 'C'
       result := AllTrim(hb_URight(result, width))
    endif
return hb_UPadL(result, width, "0")

method getRow(nRow) class TSQLQuery
return TConvertQuery():new(::query:getRow(nRow))

method destroy() class TSQLQuery
       if ValType(::query) == 'O'
          ::query:destroy()
       endif
       ::query := NIL
return NIL
