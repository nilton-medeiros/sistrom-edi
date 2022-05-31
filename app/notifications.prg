/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: notifications.prg
 Rotinas: Mostra as notificações do sistema e recados de usuários
***********************************************************************************/

#include <hmg.ch>

procedure show_notifications()
		local nRow
		local bForeColor := { || iif(p_aNotifications[This.CellRowIndex]['lido'], {100,100,100}, {0,0,0}) }
		private p_aUsers := {}, p_aNotifications := {}
		private p_cTarget_EditMensagem := ''
		private p_cActionButton
		private p_lResizedEdit := false

		DEFINE WINDOW notifications ;
			AT 84, 145 ;
			WIDTH 1075 ;
			HEIGHT 625 ;
			TITLE "Mensagens" ;
			ICON "imgInBox" ;
			MODAL ;
			ON INIT notifications_form_on_init() ;
			ON SIZE notifications_form_on_size() ;
			ON RELEASE main_timer1() ;
			BACKCOLOR {255,255,255} ;
			FONT "Open Sans" SIZE 10

			DEFINE SPLITBOX

				DEFINE TOOLBAR Notifica_1 BUTTONSIZE 128,74 IMAGESIZE 24,24 FONT "Open Sans" SIZE 11 FLAT

					BUTTON Notifica_Btn1 CAPTION "Notificações" PICTURE "imgInBox" WHOLEDROPDOWN

					DEFINE DROPDOWN MENU BUTTON Notifica_Btn1
						ITEM 'Responder' ACTION reply_to_notifications() NAME Menu_Notif1_Btn1 IMAGE "imgEmailSend"
						ITEM 'Novo' ACTION new_notifications() NAME Menu_Notif1_Btn2 IMAGE "imgEmailNew"
						SEPARATOR
						ITEM 'Excluir' ACTION delete_notifications() NAME Menu_Notif1_Btn2 IMAGE "imgEmailDelete"
					END MENU

				END TOOLBAR

				DEFINE TOOLBAR Notifica_2 BUTTONSIZE 128,64 IMAGESIZE 24,24 FONT "Open Sans" SIZE 8 FLAT

					BUTTON Notifica_Btn2 CAPTION ".   Entrada   ." PICTURE "imgInput" WHOLEDROPDOWN

					DEFINE DROPDOWN MENU BUTTON Notifica_Btn2
						ITEM 'Entrada' ACTION notification_menu("Entrada") NAME Menu_Notif2_Btn1 IMAGE "imgInput"
						ITEM 'Enviados' ACTION notification_menu("Enviado") NAME Menu_Notif2_Btn2 IMAGE "imgSent"
						ITEM 'Arquivado' ACTION notification_menu("Arquivado") NAME Menu_Notif2_Btn3 IMAGE "imgArchived"
					END MENU

				END TOOLBAR

				DEFINE TOOLBAR Notifica_3 BUTTONSIZE 128,64 IMAGESIZE 24,24 FONT "Open Sans" SIZE 8 FLAT

					BUTTON Notifica_Btn3 CAPTION ".   Opções   ." PICTURE "imgOptions" WHOLEDROPDOWN

					DEFINE DROPDOWN MENU BUTTON Notifica_Btn3
						ITEM 'Marcar como lido' ACTION mark_as_read_unread("1") NAME Menu_Notif3_Btn1 IMAGE "imgEmailRead"
						ITEM 'Marcar como não lido' ACTION mark_as_read_unread("0") NAME Menu_Notif3_Btn2 IMAGE "imgUnReadEmail"
						ITEM 'Arquivar' ACTION move_notifications(true) NAME Menu_Notif3_Btn3 IMAGE "imgArchive"
					END MENU

				END TOOLBAR

				DEFINE TOOLBAR Notifica_4 BUTTONSIZE 128,64 IMAGESIZE 24,24 FONT "Open Sans" SIZE 8 FLAT
					BUTTON Notifica_Btn4 CAPTION ".   Fechar   ." PICTURE "imgClose" ACTION notifications.RELEASE
				END TOOLBAR

			END SPLITBOX

			DEFINE CHECKBOX checkbox_SelectAllItems
				ROW 88
				COL 12
				CAPTION "Selecionar Todas Notificações"
				VALUE false
				WIDTH 250
				HEIGHT 18
				FONTNAME "Open Sans"
				FONTSIZE 9
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				BACKCOLOR {255,255,255}
				FONTCOLOR {100,100,100}
				ONCHANGE notifications_combobox_selectAllItems_on_change()
				TRANSPARENT false
				VISIBLE true
				TABSTOP true
			END CHECKBOX

			DEFINE COMBOBOX combobox_filtro
				ROW    83
				COL    395
				WIDTH  120
				HEIGHT 300
				ITEMS {"Todas","Lembretes","Agenda","Pagar","Receber","Usuários"}
				VALUE 1
				FONTNAME "Open Sans"
				FONTSIZE 9
				TOOLTIP ""
				ONCHANGE notifications_combobox_filter_on_change()
				ONGOTFOCUS NIL
				ONLOSTFOCUS NIL
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				HELPID NIL
				TABSTOP true
				VISIBLE true
				SORT false
				ONENTER NIL
				ONDISPLAYCHANGE NIL
				DISPLAYEDIT false
				IMAGE NIL
				DROPPEDWIDTH NIL
				ONDROPDOWN NIL
				ONCLOSEUP NIL
			END COMBOBOX

			DEFINE GRID grid_notifications
				ROW    110
				COL    5
				WIDTH  515
				HEIGHT 445
				WIDTHS { 150, 140, 80, 140}
				TOOLTIP NIL
				HEADERS {'Titulo','Remetente','Departamento','Data'}
				FONTNAME "Open Sans"
				FONTSIZE 9
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				ONCHANGE notifications_show_messages()
				MULTISELECT false
				ALLOWEDIT false
				VIRTUAL false
				DYNAMICBACKCOLOR NIL
				DYNAMICFORECOLOR {bForeColor,bForeColor,bForeColor,bForeColor}
				COLUMNCONTROLS {"TEXTBOX","TEXTBOX","TEXTBOX","TEXTBOX"}
				SHOWHEADERS false
				CELLNAVIGATION false
				NOLINES true
				JUSTIFY {GRID_JTFY_LEFT, GRID_JTFY_LEFT, GRID_JTFY_LEFT, GRID_JTFY_CENTER}
				ALLOWAPPEND false
				ALLOWDELETE false
				BUFFERED false
			END GRID

			DEFINE LABEL label_titulo
				ROW     70
				COL    525
				WIDTH  500
				HEIGHT 18
				VALUE "Titulo ─────────────────────────────────────"
				FONTNAME "Open Sans"
				FONTSIZE 10
				TOOLTIP ""
				FONTBOLD true
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				HELPID NIL
				VISIBLE true
				TRANSPARENT false
				ACTION NIL
				AUTOSIZE false
				BACKCOLOR {255,255,255}
				FONTCOLOR NIL
			END LABEL

			DEFINE LABEL label_Depto_Remetente
				ROW     90
				COL    525
				WIDTH  400
				HEIGHT 18
				VALUE "Departamento | Remetente ───────────────────"
				FONTNAME "Open Sans"
				FONTSIZE 10
				TOOLTIP ""
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				HELPID NIL
				VISIBLE true
				TRANSPARENT false
				ACTION NIL
				AUTOSIZE false
				BACKCOLOR {255,255,255}
				FONTCOLOR {110,110,110}
			END LABEL

			DEFINE LABEL label_data_hora
				ROW     90
				COL    945
				WIDTH  210
				HEIGHT 18
				VALUE "Data e Hora ───────────────"
				FONTNAME "Open Sans"
				FONTSIZE 10
				TOOLTIP ""
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				HELPID NIL
				VISIBLE true
				TRANSPARENT false
				ACTION NIL
				AUTOSIZE false
				BACKCOLOR {255,255,255}
				FONTCOLOR {110,110,110}
			END LABEL

			DEFINE COMBOBOX combobox_users
				ROW    50
				COL    521
				WIDTH  525
				HEIGHT 400
				ITEMS {""}
				VALUE 0
				FONTNAME "Open Sans"
				FONTSIZE 10
				TOOLTIP "Escolha o usuário para receber a mensagem"
				ONCHANGE notifications_combobox_users_on_change()
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				TABSTOP true
				VISIBLE false
				SORT false
				DISPLAYEDIT false
			END COMBOBOX

			DEFINE TEXTBOX text_title
				ROW    85
				COL    400
				WIDTH  120
				HEIGHT 24
				FONTNAME "Open Sans"
				FONTSIZE 9
				TOOLTIP "Assunto da mensagem"
				FONTCOLOR {110,110,110}
				ONGOTFOCUS notificaations_text_title_on_goto_focus()
				ONLOSTFOCUS notificaations_text_title_on_enter_lostfocus()
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				ONENTER notificaations_text_title_on_enter_lostfocus()
				TABSTOP true
				VISIBLE true
				READONLY false
				RIGHTALIGN false
				CASECONVERT NONE
				VALUE "Assunto (Título) da mensagem"
			END TEXTBOX

			DEFINE EDITBOX editbox_message
				ROW    110
				COL    521
				WIDTH  525
				HEIGHT 445
				VALUE ""
				FONTNAME "Open Sans"
				FONTSIZE 9
				TOOLTIP ""
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				TABSTOP true
				VISIBLE true
				READONLY true
				HSCROLLBAR true
				VSCROLLBAR true
			END EDITBOX

			DEFINE BUTTON btn_send
				ROW    523
				COL    820
				WIDTH  110
				HEIGHT 30
				ACTION notifications_button_send()
				CAPTION "Enviar"
				FONTNAME "Open Sans"
				FONTSIZE 9
				TOOLTIP ""
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				FLAT false
				TABSTOP true
				VISIBLE false
				TRANSPARENT true
				MULTILINE false
				PICTURE "imgEmailSend30"
				PICTALIGNMENT LEFT
			END BUTTON

			DEFINE BUTTON button_cancel
				ROW    523
				COL    940
				WIDTH  110
				HEIGHT 30
				ACTION notifications_button_cancel()
				CAPTION "Cancelar"
				FONTNAME "Open Sans"
				FONTSIZE 9
				TOOLTIP ""
				FONTBOLD false
				FONTITALIC false
				FONTUNDERLINE false
				FONTSTRIKEOUT false
				FLAT false
				TABSTOP true
				VISIBLE false
				TRANSPARENT true
				MULTILINE false
				PICTURE "bttCancel"
				PICTALIGNMENT LEFT
			END BUTTON

			DEFINE STATUSBAR FONT "Open Sans" SIZE 9
				STATUSITEM "ATENÇÃO:  As Notificações com mais de Três Meses Não Arquivadas, sendo lidas ou não, serão Excluídas Automaticamente!" FLAT
			END STATUSBAR

		END WINDOW

		on key escape of notifications action notifications.RELEASE
		//_HMG_SYSDATA[ 40 ][ GetControlIndex("grid_notifications", "notifications") ][ 46 ] := {|| notifications_OnCheckBoxClicked() }
		notifications.CENTER

		nRow := round((GetProperty('Main','HEIGHT') - notifications.HEIGHT) / 2, 0)

		if nRow < 33
			nRow := 33 - nRow
		else
			nRow := GetProperty('Main','Row') + 100
			if nRow > 110
				nRow := 110
			endif
		endif

		notifications.ROW := nRow
		notifications.ACTIVATE

