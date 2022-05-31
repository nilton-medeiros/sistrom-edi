/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: functions_db.prg
 Rotinas: Diversas funções e procedures auxiliares para o banco de dados
***********************************************************************************/

#include <hmg.ch>

function ansi_to_unicode(string)
return hmg_ansi_to_unicode(AllTrim(string))

function unicode_to_ansi(string)
return hmg_unicode_to_ansi(mysql_escape_string(AllTrim(string)))

function select_count(table)
    local count := 0
    local query := TSQLQuery():new('SELECT COUNT(*) FROM ' + table)

    if query:isExecuted
       count := query:getField(1)
       query:destroy()
       if ! ValType(count) == 'N'
          count := 0
       endif
    endif

return count

function datetime_db_to_br(datetime, week)
    local date
    default week := false

    if ! Empty(datetime)
       date := hb_USubStr(datetime, 9, 2) + hb_USubStr(datetime, 5, 4) + hb_ULeft(datetime, 4)   // Convert  "9999-99-99 99:99:99:99999" p/ "99-99-9999"
       if week
          // Mostrar o dia da semana
          date := date_and_week(hb_CToD(date))
       endif
       datetime := date + hb_USubStr(datetime, 11, 6)  // Acresenta a hora ao formato "99-99-9999" para !lShowWeek ou "Sem 99-99-9999" para lShowWeek
    endif
return datetime

function delete_record_from_db(table, id, msg)
    local deleted := false
    local query
    default msg := Capitalize(table)

    if id == '0'
       MsgExclamation('id = 0 - Registro de sistema, exclusão não permitida.', 'Exclusão não permitida!')
       return false
    endif

    table := hmg_Lower(table)
    query := TSQLQuery():new('DELETE FROM ' + table + ' WHERE emp_id=' + id)
    status_message('Excluindo ' + msg + '...')

    if (deleted := query:isExecuted())
       saveLog(msg + ' id: ' + id + ' excluído do banco de dados tabela ' + table)
       status_message('Status: ' + msg + 'excluído com sucesso!', true, 'Exclusão de Registro', MB_ICONINFORMATION)
    endif

return deleted

function IFNULL(field)
         if Empty(field)
            return 'NULL'
         endif
return "'" + unicode_to_ansi(field) + "'"

function logical_to_tinyint_db(logical)
return iif(logical, '1', '0')

function phoneformated_to_db(phone)
         phone := get_numbers(phone)
         if ! Empty(phone)
            if hb_ULen(phone) < 10
               phone := hb_UPadL(AllTrim(hb_URight(phone, 10)), 10, '0')
            endif
            phone := hb_ULeft(phone, 2) + ' ' + hb_USubStr(phone, 3)
         endif
return IFNULL(phone)

Function get_next_insert_id(table)
   Local next_id := 0
   Local query
   Local sql := "SELECT next_insert_id('" + hmg_lower(table) + "') AS next_id;"

   query := TSQLQuery():NEW(sql)

   if query:isOpen()
      if ! (query:LastRec() == 0)
         next_id := query:FieldGet('next_id')
      end
   end

Return (next_id)


/*
   Explorar as formas de data com a função hb_dtoc(date, format)
   ? hb_datetime()
	? hb_dtoc(hb_datetime(), 'yyyy.mm.dd')
*/
Function datetime_hb_to_mysql(dDate, cTime)
   local cDateSQL

   if Empty(dDate)
       cDateSQL := "NULL"
   else
       cDateSQL := Transform(DToS(dDate), "@R 9999-99-99")
       IF ValType(cTime) == "C" .AND. !Empty(cTime)
           cDateSQL += " " + cTime
       ENDIF
       cDateSQL := "'" + AllTrim(cDateSQL) + "'"
   ENDIF

Return cDateSQL
