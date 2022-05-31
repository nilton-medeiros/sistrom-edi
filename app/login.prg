/**************************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: login.prg
 Rotinas: Apresenta o Form de Login ao sistema antes de entrar no Form principal (Main)
***************************************************************************************/

#include <hmg.ch>

declare window login
declare window Main

procedure login_form_on_init()

          login.TextBox_Usuario.ENABLED := false
          login.TextBox_Senha.ENABLED := false
          login.button_login.ENABLED := false
          login.button_esqueceu_senha.ENABLED := false
          login.checkbox_lembrar_acesso.ENABLED := false

          login.lb_Status.FontColor := YELLOW  // {255,0,0}
          login.lb_BancoDados.FontColor := YELLOW
          login.lb_Status.VALUE := "Aguarde!"
          login.lb_BancoDados.VALUE := "Procurando..."
          login.iLedBD.Picture := "imgConnecting"
          login.label_2.VALUE := "Sistema de EDI padrão Proceda (3.0A/3.1) - Versão " + app:version

          if app:mysql:connect()

               login.TextBox_Usuario.ENABLED := true
               login.TextBox_Senha.ENABLED := true
               login.button_login.ENABLED := true
               //login.button_esqueceu_senha.ENABLED := true
               login.checkbox_lembrar_acesso.ENABLED := true

               login.lb_Status.FontColor     := WHITE //{255,0,0}
               login.lb_BancoDados.FontColor := WHITE
               login.lb_Status.VALUE         := "CONECTADO"
               login.lb_BancoDados.VALUE     := app:mysql:dataBase
               login.iLedBD.Picture          := "imgConnected"
               login.TextBox_Usuario.SETFOCUS

               if ! RegistryRead(app:pathRegistry + 'Login\LoginUserName' ) == NIL .and. ! Empty(RegistryRead(app:pathRegistry + 'Login\LoginUserName'))
                     login.TextBox_Usuario.VALUE := RegistryRead(app:pathRegistry + 'Login\LoginUsername')
                     login.TextBox_Senha.VALUE := CharXor(RegistryRead(app:pathRegistry + 'Login\LoginPassword'), 'SisWeb2021')
                     login.checkbox_lembrar_acesso.VALUE := true
               else
                     login.checkbox_lembrar_acesso.VALUE := false
               endif

               PlayBeep()

          else
               login.lb_Status.FontColor := YELLOW
               login.lb_Status.BackColor := {255,255,128}
               login.lb_BancoDados.FontColor := YELLOW
               login.lb_BancoDados.BackColor := {255,255,128}
               login.lb_Status.VALUE := "SEM CONEXÃO"
               login.lb_BancoDados.VALUE := "NÃO ENCONTRADO"
               login.iLedBD.Picture := "imgConnectionError"
               PlayExclamation()
          endif

return

procedure login_textbox_usuario_on_enter()

     if Empty(login.TextBox_Usuario.VALUE)
          login.TextBox_Usuario.SETFOCUS
          PlayExclamation()
      else
          login.TextBox_Senha.SETFOCUS
      endif

return

procedure login_button_login_action()
     local reg_read

     login.button_login.ENABLED := false

     if hb_ULen(AllTrim(login.TextBox_Senha.VALUE)) < 4
        PlayExclamation()
        MsgExclamation("Senha deve conter no mínimo 4 dígitos", "Senha")
        login.TextBox_Senha.SETFOCUS
     elseif Empty(login.TextBox_Usuario.VALUE)
        MsgExclamation('Usuário não preenchido!', 'Usuário')
        PlayExclamation()
        login.TextBox_Usuario.SETFOCUS
      elseif load_user()

        app:setLogged(true)

        if RegistryRead(app:pathUser + 'lastCompany') == NIL
           RegistryWrite(app:pathUser + 'lastCompany', 0)
        endif

        reg_read := RegistryRead(app:pathUser + 'menuColor')

        if reg_read == NIL .or. ! reg_read $ 'Gray|Blue|Pink'
           RegistryWrite(app:pathUser + 'menuColor', 'Gray')
           reg_read := 'Gray'
        endif

        app:menuColor := reg_read
        app:avatar := RegistryRead(app:pathUser + 'avatar')

        if  app:avatar == NIL
            RegistryWrite(app:pathUser + 'avatar', 1)
            app:avatar := 1
        endif

        if login.checkbox_lembrar_acesso.VALUE
           login_salvar_acesso()
        else
           login_apagar_acesso()
        endif

        login.RELEASE

      else
          login.button_login.ENABLED := true
      endif

return