return

procedure notifications_form_on_init()

		notifications.Notifica_Btn2.Caption := "Entrada"
		notifications.Notifica_Btn3.Caption := "Opções"
		notifications.Notifica_Btn4.Caption := "Fechar"
		notifications.Notifica_Btn1.ENABLED := true
		notifications.Notifica_Btn2.ENABLED := true
		notifications.Notifica_Btn3.ENABLED := true
		notifications.combobox_users.Visible := false
		notifications.text_title.Visible := false
		notifications.grid_notifications.CheckBoxEnabled := true
		notifications.label_Titulo.VALUE := ''
		notifications.label_Depto_Remetente.VALUE := ''
		notifications.label_data_hora.VALUE := ''
		notifications.editbox_message.VALUE := ''

		grid_notifications_load("Entrada")

return

procedure grid_notifications_load(cOperacao)
		local oRow, oQuery
		local nRow, i, nShow_ID
		local cApelido, cShow_Name, cDeparamento
		local cSQL := "SELECT id,"

		cSQL += "id_remetente,"
		cSQL += "nome_remetente,"
		cSQL += "apelido_remetente,"
		cSQL += "departamento_remetente,"
		cSQL += "id_destinatario,"
		cSQL += "nome_destinatario,"
		cSQL += "apelido_destinatario,"
		cSQL += "departamento_destinatario,"
		cSQL += "titulo,"
		cSQL += "data_hora,"
		cSQL += "mensagem,"
		cSQL += "lido "
		cSQL += "FROM view_notificacoes "

		if cOperacao == "Enviado"
		cSQL += "WHERE id_remetente=" + app:getUser('id')
		//cSQL += " AND enviado=1"
		else

		cSQL += "WHERE id_destinatario=" + app:getUser('id')
		cSQL += " AND arquivado=" + logical_to_tinyint_db(cOperacao=="Arquivado")

		if cOperacao == 'Entrada' .and. ! (notifications.combobox_filtro.VALUE == 1)

			// {"Todas","Lembretes","Agenda","Pagar","Receber","Usuários"}

			switch notifications.combobox_filtro.VALUE
				case 2
					cSQL += " AND origem='LEMBRETES'"
					exit
				case 3
					cSQL += " AND origem='EDI'"
					exit
				case 4
					cSQL += " AND origem='FTP'"
					exit
				case 5
					cSQL += " AND origem='LOGSYS'"
					exit
				case 6
					cSQL += " AND origem='USUARIOS'"
					exit
			endswitch

		endif

		endif

		notifications.checkbox_SelectAllItems.VALUE := false

		oQuery := TSQLQuery():NEW(cSQL)

		notifications.grid_notifications.DELETEALLITEMS
		notifications.checkbox_SelectAllItems.ENABLED := false
		p_aNotifications := {}
		notifications.editbox_message.VALUE := ''

		if oQuery:isExecuted()

			nRow := oQuery:LastRec()

			if nRow > 0

				for i := 1 TO nRow

						oRow := oQuery:GetRow(i)

						if cOperacao == "Enviado"
							cApelido := oRow:getField('apelido_destinatario')
							nShow_ID := oRow:getField('id_destinatario')
							cShow_Name := oRow:getField('nome_destinatario')
							cDeparamento := oRow:getField('departamento_destinatario')
						else
							cApelido := oRow:getField('apelido_remetente')
							nShow_ID := oRow:getField('id_remetente')
							cShow_Name := oRow:getField('nome_remetente')
							cDeparamento := oRow:getField('departamento_remetente')
						endif

						if Empty(cApelido)
							cApelido := first_word(cShow_Name)
						endif

						AAdd(p_aNotifications, { 'id' => oRow:getField('id'), ;
														'titulo' => oRow:getField('titulo') , ;
														'show_id' => nShow_ID, ;
														'show_name' => cShow_Name, ;
														'apelido' => cApelido, ;
														'departamento' => cDeparamento, ;
														'data_hora' => datetime_db_to_br(oRow:getField('data_hora')), ;
														'lido' => is_true(oRow:getField('lido')), ;
														'mensagem' => oRow:getField('mensagem') ;
						})

						ADD ITEM { ;
							oRow:getField('titulo'), ;
							cShow_Name, ;
							cDeparamento, ;
							datetime_db_to_br(oRow:getField('data_hora')) ;
						} TO grid_notifications OF notifications

				next i

				notifications.checkbox_SelectAllItems.ENABLED := true

			endif

		endif

		main_timer1()
		oQuery:Destroy()

