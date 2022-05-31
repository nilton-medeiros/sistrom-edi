/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: companies_grid.prg
 Rotinas: Mostra a lista de Empresas em grade (GRID) paginada
***********************************************************************************/

#include <hmg.ch>

declare window companies_list

/*
 * Invocada pelo menu principal Empresas em Main
 * ADVERTÊNCIA: As variáveis private neste formulário são enchergadas em todos os demais formulários abertos ao mesmo tempo
 * A intensão é que a variável private seja compartilhada em todos os componentes do formulário, consequentemente outros forms também a enchergarão.
*/

/* Rotinas iniciais -------------------------------------------------------------------------------*/
procedure form_companies_list()
     	  private pEmp_lFiltro := false
     	  private pEmp_nCount := pEmp_nHeader := 0, pEmp_nOldPag := 1
     	  private pEmp_cSQL := pEmp_cWHERE := pEmp_cORDER_BY := ''
     	  private pEmp_cOldReg := pEmp_cLIMIT := "300"
     	  private pEmp_oQuery
     	  private pEmp_bBackColor := { || iif(This.CellRowIndex/2==INT(This.CellRowIndex/2), background_color_active_records('companies_list','grid_companies_list', true), background_color_active_records('companies_list','grid_companies_list')) }

     	  if IsWIndowActive(companies_list)
     	       companies_list.MINIMIZE
     	       companies_list.RESTORE
     	       companies_list.SETFOCUS
     	  else
     	       load window companies_list
     	       on key escape of companies_list action companies_list.RELEASE
     	       companies_list.CENTER
     	       companies_list.ACTIVATE
     	  endif

return

procedure companies_list_form_on_init()

          companies_list.btn_new.ENABLED := (app:getUser('menu_empresas') == 2)
          companies_list.button_edit.ENABLED := false
          companies_list.button_delete.ENABLED := false
          companies_list.text_search.ENABLED := false
          companies_list.checkbutton_search.ENABLED := false
          companies_list.button_first_page.ENABLED := false
          companies_list.button_previous_page.ENABLED := false
          companies_list.text_page.ENABLED := false
          companies_list.button_next_page.ENABLED := false
          companies_list.button_last_page.ENABLED := false
          companies_list.combobox_rows_per_page.ENABLED := false

          pEmp_cORDER_BY := 'RAZÃO SOCIAL CRESCENTE'
          pEmp_cSQL := sql_companies_list()
          pEmp_cSQL += "ORDER BY razao_social "
          pEmp_cSQL += "LIMIT " + pEmp_cLIMIT

          //companies_list.grid_companies_list.HeaderImages(2) := 'hdUp'
          companies_list.grid_companies_list.HeaderDYNAMICFONT(2) := {|| ARRAY FONT "Open Sans" SIZE 9 BOLD }

          pEmp_nHeader := 2

          status_message('Iniciando Lista de Empresas...')

          load_grid_companies()

          companies_list.combobox_rows_per_page.DELETEALLITEMS

          do case
          case pEmp_nCount > 1000
                 companies_list.combobox_rows_per_page.AddItem('300')
                 companies_list.combobox_rows_per_page.AddItem('400')
                 companies_list.combobox_rows_per_page.AddItem('500')
                 companies_list.combobox_rows_per_page.AddItem('700')
                 companies_list.combobox_rows_per_page.AddItem('800')
                 companies_list.combobox_rows_per_page.AddItem('900')
                 companies_list.combobox_rows_per_page.AddItem('1000')
          case pEmp_nCount > 900
                 companies_list.combobox_rows_per_page.AddItem('300')
                 companies_list.combobox_rows_per_page.AddItem('400')
                 companies_list.combobox_rows_per_page.AddItem('500')
                 companies_list.combobox_rows_per_page.AddItem('700')
                 companies_list.combobox_rows_per_page.AddItem('800')
                 companies_list.combobox_rows_per_page.AddItem('900')
          case pEmp_nCount > 800
                 companies_list.combobox_rows_per_page.AddItem('300')
                 companies_list.combobox_rows_per_page.AddItem('400')
                 companies_list.combobox_rows_per_page.AddItem('500')
                 companies_list.combobox_rows_per_page.AddItem('700')
                 companies_list.combobox_rows_per_page.AddItem('800')
          case pEmp_nCount > 700
                 companies_list.combobox_rows_per_page.AddItem('300')
                 companies_list.combobox_rows_per_page.AddItem('400')
                 companies_list.combobox_rows_per_page.AddItem('500')
                 companies_list.combobox_rows_per_page.AddItem('700')
          case pEmp_nCount > 500
                 companies_list.combobox_rows_per_page.AddItem('300')
                 companies_list.combobox_rows_per_page.AddItem('400')
                 companies_list.combobox_rows_per_page.AddItem('500')
          case pEmp_nCount > 400
                 companies_list.combobox_rows_per_page.AddItem('300')
                 companies_list.combobox_rows_per_page.AddItem('400')
          OTHERWISE
                 companies_list.combobox_rows_per_page.AddItem('300')
          endcase

          companies_list.combobox_rows_per_page.VALUE := 1