function load_user()
         local query
         local sql
         local i
         local emp

         status_message('Localizando usuário...')

         sql := "SELECT user_id AS id, "
         sql += "user_nome AS nome, "
         sql += "IFNULL(user_apelido,'') AS apelido, "
         sql += "user_login AS login, "
         sql += "user_senha AS senha, "
         sql += "user_email AS email, "
         sql += "user_celular AS celular, "
         sql += "user_ativo AS ativo, "
         sql += "menu_edi, "
         sql += "menu_ftp, "
         sql += "menu_lembretes, "
         sql += "menu_clientes, "
         sql += "menu_usuarios, "
         sql += "menu_empresas, "
         sql += "menu_configuracoes, "
         sql += "menu_log_sistema "
         sql += "FROM usuarios "
         sql += "WHERE user_login = '" + AllTrim(login.TextBox_Usuario.VALUE) + "' "
         sql += "LIMIT 1"

         query := TSQLQuery():new(sql)

         if query:isExecuted()

             if query:lastRec() > 0

                 /* Pega todas as linhas retornadas, neste caso 1 apenas retornou devido ao limit e também no BD a coluna login é do tipo único */
                 app:user := query:getRow(1)

                 /* Verifica se a senha digitada está correta */
                 /* Atribui as variáveis globais em Main o primeiro e único registro retornado*/

                 if AllTrim(login.TextBox_Senha.VALUE)  == app:user:getField('senha')

                     if app:getUser('ativo') == 0
                         login.button_login.ENABLED := false
                         PlayExclamation()
                         MsgExclamation('Você não tem permissão para entrar no sistema' + hb_eol() + 'Verifique com o administrador suas credenciais','Permissão revogada!')
                         query:Destroy()
                         status_message()
                         return false
                     endif

                     login.image_3.Picture := "imgLock"
                     Main.bttb_senha.CAPTION := 'Olá ' + app:getUser()
                     Main.StatusBar.ITEM(2) := 'Usuário conectado'

                     query:Destroy()

                     // Seleciona as empresas que o usuário tem acesso
                     status_message('Localizando empresa...')

                     sql := "SELECT emp_id AS id_empresa FROM users_emps WHERE user_id = " + app:getUser('id') + ';'

                     query := TSQLQuery():NEW(sql)

                     if query:isExecuted()

                         sql := 'SELECT emp_id AS id,'
                         sql += 'emp_razao_social AS razao_social,'
                         sql += 'emp_nome_fantasia AS nome_fantasia,'
                         sql += 'emp_sigla_cia AS sigla_cia,'
                         sql += 'emp_cnpj AS cnpj,'
                         sql += 'emp_logradouro AS logradouro,'
                         sql += 'emp_numero AS numero,'
                         sql += 'emp_complemento AS complemento,'
                         sql += 'emp_bairro AS bairro,'
                         sql += 'cid_municipio AS municipio,'
                         sql += 'cid_uf AS uf,'
                         sql += 'emp_cep AS cep,'
                         sql += 'emp_fone1 AS fone1,'
                         sql += 'emp_fone2 AS fone2,'
                         sql += 'emp_cte_modelo AS cte_modelo,'
                         sql += 'emp_tipo_emitente AS tipo_emitente,'
                         sql += 'emp_email_contabil AS email_contabil,'
                         sql += 'emp_email_comercial AS email_comercial,'
                         sql += 'edi_caixa_postal '
                         sql += 'FROM view_empresas '

                         if query:lastRec() == 1

                             query:goTop()
                             sql += 'WHERE emp_ativa = 1 AND emp_id = ' + query:getField('id_empresa', 'as string')

                         elseif query:lastRec() > 1

                             sql += 'WHERE emp_ativa = 1 AND emp_id IN ('

                             for i := 1 TO query:lastRec()
                                 if i > 1
                                    sql += ','
                                 endif
                                 sql += query:getField('id_empresa', 'as string')
                                 query:Skip(1)
                             next i

                             sql += ")"

                         else
                             query:Destroy()
                             MsgExclamation('Nenhuma empresa está associada ao seu login/usuário', 'Empresa não encontrada!')
                             return false
                         endif

                         sql += " ORDER BY emp_id;"

                         query:Destroy()
                         query := TSQLQuery():NEW(sql)

                         if query:isExecuted()

                             if query:lastRec() == 0
                                 PlayExclamation()
                                 MsgExclamation({app:getUser('nome', 'capitalize'), hb_eol(), 'Não há empresas ativas ou permissão para o usuário : ' + app:getUser('login')}, 'Tabela: empresas')
                                 query:Destroy()
                                 return false
                             endif

                             app:clearCompanies()

                             for i := 1 TO query:lastRec()
                                 app:addCompanies(query:getRow(i))
                             next i

                             query:Destroy()

                         else
                             return false
                         endif

                     else
                         return false
                     endif

                     status_message()

                 else

                     login.button_login.ENABLED := false

                     PlayExclamation()
                     MsgExclamation('Acho que você digitou a senha errada' + hb_eol() + 'Se esqueceu sua senha clique em "Esqueci minha senha"','Ops! Senha não confere')
                     query:Destroy()
                     status_message()
                     return false

                 endif

             else

                 login.button_login.ENABLED := false
                 saveLog('Login - Usuário ' + AllTrim(login.TextBox_Usuario.VALUE) + ' não encontrado: ' + hb_eol() + sql)
                 PlayExclamation()
                 MsgExclamation('Usuário não encontrado' + hb_eol() + 'Verifique se digitou corretamente os dados de acesso.','Acesso Negado!')
                 query:Destroy()
                 status_message()
                 return false

             endif

         else
             query:Destroy()
             return false
         endif

         status_message()

return true

procedure login_button_esqueceu_senha_action()
          MsgInfo('Módulo de e-mail não implementado','Envio de e-mail')
return

procedure login_iledbd_action()
         if ! (app:mysql:connected)
            login_form_on_init()
         endif
return

procedure login_form_key_escape()
          // Quando usuário fecha ou tecla ESC no form Login para cancelar. Não colocar esse evento no ON RELEASE do Form login
          turnOFF(true)
return

procedure login_image_2_action()
          login.TextBox_Usuario.VALUE := ''
          login.TextBox_Usuario.SETFOCUS
return

procedure login_image_3_action()
          login.TextBox_Senha.VALUE := ''
          login.TextBox_Senha.SETFOCUS
return

procedure login_salvar_acesso()
          RegistryWrite(app:pathRegistry + 'Login\LoginUsername', AllTrim(login.TextBox_Usuario.VALUE))
          RegistryWrite(app:pathRegistry + 'Login\LoginPassword', CharXor(AllTrim(login.TextBox_Senha.VALUE), 'SisWeb2021'))
return

procedure login_apagar_acesso()
          RegistryWrite(app:pathRegistry + 'Login\LoginUserName', '')
          RegistryWrite(app:pathRegistry + 'Login\LoginPassWord', CharXor('', 'SisWeb2021'))
return
