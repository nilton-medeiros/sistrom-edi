/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: companies.prg
 Rotinas: Cadastro de Empresas - CRUD: Incluir, Consultar, Alterar e Excluir
***********************************************************************************/

#include <hmg.ch>

declare window companies

/*
 * Invocada pelo form empresas, botoes: Novo, Editar, Excluir e OnDblClick no registro da Grade
 * ADVERTÊNCIA: As variáveis private neste formulário são enchergadas em todos os demais formulários abertos ao mesmo tempo
*/

/* Rotinas iniciais -------------------------------------------------------------------------------*/
procedure companies_form_open(cModo)
	 private pEmp_cModo := cModo

	 if IsWIndowActive(companies)
		  companies.MINIMIZE
		  companies.RESTORE
		  companies.SETFOCUS
	 else
		  load window companies
		  on key escape of companies action companies.RELEASE
		  companies.CENTER
		  companies.ACTIVATE
	 endif

return

procedure companies_form_on_init()

	 companies.text_id.ENABLED := false
	 companies.btt_save.ENABLED := true
	 companies.btt_save_and_new.ENABLED := true
	 companies.btn_cancel.ENABLED := true

	 if pEmp_cModo == 'INSERT'
		  companies_reset_fields()
	 elseif pEmp_cModo == 'UPDATE'
		  companies_load_fields(false)
		  companies.btt_save_and_new.ENABLED := false
	 else  // SELECT
		  companies_load_fields(true)
		  companies.btt_save.ENABLED := false
		  companies.btt_save_and_new.ENABLED := false
	 endif

return

procedure companies_reset_fields()

	 companies.text_id.VALUE := 0
	 companies.text_razao_social.VALUE := ''
	 companies.text_nome_fantasia.VALUE := ''
	 companies.text_sigla_cia.VALUE := ''
	 companies.text_cnpj.VALUE := ''
	 companies.text_inscricao_estadual.VALUE := ''
	 companies.text_fone1.VALUE := ''
	 companies.text_fone2.VALUE := ''
	 companies.checkbox_simples_nacional.VALUE := false
	 companies.checkbutton_ativo.VALUE := true
	 companies.text_cep.VALUE := ''
	 companies.text_logradouro.VALUE := ''
	 companies.text_numero.VALUE := ''
	 companies.text_complemento.VALUE := ''
	 companies.text_bairro.VALUE := ''
	 companies.text_municipio.VALUE := ''
	 companies.combobox_uf.VALUE := 0
	 companies.text_email_comercial.VALUE := ''
	 companies.text_email_contabil.VALUE := ''
	 companies.text_edi_caixa_postal.VALUE := ''

return

procedure companies_load_fields(lReadOnly)
	 local oRow := pEmp_oQuery:GetRow(GetProperty('companies_list', 'grid_companies_list', 'VALUE'))

	 companies.text_id.VALUE := oRow:getField('id')
	 companies.text_razao_social.VALUE := oRow:getField('razao_social')
	 companies.text_nome_fantasia.VALUE := oRow:getField('nome_fantasia')
	 companies.text_sigla_cia.VALUE := oRow:getField('sigla_cia')
	 companies.text_cnpj.VALUE := oRow:getField('cnpj', "as cnpj")
	 companies.text_inscricao_estadual.VALUE := oRow:getField('inscricao_estadual')
	 companies.text_fone1.VALUE := oRow:getField('fone1')
	 companies.text_fone2.VALUE := oRow:getField('fone2')
	 companies.checkbox_simples_nacional.VALUE := oRow:getField('simples_nacional', 'as logical')
	 companies.checkbutton_ativo.VALUE := oRow:getField('ativo', 'as logical')
	 companies.text_cep.VALUE := oRow:getField('cep', "as cep")
	 companies.text_logradouro.VALUE := oRow:getField('logradouro')
	 companies.text_numero.VALUE := oRow:getField('numero')
	 companies.text_complemento.VALUE := oRow:getField('complemento')
	 companies.text_bairro.VALUE := oRow:getField('bairro')
	 companies.text_municipio.VALUE := oRow:getField('municipio')
	 companies.combobox_uf.VALUE := index_of_comboBox("companies", "combobox_uf", oRow:getField('uf'))
	 companies.text_email_comercial.VALUE := oRow:getField('email_comercial')
	 companies.text_email_contabil.VALUE := oRow:getField('email_contabil')
	 companies.text_edi_caixa_postal.VALUE := oRow:getField('edi_caixa_postal')

	 companies.text_razao_social.READONLY := lReadOnly
	 companies.text_nome_fantasia.READONLY := lReadOnly
	 companies.text_sigla_cia.READONLY := lReadOnly
	 companies.text_cnpj.READONLY := lReadOnly
	 companies.text_inscricao_estadual.READONLY := lReadOnly
	 companies.text_fone1.READONLY := lReadOnly
	 companies.text_fone2.READONLY := lReadOnly
	 companies.checkbox_simples_nacional.ENABLED := !lReadOnly
	 companies.checkbutton_ativo.ENABLED := !lReadOnly
	 companies.text_cep.READONLY := lReadOnly
	 companies.button_auto_cep.ENABLED := !lReadOnly
	 companies.text_logradouro.READONLY := lReadOnly
	 companies.text_numero.READONLY := lReadOnly
	 companies.text_complemento.READONLY := lReadOnly
	 companies.text_bairro.READONLY := lReadOnly
	 companies.text_municipio.READONLY := lReadOnly
	 companies.combobox_uf.ENABLED := !lReadOnly
	 companies.text_email_comercial.READONLY := lReadOnly
	 companies.text_email_contabil.READONLY := lReadOnly
	 companies.text_edi_caixa_postal.READONLY := lReadOnly