return

/* STATIC: Funções exclusivas deste .prg ----------------------------------------------------------*/
STATIC;
function sql_companies_list(add_where)
		 local cSQL := "SELECT "

           cSQL += "emp_id AS id,"
		 cSQL += "emp_razao_social AS razao_social,"
		 cSQL += "emp_nome_fantasia AS nome_fantasia,"
           cSQL += "emp_sigla_cia AS sigla_cia,"
		 cSQL += "emp_cnpj AS cnpj,"
		 cSQL += "emp_inscricao_estadual AS inscricao_estadual,"
		 cSQL += "emp_logradouro AS logradouro,"
		 cSQL += "emp_numero AS numero,"
		 cSQL += "emp_complemento AS complemento,"
		 cSQL += "emp_bairro AS bairro,"
		 cSQL += "cid_municipio AS municipio,"
		 cSQL += "cid_uf AS uf,"
		 cSQL += "emp_cep AS cep,"
		 cSQL += "emp_fone1 AS fone1,"
		 cSQL += "emp_fone2 AS fone2,"
		 cSQL += "emp_simples_nacional AS simples_nacional,"
		 cSQL += "emp_ativa AS ativo,"
		 cSQL += "emp_email_comercial AS email_comercial,"
		 cSQL += "emp_email_contabil AS email_contabil,"
		 cSQL += "edi_caixa_postal,"
           cSQL += "emp_cadastrado_por_nome AS nome_cadastrado_por, "
           cSQL += "emp_cadastrado_em AS cadastrado_em, "
           cSQL += "emp_alterado_por_nome AS nome_alterado_por, "
           cSQL += "emp_alterado_em AS alterado_em, "
		 cSQL += "emp_versao AS alteracoes "
		 cSQL += "FROM view_empresas "

		 if ValType(add_where) == "C" .and. !Empty(add_where)
			 cSQL += "WHERE " + add_where + " "
		 endif

return cSQL