return

procedure notification_menu(cOperacao)

		notifications.label_Titulo.VALUE := ''
		notifications.label_Depto_Remetente.VALUE := ''
		notifications.label_data_hora.VALUE := ''
		notifications.editbox_message.VALUE := ''

		if ! (notifications.Notifica_Btn2.Caption == cOperacao)

			notifications.Notifica_Btn2.Caption := cOperacao
			notifications.Notifica_Btn2.Picture := iif(cOperacao=="Entrada", "imgInput", iif(cOperacao=="Enviado", "imgSent", "imgArchived"))
			notifications.combobox_filtro.ENABLED := (cOperacao == 'Entrada')

			if (cOperacao == 'Enviado')
				notifications.Notifica_Btn3.ENABLED := false
				notifications.Menu_Notif1_Btn1.ENABLED := false
			else
				RELEASE DROPDOWN MENU BUTTON Notifica_Btn3 OF notifications
				DEFINE DROPDOWN MENU BUTTON Notifica_Btn3 OF notifications
						ITEM 'Marcar como lido' ACTION mark_as_read_unread("1") NAME Menu_Notif3_Btn1 IMAGE "imgEmailRead"
						ITEM 'Marcar como não lido' ACTION mark_as_read_unread("0") NAME Menu_Notif3_Btn2 IMAGE "imgUnReadEmail"
						ITEM iif(cOperacao=="Entrada", 'Arquivar', 'Mover para Entrada') ACTION move_notifications(cOperacao=="Entrada") NAME Menu_Notif2_Btn3 IMAGE iif(cOperacao=="Entrada", "imgArchive", "imgMove")
				END MENU
				notifications.Menu_Notif1_Btn1.ENABLED := true
				notifications.Notifica_Btn3.ENABLED := true
			endif

			grid_notifications_load(cOperacao)

		endif

