/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 10-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: class_appdata.prg
 Classe: TAppData - Classe de configurações gerais do Aplicativo
***********************************************************************************/

#include <hmg.ch>
#include 'hbclass.ch'

class TAppData
      data mysql                        // Este objeto pode ser redefinido em register_db.prg
      data companies readonly           // Definido no login (row da query tabela empresas)
      data nuCompany protected
      data user                         // Definido no login
      data UTC readonly   // Fuso horário - Tempo Universal Coordenado - Coordinated Universal Time
      data logged readonly
      data executable readonly
      data displayName readonly
      data version readonly
      data rootRegistry readonly
      data pathRegistry readonly
      data supportURL readonly
      data WIDTH          // Redefinido ao maximizar a tela dependendo do tamanho do monitor
      data HEIGHT         // Redefinido ao maximizar a tela dependendo do tamanho do monitor
      data dynamic_back_color readonly
      data menuColor
      data avatar
      data flashing
      data messages

      method new(version) constructor
      method appRegistry()
      method isRunning()
      method registryDB()
      method setDB()
      method setUTC(utc)          // Troca o Fuso horário - Tempo Universal Coordenado - Coordinated Universal Time
      method setLogged(status) setget

      method getUser(field) setget
      method pathUser() setget

      method clearCompanies() setget
      method addCompanies(row) inline AAdd(::companies, row)
      method setCompanies(pos) setget
      method getCompanies(field, format)
      method lenCompanies() inline hmg_len(::companies)

      method getMessages(as_string) setget

end class

method new(version) class TAppData
       default version := '1.0.0'

       ::companies := {}
       ::nuCompany := 0
       ::UTC := '-03:00'
       ::logged := false
       ::executable := hb_FNameNameExt(hb_ProgName())
       ::version := version
       ::displayName := 'Sistrom-EDI Proceda ' + ::version + ' (32-bit)'
       ::rootRegistry := 'HKEY_CURRENT_USER\SOFTWARE\Sistrom\'   // Modelo \HKEY_CURRENT_USER\SOFTWARE\Python\PythonCore\3.9
       ::pathRegistry := ::rootRegistry + hb_FNameNameExt(hb_FNameName(hb_ProgName())) + '\'    // Nome do executável (Executable Name)
       ::supportURL := 'https://www.sistrom.com.br'
       ::HEIGHT := 730
       ::WIDTH := 1382
       ::dynamic_back_color := {|| iif(This.CellRowIndex/2==INT(This.CellRowIndex/2), {234,244,255}, {255,255,255})}
       ::menuColor := 'Blue'
       ::avatar := 1        // 1 - Masculino | 2 - Feminino
       ::flashing := 0
       ::messages := 0

return self

