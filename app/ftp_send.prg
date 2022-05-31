/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: ftp_send.prg | Trabalha com o Form ftp_send.fmg
 Rotinas: Formulário de Envio de Arquivos via FTP ao Cliente
***********************************************************************************/

#include <hmg.ch>
//#include <fileio.ch>
#include "Directry.ch"

declare window ftp_send
declare window search_client

procedure ftp_send_form()
        local k
        private clie_ftp as object

        if IsWIndowActive(ftp_send)
            ftp_send.MINIMIZE
            ftp_send.RESTORE
            ftp_send.SETFOCUS
        else
            load window ftp_send
            on key escape of ftp_send action ftp_send.RELEASE

            k := GetControlIndex("grid_files_to_send", "ftp_send")
            _HMG_SYSDATA[ 40 ][ k ][ 46 ] := {|| ftp_send_on_checkbox_clicked() }

            ftp_send.CENTER
            ftp_send.ACTIVATE

        endif
return

procedure ftp_send_form_on_init()
    ftp_send.button_send_ftp.ENABLED := false
    ftp_send.button_close.ENABLED := true
    ftp_send.grid_files_to_send.CHECKBOXENABLED := true
return

procedure ftp_send_text_cnpj_on_enter()
    local search := unicode_to_ansi(ftp_send.text_cnpj.VALUE)
    local cnpj := get_numbers(search)
    local sql

    if Empty(search)
        MsgExclamation('Digite o CNPJ ou parte do nome da Razão Social para pesquisar!', 'Pesquisa do Destinatário de FTP')
        return
    endif

    status_message('Pesquisando cliente...')
    ftp_send.button_close.ENABLED := false

    sql := "SELECT "
    sql += "clie_id AS id,"
    sql += "clie_razao_social AS razao_social,"
    sql += "clie_nome_fantasia AS nome_fantasia,"
    sql += "clie_cnpj AS cnpj,"
    sql += "clie_fone1 AS fone1,"    // Esse fone é usado na grid pesquisa em search_client
    sql += "edi_ftp_server AS ftp_server,"
    sql += "edi_ftp_user_id AS ftp_user,"
    sql += "edi_ftp_password AS ftp_password,"
    sql += "edi_ftp_remote_path AS ftp_remote_path "
    sql += "FROM clientes "
    sql += "WHERE clie_ativo=1 AND "
    sql += "NOT ISNULL(edi_ftp_server) AND edi_ftp_server != '' AND "
    sql += "NOT ISNULL(edi_ftp_user_id) AND edi_ftp_user_id != '' AND "
    sql += "NOT ISNULL(edi_ftp_password) AND edi_ftp_password != '' AND "

    if hmg_len(cnpj) == 14
        // Busca pelo CNPJ
        sql += "clie_cnpj='" + cnpj + "';"
    else
        sql += "(clie_razao_social LIKE '%" + search + "%' OR clie_nome_fantasia LIKE '%" + search + "%') LIMIT 300;"
    endif

    if ValType(clie_ftp) == 'O'
        clie_ftp:destroy()
    endif
    clie_ftp := NIL

    clie_ftp := TSQLQuery():new(sql)

    if clie_ftp:isExecuted

        // setar os campos da query clie_ftp para o form
        clie_ftp:goTop()
        clie_ftp:cargo := 0

        if clie_ftp:lastRec() == 0
            MsgExclamation('Destinatário não definido para FTP.' + hb_eol() + 'Informe as opções de FTP para este Cliente em Cadastros/Clientes', 'Pesquisa de Destinatários de FTP')
        elseif clie_ftp:lastRec() == 1
            clie_ftp:cargo := 1
        else
            // Mais de um encontrado, abrir grade de escolha
            search_client_form(clie_ftp, 'ftp_send', 'button_send_ftp')
        endif

        ftp_send_set_fields()
        status_message()

    else
        status_message('Não foi possível pesquisar cliente.')
    endif

    ftp_send.button_close.ENABLED := true

return

procedure ftp_send_set_fields()
    local dir := hb_cwd() + 'edi\'

    if clie_ftp:cargo == 0
        ftp_send.text_id.VALUE := 0
        ftp_send.text_razao_social.VALUE := ''
        ftp_send.checkbox_files_sent.VALUE := false
        ftp_send.button_send_ftp.ENABLED := false
    else
        with object clie_ftp
            :goTo(:cargo)
            ftp_send.text_cnpj.VALUE := :getField('cnpj', 'as cnpj')
            ftp_send.text_id.VALUE := :getField('id')
            ftp_send.text_razao_social.VALUE := :getField('razao_social')
            ftp_send.checkbox_files_sent.VALUE := false
            dir += clie_ftp:getField('cnpj') + '\'
            if ! hb_DirExists(dir + 'enviados')
                hb_DirBuild(dir + 'enviados')
             endif
        end with
    endif

    ftp_send_grid_files_to_send_load()
    ftp_send.button_send_ftp.ENABLED := true