return

procedure notifications_combobox_selectAllItems_on_change()
		local x
		for x := 1 TO notifications.grid_notifications.ItemCount
			notifications.grid_notifications.CheckBoxItem(x) := notifications.checkbox_SelectAllItems.VALUE
		next x
return

procedure mark_as_read_unread(cLido)
		local x
		local nItens := 0
		local oQuery
		local cSQL := "UPDATE notificacoes SET lido=" + cLido + " WHERE id IN ("

		for x := 1 TO notifications.grid_notifications.ItemCount

			if notifications.grid_notifications.CheckBoxItem(x) .AND. iif(cLido=="0", p_aNotifications[x]['lido'], ! p_aNotifications[x]['lido'])

				nItens++

				if (nItens == 1)
						cSQL += hb_NToS(p_aNotifications[x]['id'])
				else
						cSQL += "," + hb_NToS(p_aNotifications[x]['id'])
				endif

				p_aNotifications[x]['lido'] := ! p_aNotifications[x]['lido']

			endif

		next x

		if ! (nItens == 0)

			cSQL += ") AND lido=" + iif(cLido=="0", "1", "0")

			oQuery := TSQLQuery():NEW(cSQL)

			if oQuery:isExecuted()
				notifications.grid_notifications.Refresh
				notifications.checkbox_SelectAllItems.VALUE := false
				notifications.checkbox_SelectAllItems.SETFOCUS
				main_timer1()
			endif

			oQuery:Destroy()

		endif

