/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: general_routines.prg
 Rotinas: Diversas Funções e procedures auxiliares
***********************************************************************************/

#include <hmg.ch>
#include <fileio.ch>

procedure saveLog(msg)
          local log, handle
          local cDate := dtoc(Date())
          local folder := hb_cwd() + 'log'+hb_ps()
          local logFile := 'log' + hb_URight(cDate,2) + hb_USubStr(cDate,4,2) + '.txt'

          if hb_FileExists(folder+logFile)
             handle := fOpen(folder+logFile, FO_WRITE)
             fSeek(handle, 0, FS_END)
          else
             handle := hb_FCreate(folder+logFile, FC_NORMAL)
             fWrite(handle, 'Log do Sistema de Sistrom-EDI Proceda - v.' + MemVar->app:version + hb_eol() + hb_eol())
          endif

          log := cDate + ' ' + time() + '| Usuário: ' + hb_UPadR(app:getUser, 20) + hb_UPadR(' | Processo: ' + AllTrim(ProcName(1)), 35) + '| Linha: ' + Transform(ProcLine(1), "9999")
          log += ' | ' + msg + hb_eol()

          fWrite(handle, log)
          fClose(handle)

return

function is_true(boolean)
         if ValType(boolean) == 'L'
            return boolean
         elseif ValType(boolean) == 'N'
            return boolean > 0
         endif
return false

function status_message(message, dialog, title, icon, milliSeconds)
         local return_message := 'Status'
         local form_name := ''
         local form_index := GetLastActiveFormIndex()

         default message := 'Status'
         default dialog := false
         default milliSeconds := 10000  // 10 segundos

         if form_index > 0
            form_name := GetFormNameByIndex(form_index)
            if ! _isControlDefined('StatusBar', form_name)
               form_name := 'Main'
            endif
            return_message := GetProperty(form_name, 'StatusBar', 'Item', 1)
            SetProperty(form_name, 'StatusBar', 'Item', 1, message)
         endif

         if dialog
            if hb_ULeft(hmg_lower(message), 6) == 'status'
               message := hb_USubStr(message, hb_At(' ', message)+1)
            endif
            MessageBoxTimeout(message, title, icon, milliSeconds)
         endif

return return_message

procedure msg_debug_info(in_msg)
   local out_msg := {'Chamado de: ', ProcName(1) + '(' + hb_NToS(ProcLine(1)) + ') -->', hb_eol()}
   local msg
   if (ValType(in_msg) == 'A')
      for each msg in in_msg
         AAdd(out_msg, msg)
      next
   else
      AAdd(out_msg, in_msg)
   endif
   MsgInfo(out_msg, 'DEBUG INFO')
return

function first_word(string)
         local pos as numeric

         if ! Empty(string)
             string := LTrim(string)
             pos := hb_UAt(' ', string)
             if pos == 0
               pos := hb_ULen(AllTrim(string))
             endif
             string := hb_ULeft(string, pos)
         endif

return AllTrim(string)

function last_word(string)
         if ! Empty(string)
            string := RTrim(string)
            string := hb_USubStr(string, hb_Rat(' ', string))
         endif
return AllTrim(string)

procedure pause_system(seconds)
          local time := Seconds()
          default seconds := 2
          do while (Seconds() - time) < seconds
             Inkey(1)
          end do
return

function Capitalize(string)
   Local pos

   string := AllTrim(string)
   string := hmg_Upper(hb_ULeft(string,1)) + hmg_Lower(hb_USubStr(string, 2))
   string := StrTran(string, " ", Chr(176))
   pos    := hb_UAt(Chr(176), string)

   WHILE pos > 0
         string := hb_ULeft(string, pos-1) + " " + hmg_Upper(hb_USubStr(string, pos+1 , 1)) + hb_USubStr(string, pos+2)
         pos := hb_UAt(Chr(176), string)
   ENDDO

return string

function get_numbers(string)
    local numbers := ''
    local char

    if ValType(string) == 'C' .and. ! Empty(string)
        for each char in string
            if char $ '0123456789'
                numbers += char
            endif
        next each
    endif

return numbers

function extended_date(date)
         local result
         local week := {'domingo','segunda-feira','terça-feira','quarta-feira','quinta-feira','sexta-feira','sábado'}
         local month := {'Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'}
         default date := Date()

         result := week[DoW(date)] + ', ' + hb_NToS(Day(date)) + ' de ' + month[Month(date)] + ' de ' + hb_NToS(Year(date))

return result

function background_color_active_records(form, grid, light_blue)
         local bgcolor
         default light_blue := false

         // Testar cores RGB online: https://www.w3schools.com/colors/colors_rgb.asp

         if GetProperty(form, grid, 'CellEx', This.CellRowIndex, grid_column_index(form, grid, 'Status')) == 'ATIVO'
            bgcolor := iif(light_blue, {234,244,255}, {255,255,255})    // Azul Claro ou Branco
         else
            bgcolor := {192,192,192}      // Cinza
         endif

return bgcolor

function grid_column_index(form, grid, header)
         local c, grid_column := 0
         local grid_header

         for c := 1 to GetProperty(form, grid, 'ColumnCOUNT')
            grid_column := StrTran(GetProperty(form, grid, 'ColumnHEADER', c), '↑')    // Remove o caracter ↑
            grid_column := StrTran(grid_column, '↓')    // Remove o caracter ↓
            if HMG_UPPER(AllTrim(grid_column)) == HMG_UPPER(AllTrim(header))
               grid_column := c
               exit
            endif
         next c