function load_grid_companies()
		 Local i, nRow := 0 , nTotPag := 0 , nOldReg
		 Local endereco := TString():NEW()
		 Local lRet := false
		 Local oRow

		 if ! pEmp_oQuery == NIL
			pEmp_oQuery:Destroy()
		 endif

		 DELETE ITEM ALL FROM grid_companies_list OF companies_list

		 pEmp_oQuery := TSQLQuery():NEW(pEmp_cSQL)

		 if ! pEmp_oQuery:isExecuted()
			return false
		 endif

		 nRow := pEmp_oQuery:LastRec()

		 if nRow > 0

			status_message('Preparando Lista de empresas, aguarde...')

			//companies_list.grid_companies_list.Image(true) := {"gdEmpty","gdHappyDay"}

			for i := 1 TO nRow

				oRow := pEmp_oQuery:getRow(i)

				endereco:setText(oRow:getField('logradouro'))

				if ! Empty(oRow:getField('numero'))
					if ! endereco:Empty()
						endereco:Add(", ")
					endif
					endereco:Add(oRow:getField('numero'))
				endif

				if ! Empty(oRow:getField('complemento'))
					if ! endereco:Empty()
						endereco:Add(", ")
					endif
					endereco:Add(oRow:getField('complemento'))
				endif

				if ! Empty(oRow:getField('bairro'))
					if ! endereco:Empty()
						endereco:Add(" - ")
					endif
					endereco:Add(oRow:getField('bairro'))
				endif

				if ! Empty(oRow:getField('municipio'))
					if ! endereco:Empty()
						endereco:Add(" - ")
					endif
					endereco:Add(oRow:getField('municipio'))
				endif

				endereco:Add(' (' + oRow:getField('uf') + ')')

				if ! Empty(oRow:getField('cep'))
					endereco:Add(" CEP: ")
					endereco:Add(oRow:getField('cep', 'as cep'))
				endif

				ADD ITEM { ;
					oRow:getField('id'), ;
					oRow:getField('razao_social'), ;
					oRow:getField('nome_fantasia'), ;
                         oRow:getField('sigla_cia'),;
					oRow:getField('cnpj', 'as cnpj'), ;
					oRow:getField('inscricao_estadual'), ;
					endereco:text, ;
					oRow:getField('fone1', 'as phone'), ;
					oRow:getField('fone2', 'as phone'), ;
					oRow:getField('email_comercial'), ;
					oRow:getField('email_contabil'), ;
					iif(is_true(oRow:getField('ativo')), 'ATIVO', 'INATIVO'), ;
					oRow:getField('nome_cadastrado_por'), ;
					datetime_db_to_br(oRow:getField('cadastrado_em')), ;
					oRow:getField('nome_alterado_por'), ;
					datetime_db_to_br(oRow:getField('alterado_em')), ;
					oRow:getField('alteracoes') ;
				} TO grid_companies_list OF companies_list

                    // Linha baixo comentada: Imagem de aniversário, não usado nos agentes.
				// companies_list.grid_companies_list.ImageIndex(i,1) := iif(Month(oRow:getField('data_nascimento')) == Month(Date()), 1, 0)
                    // Caracteres usado em títulos indexados da grid  "↓" & "↑" no lugar de imagens

			next i

			/*  pEmp_oQuery, deixa posicionada na primeira linha para uso posterior em outras funções neste prg */
			pEmp_oQuery:GoTop()

			companies_list.grid_companies_list.VALUE := 1
			companies_list.button_edit.ENABLED := (app:getUser('menu_empresas') == 2)
			companies_list.button_delete.ENABLED := (app:getUser('menu_empresas') == 2)
			companies_list.text_search.ENABLED := true
			companies_list.checkbutton_search.ENABLED := true

			pEmp_nCount := select_count("empresas") // Total de registros na tabela toda e não na Grid (nRow = total de registro na Grid)
			pEmp_cOldReg := companies_list.combobox_rows_per_page.DisplayValue
			nOldReg := hb_Val(pEmp_cOldReg)
			nTotPag := iif(pEmp_nCount > nOldReg, pEmp_nCount/nOldReg, 1)

			if nTotPag > 1

				companies_list.button_first_page.ENABLED := true
				companies_list.button_previous_page.ENABLED := true
				companies_list.text_page.ENABLED := true
				companies_list.button_next_page.ENABLED := true
				companies_list.button_last_page.ENABLED := true
				companies_list.combobox_rows_per_page.ENABLED := true

				if (nTotPag - int(nTotPag) > 0)
					nTotPag := int(nTotPag) + 1
				endif

			endif

			companies_list.label_number_of_pages.VALUE := 'de ' + hb_NToS(nTotPag)
			companies_list.label_TotReg.VALUE := LTrim(TransForm(pEmp_nCount, "@E 99,999,999,999"))

			lRet := true

			status_message('Pesquisa ' + iif(pEmp_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' + hmg_lower(pEmp_cORDER_BY) + '. ' + hb_NToS(nRow) + iif(nRow > 1, ' registros carregados.',' registro carregado.'))

		 else

			 companies_list.button_edit.ENABLED := false
			 companies_list.button_delete.ENABLED := false

			 if Empty(companies_list.text_search.VALUE)
				 companies_list.text_search.ENABLED := false
				 companies_list.checkbutton_search.ENABLED := false
				 companies_list.button_exit.SETFOCUS
			 else
				 companies_list.text_search.ENABLED := true
				 companies_list.checkbutton_search.ENABLED := true
				 companies_list.text_search.SETFOCUS
			 endif

			 status_message('Pesquisa ' + iif(pEmp_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' + hmg_lower(pEmp_cORDER_BY) + '. Nenhum registro encontrado.')

		 endif

return (lRet)

STATIC;
function order_by_companies()
            Local cOrderBy

            do case
            case pEmp_cORDER_BY == 'ID DECRESCENTE'
                  cOrderBy := "ORDER BY emp_id DESC "
            case pEmp_cORDER_BY == 'RAZÃO SOCIAL CRESCENTE'
                  cOrderBy := "ORDER BY emp_razao_social "
            case pEmp_cORDER_BY == 'RAZÃO SOCIAL DECRESCENTE'
                  cOrderBy := "ORDER BY emp_razao_social DESC "
            case pEmp_cORDER_BY == 'NOME FANTASIA CRESCENTE'
                  cOrderBy := "ORDER BY emp_nome_fantasia "
            case pEmp_cORDER_BY == 'NOME FANTASIA DECRESCENTE'
                  cOrderBy := "ORDER BY emp_nome_fantasia DESC "
            case pEmp_cORDER_BY == 'CNPJ CRESCENTE'
                  cOrderBy := "ORDER BY emp_cnpj "
            case pEmp_cORDER_BY == 'CNPJ DECRESCENTE'
                  cOrderBy := "ORDER BY emp_cnpj DESC "
            OTHERWISE
                  cOrderBy := "ORDER BY emp_id "
                  pEmp_cORDER_BY := 'ID CRESCENTE'
            endcase

return (cOrderBy)

/* Botões - Ações ---------------------------------------------------------------------------------*/
procedure companies_list_button_new_action()
     if companies_list.grid_companies_list.VALUE > 0
          // A primeira empresa (principal) deve ter sido inserida pelo TMS.CLOUD ou manualmente devido configurações específicas técnicas
          companies_form_open('INSERT')
      endif
return

procedure companies_list_button_edit_action()
          companies_form_open('UPDATE')
return

procedure companies_list_button_delete_action()
     local cID := hb_NToS(companies_list.grid_companies_list.CellEx(companies_list.grid_companies_list.VALUE,1))

     if ! (companies_list.grid_companies_list.VALUE == 0)
          if MsgYesNo({'Deseja realmente excluir a Empresa?', CRLF+CRLF,;
                'Empresa: ', companies_list.grid_companies_list.CellEx(companies_list.grid_companies_list.VALUE,2)}, 'Exclusão de Empresa ID#: ' + cID, false)
                if delete_record_from_db('empresas', cID, 'Empresa')
                     companies_list.grid_companies_list.DeleteItem(companies_list.grid_companies_list.VALUE)
                     companies_list.grid_companies_list.Refresh
                endif
          endif
     endif

return

procedure companies_list_checkbutton_search_on_change()

     if (companies_list.checkbutton_search.VALUE)

          // Botão foi apertado

          companies_list.checkbutton_search.Picture := 'bttFilterOff'

          if Empty(companies_list.text_search.VALUE)

              // Se apertou botão e não tem pesquisa, solta o botão e não faz nada

              companies_list.checkbutton_search.VALUE := false
              pEmp_lFiltro := false
              pEmp_cWHERE := ''
              companies_list.text_search.SETFOCUS
              return

          else

              // Se apertou botão e tem pesquisa, deixa botão apertado e re-carrega grid com filtro
              // Filtro solicitado, faz pesquisa mantendo a ordem atual

              status_message('Pesquisando registros...')

              // pEmp_cWHERE: Usado em outras funçoes
              pEmp_cWHERE := "emp_razao_social LIKE '%" + unicode_to_ansi(companies_list.text_search.VALUE) + "%'"
              pEmp_cWHERE += " OR emp_nome_fantasia LIKE '%" + unicode_to_ansi(companies_list.text_search.VALUE) + "%'"

              if IsDigit(companies_list.text_search.VALUE)
                     pEmp_cWHERE += " OR emp_id=" + get_numbers(companies_list.text_search.VALUE)
                     pEmp_cWHERE += " OR emp_fone1 LIKE '%" + phoneformated_to_db(companies_list.text_search.VALUE) + "%'"
                     pEmp_cWHERE += " OR emp_fone2 LIKE '%" + phoneformated_to_db(companies_list.text_search.VALUE) + "%'"
              endif

              pEmp_cSQL := sql_companies_list(pEmp_cWHERE)
              pEmp_cSQL += order_by_companies()
              pEmp_cSQL += " LIMIT " + pEmp_cLIMIT

              // Mantem a ordem atual na nova pesquisa

              if load_grid_companies()
                  companies_list.text_search.ENABLED := false
                  pEmp_lFiltro := true
              else
                  pEmp_lFiltro := false
                  pEmp_cWHERE := ''
              endif

          endif

     else

          // Soltou botão
          companies_list.checkbutton_search.Picture := 'bttFilterOn'

          if (pEmp_lFiltro)

              // Se Soltou botão, e tem filtro ativo, remove filtro e recarrega a grid
              status_message('Removendo filtro...')

              // Mantem a ordem atual para nova consulta sem filtro

              pEmp_cSQL   := sql_companies_list()
              pEmp_cSQL   += order_by_companies()
              pEmp_cLIMIT := LTrim(companies_list.combobox_rows_per_page.DisplayValue)
              pEmp_cSQL   += "LIMIT " + pEmp_cLIMIT

              load_grid_companies()

          else
              status_message('Pesquisa sem filtro na ordem ' +  hmg_lower(pEmp_cORDER_BY))
          endif

          companies_list.text_search.ENABLED := true
          pEmp_lFiltro := false
          pEmp_cWHERE := ''

      endif

return

procedure companies_list_button_front_page_action()
     if companies_list.text_page.VALUE > 1
          pEmp_cSQL := sql_companies_list(iif(pEmp_lFiltro, pEmp_cWHERE, NIL))
          pEmp_cSQL += order_by_companies()
          pEmp_cLIMIT := LTrim(companies_list.combobox_rows_per_page.DisplayValue)
          pEmp_cSQL += "LIMIT " + pEmp_cLIMIT
          companies_list.text_page.VALUE := 1
          load_grid_companies()
      end
return

procedure companies_list_button_previous_page_action()
     Local nPag := companies_list.text_page.VALUE
     Local nMinimo

     if nPag > 1
         nPag--
         pEmp_cSQL := sql_companies_list(iif(pEmp_lFiltro, pEmp_cWHERE, NIL))
         pEmp_cSQL += order_by_companies()
         nMinimo := (nPag * hb_Val(companies_list.combobox_rows_per_page.DisplayValue)) - hb_Val(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cSQL += "LIMIT " + pEmp_cLIMIT
         companies_list.text_page.VALUE := nPag
         load_grid_companies()
     end
return

procedure companies_list_text_page_on_enter()
     Local nPag := companies_list.text_page.VALUE
     Local nMaxPag := hb_Val(HB_USUBSTR(companies_list.label_number_of_pages.VALUE, 4))
     Local nMinimo

     if !(pEmp_nOldPag == nPag)
         if nPag < 1
             nPag := 1
         elseif nPag > nMaxPag
             nPag := nMaxPag
         endif
         pEmp_cSQL := sql_companies_list(iif(pEmp_lFiltro, pEmp_cWHERE, NIL))
         pEmp_cSQL += order_by_companies()
         nMinimo := (nPag * hb_Val(companies_list.combobox_rows_per_page.DisplayValue)) - hb_Val(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cSQL += "LIMIT " + pEmp_cLIMIT
         load_grid_companies()
         companies_list.text_page.VALUE := pEmp_nOldPag := nPag
     endif
     companies_list.grid_companies_list.SETFOCUS
return

procedure companies_list_button_next_page_action()
     Local nPag := companies_list.text_page.VALUE
     Local nMaxPag := hb_Val(HB_USUBSTR(companies_list.label_number_of_pages.VALUE, 4))
     Local nMinimo

     if nPag < nMaxPag
         nPag++
         pEmp_cSQL := sql_companies_list(iif(pEmp_lFiltro, pEmp_cWHERE, NIL))
         pEmp_cSQL += order_by_companies()
         nMinimo := (nPag * hb_Val(companies_list.combobox_rows_per_page.DisplayValue)) - hb_Val(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cSQL += "LIMIT " + pEmp_cLIMIT
         companies_list.text_page.VALUE := nPag
         load_grid_companies()
     endif
return

procedure companies_list_button_last_page_action()
     Local nPag := companies_list.text_page.VALUE
     Local nMaxPag := Val(HB_USUBSTR(companies_list.label_number_of_pages.VALUE, 4))
     Local nMinimo

     if nPag < nMaxPag
         nPag := nMaxPag
         pEmp_cSQL := sql_companies_list(iif(pEmp_lFiltro, pEmp_cWHERE, NIL))
         pEmp_cSQL += order_by_companies()
         nMinimo := (nPag * hb_Val(companies_list.combobox_rows_per_page.DisplayValue)) - hb_Val(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cSQL += "LIMIT " + pEmp_cLIMIT
         companies_list.text_page.VALUE := nPag
         load_grid_companies()
     endif
return

procedure companies_list_combobox_rows_per_page_on_change()
     Local nPag := companies_list.text_page.VALUE
     Local nMaxPag := hb_Val(HB_USUBSTR(companies_list.label_number_of_pages.VALUE, 4))
     Local nMinimo := (nPag * hb_Val(companies_list.combobox_rows_per_page.DisplayValue)) - hb_Val(companies_list.combobox_rows_per_page.DisplayValue)

     if !(pEmp_cOldReg == companies_list.combobox_rows_per_page.DisplayValue) .and. (nMinimo < pEmp_nCount)
         pEmp_cSQL := sql_companies_list(iif(pEmp_lFiltro, pEmp_cWHERE, NIL))
         pEmp_cSQL += order_by_companies()
         pEmp_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(companies_list.combobox_rows_per_page.DisplayValue)
         pEmp_cSQL += "LIMIT " + pEmp_cLIMIT
         pEmp_cOldReg := companies_list.combobox_rows_per_page.DisplayValue
         companies_list.text_page.VALUE := nPag
         load_grid_companies()
     endif
     companies_list.grid_companies_list.SETFOCUS
return

/* Grid - Eventos ---------------------------------------------------------------------------------*/
procedure grid_companies_list_on_dblclick()
     if companies_list.grid_companies_list.VALUE > 0
          companies_form_open('SELECT')
      endif
return

procedure grid_companies_list_id_on_headclick()
     STATIC sEmp_id_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
     companies_list_change_on_head('id#', sEmp_id_lFlag)
     sEmp_id_lFlag := !(sEmp_id_lFlag)
return

procedure grid_companies_list_razaoSocial_on_headclick()
     STATIC sEmp_Nome_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
     companies_list_change_on_head('Razão Social', sEmp_Nome_lFlag)
     sEmp_Nome_lFlag := !(sEmp_Nome_lFlag)
return

procedure grid_companies_list_nomeFantasia_on_headclick()
     STATIC sEmp_NomeFantasia_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
     companies_list_change_on_head('Nome Fantasia', sEmp_NomeFantasia_lFlag)
     sEmp_NomeFantasia_lFlag := !(sEmp_NomeFantasia_lFlag)
return

procedure grid_companies_list_cnpj_on_headclick()
     STATIC sEmp_CNPJ_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
     companies_list_change_on_head('CNPJ', sEmp_CNPJ_lFlag)
     sEmp_CNPJ_lFlag := !(sEmp_CNPJ_lFlag)
return

procedure companies_list_change_on_head(cHeader, lFlag)
     local nOrdem := grid_column_index('companies_list', 'grid_companies_list', cHeader)
     pEmp_cSQL := sql_companies_list(iif(pEmp_lFiltro, pEmp_cWHERE, NIL))

     if ! (pEmp_nHeader == nOrdem) .and. pEmp_nHeader > 0
         // Troca o fonte da coluna ativa (pEmp_nHeader) para Normal (tira de negrito) e troca o ícone para vazio
         companies_list.grid_companies_list.HeaderDYNAMICFONT(pEmp_nHeader) := {|| ARRAY FONT "Open Sans" SIZE 9 }
         //companies_list.grid_companies_list.HeaderImages(pEmp_nHeader) := 'hdEmpty'
     endif

     // Muda a coluna ativa para nOrdem (nova coluna clicada pelo usuário)
     pEmp_nHeader := nOrdem

     // Troca o ícone para up ou down conforme a flag
    companies_list.grid_companies_list.ColumnHEADER(nOrdem) := iif(lFlag, '↑', '↓') + "  " + cHeader

     // Seta as variáveis para a nova ordem selecionada

     cHeader := HMG_UPPER(AllTrim(cHeader))

     switch cHeader
     case 'ID#'

          if (lFlag)
              pEmp_cORDER_BY := 'ID CRESCENTE'
              pEmp_cSQL += 'ORDER BY emp_id '
          else
              pEmp_cORDER_BY := 'ID DECRESCENTE'
              pEmp_cSQL += "ORDER BY emp_id DESC "
          endif
          EXIT

     case 'RAZÃO SOCIAL'

          if (lFlag)
              pEmp_cORDER_BY := 'RAZÃO SOCIAL CRESCENTE'
              pEmp_cSQL += 'ORDER BY emp_razao_social '
          else
              pEmp_cORDER_BY := 'RAZÃO SOCIAL DECRESCENTE'
              pEmp_cSQL += 'ORDER BY emp_razao_social DESC '
          endif
          EXIT

     case 'NOME FANTASIA'

          if (lFlag)
              pEmp_cORDER_BY := 'NOME FANTASIA CRESCENTE'
              pEmp_cSQL += 'ORDER BY emp_nome_fantasia '
          else
              pEmp_cORDER_BY := 'NOME FANTASIA DECRESCENTE'
              pEmp_cSQL += 'ORDER BY emp_nome_fantasia DESC '
          endif
          EXIT

     case 'CNPJ'

          if (lFlag)
              pEmp_cORDER_BY := 'CNPJ CRESCENTE'
              pEmp_cSQL += 'ORDER BY emp_cnpj '
          else
              pEmp_cORDER_BY := 'CNPJ DECRESCENTE'
              pEmp_cSQL += 'ORDER BY emp_cnpj DESC '
          endif
          EXIT

     endswitch

     // Troca o ícone para up ou down conforme a flag
     //companies_list.grid_companies_list.HeaderImages(nOrdem) := iif(lFlag, 'hdUp', 'hdDown')

     // Troca o fonte da colula (nOrdem) em negrito
     companies_list.grid_companies_list.HeaderDYNAMICFONT(nOrdem) := {|| ARRAY FONT "Open Sans" SIZE 9 BOLD }

     pEmp_cSQL += "LIMIT " + pEmp_cLIMIT

     load_grid_companies()
     status_message('Pesquisa ' + iif(pEmp_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' +  hmg_lower(pEmp_cORDER_BY))

return
