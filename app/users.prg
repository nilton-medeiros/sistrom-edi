/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: users.prg
 Rotinas: Cadastro de Usuários - CRUD: Incluir, Consultar, Alterar e Excluir
***********************************************************************************/

#include <hmg.ch>

declare window users

/*
 * Invocada pelo form usuarios, botoes: Novo, Editar, Excluir e OnDblClick no registro da Grade
 * ADVERTÊNCIA: As variáveis private neste formulário são enchergadas em todos os demais formulários abertos ao mesmo tempo
*/

/* Rotinas iniciais -------------------------------------------------------------------------------*/
procedure form_users(cModo)
			local k
			private pUsers_cModo := cModo

			if IsWIndowActive(users)
				users.MINIMIZE
				users.RESTORE
				users.SETFOCUS
			else
				load window users
				on key escape of users action users.RELEASE

				k := GetControlIndex("grid_users_companies", "users")
				_HMG_SYSDATA[ 40 ][ k ][ 46 ] := {|| users_on_checkbox_clicked() }

				users.CENTER
				users.ACTIVATE
			endif

return

procedure users_form_on_init()

			users.Tab_usuarios.VALUE := 1
			users.text_id.ENABLED := false
			users.grid_users_companies.CheckBoxEnabled := true

			load_grid_users_companies()

			if pUsers_cModo == 'INSERT'
				users_clear_fields()
			elseif pUsers_cModo == 'UPDATE'
				users_loads_fields(false)
				users.btt_save_and_new.ENABLED := false
			else  // SELECT
				users_loads_fields(true)
				users.button_NegarTudo.ENABLED := false
				users.button_SelTodosLeitura.ENABLED := false
				users.button_SelTodosLerGravar.ENABLED := false
				users.btt_save.ENABLED := false
				users.btt_save_and_new.ENABLED := false
			endif

return

procedure users_clear_fields()
			local e

			users.text_id.VALUE := 0
			users.text_nome.VALUE := ''
			users.text_apelido.VALUE := ''
			users.text_login.VALUE := ''
			users.text_senha.VALUE := ''
			users.text_celular.VALUE := ''
			users.text_email.VALUE := ''
			users.text_departamento.VALUE := ''
			users.checkbutton_ativo.VALUE := true

			users_permissions_action(1)

			for e := 1 TO users.grid_users_companies.ItemCount
				users.grid_users_companies.CheckBoxItem(e) := false
			next e

return
procedure users_loads_fields(lReadOnly)
			local oRow := private_users_list_query:GetRow(GetProperty('users_list','grid_users_list', 'VALUE'))

			users.text_id.VALUE := oRow:getField('id')
			users.text_nome.VALUE := oRow:getField('nome')
			users.text_apelido.VALUE := oRow:getField('apelido')
			users.text_login.VALUE := oRow:getField('login')
			users.text_senha.VALUE := oRow:getField('senha')
			users.text_celular.VALUE := oRow:getField('celular')
			users.text_email.VALUE := oRow:getField('email')
			users.text_departamento.VALUE := oRow:getField('departamento')
			users.checkbutton_ativo.VALUE := oRow:getField('ativo', 'as logical')
			users.radio_edi.VALUE := (oRow:getField('menu_edi') + 1)
			users.radio_ftp.VALUE := (oRow:getField('menu_ftp') + 1)
			users.radio_lembretes.VALUE := (oRow:getField('menu_lembretes') + 1)
			users.radio_clientes.VALUE := (oRow:getField('menu_clientes') + 1)
			users.radio_usuarios.VALUE := (oRow:getField('menu_usuarios') + 1)
			users.radio_empresas.VALUE := (oRow:getField('menu_empresas') + 1)
			users.radio_log_sistema.VALUE := (oRow:getField('menu_log_sistema') + 1)
			users.radio_configuracoes.VALUE := (oRow:getField('menu_configuracoes') + 1)

			users.text_nome.READONLY := lReadOnly
			users.text_apelido.READONLY := lReadOnly
			users.text_login.READONLY := lReadOnly
			users.text_senha.READONLY := lReadOnly
			//users.button_show_password.ENABLED := ! lReadOnly
			users.text_celular.READONLY := lReadOnly
			users.text_email.READONLY := lReadOnly
			users.text_departamento.READONLY := lReadOnly
			//users.checkbutton_ativo.ENABLED := ! lReadOnly
			users.radio_edi.READONLY := {lReadOnly,lReadOnly,lReadOnly}
			users.radio_ftp.READONLY := {lReadOnly,lReadOnly,lReadOnly}
			users.radio_lembretes.READONLY := {lReadOnly,lReadOnly,lReadOnly}
			users.radio_clientes.READONLY := {lReadOnly,lReadOnly,lReadOnly}
			users.radio_usuarios.READONLY := {lReadOnly,lReadOnly,lReadOnly}
			users.radio_empresas.READONLY := {lReadOnly,lReadOnly,lReadOnly}
			users.radio_log_sistema.READONLY := {lReadOnly,lReadOnly,lReadOnly}
			users.radio_configuracoes.READONLY := {lReadOnly,lReadOnly,lReadOnly}

			users_mark_grid(hb_NToS(users.text_id.VALUE))