return

procedure Marcar_Lido(nId)
		local oQuery
		local cSQL := "UPDATE notificacoes SET lido=1 WHERE id=" + hb_NToS(nId)

		oQuery := TSQLQuery():NEW(cSQL)

		if oQuery:isExecuted()
			main_timer1()
		endif

		oQuery:Destroy()

return

procedure move_notifications(lArquivar)
		local x
		local nItens := 0
		local oQuery
		local cSQL1 := "UPDATE notificacoes SET arquivado=" + logical_to_tinyint_db(lArquivar) + " WHERE id", cSQL2

		for x := 1 TO notifications.grid_notifications.ItemCount

			if notifications.grid_notifications.CheckBoxItem(x)

				nItens++

				if (nItens == 1)
						cSQL2 := hb_NToS(p_aNotifications[x]['id'])
				else
						cSQL2 += "," + hb_NToS(p_aNotifications[x]['id'])
				endif

			endif

		next x

		if ! (nItens == 0)

			if (nItens == 1)
				cSQL1 += "=" + cSQL2
			else
				cSQL1 += " IN (" + cSQL2 + ")"
			endif

			oQuery := TSQLQuery():NEW(cSQL1)

			if oQuery:isExecuted()
				nItens := notifications.grid_notifications.ItemCount
				nPos   := 1
				for x := 1 TO nItens
						if notifications.grid_notifications.CheckBoxItem(nPos)
							notifications.grid_notifications.DeleteItem(nPos)
							nPos--
						endif
						nPos++
				next x
				notifications.grid_notifications.Refresh
			endif

			oQuery:Destroy()

		endif

		notifications.checkbox_SelectAllItems.VALUE := false