return

procedure ftp_send_grid_files_to_send_load()
    local e, dir := 'edi\' + clie_ftp:getField('cnpj') + '\'
    local status := 'Pronto para Envio', msg := 'à serem enviados'

    ftp_send.grid_files_to_send.DELETEALLITEMS

    if ftp_send.checkbox_files_sent.VALUE
        dir += 'enviados\'
        status := 'OK - Enviados'
        msg := 'enviados'
    endif

    if hb_DirExists(dir) .and. ! Empty(Directory(dir + '*.txt'))
        AEval(Directory(dir + '*.txt'), {|aFile| ftp_send.grid_files_to_send.AddItem({aFile[F_NAME], DtoC(aFile[F_DATE]) + ' ' + aFile[F_TIME], status})})
        ftp_send.grid_files_to_send.REFRESH
        ftp_send.button_send_ftp.ENABLED := ! ftp_send.checkbox_files_sent.VALUE

        for e:= 1 TO ftp_send.grid_files_to_send.ITEMCOUNT
            ftp_send.grid_files_to_send.CHECKBOXITEM(e) := ftp_send.button_send_ftp.ENABLED
        next e
        status_message('Status: ' + hb_ntos(ftp_send.grid_files_to_send.ITEMCOUNT) + ' arquivos carregados')
    else
        status_message('Não há Arquivos ' + msg + ' - Diretório vazio!')
        ftp_send.button_send_ftp.ENABLED := false
    endif

return


procedure ftp_send_button_send_ftp_action()
        local ftp, f, sent := 0
        local dir := hb_cwd() + 'edi\' + clie_ftp:getField('cnpj') + '\'
        local file, path, credential
        local items := ftp_send.grid_files_to_send.ITEMCOUNT

        ftp_send.progress_bar_ftp.VALUE := 1
        ftp_send.progress_bar_ftp.RANGEMAX := items - 1
        ftp_send.progress_bar_ftp.VISIBLE := true

        path := clie_ftp:getField('ftp_remote_path')
        credential := {'server' => clie_ftp:getField('ftp_server'),;
                       'userId' => clie_ftp:getField('ftp_user'),;
                       'password' => clie_ftp:getField('ftp_password')}

        for f:=1 to items
            ftp_send.progress_bar_ftp.VALUE := f
            ftp_send.grid_files_to_send.VALUE := f
            if ftp_send.grid_files_to_send.CHECKBOXITEM(f)
                file := dir + ftp_send.grid_files_to_send.CellEx(f, 1)
                ftp := TGedFTP():new(file, path, credential)
                if ftp:upload()
                    ftp_send.grid_files_to_send.CellEx(f, 3) := 'OK - Enviados'
                    ftp_send.grid_files_to_send.CHECKBOXITEM(f) := false
                    sent++
                endif
            endif
        next f

        if ! (sent == 0)
            for f:=1 to items
                file := dir + ftp_send.grid_files_to_send.CellEx(f, 1)
                hb_vfMoveFile(file, dir + 'enviados\' + Token(file, '\'))
                ftp_send.grid_files_to_send.DELETEITEM(f)
            next f
        endif

        ftp_send.progress_bar_ftp.VALUE := ftp_send.progress_bar_ftp.RANGEMAX + 1
        status_message('Status: ' + hb_ntos(sent) + iif(sent > 1, ' arquivos enviados', ' arquivo enviado'))
        ftp_send.progress_bar_ftp.VISIBLE := false

return

procedure ftp_send_on_checkbox_clicked()
			/* Posiciona na linha que o CheckBox foi clicada */
			ftp_send.grid_files_to_send.VALUE := This.CellRowClicked
return

procedure ftp_send_button_open_folder_action()
    local path := hb_cwd() + 'edi\'
    if (Type('clie_ftp') == 'O') .and. hb_DirExists(path + clie_ftp:getField('cnpj') + '\')
        path += clie_ftp:getField('cnpj') + '\'
    endif
    EXECUTE FILE 'Explorer' PARAMETERS (path)
return