return

procedure users_mark_grid(cId)
			local i
			local q AS OBJECT

			q := TSQLQuery():NEW("SELECT emp_id FROM users_emps WHERE user_id=" + cId)

			if q:isExecuted()

				if !(q:LastRec() == 0)
					for i := 1 TO q:LastRec()
							oRow := q:GetRow(i)
							grid_users_companies_checked(oRow:getField('emp_id'))
					next i
				endif

				q:Destroy()

			endif

return

STATIC ;
procedure grid_users_companies_checked(id_empresa)
			local k
			for k := 1 TO users.grid_users_companies.ITEMCOUNT
				if users.grid_users_companies.CellEx(k,1) == id_empresa
					users.grid_users_companies.CheckBoxItem(k) := true
				endif
			next k
return

procedure users_on_checkbox_clicked()
			/* Posiciona na linha que o CheckBox foi clicada */
			users.grid_users_companies.VALUE := This.CellRowClicked
			if pUsers_cModo == 'SELECT'
				/* Se é consulta, não deixa mudar o status original */
				users.grid_users_companies.CheckBoxItem(This.CellRowClicked) := ! users.grid_users_companies.CheckBoxItem(This.CellRowClicked)
			endif
return

procedure load_grid_users_companies()
			local e
			local cSQL := "SELECT emp_id AS id,emp_nome_fantasia AS nome_fantasia,emp_razao_social AS razao_social FROM empresas"
			local q := TSQLQuery():NEW(cSQL)

			if q:isExecuted()
				if ! (q:LastRec() == 0)
					for e := 1 TO q:LastRec()
						oRow := q:GetRow(e)
						ADD ITEM { ;
							oRow:getField('id'), ;
							oRow:getField('nome_fantasia'), ;
							oRow:getField('razao_social') ;
						} TO grid_users_companies OF users
					next e
					q:Destroy()
				endif
			endif
return


/* Botões do formulário ***************************************************************************************************************************/

procedure users_button_show_password_action()
			users.label_show_password.VALUE := users.text_senha.VALUE
			users.label_show_password.Visible := true
			inkey(2)
			users.label_show_password.Visible := false
return

procedure users_permissions_action(nValue)
			users.radio_edi.VALUE := iif(nValue == 3, 2, 1)
			users.radio_ftp.VALUE := iif(nValue == 3, 2, 1)
			users.radio_lembretes.VALUE := nValue
			users.radio_clientes.VALUE := nValue
			users.radio_usuarios.VALUE := nValue
			users.radio_empresas.VALUE := nValue
			users.radio_log_sistema.VALUE := iif(nValue == 3, 2, 1)
			users.radio_configuracoes.VALUE := nValue
return