return

procedure notifications_show_messages()

		if (notifications.grid_notifications.VALUE == 0)
			notifications.editbox_message.VALUE := ''
		else

			notifications.label_Titulo.VALUE := p_aNotifications[notifications.grid_notifications.VALUE]['titulo']
			notifications.label_Depto_Remetente.VALUE := p_aNotifications[notifications.grid_notifications.VALUE]['departamento'] + " | " + p_aNotifications[notifications.grid_notifications.VALUE]['show_name']
			notifications.label_data_hora.VALUE := p_aNotifications[notifications.grid_notifications.VALUE]['data_hora']
			notifications.editbox_message.VALUE := CRLF + p_aNotifications[notifications.grid_notifications.VALUE]['mensagem']

			if ! (notifications.Notifica_Btn2.Caption == "Enviado") .AND. ! p_aNotifications[notifications.grid_notifications.VALUE]['lido']
				Marcar_Lido(p_aNotifications[notifications.grid_notifications.VALUE]['id'])
				p_aNotifications[notifications.grid_notifications.VALUE]['lido'] := true
				notifications.grid_notifications.Refresh
				notifications.checkbox_SelectAllItems.SETFOCUS
			endif

		endif

return

procedure new_notifications()
		local oQuery
		local cUserName
		local cSQL := "SELECT t1.user_id AS id, t1.user_nome AS nome, t1.user_apelido AS apelido, t1.departamento, t3.emp_nome_fantasia AS nome_fantasia "

		cSQL += "FROM view_usuarios AS t1 "
		cSQL += "INNER JOIN users_emps AS t2 ON t2.user_id = t1.user_id "
		cSQL += "INNER JOIN empresas AS t3 ON t3.emp_id = t2.emp_id "
		cSQL += "WHERE t1.user_ativo=1 AND t1.user_id > 1 "
		cSQL += "GROUP BY user_nome "
		cSQL += "ORDER BY emp_nome_fantasia, user_apelido, user_nome"

		oQuery := TSQLQuery():NEW(cSQL)

		if oQuery:isExecuted()

			notifications.Notifica_Btn1.ENABLED := false
			notifications.Notifica_Btn2.ENABLED := false
			notifications.Notifica_Btn3.ENABLED := false
			notifications.checkbox_SelectAllItems.ENABLED := false
			notifications.grid_notifications.VALUE := 0
			notifications.grid_notifications.ENABLED := false
			notifications.label_Titulo.Visible := false
			notifications.label_Depto_Remetente.Visible := false
			notifications.label_data_hora.Visible := false
			notifications.combobox_users.ROW := notifications.label_Titulo.ROW - 10
			notifications.combobox_users.DELETEALLITEMS
			notifications.text_title.COL := notifications.combobox_users.COL
			notifications.text_title.WIDTH := notifications.combobox_users.WIDTH
			notifications.text_title.VALUE := "Assunto (Título) da mensagem"
			notifications.text_title.FontColor := {110,110,110}
			notifications.text_title.Visible := true

			p_aUsers := {}

			for x := 1 TO oQuery:LastRec()

				AAdd(p_aUsers, {'id' => oQuery:getField('id'), 'nome' => oQuery:getField('nome'), 'departamento' => oQuery:getField('departamento')})

				cUserName := oQuery:getField('apelido')

				if Empty(cUserName)
					cUserName := first_word(oQuery:getField('nome')) + ' ' + last_word(oQuery:getField('nome'))
				endif

				cUserName += " | " + oQuery:getField('departamento')

				if app:lenCompanies() > 1
					cUserName += " | " + oQuery:getField('nome_fantasia')
				endif

				notifications.combobox_users.AddItem(cUserName)

				oQuery:Skip()

			next x

			oQuery:Destroy()

			notifications.combobox_users.VALUE := 0
			notifications.combobox_users.Visible := true

			p_cActionButton := 'NOVA'
			p_cTarget_EditMensagem := notifications.editbox_message.VALUE
			p_lResizedEdit := true

			notifications.editbox_message.VALUE := ''
			notifications.editbox_message.Height := notifications.editbox_message.Height - 45
			notifications.btn_send.Visible := true
			notifications.button_cancel.Visible := true
			notifications.editbox_message.READONLY := false
			notifications.combobox_users.SETFOCUS

		endif

