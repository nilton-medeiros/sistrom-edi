/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: change_password.prg
 Rotinas: Faz a troca de senha e outras informações rápidas do usuário
***********************************************************************************/

#include <hmg.ch>

declare window change_password
declare window Main

procedure change_password()

            if IsWIndowActive(change_password)
            change_password.MINIMIZE
            change_password.RESTORE
            change_password.SETFOCUS
            else
            load window change_password
            on key escape of change_password action change_password.RELEASE
            change_password.ACTIVATE
            endif

return

procedure change_password_form_on_init()
            local nCol := Main.WIDTH //- change_password.WIDTH ** o form change_password não está ativo/definido ainda aqui

            nCol -= change_password.WIDTH    // Aqui já está definido/ativo o form
            change_password.ROW := 90
            change_password.COL := nCol - 10

            change_password.text_user_name.VALUE := app:getUser('nome')
            change_password.text_user_apelido.VALUE := app:getUser('apelido')
            change_password.text_user_login.VALUE := app:getUser('login')
            change_password.text_user_senha.VALUE := app:getUser('senha')
            change_password.text_user_email.VALUE := app:getUser('email')
            change_password.text_user_celular.VALUE := app:getUser('celular')

return

procedure change_password_text_user_name_on_enter()
            if Empty(change_password.text_user_name.VALUE)
                change_password.text_user_name.SETFOCUS
                PlayBeep()
            else
                change_password.text_user_login.SETFOCUS
            end
return

procedure change_password_text_user_login_on_enter()
            if Empty(change_password.text_user_login.VALUE)
                change_password.text_user_login.SETFOCUS
                PlayBeep()
            else
                change_password.text_user_senha.SETFOCUS
            end
return

procedure change_password_text_user_senha_on_enter()
            if !Empty(change_password.text_user_login.VALUE) .and. hb_ULen(AllTrim(change_password.text_user_senha.VALUE)) > 3
                change_password.btt_save.ENABLED := true
            else
                MsgExclamation('Senhe deve conter no mínimo 4 dígitos', 'Senha')
                change_password.btt_save.ENABLED := false
            end

            if Empty(change_password.text_user_senha.VALUE)
                change_password.text_user_senha.SETFOCUS
            else
                change_password.text_user_email.SETFOCUS
            end
return

procedure change_password_button_show_password_action()
            change_password.label_show_password.VALUE := change_password.text_user_senha.VALUE
            change_password.label_show_password.Visible := true
            inkey(2)
            change_password.label_show_password.Visible := false
return

procedure change_password_button_save_action()
            local cSQL := "UPDATE usuarios SET "
            local q AS OBJECT

            if Empty(change_password.text_user_name.VALUE) .OR. hb_ULen(AllTrim(change_password.text_user_name.VALUE)) < 5
                MsgExclamation('Nome incompleto ou curto demais!')
                change_password.text_user_name.SETFOCUS
                return
            endif
            if Empty(change_password.text_user_login.VALUE)
                MsgExclamation('Login não preenchido!')
                change_password.text_user_login.SETFOCUS
                return
            endif
            if hb_ULen(AllTrim(change_password.text_user_senha.VALUE)) < 4
                MsgExclamation('Senha não preenchida ou muito curta!', 'Senha')
                change_password.text_user_senha.SETFOCUS
                return
            endif
            if hb_ULen(AllTrim(change_password.text_user_email.VALUE)) < 10
                MsgExclamation('E-Mail não preenchido ou muito curto!', 'E-Mail')
                change_password.text_user_email.SETFOCUS
                return
            endif
            if hb_ULen(AllTrim(change_password.text_user_celular.VALUE)) < 7
                MsgExclamation('Fone/Celular não preenchido ou muito curto!', 'Celular')
                change_password.text_user_celular.SETFOCUS
                return
            endif

            cSQL += "user_login='" + unicode_to_ansi(change_password.text_user_login.VALUE) + "',"
            cSQL += "user_nome='" + unicode_to_ansi(change_password.text_user_name.VALUE) + "',"
            cSQL += "user_apelido=" + IFNULL(change_password.text_user_apelido.VALUE) + ","
            cSQL += "user_senha='" + unicode_to_ansi(change_password.text_user_senha.VALUE) + "',"
            cSQL += "user_email='" + unicode_to_ansi(change_password.text_user_email.VALUE) + "',"
            cSQL += "user_celular='" + unicode_to_ansi(change_password.text_user_celular.VALUE) + "' "
            cSQL += "WHERE user_id=" + app:getUser('id')

            q := TSQLQuery():NEW(cSQL)

            if q:isExecuted()
                app:user:putField('nome', AllTrim(change_password.text_user_name.VALUE))
                app:user:putField('apelido', AllTrim(change_password.text_user_apelido.VALUE))
                app:user:putField('login', AllTrim(change_password.text_user_login.VALUE))
                app:user:putField('senha', AllTrim(change_password.text_user_senha.VALUE))
                app:user:putField('email', AllTrim(change_password.text_user_email.VALUE))
                app:user:putField('celular', AllTrim(change_password.text_user_celular.VALUE))
                SetProperty("Main", "bttb_senha", "CAPTION", app:getUser())
                status_message('Status: Usuário alterado com sucesso!', true, 'Tabela Usuários', MB_USERICON)
                q:Destroy()
                change_password.RELEASE
            endif

return

procedure change_password_button_cancel_action
          change_password.RELEASE
return

procedure change_password_button_logout_action

          change_password.RELEASE
          Load Window Login
          Login.CENTER
          Login.ACTIVATE

return