/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: clients.prg
 Rotinas: Cadastro de Clientes - CRUD: Incluir, Consultar, Alterar e Excluir
***********************************************************************************/

#include <hmg.ch>

declare window clients

/*
 * Invocada pelo form clientes, botoes: Novo, Editar, Excluir e OnDblClick no registro da Grade
 * ADVERTÊNCIA: As variáveis private neste formulário são enchergadas em todos os demais formulários abertos ao mesmo tempo
*/

/* Rotinas iniciais -------------------------------------------------------------------------------*/
procedure clients_form
    parameter pCli_cModo   // Dessa forma o parâmetro é private, se for da forma convencional clients_form(pCli_cModo), o parâmetro é de escopo local
    private pHistoric_query AS OBJECT

    if IsWIndowActive(clients)
        clients.MINIMIZE
        clients.RESTORE
        clients.SETFOCUS
    else
        load window clients
        on key escape of clients action clients.RELEASE
        clients.CENTER
        clients.ACTIVATE
    endif

return

procedure clients_form_on_init()

    clients.tab_clients.VALUE := 1
    clients.text_id.ENABLED := false
    clients.btt_save.ENABLED := true
    clients.btt_save_and_new.ENABLED := true
    clients.btn_cancel.ENABLED := true

    if pCli_cModo == 'INSERT'
        clients_reset_fields()
    elseif pCli_cModo == 'UPDATE'
        clients_load_fields(false)
        clients.btt_save_and_new.ENABLED := false
    else  // SELECT
        clients_load_fields(true)
        clients.btt_save.ENABLED := false
        clients.btt_save_and_new.ENABLED := false
    endif

return

procedure clients_reset_fields()

          clients.text_id.VALUE := 0
          clients.text_razao_social.VALUE := ''
          clients.text_nome_fantasia.VALUE := ''
          clients.radio_tipo_pessoa.VALUE := 1  // 1-Jurídica, 2-Física
          clients.text_doc1.VALUE := ''
          clients.text_doc2.VALUE := ''
          clients.text_fone1.VALUE := ''
          clients.text_fone2.VALUE := ''
          clients.checkbutton_ativo.VALUE := false
          clients.checkbutton_ativo.PICTURE := 'bttTurnOff'
          clients.text_cep.VALUE := ''
          clients.text_logradouro.VALUE := ''
          clients.text_numero.VALUE := ''
          clients.text_complemento.VALUE := ''
          clients.text_bairro.VALUE := ''
          clients.text_municipio.VALUE := ''
          clients.combobox_uf.VALUE := index_of_comboBox("clients", "combobox_uf", app:getCompanies('uf'))
          // Categorias do cliente: 0 - Remetente, 1 - Expedidor, 2 - Recebedor, 3 - Destinatário, 4 - Todos, 5 - Representante
          clients.combobox_categoria.VALUE := 5  // no mysql começa no 0, no combobox começa no 1, então o 4 do mysql é o 5 no combobox
          clients.checkbox_conemb.VALUE := false
          clients.checkbox_notfis.VALUE := false
          clients.checkbox_ocoren.VALUE := false
          clients.checkbox_doccob.VALUE := false
          clients.text_caixa_postal.VALUE := ''
          clients.text_ftp_server.VALUE := ''
          clients.text_ftp_user_id.VALUE := ''
          clients.text_ftp_password.VALUE := ''
          clients.text_ftp_remote_path.VALUE := ''
          DELETE ITEM ALL FROM grid_clients_events OF clients
          clients.editbox_clients_events.VALUE := ''
          clients_radio_tipo_pessoa_on_change()
return

