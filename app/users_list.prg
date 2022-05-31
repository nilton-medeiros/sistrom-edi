/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: users_grid.prg
 Rotinas: Mostra a lista de Usuários em grade (GRID) paginada
***********************************************************************************/

#include <hmg.ch>

declare window users_list

/*
 * Invocada pelo menu principal Usuarios em Main
 * ADVERTÊNCIA: As variáveis private neste formulário são enchergadas em todos os demais formulários abertos ao mesmo tempo
*/

/* Rotinas iniciais -------------------------------------------------------------------------------*/
procedure form_users_list()
   private pUsers_loadgrid := false // usado no form users quando incluir ou alterar
    private pUsers_list_lFiltro := false
    private pUsers_list_nCount := pUsers_list_nHeader := 0, pUsers_list_nOldPag := 1
    private pUsers_list_cSQL := pUsers_list_cWHERE := pUsers_list_cORDER_BY := ''
    private pUsers_list_cOldReg := pUsers_list_cLIMIT := "300"
    private private_users_list_query
    private pUsers_list_bBackColor := { || iif(This.CellRowIndex/2==INT(This.CellRowIndex/2), background_color_active_records('users_list','grid_users_list', true), background_color_active_records('users_list','grid_users_list')) }

    if IsWIndowActive(users_list)
        users_list.MINIMIZE
        users_list.RESTORE
        users_list.SETFOCUS
    else
        load window users_list
        on key escape of users_list action users_list.RELEASE
        users_list.CENTER
        users_list.ACTIVATE
    endif

return

procedure users_list_form_on_init()

    users_list.button_new.ENABLED := (app:getUser('menu_usuarios') == 2)
    users_list.button_edit.ENABLED := false
    users_list.button_delete.ENABLED := false
    users_list.text_search.ENABLED := false
    users_list.checkbutton_search.ENABLED := false
    users_list.button_first_page.ENABLED := false
    users_list.button_previous_page.ENABLED := false
    users_list.text_page.ENABLED := false
    users_list.button_next_page.ENABLED := false
    users_list.button_last_page.ENABLED := false
    users_list.combobox_rows_per_page.ENABLED := false

    pUsers_list_cORDER_BY := 'NOME CRESCENTE'
    pUsers_list_cSQL := sql_users_list()
    pUsers_list_cSQL += "ORDER BY user_nome "
    pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT

    //users_list.grid_users_list.HeaderImages(2) := 'hdUp'
    users_list.grid_users_list.HeaderDYNAMICFONT(2) := {|| ARRAY FONT "Open Sans" SIZE 9 BOLD }

    pUsers_list_nHeader := 2

    status_message('Iniciando Grade Usuários...')

    load_grid_users_list()

    users_list.combobox_rows_per_page.DELETEALLITEMS

    do case
    case pUsers_list_nCount > 1000
         users_list.combobox_rows_per_page.AddItem('300')
         users_list.combobox_rows_per_page.AddItem('400')
         users_list.combobox_rows_per_page.AddItem('500')
         users_list.combobox_rows_per_page.AddItem('700')
         users_list.combobox_rows_per_page.AddItem('800')
         users_list.combobox_rows_per_page.AddItem('900')
         users_list.combobox_rows_per_page.AddItem('1000')
    case pUsers_list_nCount > 900
         users_list.combobox_rows_per_page.AddItem('300')
         users_list.combobox_rows_per_page.AddItem('400')
         users_list.combobox_rows_per_page.AddItem('500')
         users_list.combobox_rows_per_page.AddItem('700')
         users_list.combobox_rows_per_page.AddItem('800')
         users_list.combobox_rows_per_page.AddItem('900')
    case pUsers_list_nCount > 800
         users_list.combobox_rows_per_page.AddItem('300')
         users_list.combobox_rows_per_page.AddItem('400')
         users_list.combobox_rows_per_page.AddItem('500')
         users_list.combobox_rows_per_page.AddItem('700')
         users_list.combobox_rows_per_page.AddItem('800')
    case pUsers_list_nCount > 700
         users_list.combobox_rows_per_page.AddItem('300')
         users_list.combobox_rows_per_page.AddItem('400')
         users_list.combobox_rows_per_page.AddItem('500')
         users_list.combobox_rows_per_page.AddItem('700')
    case pUsers_list_nCount > 500
         users_list.combobox_rows_per_page.AddItem('300')
         users_list.combobox_rows_per_page.AddItem('400')
         users_list.combobox_rows_per_page.AddItem('500')
    case pUsers_list_nCount > 400
         users_list.combobox_rows_per_page.AddItem('300')
         users_list.combobox_rows_per_page.AddItem('400')
    OTHERWISE
         users_list.combobox_rows_per_page.AddItem('300')
    endcase

    users_list.combobox_rows_per_page.VALUE := 1

