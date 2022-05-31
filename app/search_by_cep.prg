#include <hmg.ch>

declare window search_by_cep

procedure register_form_button_cep_action()
    LOCAL cCep := get_numbers(GetProperty(ThisWindow.Name, "text_cep", "Value"))
    LOCAL oCep
    private p_cNameForm := ThisWindow.Name   // Usado na procedure search_by_cep_form_on_init() em search_by_cep.prg
    private p_aCEPs := {}

    if hb_ULen(cCep) == 8
        oCep := TViaCEP():New(cCep)
    elseif !Empty(GetProperty(ThisWindow.Name, "text_logradouro", "Value")) .AND. !Empty(GetProperty(ThisWindow.Name, "text_municipio", "Value")) .AND. !Empty(GetProperty(ThisWindow.Name, "combobox_uf", "DisplayValue"))
        oCep := TViaCEP():New(GetProperty(ThisWindow.Name, "combobox_uf", "DisplayValue") + "/" + AllTrim(GetProperty(ThisWindow.Name, "text_municipio", "Value")) + "/" + AllTrim(GetProperty(ThisWindow.Name, "text_logradouro", "Value")))
    endif

    if (oCep == NIL)
        DoMethod(ThisWindow.Name, "text_cep", "SetFocus")
        SetProperty(ThisWindow.Name, "text_cep", "BackColor", {255,0,0})
    else

        if Empty(oCep:aCEP)
           SetProperty(ThisWindow.Name, "text_cep", "Value", oCep:cCEP)
           SetProperty(ThisWindow.Name, "text_logradouro", "Value", oCep:cLogradouro)
           SetProperty(ThisWindow.Name, "text_complemento", "Value", oCep:cComplemento)
           SetProperty(ThisWindow.Name, "text_bairro", "Value", oCep:cBairro)
           SetProperty(ThisWindow.Name, "text_municipio", "Value", oCep:cLocalidade)
           SetProperty(ThisWindow.Name, "combobox_uf", "Value", index_of_comboBox(ThisWindow.Name, "combobox_uf", oCep:cUF))
        else

           p_aCEPs := AClone(oCep:aCEP)

            if IsWindowActive(search_by_cep)
                search_by_cep.MINIMIZE
                search_by_cep.RESTORE
                search_by_cep.SETFOCUS
            else
                load window search_by_cep
                on key escape of search_by_cep action search_by_cep.RELEASE
                search_by_cep.CENTER
                search_by_cep.ACTIVATE
            endif
        endif

        DoMethod(ThisWindow.Name, "text_numero", "SETFOCUS")

    endif

return

procedure search_by_cep_form_on_init()
    LOCAL hCEP

    search_by_cep.label_informa_ocorrencias.VALUE := "A pesquisa retornou " + hb_NToS(hmg_Len(p_aCEPs)) + " ocorrências, escolha uma delas: "
    search_by_cep.label_informa_ocorrencias.Visible := true
    search_by_cep.Grid_search_by_cep.DELETEALLITEMS

    for each hCEP in p_aCEPs
        ADD ITEM { ;
            hCEP['cep'], ;
            hCEP['logradouro'], ;
            hCEP['complemento'], ;
            hCEP['bairro'], ;
            hCEP['localidade'], ;
            hCEP['uf'] ;
        } TO Grid_search_by_cep OF search_by_cep

    next each

return

procedure grid_enderecos_on_dblclick()
    if ! (This.CellRowIndex == 0)
        SetProperty(p_cNameForm, "text_cep", "Value", p_aCEPs[This.CellRowIndex, 'cep'])
        SetProperty(p_cNameForm, "text_logradouro", "Value", p_aCEPs[This.CellRowIndex, 'logradouro'])
        SetProperty(p_cNameForm, "text_complemento", "Value", p_aCEPs[This.CellRowIndex, 'complemento'])
        SetProperty(p_cNameForm, "text_bairro", "Value", p_aCEPs[This.CellRowIndex, 'bairro'])
        SetProperty(p_cNameForm, "text_municipio", "Value", p_aCEPs[This.CellRowIndex, 'localidade'])
        SetProperty(p_cNameForm, "combobox_uf", "Value", index_of_comboBox(p_cNameForm, "combobox_uf", p_aCEPs[This.CellRowIndex, 'uf']))
        search_by_cep.RELEASE
    endif
Return