procedure clients_load_fields(lReadOnly)
    local oRow, nValue := GetProperty('clients_list', 'grid_clients_list', 'VALUE')

    if (nValue == 0) .or. ! (ValType(pCli_oQuery) == "O") .or. (pCli_oQuery:LastRec() == 0)
        return
    endif

    oRow := pCli_oQuery:GetRow(nValue)
    clients.text_id.VALUE := oRow:getField('id')
    clients.text_razao_social.VALUE := oRow:getField('razao_social')
    clients.text_nome_fantasia.VALUE := oRow:getField('nome_fantasia')
    clients.radio_tipo_pessoa.VALUE := iif(oRow:getField('tipo_doc')=='CNPJ', 1, 2)
    clients_radio_tipo_pessoa_on_change()
    clients.text_doc1.VALUE := oRow:getField('doc1', iif(clients.radio_tipo_pessoa.VALUE==1, "as cnpj", "as cpf"))
    clients.text_doc2.VALUE := oRow:getField('doc2')
    clients.text_fone1.VALUE := oRow:getField('fone1', 'as phone')
    clients.text_fone2.VALUE := oRow:getField('fone2', "as phone")
    clients.checkbutton_ativo.VALUE := is_true(oRow:getField('ativo'))
    checkbutton_ativo_on_change('clients', 'checkbutton_ativo')
    clients.text_cep.VALUE := Transform(oRow:getField('cep'), "@R 99999-999")
    clients.text_logradouro.VALUE := oRow:getField('logradouro')
    clients.text_numero.VALUE := oRow:getField('numero')
    clients.text_complemento.VALUE := oRow:getField('complemento')
    clients.text_bairro.VALUE := oRow:getField('bairro')
    clients.text_municipio.VALUE := oRow:getField('municipio')
    clients.combobox_uf.VALUE := index_of_comboBox("clients", "combobox_uf", oRow:getField('uf'))
    // Categorias do cliente no db: 0 - Remetente, 1 - Expedidor, 2 - Recebedor, 3 - Destinatário, 4 - Todos, 5 - Representante
    clients.combobox_categoria.VALUE := oRow:getField('categoria') + 1  // no mysql começa no 0, no combobox começa no 1, então o 4 do mysql é o 5 no combobox
    clients.checkbox_conemb.VALUE := is_true(oRow:getField('edi_conemb'))
    clients.checkbox_notfis.VALUE := is_true(oRow:getField('edi_notfis'))
    clients.checkbox_ocoren.VALUE := is_true(oRow:getField('edi_ocoren'))
    clients.checkbox_doccob.VALUE := is_true(oRow:getField('edi_doccob'))
    clients.text_caixa_postal.VALUE := oRow:getField('edi_caixa_postal')
    clients.text_ftp_server.VALUE := oRow:getField('edi_ftp_server')
    clients.text_ftp_user_id.VALUE := oRow:getField('edi_ftp_user_id')
    clients.text_ftp_password.VALUE := oRow:getField('edi_ftp_password')
    clients.text_ftp_remote_path.VALUE := oRow:getField('edi_ftp_remote_path')
    clients.editbox_clients_events.VALUE := ''

    clients.text_razao_social.READONLY := lReadOnly
    clients.text_nome_fantasia.READONLY := lReadOnly
    clients.radio_tipo_pessoa.READONLY := {lReadOnly, lReadOnly}
    clients.radio_tipo_pessoa.ENABLED := ! lReadOnly
    clients.text_doc1.READONLY := lReadOnly
    clients.text_doc2.READONLY := lReadOnly
    clients.text_fone1.READONLY := lReadOnly
    clients.text_fone2.READONLY := lReadOnly
    clients.checkbutton_ativo.ENABLED := ! lReadOnly
    clients.text_cep.READONLY := lReadOnly
    clients.button_auto_cep.Enabled := ! lReadOnly
    clients.text_logradouro.READONLY := lReadOnly
    clients.text_numero.READONLY := lReadOnly
    clients.text_complemento.READONLY := lReadOnly
    clients.text_bairro.READONLY := lReadOnly
    clients.text_municipio.READONLY := lReadOnly
    clients.combobox_uf.ENABLED := ! lReadOnly
    clients.combobox_categoria.ENABLED := ! lReadOnly
    clients.checkbox_conemb.READONLY := lReadOnly
    clients.checkbox_notfis.READONLY := lReadOnly
    clients.checkbox_ocoren.READONLY := lReadOnly
    clients.checkbox_doccob.READONLY := lReadOnly
    clients.text_caixa_postal.READONLY := lReadOnly
    clients.text_ftp_server.READONLY := lReadOnly
    clients.text_ftp_user_id.READONLY := lReadOnly
    clients.text_ftp_password.READONLY := lReadOnly
    clients.text_ftp_remote_path.READONLY := lReadOnly
    clients.editbox_clients_events.READONLY := lReadOnly

    DELETE ITEM ALL FROM grid_clients_events OF clients

    /* InfoDebug: Este query tem que ter um LIMIT 300 e controle de navegação entre páginas */

    pHistoric_query := TSQLQuery():NEW("SELECT id, data_hora, historico FROM clientes_historico WHERE clie_id=" + oRow:getField('id', 'as string') + ' AND data_hora > DATE_SUB(NOW(), INTERVAL 6 MONTH) ORDER BY data_hora DESC, id')

	if pHistoric_query:isExecuted()
       do while ! pHistoric_query:EOF()
          ADD ITEM {pHistoric_query:getField('id'), datetime_db_to_br(pHistoric_query:getField('data_hora'), true)} TO grid_clients_events OF clients
          pHistoric_query:Skip()
       enddo
    endif
    // A Query pHistoric_query não deve ser destuída aqui, será usada para setar o campo editbox_cusumers_events.VALUE no evento clients_grid_events_on_change