return

/* STATIC: Funções exclusivas deste .prg ----------------------------------------------------------*/
STATIC function sql_users_list(cAddWhere)
			local cSQL := "SELECT user_id AS id,"

         cSQL += "user_nome AS nome,"
         cSQL += "user_apelido AS apelido,"
         cSQL += "user_login AS login,"
         cSQL += "user_senha AS senha,"
         cSQL += "departamento,"
         cSQL += "user_email AS email,"
         cSQL += "user_celular AS celular,"
         cSQL += "user_ativo AS ativo,"
			cSQL += "menu_edi,"
			cSQL += "menu_ftp,"
			cSQL += "menu_lembretes,"
			cSQL += "menu_clientes,"
			cSQL += "menu_usuarios,"
			cSQL += "menu_empresas,"
			cSQL += "menu_configuracoes,"
			cSQL += "menu_log_sistema,"
			cSQL += "user_cadastrado_por AS cadastrado_por_id,"
			cSQL += "user_cadastrado_por_nome AS cadastrado_por_nome,"
			cSQL += "user_cadastrado_em AS cadastrado_em,"
			cSQL += "user_alterado_por AS alterado_por_id,"
			cSQL += "user_alterado_por AS alterado_por_nome,"
			cSQL += "user_alterado_em AS alterado_em,"
			cSQL += "user_versao AS alteracoes "
			cSQL += "FROM view_usuarios "
         cSQL += "WHERE user_id>0 "

         if ValType(cAddWhere) == "C" .and. !Empty(cAddWhere)
            cSQL += "AND " + cAddWhere + " "
         endif

return (cSQL)

