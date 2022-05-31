/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: clients_list.prg
 Rotinas: Mostra a lista de Clientes em grade (GRID) paginada
***********************************************************************************/

#include <hmg.ch>

declare window clients_list
//declare window custumers2Excel

/*
 * Invocada pelo menu principal Clientes em Main
 * ADVERTÊNCIA: As variáveis private neste formulário são enchergadas em todos os demais formulários abertos ao mesmo tempo
*/

/* Rotinas iniciais -------------------------------------------------------------------------------*/
procedure clients_form_list()
    private pCli_lFiltro := false
    private pCli_nCount := 0, pCli_hHeader := {'index' => 0, 'header' => ''}, pCli_nOldPag := 1
    private pCli_cSQL := '', pCli_cWHERE := '', pCli_cORDER_BY := ''
    private pCli_cOldReg := "300", pCli_cLIMIT := "300"
    private pCli_oQuery AS OBJECT
    private pCli_bBackColor := {|| iif(This.CellRowIndex/2==INT(This.CellRowIndex/2), background_color_active_records('clients_list','grid_clients_list', true), background_color_active_records('clients_list','grid_clients_list'))}

    if IsWIndowActive(clients_list)
        clients_list.MINIMIZE
        clients_list.RESTORE
        clients_list.SETFOCUS
    else
        load window clients_list
 on key escape of clients_list action clients_list.RELEASE
        clients_list.CENTER
        clients_list.ACTIVATE
    endif

return

procedure clients_list_form_on_init()

    clients_list.button_new.ENABLED := (app:getUser('menu_clientes') == 2)
    clients_list.button_edit.ENABLED := false
    clients_list.button_delete.ENABLED := false
    clients_list.text_search.ENABLED := false
    clients_list.checkbutton_search.ENABLED := false
    clients_list.button_first_page.ENABLED := false
    clients_list.button_previous_page.ENABLED := false
    clients_list.text_page.ENABLED := false
    clients_list.button_next_page.ENABLED := false
    clients_list.button_last_page.ENABLED := false
    clients_list.combobox_rows_per_page.ENABLED := false

    pCli_cORDER_BY := 'RAZAO SOCIAL CRESCENTE'
    pCli_cSQL := sql_clients_list()
    pCli_cSQL += "ORDER BY clie_razao_social "
    pCli_cSQL += "LIMIT " + pCli_cLIMIT

    clients_list.grid_clients_list.ColumnHEADER(2) := '↑' + "  Nome"
    clients_list.grid_clients_list.HeaderDYNAMICFONT(2) := {|| ARRAY FONT "Open Sans" SIZE 9 BOLD }

    pCli_hHeader['index'] := 2
    pCli_hHeader['header'] := 'Nome'

    status_message('Iniciando Grade clients...')

    load_grid_clients_list()

    clients_list.combobox_rows_per_page.DELETEALLITEMS

    do case
    case pCli_nCount > 1000
         clients_list.combobox_rows_per_page.AddItem('300')
         clients_list.combobox_rows_per_page.AddItem('400')
         clients_list.combobox_rows_per_page.AddItem('500')
         clients_list.combobox_rows_per_page.AddItem('700')
         clients_list.combobox_rows_per_page.AddItem('800')
         clients_list.combobox_rows_per_page.AddItem('900')
         clients_list.combobox_rows_per_page.AddItem('1000')
    case pCli_nCount > 900
         clients_list.combobox_rows_per_page.AddItem('300')
         clients_list.combobox_rows_per_page.AddItem('400')
         clients_list.combobox_rows_per_page.AddItem('500')
         clients_list.combobox_rows_per_page.AddItem('700')
         clients_list.combobox_rows_per_page.AddItem('800')
         clients_list.combobox_rows_per_page.AddItem('900')
    case pCli_nCount > 800
         clients_list.combobox_rows_per_page.AddItem('300')
         clients_list.combobox_rows_per_page.AddItem('400')
         clients_list.combobox_rows_per_page.AddItem('500')
         clients_list.combobox_rows_per_page.AddItem('700')
         clients_list.combobox_rows_per_page.AddItem('800')
    case pCli_nCount > 700
         clients_list.combobox_rows_per_page.AddItem('300')
         clients_list.combobox_rows_per_page.AddItem('400')
         clients_list.combobox_rows_per_page.AddItem('500')
         clients_list.combobox_rows_per_page.AddItem('700')
    case pCli_nCount > 500
         clients_list.combobox_rows_per_page.AddItem('300')
         clients_list.combobox_rows_per_page.AddItem('400')
         clients_list.combobox_rows_per_page.AddItem('500')
    case pCli_nCount > 400
         clients_list.combobox_rows_per_page.AddItem('300')
         clients_list.combobox_rows_per_page.AddItem('400')
    OTHERWISE
         clients_list.combobox_rows_per_page.AddItem('300')
    endcase

	 clients_list.combobox_rows_per_page.VALUE := 1