return grid_column

function date_and_week(dDate)
   LOCAL cDate, aWeek := {'Dom','Seg','Ter','Qua','Qui','Sex','Sab'}
   cDate := aWeek[Dow(dDate)] + ' ' + DToC(dDate)
return cDate

function date_to_edi(date)
return hb_DToC(date, 'DDMMYYYY')

function number_to_edi(value, width, decimals)
return StrTran(StrZero(value, width+1, decimals), '.')

function index_of_comboBox(form, comboBox, value)
         local index := 0, len_cbBox := GetProperty(form, comboBox, 'ITEMCOUNT')
         local n, item

         value := AllTrim(value)
          for n := 1 to len_cbBox
              item := GetProperty(form, comboBox, 'ITEM', n)
              if (ValType(item) == 'A' .and. item[2] = value) .or. (ValType(item) == 'C' .and. item = value)
                 index := n
                 exit
              endif
          next n

return index

procedure checkbutton_ativo_on_change(form, control)
         local color := app:menuColor
         if control == 'checkbutton_ativo'
            color := iif(app:avatar == 1, 'Blue', 'Pink')
         endif
         SetProperty(form, control, 'PICTURE', iif(GetProperty(form, control, 'VALUE'), 'bttTurnOn' + color, 'bttTurnOff'))
return

procedure textbox_on_goto_focus(form_name, control_name)
   SetProperty(form_name, control_name, "BACKCOLOR", {190,215,250})
return

procedure textbox_on_lost_focus(form_name, control_name, format)
         local formatted
         SetProperty(form_name, control_name, "BACKCOLOR", WHITE)
         if ValType(format) == "C"
             formatted := format_text(GetProperty(form_name, control_name, "VALUE"), format)
             if ! Empty(formatted)
                 SetProperty(form_name, control_name, "VALUE", formatted)
             endif
         endif

return

function format_text(string, format)
         local formatted := string

         format := hmg_Lower(format)

         switch format
            case 'capitalize'
               formatted := Capitalize(string)
               exit
            case 'first word captalize'
               formatted := first_word(Capitalize(string))
               exit
            case 'first word'
               formatted := first_word(string)
               exit
            case 'datetime as string'
               formatted := StrTran(string, ' ', 'T')
               exit
            case 'datetime as tdz'
               formatted := StrTran(string, ' ', 'T') + app:UTC
               exit
            case 'as phone'
               formatted := get_numbers(string)
               if ! Empty(formatted)
                  if hb_ULen(formatted) < 10
                     formatted := hb_UPadL(AllTrim(hb_URight(formatted, 10)), 10, '0')
                  elseif hb_ULen(formatted) > 11
                     formatted := hb_NToS(hb_Val(formatted)) // Remove os zeros à esquerda
                     if ! Empty(formatted)
                         if hb_ULen(formatted) < 11
                             formatted := hb_UPadL(AllTrim(hb_URight(formatted, 11)), 11, '0')
                         else
                             formatted := hb_URight(formatted, 11)
                         endif
                     endif
                  endif
                  if hb_ULen(formatted) == 10
                     formatted := Transform(formatted, '@R (99) 9999-9999')
                  elseif hb_ULen(formatted) == 11
                     formatted := Transform(formatted, '@R (99) 99999-9999')
                  endif
               endif
               exit
            case 'as cnpj'
               formatted := get_numbers(string)
               if hb_ULen(formatted) < 14
                  formatted := hb_UPadL(AllTrim(hb_URight(formatted, 14)), 14, '0')
               elseif hb_ULen(formatted) > 14
                  formatted := hb_URight(formatted, 14)
               endif
               formatted := Transform(formatted, "@R 99.999.999/9999-99")
               exit
            case 'as cpf'
               formatted := get_numbers(string)
               if hb_ULen(formatted) < 11
                  formatted := hb_UPadL(AllTrim(hb_URight(formatted, 11)), 11, '0')
               elseif hb_ULen(formatted) > 11
                  formatted := hb_URight(formatted, 11)
               endif
               formatted := Transform(formatted, "@R 999.999.999-99")
               exit
            case 'as cep'
               formatted := get_numbers(string)
               if hb_ULen(formatted) < 8
                  formatted := hb_UPadL(AllTrim(hb_URight(formatted, 8)), 8, '0')
               elseif hb_ULen(formatted) > 8
                  formatted := hb_URight(formatted, 8)
               endif
               formatted := Transform(formatted, "@R 99999-999")
               exit
            case  'as raw' // caracter só numérico
               formatted := get_numbers(string)
            otherwise
               if hb_ULeft(format, 2) == '@R'
                  formatted := Transform(string, format)
               endif
         endswitch

return formatted


function format_number(number, format)
         local formatted := number  // retorna o próprio número sem conversão se fornmat não for definido
         default format := ''

         if format ==  'as string'
            formatted := hb_NToS(number)
         elseif format == 'as logical'
            formatted := is_true(number)
         endif

return formatted

function aux_is_alpha(string)
         local c, point := 0

         for each c in string
            if c == '.'
               point++
            else
               if ! c $ '0123456789'
                  return true
               endif
            endif
         next

return point > 1

function aux_is_digit(string)
         local c, point := 0

         for each c in string
            if c == '.'
               point++
            else
               if ! c $ '0123456789'
                  return false
               endif
            endif
         next

return point > 2
