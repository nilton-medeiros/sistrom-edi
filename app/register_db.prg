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

          if ! Empty(GetProperty('register_db', 'text_address_host', 'Value')) .and. ;
             ! Empty(GetProperty('register_db', 'text_database',   'Value')) .and.;
             ! Empty(GetProperty('register_db', 'text_user', 'Value')) .and.;
             ! Empty(GetProperty('register_db', 'text_password', 'Value'))

             userConnect := {;
                'address' => AllTrim(GetProperty('register_db', 'text_address_host', 'Value')),;
                'userName' => AllTrim(GetProperty('register_db', 'text_user', 'Value')),;
                'password' => AllTrim(GetProperty('register_db', 'text_password', 'Value'));
             }

             MemVar->app:mysql := TMySQL():new(userConnect)
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

procedure register_db_Escape()
    doMethod('register_db', 'RELEASE')
    turnOFF(true)
return