return

/* STATIC: Funções exclusivas deste .prg ----------------------------------------------------------*/
STATIC;
function sql_clients_list(cAddWhere)
         local cSQL

         cSQL := "SELECT "
         cSQL += "clie_id AS id,"
         cSQL += "clie_categoria AS categoria,"
         cSQL += "clie_ativo AS ativo,"
         cSQL += "clie_tipo_documento AS tipo_doc,"
         cSQL += "clie_razao_social AS razao_social,"
         cSQL += "IFNULL(clie_nome_fantasia, '') AS nome_fantasia,"
         cSQL += "IF(clie_tipo_documento = 'CNPJ', clie_cnpj, clie_cpf) AS doc1,"
         cSQL += "IF(clie_tipo_documento = 'CNPJ', clie_inscr_estadual, clie_rg) AS doc2,"
         cSQL += "clie_logradouro AS logradouro,"
         cSQL += "clie_numero AS numero,"
         cSQL += "clie_complemento AS complemento,"
         cSQL += "clie_bairro AS bairro,"
         cSQL += "clie_cep AS cep,"
         cSQL += "cid_municipio AS municipio,"
         cSQL += "cid_uf AS uf,"
         cSQL += "clie_fone1 AS fone1,"
         cSQL += "clie_fone2 AS fone2,"
         cSQL += "edi_conemb,"
         cSQL += "edi_notfis,"
         cSQL += "edi_ocoren,"
         cSQL += "edi_doccob,"
         cSQL += "edi_caixa_postal,"
         cSQL += "edi_ftp_url,"
         cSQL += "edi_ftp_server,"
         cSQL += "edi_ftp_user_id,"
         cSQL += "edi_ftp_password,"
         cSQL += "edi_ftp_remote_path,"
         cSQL += "clie_cadastrado_por_nome AS cadastrado_por,"
         cSQL += "clie_cadastrado_em AS cadastrado_em,"
         cSQL += "clie_alterado_por_nome AS alterado_por,"
         cSQL += "clie_alterado_em AS alterado_em,"
         cSQL += "clie_versao AS alteracoes "
         cSQL += "FROM view_clientes "

         if ValType(cAddWhere) == "C" .and. !Empty(cAddWhere)
            cSQL += "WHERE " + cAddWhere + " "
         endif

return (cSQL)