function load_grid_users_list()
         Local i, nRow := 0 , nTotPag := 0 , nOldReg
         Local lRet := false
         Local oRow

         if !(private_users_list_query == NIL)
            private_users_list_query:Destroy()
         endif

         DELETE ITEM ALL FROM grid_users_list OF users_list

			private_users_list_query := TSQLQuery():NEW(pUsers_list_cSQL)
         if ! private_users_list_query:isExecuted()
            return false
         endif

         nRow := private_users_list_query:LastRec()

         if nRow > 0

            status_message('Preparando Grade de users_list...')

            //users_list.grid_users_list.Image(true) := {"gdEmpty","gdHappyDay"}

            for i := 1 TO nRow

                oRow := private_users_list_query:GetRow(i)

                ADD ITEM { ;
                    oRow:getField('id'), ;
                    oRow:getField('nome'), ;
                    oRow:getField('apelido'), ;
                    oRow:getField('login'), ;
                    oRow:getField('departamento'),;
                    AllTrim(oRow:getField('celular')), ;
                    AllTrim(oRow:getField('email')), ;
                    iif(is_true(oRow:getField('ativo')), 'ATIVO', 'INATIVO'), ;
                    iif(oRow:getField('menu_edi')==0, "SEM ACESSO", iif(oRow:getField('menu_edi')==1, 'LER', 'LER & GRAVAR')), ;
                    iif(oRow:getField('menu_ftp')==0, "SEM ACESSO", iif(oRow:getField('menu_ftp')==1, 'LER', 'LER & GRAVAR')), ;
                    iif(oRow:getField('menu_lembretes')==0, "SEM ACESSO", iif(oRow:getField('menu_lembretes')==1, 'LER', 'LER & GRAVAR')), ;
                    iif(oRow:getField('menu_clientes')==0, "SEM ACESSO", iif(oRow:getField('menu_clientes')==1, 'LER', 'LER & GRAVAR')), ;
                    iif(oRow:getField('menu_usuarios')==0, "SEM ACESSO", iif(oRow:getField('menu_usuarios')==1, 'LER', 'LER & GRAVAR')), ;
                    iif(oRow:getField('menu_empresas')==0, "SEM ACESSO", iif(oRow:getField('menu_empresas')==1, 'LER', 'LER & GRAVAR')), ;
                    iif(oRow:getField('menu_configuracoes')==0, "SEM ACESSO", iif(oRow:getField('menu_configuracoes')==1, 'LER', 'LER & GRAVAR')), ;
                    iif(oRow:getField('menu_log_sistema')==0, "SEM ACESSO", iif(oRow:getField('menu_log_sistema')==1, 'LER', 'LER & GRAVAR')), ;
                    oRow:getField('cadastrado_por_nome'), ;
                    datetime_db_to_br(oRow:getField('cadastrado_em')), ;
                    oRow:getField('alterado_por_nome'), ;
                    datetime_db_to_br(oRow:getField('alterado_em')), ;
                    oRow:getField('alteracoes') ;
                } TO grid_users_list OF users_list

                //users_list.grid_users_list.ImageIndex(i,1) := iif(Month(oRow:getField('data_nascimento')) == Month(Date()), 1, 0)

            next i

            /*  private_users_list_query, deixa posicionada na primeira linha para uso posterior em outras funções neste prg */
            private_users_list_query:GoTop()

            users_list.grid_users_list.VALUE := 1
            users_list.button_edit.ENABLED := (app:getUser('menu_usuarios') == 2)
            users_list.button_delete.ENABLED := (app:getUser('menu_usuarios') == 2)
            users_list.text_search.ENABLED := true
            users_list.checkbutton_search.ENABLED := true

            pUsers_list_nCount := select_count("usuarios WHERE user_id>0") // Total de registros na tabela toda e não na Grid (nRow = total de registro na Grid)
       	    pUsers_list_cOldReg := users_list.combobox_rows_per_page.DisplayValue
            nOldReg := hb_Val(pUsers_list_cOldReg)
            nTotPag := iif(pUsers_list_nCount > nOldReg, pUsers_list_nCount/nOldReg, 1)

            if nTotPag > 1

               users_list.text_page.ENABLED := true
               users_list.button_first_page.ENABLED := true
               users_list.button_previous_page.ENABLED := true
               users_list.button_next_page.ENABLED := true
               users_list.button_last_page.ENABLED := true
               users_list.combobox_rows_per_page.ENABLED := true

               if (nTotPag - int(nTotPag) > 0)
                   nTotPag := int(nTotPag) + 1
               endif

            endif

            users_list.label_number_of_pages.VALUE := 'de ' + hb_NToS(nTotPag)
            users_list.label_TotReg.VALUE := LTrim(TransForm(pUsers_list_nCount, "@E 99,999,999,999"))

            lRet := true

            status_message('Pesquisa ' + iif(pUsers_list_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' + hmg_lower(pUsers_list_cORDER_BY) + '. ' + hb_NToS(nRow) + iif(nRow > 1, ' registros carregados.',' registro carregado.'))

         else

            users_list.button_edit.ENABLED := false
            users_list.button_delete.ENABLED := false

            if Empty(users_list.text_search.VALUE)
               users_list.text_search.ENABLED := false
               users_list.checkbutton_search.ENABLED := false
               users_list.button_exit.SETFOCUS
            else
               users_list.text_search.ENABLED := true
               users_list.checkbutton_search.ENABLED := true
               users_list.text_search.SETFOCUS
            endif

            status_message('Pesquisa ' + iif(pUsers_list_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' + hmg_lower(pUsers_list_cORDER_BY) + '. Nenhum registro encontrado.')

         endif

return (lRet)

STATIC;
function order_by_users_list()
         Local cOrderBy

         do case
         case pUsers_list_cORDER_BY == 'ID DECRESCENTE'
              cOrderBy := "ORDER BY user_id DESC "
         case pUsers_list_cORDER_BY == 'NOME CRESCENTE'
              cOrderBy := "ORDER BY user_nome "
         case pUsers_list_cORDER_BY == 'NOME DECRESCENTE'
              cOrderBy := "ORDER BY user_nome DESC "
         case pUsers_list_cORDER_BY == 'APELIDO CRESCENTE'
              cOrderBy := "ORDER BY user_apelido "
         case pUsers_list_cORDER_BY == 'APELIDO DECRESCENTE'
              cOrderBy := "ORDER BY user_apelido DESC "
         OTHERWISE
              cOrderBy := "ORDER BY user_id "
              pUsers_list_cORDER_BY := 'ID CRESCENTE'
         endcase

return (cOrderBy)

/* Botões - Ações ---------------------------------------------------------------------------------*/
procedure users_list_button_new_action()
    if users_list.grid_users_list.VALUE > 0
        form_users('INSERT')
        if pUsers_loadgrid
            load_grid_users_list()
            pUsers_loadgrid := false
        endif
     endif
return

procedure users_list_button_edit_action()
      if users_list.grid_users_list.VALUE > 0
         form_users('UPDATE')
         if pUsers_loadgrid
             load_grid_users_list()
             pUsers_loadgrid := false
         endif
      endif
return

procedure users_list_button_delete_action()
    local cID := hb_NToS(users_list.grid_users_list.CellEx(users_list.grid_users_list.VALUE,1))

    if !(users_list.grid_users_list.VALUE == 0)
        if MsgYesNo({'Deseja realmente excluir o Usuário?', CRLF+CRLF,;
            'Usuário: ', users_list.grid_users_list.CellEx(users_list.grid_users_list.VALUE,2)}, 'Exclusão de Usuário ID#: ' + cID, false)
            if delete_record_from_db('users_list', cID, 'Usuário')
                users_list.grid_users_list.DeleteItem(users_list.grid_users_list.VALUE)
                users_list.grid_users_list.Refresh
            endif
        endif
    endif

return

procedure users_list_checkbutton_search_on_change()

    if (users_list.checkbutton_search.VALUE)

        // Botão foi apertado

        users_list.text_search.VALUE := AllTrim(users_list.text_search.VALUE)
        users_list.checkbutton_search.Picture := 'bttFilterOff'

        if Empty(users_list.text_search.VALUE)

           // Se apertou botão e não tem pesquisa, solta o botão e não faz nada

           users_list.checkbutton_search.VALUE := false
           pUsers_list_lFiltro := false
           pUsers_list_cWHERE := ''
           users_list.text_search.SETFOCUS
           return

        else

           // Se apertou botão e tem pesquisa, deixa botão apertado e re-carrega grid com filtro
           // Filtro solicitado, faz pesquisa mantendo a ordem atual

           status_message('Pesquisando registros...')

           // pUsers_list_cWHERE: Usado em outras funçoes
           pUsers_list_cWHERE := " user_nome LIKE '%" + unicode_to_ansi(users_list.text_search.VALUE) + "%'"
           pUsers_list_cWHERE += " OR user_apelido LIKE '%" + unicode_to_ansi(users_list.text_search.VALUE) + "%'"

           if IsDigit(users_list.text_search.VALUE)
                pUsers_list_cWHERE += " OR user_id=" + get_numbers(users_list.text_search.VALUE)
                pUsers_list_cWHERE += " OR user_celular LIKE '%" + users_list.text_search.VALUE + "%'"
           endif

           pUsers_list_cSQL := sql_users_list(pUsers_list_cWHERE)
           pUsers_list_cSQL += order_by_users_list()
           pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT

           // Mantem a ordem atual na nova pesquisa

           if load_grid_users_list()
              users_list.text_search.ENABLED := false
              pUsers_list_lFiltro := true
           else
              pUsers_list_lFiltro := false
              pUsers_list_cWHERE := ''
           endif

        endif

    else

        // Soltou botão
        users_list.checkbutton_search.Picture := 'bttFilterOn'

        if (pUsers_list_lFiltro)

           // Se Soltou botão, e tem filtro ativo, remove filtro e recarrega a grid
           status_message('Removendo filtro...')

           // Mantem a ordem atual para nova consulta sem filtro

           pUsers_list_cSQL   := sql_users_list()
           pUsers_list_cSQL   += order_by_users_list()
           pUsers_list_cLIMIT := LTrim(users_list.combobox_rows_per_page.DisplayValue)
           pUsers_list_cSQL   += "LIMIT " + pUsers_list_cLIMIT

           load_grid_users_list()

        else
           status_message('Pesquisa sem filtro na ordem ' +  hmg_lower(pUsers_list_cORDER_BY))
        endif

        users_list.text_search.ENABLED := true
        pUsers_list_lFiltro := false
        pUsers_list_cWHERE := ''

     endif

return

procedure users_list_button_first_page_action()
    if users_list.text_page.VALUE > 1
        pUsers_list_cSQL := sql_users_list(iif(pUsers_list_lFiltro, pUsers_list_cWHERE, NIL))
        pUsers_list_cSQL += order_by_users_list()
        pUsers_list_cLIMIT := LTrim(users_list.combobox_rows_per_page.DisplayValue)
        pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT
        users_list.text_page.VALUE := 1
        load_grid_users_list()
     end
return

procedure users_list_button_previous_page_action()
    Local nPag := users_list.text_page.VALUE
    Local nMinimo

    if nPag > 1
       nPag--
       pUsers_list_cSQL := sql_users_list(iif(pUsers_list_lFiltro, pUsers_list_cWHERE, NIL))
       pUsers_list_cSQL += order_by_users_list()
       nMinimo := (nPag * hb_Val(users_list.combobox_rows_per_page.DisplayValue)) - hb_Val(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT
       users_list.text_page.VALUE := nPag
       load_grid_users_list()
    end
return

procedure users_list_text_page_on_enter()
    Local nPag := users_list.text_page.VALUE
    Local nMaxPag := hb_Val(HB_USUBSTR(users_list.label_number_of_pages.VALUE, 4))
    Local nMinimo

    if !(pUsers_list_nOldPag == nPag)
       if nPag < 1
          nPag := 1
       elseif nPag > nMaxPag
          nPag := nMaxPag
       endif
       pUsers_list_cSQL := sql_users_list(iif(pUsers_list_lFiltro, pUsers_list_cWHERE, NIL))
       pUsers_list_cSQL += order_by_users_list()
       nMinimo := (nPag * hb_Val(users_list.combobox_rows_per_page.DisplayValue)) - hb_Val(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT
       load_grid_users_list()
       users_list.text_page.VALUE := pUsers_list_nOldPag := nPag
    endif
    users_list.grid_users_list.SETFOCUS
return

procedure users_list_button_next_page_action()
    Local nPag := users_list.text_page.VALUE
    Local nMaxPag := hb_Val(HB_USUBSTR(users_list.label_number_of_pages.VALUE, 4))
    Local nMinimo

    if nPag < nMaxPag
       nPag++
       pUsers_list_cSQL := sql_users_list(iif(pUsers_list_lFiltro, pUsers_list_cWHERE, NIL))
       pUsers_list_cSQL += order_by_users_list()
       nMinimo := (nPag * hb_Val(users_list.combobox_rows_per_page.DisplayValue)) - hb_Val(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT
       users_list.text_page.VALUE := nPag
       load_grid_users_list()
    endif
return

procedure users_list_button_last_page_action()
    Local nPag := users_list.text_page.VALUE
    Local nMaxPag := Val(HB_USUBSTR(users_list.label_number_of_pages.VALUE, 4))
    Local nMinimo

    if nPag < nMaxPag
       nPag := nMaxPag
       pUsers_list_cSQL := sql_users_list(iif(pUsers_list_lFiltro, pUsers_list_cWHERE, NIL))
       pUsers_list_cSQL += order_by_users_list()
       nMinimo := (nPag * hb_Val(users_list.combobox_rows_per_page.DisplayValue)) - hb_Val(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT
       users_list.text_page.VALUE := nPag
       load_grid_users_list()
    endif
return

procedure users_list_combobox_rows_per_page_on_change()
    Local nPag := users_list.text_page.VALUE
    Local nMaxPag := hb_Val(HB_USUBSTR(users_list.label_number_of_pages.VALUE, 4))
    Local nMinimo := (nPag * hb_Val(users_list.combobox_rows_per_page.DisplayValue)) - hb_Val(users_list.combobox_rows_per_page.DisplayValue)

    if !(pUsers_list_cOldReg == users_list.combobox_rows_per_page.DisplayValue) .and. (nMinimo < pUsers_list_nCount)
       pUsers_list_cSQL := sql_users_list(iif(pUsers_list_lFiltro, pUsers_list_cWHERE, NIL))
       pUsers_list_cSQL += order_by_users_list()
       pUsers_list_cLIMIT := hb_NToS(nMinimo) + "," + LTrim(users_list.combobox_rows_per_page.DisplayValue)
       pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT
       pUsers_list_cOldReg := users_list.combobox_rows_per_page.DisplayValue
       users_list.text_page.VALUE := nPag
       load_grid_users_list()
    endif
    users_list.grid_users_list.SETFOCUS
return

/* Grid - Eventos ---------------------------------------------------------------------------------*/
procedure grid_users_list_on_dblclick()
    if users_list.grid_users_list.VALUE > 0
        form_users('SELECT')
     endif
return

procedure grid_users_list_id_on_headclick()
    STATIC susers_list_id_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
    users_list_Troca_OnHead('id#', susers_list_id_lFlag)
    susers_list_id_lFlag := !(susers_list_id_lFlag)
return

procedure grid_users_list_Nome_on_headclick()
    STATIC susers_list_Nome_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
    users_list_Troca_OnHead('Nome', susers_list_Nome_lFlag)
    susers_list_Nome_lFlag := !(susers_list_Nome_lFlag)
return

procedure grid_users_list_Apelido_on_headclick()
    STATIC susers_list_Apelido_lFlag := true           // A variavel estatica é definida apenas na primeira vez que a função é executada, depois mantem seu conteudo.
    users_list_Troca_OnHead('Apelido', susers_list_Apelido_lFlag)
    susers_list_Apelido_lFlag := !(susers_list_Apelido_lFlag)
return

procedure users_list_Troca_OnHead(cHeader, lFlag)
    local nOrdem := grid_column_index('users_list', 'grid_users_list', cHeader)
    pUsers_list_cSQL := sql_users_list(iif(pUsers_list_lFiltro, pUsers_list_cWHERE, NIL))

    if !(pUsers_list_nHeader == nOrdem) .and. pUsers_list_nHeader > 0
       // Troca o fonte da coluna ativa (pUsers_list_nHeader) para Normal (tira de negrito) e troca o ícone para vazio
       users_list.grid_users_list.HeaderDYNAMICFONT(pUsers_list_nHeader) := {|| ARRAY FONT "Open Sans" SIZE 9 }
       //users_list.grid_users_list.HeaderImages(pUsers_list_nHeader) := 'hdEmpty'
    endif

    // Muda a coluna ativa para nOrdem (nova coluna clicada pelo usuário)
    pUsers_list_nHeader := nOrdem

    // Seta as variáveis para a nova ordem selecionada

    cHeader := HMG_UPPER(AllTrim(cHeader))

    switch cHeader
    case 'ID#'

        if (lFlag)
           pUsers_list_cORDER_BY := 'ID CRESCENTE'
           pUsers_list_cSQL += 'ORDER BY user_id '
        else
           pUsers_list_cORDER_BY := 'ID DECRESCENTE'
           pUsers_list_cSQL     += "ORDER BY user_id DESC "
        endif
        EXIT

    case 'NOME'

        if (lFlag)
           pUsers_list_cORDER_BY := 'NOME CRESCENTE'
           pUsers_list_cSQL     += 'ORDER BY user_nome '
        else
           pUsers_list_cORDER_BY := 'NOME DECRESCENTE'
           pUsers_list_cSQL     += 'ORDER BY user_nome DESC '
        endif
        EXIT

    case 'APELIDO'

        if (lFlag)
           pUsers_list_cORDER_BY := 'APELIDO CRESCENTE'
           pUsers_list_cSQL     += 'ORDER BY user_apelido, user_nome '
        else
           pUsers_list_cORDER_BY := 'APELIDO DECRESCENTE'
           pUsers_list_cSQL     += 'ORDER BY user_apelido DESC, user_nome DESC '
        endif
        EXIT

    endswitch

    // Troca o ícone para up ou down conforme a flag
    //users_list.grid_users_list.HeaderImages(nOrdem) := iif(lFlag, 'hdUp', 'hdDown')

    // Troca o fonte da colula (nOrdem) em negrito
    users_list.grid_users_list.HeaderDYNAMICFONT(nOrdem) := {|| ARRAY FONT "Open Sans" SIZE 9 BOLD }

    pUsers_list_cSQL += "LIMIT " + pUsers_list_cLIMIT

    load_grid_users_list()
    status_message('Pesquisa ' + iif(pUsers_list_lFiltro, 'com filtro ativo', 'sem filtro') + ' na ordem ' +  hmg_lower(pUsers_list_cORDER_BY))

return