return

procedure delete_notifications()
		local nItens, nPos, n, x := 0
		LOCA hId
		local cSQL := "DELETE FROM notificacoes WHERE id"
		local aDelIds := {}
		local oQuery

		for n := 1 TO notifications.grid_notifications.ItemCount
			if notifications.grid_notifications.CheckBoxItem(n) .AND. p_aNotifications[n]['lido']
				AAdd(aDelIds, {'id' => p_aNotifications[n]['id'], 'Value' => n})
				x++
			endif
		next n

		if (x == 0)
			MsgInfo('Não há notificações lidas ou selecionadas para excluir', 'Exclusão de Notificações')
		else
			if MsgYesNo('Deseja excluir ' + iif(x==1, 'a notificação selecionada?','as ' + hb_NToS(x) + ' notificações lidas e selecionadas?'), 'Exclusão de Notificações Lidas' )

				if (x == 1)
						cSQL += "=" + hb_NToS(aDelIds[1,'id'])
				else
						cSQL += " IN ("
						n := 0
						for each hId in aDelIds
							if (++n == 1)
								cSQL += hb_NToS(hId['id'])
							else
								cSQL += "," + hb_NToS(hId['id'])
							endif
						next each
						cSQL += ")"
				endif

				oQuery := TSQLQuery():NEW(cSQL)

				if oQuery:isExecuted()
						notifications.label_Titulo.VALUE := ''
						notifications.label_Depto_Remetente.VALUE := ''
						notifications.label_data_hora.VALUE := ''
						notifications.editbox_message.VALUE := ''
						grid_notifications_load(notifications.Notifica_Btn2.Caption)
						status_message('Status: ' + iif(x==1, 'Notificação excluída', hb_NToS(x) + ' Notificações excluídas') + ' com sucesso!')
						oQuery:Destroy()
				endif

			endif

		endif

return

procedure reply_to_notifications()

		if (notifications.grid_notifications.VALUE == 0)
			MsgInfo('Selecione uma mensagem','Responder')
		else

			notifications.Notifica_Btn1.ENABLED := false
			notifications.Notifica_Btn2.ENABLED := false
			notifications.Notifica_Btn3.ENABLED := false
			notifications.checkbox_SelectAllItems.ENABLED := false
			notifications.grid_notifications.ENABLED := false
			p_lResizedEdit := true

			p_cTarget_EditMensagem := notifications.editbox_message.VALUE
			notifications.editbox_message.Height := notifications.grid_notifications.Height - 45
			notifications.editbox_message.VALUE := "Oi " + p_aNotifications[notifications.grid_notifications.VALUE]['apelido'] + CRLF + CRLF + ;
															"Em resposta à sua mensagem..." + CRLF + CRLF + ;
															"─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" + CRLF + ;
															"De: " + notifications.label_Depto_Remetente.VALUE + CRLF + ;
															"Enviada em: " + notifications.label_data_hora.VALUE + CRLF + ;
															"Para: " + app:getUser() + CRLF + ;
															"Assunto: " + notifications.label_Titulo.VALUE + CRLF + CRLF + ;
															notifications.editbox_message.VALUE
			p_cActionButton := 'RESPONDER'
			notifications.btn_send.Visible := true
			notifications.button_cancel.Visible := true
			notifications.editbox_message.READONLY := false
			notifications.editbox_message.SETFOCUS

		endif

return