return

procedure clients_button_save_action(lNovo)
			local cSQL, cSoNumero
			local q AS OBJECT

			if Empty(clients.text_razao_social.VALUE) .or. Empty(clients.text_fone1.VALUE) .or.;
               hb_ULen(get_numbers(clients.text_fone1.VALUE)) < 10 .or.;
               Empty(clients.combobox_uf.DisplayValue) .or. Empty(clients.text_logradouro.VALUE) .or.;
               Empty(clients.text_numero.VALUE) .or. Empty(clients.text_bairro.VALUE) .or.;
               Empty(clients.text_cep.VALUE)
			   MsgExclamation('Razão Social, Telefone-1 menor que 10 dígitos, UF, Logradouro, Número, Bairro e CEP não informados ou faltam dígitos!', 'Preenchimento obrigatório')
				return
			endif

			if pCli_cModo == 'INSERT'
				cSQL := "INSERT INTO clientes SET "
			else
				cSQL := "UPDATE clientes SET "
			endif

			cSQL += "clie_ativo=" + logical_to_tinyint_db(clients.checkbutton_ativo.VALUE)
			cSQL += ",clie_tipo_documento='" + iif(clients.radio_tipo_pessoa.VALUE == 1, "CNPJ", "CPF") + "'"
			cSQL += ",clie_razao_social='" + unicode_to_ansi(clients.text_razao_social.VALUE) + "'"
			cSQL += ",clie_nome_fantasia=" + IFNULL(clients.text_nome_fantasia.VALUE)

            cSoNumero := get_numbers(clients.text_doc1.VALUE)

            if clients.radio_tipo_pessoa.VALUE == 1
                cSQL += ",clie_cnpj='" + cSoNumero + "'"
                cSQL += ",clie_inscr_estadual=" + IFNULL(clients.text_doc2.VALUE)
            else
                cSQL += ",clie_cpf='" + cSoNumero + "'"
                cSQL += ",clie_rg=" + IFNULL(clients.text_doc2.VALUE)
            endif

            cSQL += ",clie_logradouro='" + unicode_to_ansi(clients.text_logradouro.VALUE) + "'"
            cSQL += ",clie_numero='" + unicode_to_ansi(clients.text_numero.VALUE) + "'"
            cSQL += ",clie_complemento=" + IFNULL(clients.text_complemento.VALUE)

            cSoNumero := get_numbers(clients.text_cep.VALUE)

			if (hb_ULen(cSoNumero) == 8)
				cSQL += ",clie_cep='" + cSoNumero + "'"
			endif

			cSQL += ",clie_fone1=" + phoneformated_to_db(clients.text_fone1.VALUE)
			cSQL += ",clie_fone2=" + phoneformated_to_db(clients.text_fone2.VALUE)
			cSQL += ",edi_caixa_postal=" + IFNULL(clients.text_caixa_postal.VALUE)
			cSQL += ",edi_conemb=" + logical_to_tinyint_db(clients.checkbox_conemb.VALUE)
			cSQL += ",edi_notfis=" + logical_to_tinyint_db(clients.checkbox_notfis.VALUE)
			cSQL += ",edi_ocoren=" + logical_to_tinyint_db(clients.checkbox_ocoren.VALUE)
			cSQL += ",edi_doccob=" + logical_to_tinyint_db(clients.checkbox_doccob.VALUE)
			cSQL += ",edi_ftp_server=" + IFNULL(clients.text_ftp_server.VALUE)
			cSQL += ",edi_ftp_user_id=" + IFNULL(clients.text_ftp_user_id.VALUE)
			cSQL += ",edi_ftp_password=" + IFNULL(clients.text_ftp_password.VALUE)
			cSQL += ",edi_ftp_remote_path=" + IFNULL(clients.text_ftp_remote_path.VALUE)

			if pCli_cModo == 'UPDATE'
				cSQL += " WHERE clie_id=" + hb_NToS(clients.text_id.VALUE)
			endif

			q := TSQLQuery():NEW(cSQL)

			if q:isExecuted()
                load_grid_clients_list()
				if (lNovo)
					SetProperty('clients', "StatusBar", "ITEM", 1, 'Status: Cliente ' + iif(pCli_cModo == 'INSERT', 'incluído', 'alterado') + ' com sucesso no TMS.Cloud!')
				else
					MsgInfo('Status: Cliente ' + iif(pCli_cModo == 'INSERT', 'incluído', 'alterado') + ' com sucesso no TMS.Cloud!', 'Tabela: Clientes')
				endif
			endif

            q:Destroy()

			if (lNovo)
				clients_reset_fields()
			else
				clients.RELEASE
			endif