function load_grid_clients_list()
         Local i, nRow := 0 , nTotPag := 0 , nOldReg
         Local cEndereco
         Local lResult := false
         Local oRow

         if ValType(pCli_oQuery) == "O"
            pCli_oQuery:Destroy()
         endif

         DELETE ITEM ALL FROM grid_clients_list OF clients_list

         pCli_oQuery := TSQLQuery():NEW(pCli_cSQL)

        if ! pCli_oQuery:isExecuted()
            return false
        endif

         nRow := pCli_oQuery:LastRec()
        clients_list.button_excel.ENABLED := ! (nRow == 0)

         if nRow > 0

            status_message('Preparando Grade de clients...')

            //clients_list.grid_clients_list.Image(false) := {"gdEmpty","gdHappyDay"}

            for i := 1 TO nRow

                 oRow := pCli_oQuery:GetRow(i)

                 cEndereco := iif(Empty(oRow:getField('logradouro')), '', oRow:getField('logradouro'))
                 cEndereco += iif(Empty(oRow:getField('numero')), '', iif(Empty(cEndereco), '', ', ') + oRow:getField('numero'))
                 cEndereco += iif(Empty(oRow:getField('complemento')), '', iif(Empty(cEndereco), '', ', ') + oRow:getField('complemento'))
                 cEndereco += iif(Empty(oRow:getField('bairro')), '',  iif(Empty(cEndereco), '', ' - ') + oRow:getField('bairro'))
                 cEndereco += iif(Empty(oRow:getField('municipio')), '', iif(Empty(cEndereco), '', ' - ') + oRow:getField('municipio'))
                 cEndereco += ' (' + oRow:getField('uf') + ')'
                 cEndereco += iif(Empty(oRow:getField('cep')), '', ' CEP: ' + Transform(oRow:getField('cep'), "@R 99999-999"))

                 ADD ITEM { ;
                     oRow:getField('id'), ;
                     oRow:getField('razao_social'), ;
                     oRow:getField('nome_fantasia'), ;
                     oRow:getField('doc1'), ;
                     oRow:getField('doc2'), ;
                     oRow:getField('fone1'), ;
                     oRow:getField('fone2'), ;
                     cEndereco, ;
                     iif(is_true(oRow:getField('ativo')),'ATIVO','INATIVO'),  ;
                     oRow:getField('cadastrado_por'),;
                     datetime_db_to_br(oRow:getField('cadastrado_em')), ;
                     oRow:getField('alterado_por'), ;
                     datetime_db_to_br(oRow:getField('alterado_em')), ;
                     oRow:getField('alteracoes') ;
                 } TO grid_clients_list OF clients_list

                 // clients_list.grid_clients_list.ImageIndex(i,1) := iif(Month(oRow:getField('data_nascimento')) == Month(Date()), 1, 0)

            next i

            /*  pCli_oQuery, deixa posicionada na primeira linha para uso posterior em outras funções neste prg */
            pCli_oQuery:GoTop()

            clients_list.grid_clients_list.VALUE := 1

            clients_list.button_edit.ENABLED := (app:getUser('menu_clientes') == 2)
            clients_list.button_delete.ENABLED := (app:getUser('menu_clientes') == 2)

            clients_list.text_search.ENABLED := true
            clients_list.checkbutton_search.ENABLED := true

            pCli_nCount := select_count('clientes') // Total de registros na tabela toda e não na Grid (nRow = total de registro na Grid)
       	    pCli_cOldReg := clients_list.combobox_rows_per_page.DisplayValue
            nOldReg := hb_Val(pCli_cOldReg)
            nTotPag := iif(pCli_nCount > nOldReg, pCli_nCount/nOldReg, 1)

            if nTotPag > 1

               clients_list.text_page.ENABLED := true
               clients_list.button_first_page.ENABLED := true
               clients_list.button_previous_page.ENABLED := true
               clients_list.button_next_page.ENABLED := true
               clients_list.button_last_page.ENABLED := true
               clients_list.combobox_rows_per_page.ENABLED := true

               if (nTotPag - int(nTotPag) > 0)
                   nTotPag := int(nTotPag) + 1
               endif

            endif

            clients_list.label_number_of_pages.VALUE := 'de ' + hb_NToS(nTotPag)
            clients_list.label_TotReg.VALUE := LTrim(TransForm(pCli_nCount, "@E 99,999,999,999"))
            lResult := true

            status_message('Pesquisa ' + iif(pCli_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' + hmg_lower(pCli_cORDER_BY) + '. ' + hb_NToS(nRow) + iif(nRow > 1, ' registros carregados.',' registro carregado.'))

         else

            clients_list.button_edit.ENABLED := false
            clients_list.button_delete.ENABLED := false


                if Empty(clients_list.text_search.VALUE)
                    clients_list.text_search.ENABLED := false
                    clients_list.checkbutton_search.ENABLED := false
                    clients_list.button_exit.SETFOCUS
                else
                    clients_list.text_search.ENABLED := true
                    clients_list.checkbutton_search.ENABLED := true
                    clients_list.text_search.SETFOCUS
                endif

            status_message('Pesquisa ' + iif(pCli_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' + hmg_lower(pCli_cORDER_BY) + '. Nenhum registro encontrado.')

         endif

return (lResult)

STATIC;
function order_by_custumers()
         Local cOrderBy

         if ! (Type("pCli_cORDER_BY") == "C")
            pCli_cORDER_BY := ""
         endif

         do case
         case pCli_cORDER_BY == 'ID DECRESCENTE'
              cOrderBy := "ORDER BY clie_id DESC "
         case pCli_cORDER_BY == 'RAZAO SOCIAL CRESCENTE'
              cOrderBy := "ORDER BY clie_razao_social "
         case pCli_cORDER_BY == 'RAZAO SOCIAL DECRESCENTE'
              cOrderBy := "ORDER BY clie_razao_social DESC "
         case pCli_cORDER_BY == 'NOME FANTASIA CRESCENTE'
              cOrderBy := "ORDER BY clie_nome_fantasia "
         case pCli_cORDER_BY == 'NOME FANTASIA DECRESCENTE'
              cOrderBy := "ORDER BY clie_nome_fantasia DESC "
         OTHERWISE
              cOrderBy := "ORDER BY clie_id "
              pCli_cORDER_BY := 'ID CRESCENTE'
         endcase

return (cOrderBy)

/* Botões - Ações ---------------------------------------------------------------------------------*/
procedure clients_list_button_new_action()
    clients_form('INSERT')
return

procedure clients_list_button_edit_action()
    if clients_list.grid_clients_list.VALUE > 0
        clients_form('UPDATE')
     endif
return

procedure clients_list_button_delete_action()
    local cID := hb_NToS(clients_list.grid_clients_list.CellEx(clients_list.grid_clients_list.VALUE,1))

    if !(clients_list.grid_clients_list.VALUE == 0)
        if MsgYesNo({'Deseja realmente excluir o Cliente?', CRLF+CRLF,;
            'Cliente: ', clients_list.grid_clients_list.CellEx(clients_list.grid_clients_list.VALUE,2)}, 'Exclusão de Cliente ID#: ' + cID, false)
            if delete_record_from_db('clientes', cID, 'Cliente')
                clients_list.grid_clients_list.DeleteItem(clients_list.grid_clients_list.VALUE)
                clients_list.grid_clients_list.Refresh
            endif
        endif
    endif

return

procedure clients_list_checkbutton_search_on_change()
    local numbers

    if clients_list.checkbutton_search.VALUE

        clients_list.text_search.VALUE := AllTrim(clients_list.text_search.VALUE)
        clients_list.checkbutton_search.Picture := 'bttFilterOff'

        if Empty(clients_list.text_search.VALUE)

           // Se apertou botão e não tem pesquisa, solta o botão e não faz nada

           clients_list.checkbutton_search.VALUE := false
           pCli_lFiltro := false
           pCli_cWHERE := ''
           clients_list.text_search.SETFOCUS
           return

        else

           // Se apertou botão e tem pesquisa, deixa botão apertado e re-carrega grid com filtro
           // Filtro solicitado, faz pesquisa mantendo a ordem atual

           status_message('Ativando filtro...')

           // pCli_cWHERE: Usado em outras funçoes
           pCli_cWHERE := " (clie_razao_social LIKE '%" + unicode_to_ansi(clients_list.text_search.VALUE) + "%'"
           pCli_cWHERE += " OR clie_nome_fantasia LIKE '%" + unicode_to_ansi(clients_list.text_search.VALUE) + "%'"

           numbers := get_numbers(clients_list.text_search.VALUE)

           if !Empty(numbers)
                pCli_cWHERE += " OR clie_cnpj = '" + numbers + "'"
                pCli_cWHERE += " OR clie_cpf = '" + numbers + "'"
                pCli_cWHERE += " OR clie_fone1 = " + phoneformated_to_db(numbers)
                pCli_cWHERE += " OR clie_fone2 = " + phoneformated_to_db(numbers)
           endif

           pCli_cWHERE += ") AND (clie_ativo = 1 AND"
           pCli_cWHERE += " (ISNULL(emp_id) OR emp_id=" + app:getCompanies('id', 'as string') + ')) '

           pCli_cSQL := sql_clients_list(pCli_cWHERE)
           pCli_cSQL += order_by_custumers()
           pCli_cSQL += "LIMIT " + pCli_cLIMIT

           // Mantem a ordem atual na nova pesquisa

           if load_grid_clients_list()
              clients_list.text_search.ENABLED := false
              pCli_lFiltro := true
           else
              pCli_lFiltro := false
              pCli_cWHERE := ''
           endif

        endif

    else

        // Soltou botão - Habilita o botão filtro aniversário e muda imagem do botão
        clients_list.checkbutton_search.Picture := 'bttFilterOn'

        // Se Soltou botão, e tem filtro ativo, remove filtro e recarrega a grid
        status_message('Removendo filtro...')

        // Mantem a ordem atual para nova consulta sem filtro

        pCli_cSQL   := sql_clients_list()
        pCli_cSQL   += order_by_custumers()
        pCli_cLIMIT := LTrim(clients_list.combobox_rows_per_page.DisplayValue)
        pCli_cSQL   += "LIMIT " + pCli_cLIMIT

        load_grid_clients_list()

        if ! (pCli_lFiltro)
           status_message('Pesquisa sem filtro na ordem ' +  hmg_lower(pCli_cORDER_BY))
        endif

        clients_list.text_search.ENABLED := true
        pCli_lFiltro := false
        pCli_cWHERE := ''

     endif

return

procedure clients_list_button_first_page_action()
    if clients_list.text_page.VALUE > 1
        pCli_cSQL := sql_clients_list(iif(pCli_lFiltro, pCli_cWHERE, NIL))
        pCli_cSQL += order_by_custumers()
        pCli_cLIMIT := LTrim(clients_list.combobox_rows_per_page.DisplayValue)
        pCli_cSQL += "LIMIT " + pCli_cLIMIT
        clients_list.text_page.VALUE := 1
        load_grid_clients_list()
     end
return

procedure clients_list_button_previous_page_action()
    Local nPag := clients_list.text_page.VALUE
    Local nMinimo

    if nPag > 1
       nPag--
       pCli_cSQL := sql_clients_list(iif(pCli_lFiltro, pCli_cWHERE, NIL))
       pCli_cSQL += order_by_custumers()
       nMinimo := (nPag * hb_Val(clients_list.combobox_rows_per_page.DisplayValue)) - hb_Val(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cSQL += "LIMIT " + pCli_cLIMIT
       clients_list.text_page.VALUE := nPag
       load_grid_clients_list()
    end
return

procedure clients_list_text_page_on_enter()
    Local nPag := clients_list.text_page.VALUE
    Local nMaxPag := hb_Val(HB_USUBSTR(clients_list.label_number_of_pages.VALUE, 4))
    Local nMinimo

    if !(pCli_nOldPag == nPag)
       if nPag < 1
          nPag := 1
       elseif nPag > nMaxPag
          nPag := nMaxPag
       endif
       pCli_cSQL := sql_clients_list(iif(pCli_lFiltro, pCli_cWHERE, NIL))
       pCli_cSQL += order_by_custumers()
       nMinimo := (nPag * hb_Val(clients_list.combobox_rows_per_page.DisplayValue)) - hb_Val(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cSQL += "LIMIT " + pCli_cLIMIT
       load_grid_clients_list()
       clients_list.text_page.VALUE := pCli_nOldPag := nPag
    endif
    clients_list.grid_clients_list.SETFOCUS
return

procedure clients_list_button_next_page_action()
    Local nPag := clients_list.text_page.VALUE
    Local nMaxPag := hb_Val(HB_USUBSTR(clients_list.label_number_of_pages.VALUE, 4))
    Local nMinimo

    if nPag < nMaxPag
       nPag++
       pCli_cSQL := sql_clients_list(iif(pCli_lFiltro, pCli_cWHERE, NIL))
       pCli_cSQL += order_by_custumers()
       nMinimo := (nPag * hb_Val(clients_list.combobox_rows_per_page.DisplayValue)) - hb_Val(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cSQL += "LIMIT " + pCli_cLIMIT
       clients_list.text_page.VALUE := nPag
       load_grid_clients_list()
    endif
return

procedure clients_list_button_last_page_action()
    Local nPag := clients_list.text_page.VALUE
    Local nMaxPag := Val(HB_USUBSTR(clients_list.label_number_of_pages.VALUE, 4))
    Local nMinimo

    if nPag < nMaxPag
       nPag := nMaxPag
       pCli_cSQL := sql_clients_list(iif(pCli_lFiltro, pCli_cWHERE, NIL))
       pCli_cSQL += order_by_custumers()
       nMinimo := (nPag * hb_Val(clients_list.combobox_rows_per_page.DisplayValue)) - hb_Val(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cSQL += "LIMIT " + pCli_cLIMIT
       clients_list.text_page.VALUE := nPag
       load_grid_clients_list()

    endif
return

procedure clients_list_combobox_rows_per_page_on_change()
    Local nPag := clients_list.text_page.VALUE
    Local nMaxPag := hb_Val(HB_USUBSTR(clients_list.label_number_of_pages.VALUE, 4))
    Local nMinimo := (nPag * hb_Val(clients_list.combobox_rows_per_page.DisplayValue)) - hb_Val(clients_list.combobox_rows_per_page.DisplayValue)

    if !(pCli_cOldReg == clients_list.combobox_rows_per_page.DisplayValue) .and. (nMinimo < pCli_nCount)
       pCli_cSQL := sql_clients_list(iif(pCli_lFiltro, pCli_cWHERE, NIL))
       pCli_cSQL += order_by_custumers()
       pCli_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(clients_list.combobox_rows_per_page.DisplayValue)
       pCli_cSQL += "LIMIT " + pCli_cLIMIT
       pCli_cOldReg := clients_list.combobox_rows_per_page.DisplayValue
       clients_list.text_page.VALUE := nPag
       load_grid_clients_list()
    endif
    clients_list.grid_clients_list.SETFOCUS
return

/* Grid - Eventos ---------------------------------------------------------------------------------*/
procedure grid_clients_list_on_dblclick()
    if clients_list.grid_clients_list.VALUE > 0
        clients_form('SELECT')
     endif
return

procedure grid_clients_list_id_on_headclick()
    STATIC sClie_id_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
    clients_list_change_on_head('id#', 1, sClie_id_lFlag)
    sClie_id_lFlag := !(sClie_id_lFlag)
return

procedure grid_clients_list_razao_social_on_headclick()
    STATIC sClie_Nome_lFlag := false           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
    clients_list_change_on_head('Razão Social', 2, sClie_Nome_lFlag)
    sClie_Nome_lFlag := ! sClie_Nome_lFlag
return

procedure grid_clients_list_nome_fantasia_on_headclick()
    STATIC sClie_Apelido_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
    clients_list_change_on_head('Nome Fantasia', 3, sClie_Apelido_lFlag)
    sClie_Apelido_lFlag := !(sClie_Apelido_lFlag)
return

procedure clients_list_change_on_head(cHeader, nOrdem, lFlag)
    pCli_cSQL := sql_clients_list(iif(pCli_lFiltro, pCli_cWHERE, NIL))

    if !(pCli_hHeader['index'] == nOrdem) .and. pCli_hHeader['index'] > 0
       // Troca o fonte da coluna ativa (pCli_hHeader) para Normal (tira de negrito) e troca o ícone para vazio
       clients_list.grid_clients_list.ColumnHEADER(pCli_hHeader['index']) := pCli_hHeader['header']
       clients_list.grid_clients_list.HeaderDYNAMICFONT(pCli_hHeader['index']) := {|| ARRAY FONT "Open Sans" SIZE 9 }
    endif

    // Muda a coluna ativa para nOrdem (nova coluna clicada pelo usuário)
    pCli_hHeader['index'] := nOrdem
    pCli_hHeader['header'] := cHeader

    // Troca o ícone para up ou down conforme a flag
    clients_list.grid_clients_list.ColumnHEADER(nOrdem) := iif(lFlag, '↑', '↓') + "  " + cHeader

    // Troca o fonte da colula (nOrdem) em negrito
    clients_list.grid_clients_list.HeaderDYNAMICFONT(nOrdem) := {|| ARRAY FONT "Open Sans" SIZE 9 BOLD }

    // Seta as variáveis para a nova ordem selecionada

    cHeader := HMG_UPPER(AllTrim(cHeader))

    switch cHeader
    case 'ID#'

        if (lFlag)
           pCli_cORDER_BY := 'ID CRESCENTE'
           pCli_cSQL += 'ORDER BY clie_id '
        else
           pCli_cORDER_BY := 'ID DECRESCENTE'
           pCli_cSQL     += "ORDER BY clie_id DESC "
        endif
        EXIT

    case 'RAZÃO SOCIAL'

        if (lFlag)
           pCli_cORDER_BY := 'RAZÃO SOCIAL CRESCENTE'
           pCli_cSQL     += 'ORDER BY clie_razao_social '
        else
           pCli_cORDER_BY := 'RAZÃO SOCIAL DECRESCENTE'
           pCli_cSQL     += 'ORDER BY clie_razao_social DESC '
        endif
        EXIT

    case 'NOME FANTASIA'

        if (lFlag)
           pCli_cORDER_BY := 'NOME FANTASIA CRESCENTE'
           pCli_cSQL     += 'ORDER BY clie_nome_fantasia, clie_razao_social '
        else
           pCli_cORDER_BY := 'NOME FANTASIA DECRESCENTE'
           pCli_cSQL     += 'ORDER BY clie_nome_fantasia DESC, clie_razao_social DESC '
        endif
        EXIT

    endswitch

    pCli_cSQL += "LIMIT " + pCli_cLIMIT

    load_grid_clients_list()
    status_message('Pesquisa ' + iif(pCli_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' +  hmg_lower(pCli_cORDER_BY))

return

procedure clients_list_form_on_release()
		if ! (pCli_oQuery == NIL)
			pCli_oQuery:Destroy()
		endif
return

procedure clients_list_button_excel_Action()
    // Ver abaixo
return
/* A Fazer ..........
procedure clients_list_button_excel_Action()
        // Variáveis private serão usadas no form cliente2Excel em suas rotinas e sub-chamadas dentro do form cliente2Excel
		private oExcel_Clientes := CreateObject("Excel.Application")
		private oForm7 AS OBJECT

        // Desabilita o botão Excel enquanto gera arquivo e impede usuário dar duplo-click e chamdas recursivas
		clients_list.button_excel.ENABLED := false

		if (oExcel_Clientes == NIL)
			MsgExclamation("Essa exportação exige que o MS Excel esteja instalado nesse equipamento.", "MS Excel não instalado!")
			clients_list.button_excel.ENABLED := true
			return
		endif

		if IsWIndowActive(clientes2Excel)
			clientes2Excel.MINIMIZE
			clientes2Excel.RESTORE
			clientes2Excel.SETFOCUS
		else
			load window clientes2Excel
			on key escape of clientes2Excel action clientes2Excel.RELEASE
			clientes2Excel.CENTER
			clientes2Excel.ACTIVATE
		endif

return
*/