procedure users_button_save_action(lNovo)
			local cSQL, id_user
			local q AS OBJECT

			if Empty(users.text_nome.VALUE) .OR. Empty(users.text_celular.VALUE) .OR. Empty(users.text_email.VALUE) .OR.;
			   Empty(users.text_login.VALUE) .OR. Empty(users.text_senha.VALUE) .OR. Empty(users.text_departamento.VALUE)
				MsgExclamation('O nome, departamento, celular, eMail, Login e Senha devem ser informados!', 'Preenchimento obrigatório')
				return
			endif

			if pUsers_cModo == 'INSERT'
				id_user := hb_NToS(get_next_insert_id('usuarios'))
				cSQL := "INSERT INTO usuarios SET id=" + id_user + ","
			else
				cSQL := "UPDATE usuarios SET "
			endif

			cSQL += "user_login='" + unicode_to_ansi(users.text_login.VALUE) + "'"
			cSQL += ",user_nome='" + unicode_to_ansi(users.text_nome.VALUE) + "'"
			cSQL += ",user_apelido=" + IFNULL(users.text_apelido.VALUE)
			cSQL += ",departamento='" + unicode_to_ansi(users.text_departamento.VALUE) + "'"
			cSQL += ",user_senha='" + unicode_to_ansi(users.text_senha.VALUE) + "'"
			cSQL += ",user_email='" + unicode_to_ansi(users.text_email.VALUE) + "'"
			cSQL += ",user_celular=" + phoneformated_to_db(users.text_celular.VALUE)
			cSQL += ",user_ativo=" + logical_to_tinyint_db(users.checkbutton_ativo.VALUE)
			cSQL += ",menu_edi=" + hb_NToS(users.radio_edi.VALUE - 1)
			cSQL += ",menu_ftp=" + hb_NToS(users.radio_ftp.VALUE - 1)
			cSQL += ",menu_lembretes=" + hb_NToS(users.radio_lembretes.VALUE - 1)
			cSQL += ",menu_clientes=" + hb_NToS(users.radio_clientes.VALUE - 1)
			cSQL += ",menu_usuarios=" + hb_NToS(users.radio_usuarios.VALUE - 1)
			cSQL += ",menu_empresas=" + hb_NToS(users.radio_empresas.VALUE - 1)
			cSQL += ",menu_configuracoes=" + hb_NToS(users.radio_configuracoes.VALUE - 1)
			cSQL += ",menu_log_sistema=" + hb_NToS(users.radio_Log_sistema.VALUE - 1)

			if pUsers_cModo == 'UPDATE'
				id_user := hb_NToS(users.text_id.VALUE)
				cSQL += " WHERE user_id=" + id_user
			endif

			q := TSQLQuery():new(cSQL)

			if q:isExecuted()

				insert_company(id_user)
				load_grid_users_companies()

				if (lNovo)
					status_message('Status: Usuário ' + iif(pUsers_cModo == 'INSERT', 'incluído', 'alterado') + ' com sucesso!')
				else
					MsgInfo('Status: Usuário ' + iif(pUsers_cModo == 'INSERT', 'incluído', 'alterado') + ' com sucesso!', 'Tabela: Usuarios')
				endif
				pUsers_loadgrid := true
				q:Destroy()

			endif

			if (lNovo)
				users_clear_fields()
			else
				users.RELEASE
			endif

return

procedure insert_company(id_user)
			local e, n := 0
			local cSQL := "INSERT INTO users_emps (user_id, emp_id) VALUES "
			local q AS OBJECT

			/* Limpa todas as empresas do usuario antes de inserir as novas empresas */
			q := TSQLQuery():NEW("DELETE FROM users_emps WHERE user_id=" + id_user)

			for e := 1 TO users.grid_users_companies.ITEMCOUNT
				if users.grid_users_companies.CheckBoxItem(e)
					if ! (++n == 1)
							cSQL += ","
					endif
					cSQL += "(" + id_user + "," + hb_NToS(users.grid_users_companies.CellEx(e,1)) + ")"
				endif
			next e

			q:Destroy()
			q := TSQLQuery():NEW(cSQL)
			q:Destroy()
return

procedure users_form_on_release()
			if IsWIndowActive(users_list)
				DoMethod("users_list", "SETFOCUS")
			endif
return