procedure notifications_button_send()
		local nPos := notifications.grid_notifications.VALUE
		local cSQL := "INSERT INTO notificacoes SET "
		local oQuery

		if Empty(notifications.text_title.VALUE) .OR. Empty(notifications.editbox_message.VALUE) .OR. (p_cActionButton == 'NOVA' .AND. Empty(notifications.combobox_users.VALUE))
			return
		endif

		cSQL += "id_remetente=" + app:getUser('id') + ","

		if p_cActionButton == 'NOVA'
			cSQL += "id_destinatario=" + hb_NToS(p_aUsers[notifications.combobox_users.VALUE]['id']) + ","
			cSQL += "titulo='" + unicode_to_ansi(notifications.text_title.VALUE) + "',"
			cSQL += "enviado=1,"
		else
			cSQL += "id_destinatario=" + hb_NToS(p_aNotifications[nPos]['show_id']) + ","
			cSQL += "titulo='RES: " + p_aNotifications[nPos]['titulo'] + "',"
		endif

		cSQL += "mensagem='" + unicode_to_ansi(notifications.editbox_message.VALUE) + "',"
		cSQL += "origem='USUARIOS'"

		oQuery := TSQLQuery():NEW(cSQL)

		if oQuery:isExecuted()

			notifications.combobox_users.Visible := false
			notifications.text_title.Visible := false
			notifications.label_Titulo.Visible := true
			notifications.label_Depto_Remetente.Visible := true
			notifications.label_data_hora.Visible := true
			notifications.Notifica_Btn1.ENABLED := true
			notifications.Notifica_Btn2.ENABLED := true
			notifications.Notifica_Btn3.ENABLED := true
			notifications.checkbox_SelectAllItems.ENABLED := true
			notifications.editbox_message.VALUE := p_cTarget_EditMensagem
			notifications.btn_send.Visible := false
			notifications.button_cancel.Visible := false
			notifications.editbox_message.READONLY := true
			notifications.grid_notifications.ENABLED := true
			notifications.editbox_message.Height := notifications.grid_notifications.Height
			p_lResizedEdit := false

			oQuery:Destroy()

			grid_notifications_load(notifications.Notifica_Btn2.Caption)
			status_message('Mensagem enviada com sucesso!', true, 'Envio de Mensagem', MB_ICONINFORMATION)

		endif

return

procedure notifications_button_cancel()
		notifications.combobox_users.Visible := false
		notifications.text_title.Visible := false
		notifications.label_Titulo.Visible := true
		notifications.label_Depto_Remetente.Visible := true
		notifications.label_data_hora.Visible := true
		notifications.btn_send.Visible := false
		notifications.button_cancel.Visible := false
		notifications.editbox_message.VALUE := p_cTarget_EditMensagem
		notifications.editbox_message.Height := notifications.grid_notifications.Height
		notifications.editbox_message.READONLY := true
		notifications.grid_notifications.ENABLED := true
		notifications.Notifica_Btn1.ENABLED := true
		notifications.Notifica_Btn2.ENABLED := true
		notifications.Notifica_Btn3.ENABLED := true
		notifications.checkbox_SelectAllItems.ENABLED := true
		p_lResizedEdit := false
return

procedure notificaations_text_title_on_goto_focus()
		if notifications.text_title.VALUE == "Assunto (Título) da mensagem"
			notifications.text_title.VALUE := ''
			notifications.text_title.FontColor := BLACK
		endif
return

procedure notificaations_text_title_on_enter_lostfocus()
		 if Empty(notifications.text_title.VALUE)
			notifications.text_title.VALUE := "Assunto (Título) da mensagem"
			notifications.text_title.FontColor := {110,110,110}
		endif
return

procedure notifications_combobox_users_on_change()
		notifications.combobox_users.ToolTip := p_aUsers[notifications.combobox_users.VALUE]['nome'] + CRLF + p_aUsers[notifications.combobox_users.VALUE]['departamento']
return

procedure notifications_form_on_size()

		if notifications.Height < 625
			notifications.Height := 625
		end
		if notifications.WIDTH < 1075
			notifications.WIDTH := 1075
		end

		notifications.grid_notifications.Height := notifications.Height - 180

		if p_lResizedEdit
			notifications.editbox_message.Height := notifications.grid_notifications.Height - 45
		else
			notifications.editbox_message.Height := notifications.grid_notifications.Height
		endif

		notifications.editbox_message.WIDTH := notifications.WIDTH - 550
		notifications.btn_send.ROW := notifications.Height - 102
		notifications.btn_send.COL := notifications.WIDTH - 255
		notifications.button_cancel.ROW := notifications.btn_send.ROW
		notifications.button_cancel.COL := notifications.btn_send.COL + 120

return

procedure notifications_combobox_filter_on_change()

		if notifications.Notifica_Btn2.Caption == 'Entrada'
			grid_notifications_load('Entrada')
		endif

return