method appRegistry() class TAppData
       local reg_read

       if !hb_DirExists('tmp')
          hb_DirBuild('tmp') // Esta função, se precisar, cria pasta e subpastas em um comando só hb_DirBuild('dir1\dir2\dir3')
       endif
       if !hb_DirExists('log')
          hb_DirBuild('log')
       endif
       if !hb_DirExists('edi')
         hb_DirBuild('edi')
      endif

      if RegistryRead(::rootRegistry + 'DisplayName') == NIL
         RegistryWrite(::rootRegistry + 'DisplayName', 'Sistrom Sistemas Web')
      endif
      if RegistryRead(::rootRegistry + 'SupportUrl') == NIL
         RegistryWrite(::rootRegistry + 'SupportUrl', ::supportURL)
      endif
      if RegistryRead(::pathRegistry + 'Executable') == NIL
         RegistryWrite(::pathRegistry + 'Executable', ::executable)
      endif

      reg_read := RegistryRead(::pathRegistry + 'DisplayName')

      if reg_read == NIL .or. ! reg_read == ::displayName
         RegistryWrite(::pathRegistry + 'DisplayName', ::displayName)
      endif
      if RegistryRead(::pathRegistry + 'SysArchitecture') == NIL
         RegistryWrite(::pathRegistry + 'SysArchitecture', '32bit')
      endif

      reg_read := RegistryRead(::pathRegistry + 'Version')

      if reg_read == NIL .or. ! reg_read == ::version
         RegistryWrite(::pathRegistry + 'Version', ::version)
         RegistryWrite(::pathRegistry + 'SysVersion', hb_ULeft(::version, hb_RAt('.', ::version)-1))
      endif
      if RegistryRead(::pathRegistry + 'SysVersion') == NIL
         RegistryWrite(::pathRegistry + 'SysVersion', hb_ULeft(::version, hb_RAt('.', ::version)-1))
      endif
      if RegistryRead(::pathRegistry + 'Installation\ComputerName') == NIL
         RegistryWrite(::pathRegistry + 'Installation\ComputerName', GetComputerName())
      endif
      if RegistryRead(::pathRegistry + 'Installation\Path') == NIL
         RegistryWrite(::pathRegistry + 'Installation\Path', hb_cwd())
      endif
      if RegistryRead(::pathRegistry + 'Host\ServerName') == NIL
      RegistryWrite(::pathRegistry + 'Host\ServerName', '')
      endif
      if (RegistryRead(::pathRegistry + 'Host\UserName') == NIL)
         RegistryWrite(::pathRegistry + 'Host\UserName', '')
      endif
      if RegistryRead(::pathRegistry + 'Host\Password') == NIL
         RegistryWrite(::pathRegistry + 'Host\Password', '')
      endif
      if RegistryRead(::pathRegistry + 'Monitoring\Running') == NIL
         RegistryWrite(::pathRegistry + 'Monitoring\Running', 0)
      endif
      if RegistryRead(::pathRegistry + "Monitoring\Don'tRun") == NIL
         RegistryWrite(::pathRegistry + "Monitoring\Don'tRun", 0)
      endif

      if ::isRunning()
         saveLog('O sistema nao foi desligado corretamente da ultima vez')
      else
         RegistryWrite(::pathRegistry + 'Monitoring\Running', 1)
      endif

      AEval(Directory('log\*.*'),  {|aFile| iif(aFile[3] <= (Date()-70), hb_FileDelete("log\"+aFile[1]), NIL)})
      AEval(Directory('tmp\*.*'),  {|aFile| iif(aFile[3] <= (Date()-10), hb_FileDelete("tmp\"+aFile[1]), NIL)})
      AEval(Directory('ftp*.txt'), {|aFile| iif(aFile[3] <= (Date()-10), hb_FileDelete(aFile[1]), NIL)})
      AEval(Directory('ftp*.log'), {|aFile| iif(aFile[3] <= (Date()-10), hb_FileDelete(aFile[1]), NIL)})

      saveLog(::displayName + ' - Sistema iniciado')

return NIL

method isRunning() class TAppData
return is_true(RegistryRead(::pathRegistry + "Monitoring\Running"))

method registryDB() class TAppData
       local userConnect := {;
             'address' => CharXor(RegistryRead(::pathRegistry + "Host\ServerName"), 'SisWeb2021'),;
             'dataBase' => CharXor(RegistryRead(::pathRegistry + "Host\UserName"), 'SisWeb2021'),;
             'userName' => CharXor(RegistryRead(::pathRegistry + "Host\UserName"), 'SisWeb2021'),;
             'password' => CharXor(RegistryRead(::pathRegistry + "Host\Password"), 'SisWeb2021');
       }

       if Empty(RegistryRead(::pathRegistry + 'Host\ServerName'))
          load window register_db
          on key escape of register_db action register_db_escape()
          register_db.CENTER
          register_db.ACTIVATE
       else
          ::mysql := TMySQL():new(userConnect)
       endif

return NIL

method setDB() class TAppData
       RegistryWrite(::pathRegistry + "Host\ServerName", CharXor(::mysql:address, 'SisWeb2021'))
       RegistryWrite(::pathRegistry + "Host\UserName", CharXor(::mysql:userName, 'SisWeb2021'))
       RegistryWrite(::pathRegistry + "Host\Password", CharXor(::mysql:password, 'SisWeb2021'))
return NIL

method setUTC(utc) class TAppData
       default utc := '-03:00'

       if ! ValType(utc) == 'C' .or. ! len(utc) == 6
          utc := '-03:00'
       endif
       ::UTC := utc
return NIL

method setLogged(status) class TAppData
       if ValType(status) == 'L'
          ::logged := status
       endif
return NIL

method getUser(field, format) class TAppData
       local obtained_field
       default field := 'apelido'
       default format := ''

       if ::user == NIL
         return 'Sistema'
       endif
       if field == 'id'
          obtained_field := ::user:getField('id', 'as string')
       elseif field == 'apelido'
          obtained_field := ::user:getField('apelido')
          if Empty(obtained_field)
             obtained_field := first_word(::user:getField('nome'))
          endif
          obtained_field := Capitalize(obtained_field)
       else
         obtained_field := ::user:getField(field, format)
       endif
return obtained_field

method pathUser() class TAppData
return app:pathRegistry + 'Users\' + ::getUser() + '\'

method clearCompanies() class TAppData
       ::companies := {}
       ::nuCompany := 0
return NIL

method setCompanies(pos) class TAppData
       local sizeCia := hmg_len(::companies)
       default pos := 1

       if sizeCia > 0 .and. pos > 0
          if sizeCia >= pos
            ::nuCompany := pos
          else
            ::nuCompany := 1
          endif
         else
            ::nuCompany := 1
         endif

         SetProperty('Main', 'bttb_empresas', 'CAPTION', ::getCompanies('nome_fantasia'))

return NIL

method getCompanies(field, format) class TAppData
       if hmg_len(::companies) == 0
         return 'NIL'
       endif
       if ::nuCompany == 0
          ::nuCompany := 1
       endif
return ::companies[::nuCompany]:getField(field, format)

method getMessages() class TAppData
       local msgs := LTrim(Transform(::messages, '@E 9,999,999'))
return iif(::messages == 1, '1 Notificação', msgs + ' Notificações')
