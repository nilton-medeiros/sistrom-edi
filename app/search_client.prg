#include <hmg.ch>

DECLARE WINDOW search_client

procedure search_client_form
        parameters clie_search, parent_form, parent_control  // Recebe um parâmetro de escopoo private, para ser usado em todas as procedures do form
        if IsWindowActive(search_client)
            search_client.MINIMIZE
            search_client.RESTORE
            search_client.SETFOCUS
        else
            load window search_client
            on key escape of search_client action search_client.RELEASE
            search_client.CENTER
            search_client.ACTIVATE
        endif
return

Procedure search_client_form_on_init()
        local i

        // Objeto clie_search PRIVATE um form acima
        search_client.label_many_clients.VALUE := 'A pesquisa retornou ' + hb_NToS(clie_search:lastRec()) + ' clientes, escolha um deles ou ESC para cancelar:'
        search_client.label_many_clients.VISIBLE := True

        /* Pega todas as linhas retornadas  */
        search_client.grid_search_client.DeleteAllItems
        clie_search:cargo := 0 // Armazena 0 para cliente não escolhido

        FOR i := 1 TO clie_search:lastRec()
            /* Adiciona registros na Grid */
            ADD ITEM {;
                clie_search:getField('id'),;
                clie_search:getField('razao_social'),;
                clie_search:getField('nome_fantasia'),;
                clie_search:getField('cnpj', 'as cnpj'),;
                clie_search:getField('fone1');
            } TO grid_search_client OF search_client
            clie_search:skip()
        NEXT i

        search_client.grid_search_client.REFRESH
        search_client.grid_search_client.SETFOCUS
        search_client.grid_search_client.VALUE := 1

Return

Procedure grid_search_client_on_dblclick()
        clie_search:cargo := search_client.grid_search_client.VALUE
        search_client.RELEASE
Return

Procedure search_client_form_on_release()
        DoMethod('parent_form', 'parent_control', "SETFOCUS")
Return