return

procedure companies_button_save_action(lNovo)
			local sql := TString():NEW()
			local cep := TString():NEW(companies.text_cep.VALUE)
			local q AS OBJECT

			if Empty(companies.text_razao_social.VALUE) .or. Empty(companies.text_nome_fantasia.VALUE) .or.;
			   ! (hb_ULen(AllTrim(companies.text_cnpj.VALUE)) == 18) .or. Empty(companies.text_inscricao_estadual.VALUE) .or.;
			   (hb_ULen(AllTrim(companies.text_fone1.VALUE)) < 7) .or. ! (cep:Length(true) == 8) .or. Empty(companies.text_logradouro.VALUE)
				MsgExclamation('A razao social, nome fantasia, i.e., cnpj, telefone principal e CEP!', 'Preenchimento obrigatório')
				return
			endif

			if pEmp_cModo == 'INSERT'
				sql:setText := "INSERT INTO empresas SET "
			else
				sql:setText := "UPDATE empresas SET "
			endif

			sql:Add := "emp_razao_social='" + unicode_to_ansi(companies.text_razao_social.VALUE) + "'"
			sql:Add := ",emp_nome_fantasia=" + IFNULL(companies.text_nome_fantasia.VALUE)
			sql:Add := ",emp_cnpj='" + get_numbers(companies.text_cnpj.VALUE) + "'"
			sql:Add := ",emp_inscricao_estadual='" + unicode_to_ansi(companies.text_inscricao_estadual.VALUE) + "'"
			sql:Add := ",emp_logradouro=" + IFNULL(companies.text_logradouro.VALUE)
			sql:Add := ",emp_numero='" + unicode_to_ansi(companies.text_numero.VALUE) + "'"
			sql:Add := ",emp_complemento=" + IFNULL(companies.text_complemento.VALUE)
			sql:Add := ",emp_bairro='" + unicode_to_ansi(companies.text_bairro.VALUE) + "'"
			sql:Add := ",emp_cep='" + cep:get_numbers + "'"
			sql:Add := ",emp_fone1='" + get_numbers(companies.text_fone1.VALUE) + "'"
			sql:Add := ",emp_fone2=" + IFNULL(get_numbers(companies.text_fone2.VALUE))
			sql:Add := ",emp_simples_nacional=" + logical_to_tinyint_db(companies.checkbox_simples_nacional.VALUE)
			sql:Add := ",emp_ativa=" + logical_to_tinyint_db(companies.checkbutton_ativo.VALUE)
			sql:Add := ",emp_email_contabil=" + IFNULL(companies.text_email_contabil.VALUE)
			sql:Add := ",emp_email_comercial=" + IFNULL(companies.text_email_comercial.VALUE)
			sql:Add := ",edi_caixa_postal=" + IFNULL(companies.text_edi_caixa_postal.VALUE)

			if pEmp_cModo == 'UPDATE'
				sql:Add := " WHERE emp_id=" + hb_NToS(companies.text_id.VALUE)
			endif

			q := TSQLQuery():NEW(sql:Text)

			if q:isExecuted()

				load_grid_companies()

				if (lNovo)
					MsgInfo('Status: Empresa ' + iif(pEmp_cModo == 'INSERT', 'incluída', 'alterada') + ' com sucesso no TMS.Cloud!', 'Tabela: Empresas')
				else
					SetProperty('companies', "StatusBar", "Item", 1, 'Status: Empresa ' + iif(pEmp_cModo == 'INSERT', 'incluída', 'alterada') + ' com sucesso no TMS.Cloud!')
				endif

				q:Destroy()

			endif

			if (lNovo)
				companies_reset_fields()
			else
				companies.RELEASE
			endif

return

procedure companies_form_on_release()
	 DoMethod('companies_list', "SETFOCUS")
return