return

procedure clients_form_on_release()
    if IsWIndowActive(clients)
        DoMethod('clients', "SETFOCUS")
    endif
return

procedure grid_clients_events_on_change()
    if ! (clients.grid_clients_events.VALUE == 0) .AND. ValType(pHistoric_query) == "O"
       pHistoric_query:goTo(clients.grid_clients_events.VALUE)
        clients.editbox_clients_events.VALUE := pHistoric_query:getField('historico')
    endif
return

procedure clients_radio_tipo_pessoa_on_change()
          if clients.radio_tipo_pessoa.VALUE == 1
            clients.label_2.VALUE := 'Razão Social *'
            clients.label_3.VALUE := 'Nome Fantasia *'
            clients.label_5.VALUE := 'CNPJ *'
            clients.label_6.VALUE := 'I.E.'
            clients.label_12.VALUE := 'Telefone 1 *'
            clients.label_13.VALUE := 'Telefone 2'
        else
             clients.label_2.VALUE := 'Nome *'
             clients.label_3.VALUE := 'Apelido *'
             clients.label_5.VALUE := 'CPF *'
             clients.label_6.VALUE := 'RG'
             clients.label_12.VALUE := 'Celular 1 *'
             clients.label_13.VALUE := 'Fixo / Celular 2'
          endif
return

procedure clients_tab_clients_on_change()
           // Só torna visível o label oculto na terceira Tab "Histórico"
           clients.label_msg_historico.VISIBLE := (clients.tab_clients.VALUE == 3)
return
