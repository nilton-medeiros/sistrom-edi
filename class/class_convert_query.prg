/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 15-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: class_convert_query.prg
 Classe: TConvertQuery - Classe de Banco de Dados para convert Objeto Query MySQL
***********************************************************************************/

#include <hmg.ch>
#include "hbclass.ch"

class TConvertQuery

      data row protected

      method new(row) constructor
      method getField(params)
      method lenField(field)
      method putField(field, value)
      method destroy() INLINE ::row := NIL
      method padCenter(field_name_or_number, width, fill)
      method padLeft(field_name_or_number, width, fill)
      method padRight(field_name_or_number, width, fill)
      method zeroFill(field_name_or_number, width)

end class

method new(row) class TConvertQuery
    ::row := row
return self

method getField(field, format_command) class TConvertQuery
       local result_field, obtained_field
       default field := 1
       default format_command := ''

       //  Não confundir esta linha com a linha da class_query, aqui é ::row e lá é ::query [no ::row é FIELDGET e não getField!]
       obtained_field := ::row:FieldGet(field)

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

method lenField(field) class TConvertQuery
return ::row:FieldLen(iif(ValType(field) == "N", field, ::row:FieldPos(field)))

method putField(field, value) class TConvertQuery
return ::row:FieldPut(field, value)

method padCenter(field_by_name_or_number, width, fill) class TConvertQuery
      // Pega o FieldLen da estrutura do campo não importando em que posição está o row na query
      default width := ::lenField(field_by_name_or_number)
      default fill := " "
      // Retorna o campo formatado na posição corrente da query
return hb_UPadC(::getField(field_by_name_or_number), width, fill)

method padLeft(field_by_name_or_number, width, fill) class TConvertQuery
      local x
      default width := ::lenField(field_by_name_or_number)
      default fill := " "
      x := ::getField(field_by_name_or_number)
      if ValType(x) == "C"
         x := AllTrim(Right(x, width))
      endif
return hb_UPadL(x, width, fill)

method padRight(field_by_name_or_number, width, fill) class TConvertQuery
      default width := ::lenField(field_by_name_or_number)
      default fill := " "
return hb_UPadR(::getField(field_by_name_or_number), width, fill)

method zeroFill(field_by_name_or_number, width) class TConvertQuery
      local result := ::getField(field_by_name_or_number)
      default width := ::lenField(field_by_name_or_number)
      if ValType(result) == 'C'
         result := AllTrim(hb_URight(result, width))
      endif
return hb_UPadL(result, width, "0")
