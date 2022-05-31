/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: register_db.prg
 Rotinas: Faz o Registro do Banco de Dados na primeira vez que executa o sistema
***********************************************************************************/

#include <hmg.ch>

procedure register_db_buttonSaveAction()
          local userConnect
          local ip_array := GetProperty('register_db', 'ip_address_host', 'Value')

          if ! (ip_array[1] == 0) .and. ! Empty(GetProperty('register_db', 'text_database', 'Value')) .and.;
                                        ! Empty(GetProperty('register_db', 'text_user', 'Value')) .and.;
                                        ! Empty(GetProperty('register_db', 'text_password', 'Value'))

             userConnect := {;
                'address' => IPArrayToString(ip_array),;
                'userName' => AllTrim(GetProperty('register_db', 'text_user', 'Value')),;
                'password' => AllTrim(GetProperty('register_db', 'text_password', 'Value'));
             }

             MemVar->app:mysql := TMySQL():new({;
                'address' => IPArrayToString(ip_array),;
                'userName' => AllTrim(GetProperty('register_db', 'text_user', 'Value')),;
                'password' => AllTrim(GetProperty('register_db', 'text_password', 'Value'));
             })
          MemVar->app:setDB()

              if MemVar->app:mysql:connect()
                  doMethod('register_db', 'RELEASE')
              else
                  MsgExclamation({'Acesso negado para usuário ', MemVar->app:mysql:userName,'.', hb_eol()+hb_eol(), 'Verifique as informações digitadas ou chame o suporte.' }, 'Informações incorretas!')
              end

          else
              MsgExclamation('Preencher todos os campos', 'Dados insuficientes!')
          end

return

function IPArrayToString(ip_array)
            local ip_string := LTrim(Str(ip_array[1]))
            ip_string += '.' + LTrim(Str(ip_array[2]))
            ip_string += '.' + LTrim(Str(ip_array[3]))
            ip_string += '.' + LTrim(Str(ip_array[4]))
return (ip_string)

procedure register_db_Escape()
    doMethod('register_db', 'RELEASE')
    turnOFF(true)
return