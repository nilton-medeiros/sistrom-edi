/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: edi_generate.prg | Trabalha com o Form edi_generate.fmg
 Rotinas: Formulário de Emissão de EDI's
***********************************************************************************/

#include <hmg.ch>
#include <fileio.ch>

declare window edi_generate
declare window search_client
/* TForm1 : Classe personalizada do Form edi_generate

class TForm1
        method setConemb(checked) inline SetProperty('edi_generate', 'checkbox_conemb', checked)
        method setConemb(checked) inline SetProperty('edi_generate', 'checkbox_conemb', checked)

end class */

procedure edi_generate_form()
        private clie_edi as object  // Private para ser usado no form search_client invocado nos eventos do formulário

        if Empty(app:getCompanies('edi_caixa_postal'))
            MsgExclamation({'Caixa Postal Remetente desta empresa não foi informada!', hb_eol(), 'Vá em Sistema/Empresas e altere o cadastro.'}, 'Caixa Postal: ' + app:getCompanies('sigla_cia'))
            return
        endif

        if IsWIndowActive(edi_generate)
            edi_generate.MINIMIZE
            edi_generate.RESTORE
            edi_generate.SETFOCUS
        else
            load window edi_generate
            on key escape of edi_generate action edi_generate.RELEASE
            edi_generate.ACTIVATE
        endif
return

procedure edi_generate_form_on_init()
        edi_generate.button_gerar_edi.ENABLED := false
        edi_generate.button_cancelar.ENABLED := true
return

procedure edi_generate_text_cnpj_on_enter()
        local search := unicode_to_ansi(edi_generate.text_cnpj.VALUE)
        local cnpj := get_numbers(search)
        local sql

        if Empty(search)
            MsgExclamation('Digite o CNPJ ou parte do nome da Razão Social para pesquisar!', 'Pesquisa do Destinatário de EDI')
            return
        endif

        status_message('Pesquisando cliente...')
        edi_generate.button_cancelar.ENABLED := false

        sql := "SELECT "
        sql += "clie_id AS id,"
        sql += "clie_razao_social AS razao_social,"
        sql += "clie_nome_fantasia AS nome_fantasia,"
        sql += "clie_cnpj AS cnpj,"
        sql += "clie_fone1 AS fone1,"    // Esse fone é usado na grid pesquisa em search_client
        sql += "edi_conemb,"
        sql += "edi_notfis,"
        sql += "edi_ocoren,"
        sql += "edi_doccob,"
        sql += "edi_caixa_postal "
        sql += "FROM view_clientes "
        sql += "WHERE clie_ativo=1 AND clie_tipo_documento='CNPJ' AND NOT ISNULL(edi_caixa_postal) AND edi_caixa_postal != '' AND "
        sql += "(edi_conemb=1 OR edi_notfis=1 OR edi_ocoren=1 OR edi_doccob=1) AND "

        if hmg_len(cnpj) == 14
            // Busca pelo CNPJ
            sql += "clie_cnpj='" + cnpj + "';"
        else
            sql += "(clie_razao_social LIKE '%" + search + "%' OR clie_nome_fantasia LIKE '%" + search + "%') LIMIT 300;"
        endif

        if ValType(clie_edi) == 'O'
            clie_edi:destroy()
        endif
        clie_edi := NIL

        clie_edi := TSQLQuery():new(sql)

        if clie_edi:isExecuted

            // setar os campos da query clie_edi para o form
            clie_edi:goTop()
            clie_edi:cargo := 0

            if clie_edi:lastRec() == 0
                MsgExclamation('Cliente não definido para EDI. Informe as opções de EDI em Cadastros/Clientes', 'Pesquisa de Clientes')
            elseif clie_edi:lastRec() == 1
                clie_edi:cargo := 1
            else
                // Mais de um encontrado, abrir grade de escolha
                search_client_form(clie_edi, 'edi_generate', 'datepicker_emissoes_start')
            endif

            edi_generate_set_fields()
            status_message()

        else
            status_message('Não foi possível pesquisar cliente.')
        endif

        edi_generate.button_cancelar.ENABLED := true

return

procedure edi_generate_set_fields()
        local client := false

        if clie_edi:cargo == 0
            edi_generate.text_id.VALUE := 0
            edi_generate.text_razao_social.VALUE := ''
            edi_generate.checkbox_conemb.VALUE := false
            edi_generate.checkbox_notfis.VALUE := false
            edi_generate.checkbox_ocoren.VALUE := false
            edi_generate.checkbox_doccob.VALUE := false
            edi_generate.button_gerar_edi.ENABLED := false
        else
            with object clie_edi
                :goTo(:cargo)
                edi_generate.text_cnpj.VALUE := :getField('cnpj', 'as cnpj')
                edi_generate.text_id.VALUE := :getField('id')
                edi_generate.text_razao_social.VALUE := :getField('razao_social')
                edi_generate.checkbox_conemb.VALUE := :getField('edi_conemb', 'as logical')
                edi_generate.checkbox_notfis.VALUE := :getField('edi_notfis', 'as logical')
                edi_generate.checkbox_ocoren.VALUE := :getField('edi_ocoren', 'as logical')
                edi_generate.checkbox_doccob.VALUE := :getField('edi_doccob', 'as logical')

                if Empty(:getField('edi_caixa_postal'))
                    MsgExclamation({'Caixa Postal Destinatário (este cliente) não foi informada!', hb_eol(), 'Vá em Cadastros/Clientes e altere o cadastro.'}, 'Caixa Postal: ' + hb_ULeft(:getField('razao_social'), 10)+'..')
                elseif (edi_generate.checkbox_conemb.VALUE .or. edi_generate.checkbox_notfis.VALUE .or. edi_generate.checkbox_ocoren.VALUE .or. edi_generate.checkbox_doccob.VALUE)
                    client := true
                else
                    MsgExclamation('Tipo de EDI não selecionado.', 'Selecione um EDI para gerar!')
                endif
            end with

        endif

        edi_generate.button_gerar_edi.ENABLED := client

return


// Ações dos Botões E controlers ******************************************************************************************************************

procedure edi_generate_button_open_folder_action()
        local path := hb_cwd() + 'edi\'
        if (Type('clie_edi') == 'O') .and. hb_DirExists(path + clie_edi:getField('cnpj') + '\')
            path += clie_edi:getField('cnpj') + '\'
        endif
        EXECUTE FILE 'Explorer' PARAMETERS (path)
return

procedure edi_generate_datepicker_emissoes_on_change()
    if edi_generate.datepicker_emissoes_start.VALUE > Date()
        edi_generate.datepicker_emissoes_start.VALUE := Date()
    endif
    if edi_generate.datepicker_emissoes_end.VALUE > Date()
        edi_generate.datepicker_emissoes_end.VALUE := Date()
    endif
    if edi_generate.datepicker_emissoes_start.VALUE > edi_generate.datepicker_emissoes_end.VALUE
        edi_generate.datepicker_emissoes_end.VALUE := edi_generate.datepicker_emissoes_start.VALUE
    endif
return

procedure edi_generate_datepicker_fatura_on_change()
    if edi_generate.datepicker_fatura_start.VALUE > Date()
        edi_generate.datepicker_fatura_start.VALUE := Date()
    endif
    if edi_generate.datepicker_fatura_end.VALUE > Date()
        edi_generate.datepicker_fatura_end.VALUE := Date()
    endif
    if edi_generate.datepicker_fatura_start.VALUE > edi_generate.datepicker_fatura_end.VALUE
        edi_generate.datepicker_fatura_end.VALUE := edi_generate.datepicker_fatura_start.VALUE
    endif
return

procedure edi_generate_button_gerar_edi_action()
        local cab, cte_files, not_files, oco_files, doc_files, msg := ''
        local edi_date
        local edi_time := hb_ULeft(StrTran(Time(), ':'), 4)

        /*
        Explorar as formas de data com a função hb_dtoc(date, format)
        ? hb_datetime()
    	? hb_dtoc(hb_datetime(), 'yyyy.mm.dd')
        */
/*
 *      SET CENTURY OFF
 *      edi_date := get_numbers(DtoC(Date()))
 *      SET CENTURY ON
*/

        edi_date := hb_DToC(Date(), 'DDMMYY')
        // REGISTRO: UNB - CABEÇALHO DE INTERCÂMBIO (PADRÃO PARA OS 4 EDI's)
        cab := '000'
        cab += hb_UPadR(app:getCompanies('edi_caixa_postal'), 35)
        cab += hb_UPadR(clie_edi:getField('edi_caixa_postal'), 35)

        cab += edi_date
        cab += edi_time

        edi_date := hb_ULeft(edi_date, 4)

        //hb_cdpSelect('PT850')

        if edi_generate.checkbox_conemb.VALUE
            cte_files := edi_generate_conemb(cab, edi_date)
            msg := 'CONEMB: (' + hb_ntos(hmg_len(cte_files)) + ') '
            if ! (hmg_len(cte_files) == 0)
                AEval(cte_files, {|f| msg += f + hb_eol() + Space(15)})
            endif
        endif
        if edi_generate.checkbox_notfis.VALUE
            not_files := edi_generate_notfis(cab, edi_date, edi_time)
            msg := RTrim(msg)
            msg += 'NOTFIS: (' + hb_ntos(hmg_len(not_files)) + ') '
            AEval(not_files, {|f| msg += f + hb_eol() + Space(15)})
        endif
        if edi_generate.checkbox_ocoren.VALUE
            oco_files := edi_generate_ocoren(cab, edi_date, edi_time)
            msg := RTrim(msg)
            msg += 'OCOREN: (' + hb_ntos(hmg_len(oco_files)) + ') '
            AEval(oco_files, {|f| msg += f + hb_eol() + Space(15)})
        endif
        if edi_generate.checkbox_doccob.VALUE
            doc_files := edi_generate_doccob(cab, edi_date, edi_time)
            msg := RTrim(msg)
            msg += 'DOCCOB: (' + hb_ntos(hmg_len(doc_files)) + ') '
            AEval(doc_files, {|f| msg += f + hb_eol() + Space(15)})
        endif

        //hb_cdpSelect('UTF8')

        if Empty(cte_files) .and. Empty(not_files) .and. Empty(oco_files) .and. Empty(doc_files)
            status_message('Nenhum arquivo foi gerado')
            MsgInfo('Nenhum arquivo foi gerado', 'Não há emissão ou faturamento nesse período')
        else
            status_message("EDI's gerados com sucesso")
            MsgInfo({msg, hb_eol()+hb_eol(), 'ARQUIVOS PRONTOS P/ ENVIO POR FTP'}, "Arquivos de EDI's Gerados")
        endif

        edi_generate.text_cnpj.SETFOCUS

return

function edi_generate_conemb(cab, edi_date)
        local saved_files := {}
        local handle, conemb_file
        local ctes, nfes, chave
        local row, sql
        local c, n
        local qtde_320 := qtde_322 := qtde_cte := valor_cte := 0
        loca break := false

        ctes := conemb_select_ctes()

        if ! ctes:isExecuted
            return {}
        endif

        if ctes:lastRec() == 0
            MsgExclamation('Não foi encontrado Conhecimentos Emitidos ou Autorizados nesse período.', 'Conhecimentos não encontrados!')
            return {}
        endif

        edi_generate.progress_bar_edi.VALUE := 1
        edi_generate.progress_bar_edi.RANGEMAX := ctes:lastRec() - 1
        edi_generate.progress_bar_edi.VISIBLE := true

        conemb_file := get_edi_filename('CONE')
        handle := hb_FCreate(conemb_file, FC_NORMAL)

        conemb_000(handle, cab, edi_date)
        conemb_320_e_321(handle, edi_date)
        qtde_320++

        ctes:goTop()

        for c:=1 to ctes:lastRec()

            edi_generate.progress_bar_edi.VALUE := ctes:recNo()
            status_message('Status: Gerando CONEMB - CTe id# ' + ctes:getField('id', 'as string'))

            qtde_cte++
            valor_cte += ctes:getField('valor_total')

            sql := "SELECT cte_doc_serie AS serie,"
            sql += "cte_doc_numero AS numero "
            sql += "FROM ctes_documentos "
            sql += "WHERE cte_id=" + ctes:getField('id', 'as string')
            sql += " ORDER BY cte_doc_serie, cte_doc_numero"

            nfes := TSQLQuery():new(sql)
            row := ''

            if nfes:isExecuted()

                nfes:goTop()

                if nfes:eof()
                    conemb_322(handle, ctes:getRow())
                    qtde_322++
                    for n:=1 to 40
                        row += Space(3)
                        row += '00000000'
                    next
                    FWrite(handle, row)
                    conemb_rodape_322(handle, 'U', ctes:getRow())
                else

                    do while ! nfes:eof()

                        conemb_322(handle, ctes:getRow())
                        qtde_322++
                        row := ''

                        for n:=1 to 40
                            if nfes:eof()
                                row += Space(3)
                                row += '00000000'
                            else
                                row += nfes:zeroFill('serie', 3)
                                row += nfes:zeroFill('numero', 8)
                                nfes:skip()
                            endif
                        next n

                        FWrite(handle, row)

                        if nfes:lastRec() > 40
                            conemb_rodape_322(handle, 'C', ctes:getRow())
                            if qtde_322 > 1000
                                if qtde_320 > 200

                                    // Atingiu qtde máxima de 200 '320' por '000'. Fecha arquivo atual e abre um novo arquivo sequencial de continuação
                                    conemb_323(handle, qtde_cte, valor_cte)
                                    FClose(handle)
                                    AAdd(saved_files, conemb_file)

                                    conemb_file := get_edi_filename('CONE')
                                    handle := hb_FCreate(conemb_file, FC_NORMAL)
                                    qtde_320 := qtde_322 := qtde_cte := valor_cte := 0

                                    conemb_000(handle, cab, edi_date)

                                endif
                                conemb_320_e_321(handle, edi_date)
                                qtde_320++
                                qtde_322 := 0
                            endif
                        else
                            conemb_rodape_322(handle, 'U', ctes:getRow())
                        endif

                    enddo

                endif

            else
                break := true
                exit
            endif

            ctes:skip()

        next c

        edi_generate.progress_bar_edi.VALUE := edi_generate.progress_bar_edi.RANGEMAX + 1

        if break
            MsgExclamation('Erro ao consultar arquivos de notas fiscais.', 'EDI CONEMB-ABORTADO')
        else
            conemb_323(handle, qtde_cte, valor_cte)
            AAdd(saved_files, conemb_file)
        endif
        FClose(handle)

return AClone(saved_files)

procedure conemb_000(h, cab, edi_date)
    // UNB - CTE CABEÇALHO DE INTERCÂMBIO
    row := cab
    row += 'CON' + edi_date
    row += hb_ULeft(StrTran(Time(), ':'), 4) + hb_URight(Time(), 1)
    row += Space(631)   // Filler
    row += hb_eol()
    FWrite(h, row)
return

procedure conemb_320_e_321(h, date)
        local row
        // UNH - CABEÇALHO DE DOCUMENTO
        row := '320'
        row += 'CONHE' + date
        row += hb_ULeft(StrTran(Time(), ':'), 4) + hb_URight(Time(), 1)
        row += Space(709)   // Filler
        row += hb_eol()

        // TRA - DADOS DA TRANSPORTADORA
        row += "321"
        row += app:getCompanies('cnpj')
        row += hb_UPadR(app:getCompanies('razao_social'), 40)
        row += Space(669)   // Filler
        row += hb_eol()
        FWrite(h, row)
return

procedure conemb_322(h, cte)
            local row
            // CEM - CONHECIMENTOS EMBARCADOS
            row := '322'
            row += hb_UPadR(hb_ULeft(app:getCompanies('razao_social'), 6) + ' ' + app:getCompanies('sigla_cia'), 10)
            row += cte:zeroFill('serie', 5)
            row += cte:zeroFill('numero', 12)
            row += date_to_edi(cte:getField('data_emissao'))
            row += cte:getField('forma_pgto')
            row += number_to_edi(cte:getField('peso_bc'), 7, 2)
            row += number_to_edi(cte:getField('valor_total'), 15, 2)
            row += number_to_edi(cte:getField('valor_bc'), 15, 2)
            row += number_to_edi(cte:getField('aliquota_icms'), 4, 2)
            row += number_to_edi(cte:getField('valor_icms'), 15, 2)
            row += number_to_edi(cte:getField('tarifa_por_kg'), 15, 2)
            row += number_to_edi(cte:getField('frete_peso'), 15, 2)  // seguro
            row += number_to_edi(cte:getField('sec_cat'), 15, 2)
            row += '000000000000000' // valor adicional
            row += '000000000000000' // despacho
            row += number_to_edi(cte:getField('pedagio'), 15, 2)
            row += number_to_edi(cte:getField('valor_outros'), 15, 2)
            row += '2'  // Substituição tributária: 1 - Sim, 2 - Não
            row += Space(3) // Filler
            row += get_numbers(app:getCompanies('cnpj'))
            row += clie_edi:getField('cnpj')    // cnpj embarcadora
            FWrite(h, row)
return

procedure conemb_rodape_322(h, ic, oRow)
        row := 'I'      // Ação: Incluir, Excluir, Complementar
        row += 'N'      // Tipo de Conhecimento: Normal
        row += ic       // Indicador de Continuidade
        row += oRow:padRight('cfop', 5)
        row += hb_UPadL(AllTrim(hb_URight(app:getCompanies('cte_modelo'),2)), 2, '0')      // Modelo do Conhecimento

        if app:getCompanies('tipo_emitente') == 'CTE' .and. app:getCompanies('cte_modelo') == '57'
            row += oRow:getField('cte_chave')
        else
            row += Space(44)
        endif

        row += hb_eol()
        FWrite(h, row)
return

procedure conemb_323(h, qtde_cte, valor_cte)
        local row
        row := '323'  // 1 para cada '320'
        row += hb_UPadL(qtde_cte, 4, '0')
        row += number_to_edi(valor_cte, 15, 2)
        row += Space(704)   // Filler
        FWrite(h, row)
return

function edi_generate_notfis()
    MsgInfo('Módulo em desenvolvimento...')
return AClone({})

function edi_generate_ocoren(cab, edi_date, edi_time)
        local handle, ocoren_file
        local sql, ocor, o

        sql := "SELECT t1.cte_id,"
        sql += "t2.cte_doc_serie AS nfe_serie,"
        sql += "t2.cte_doc_numero AS nfe_numero,"
        sql += "cast(t3.cte_ocor_quando as date) AS ocorrencia_data,"
        sql += "cast(t3.cte_ocor_quando as time) AS ocorrencia_hora,"
        sql += "t3.cte_ocor_nota AS ocor_nota,"
        sql += "t4.ocor_codigo,"
        sql += "t4.ocor_caracteristica "
        sql += "FROM view_ctes t1 "
        sql += "JOIN ctes_documentos t2 ON t2.cte_id=t1.cte_id "
        sql += "LEFT JOIN ctes_ocorrencias t3 ON t3.cte_id=t1.cte_id "
        sql += "LEFT JOIN ocorrencias t4 ON t4.ocor_id = t3.ocor_id "
        sql += "WHERE t1.emp_id=" + app:getCompanies('id', 'as string') + " AND "

        if app:getCompanies('tipo_emitente') == 'CTE'
            sql += "t1.cte_situacao='AUTORIZADO' AND "
        else
            sql += "t1.cte_situacao='ME EMITIDA' AND "
        endif

        sql += "t4.ocor_codigo < 100 AND "
        sql += "t1.clie_tomador_id=" + clie_edi:getField('id', 'as string') + " AND "

        if edi_generate.datepicker_emissoes_start.VALUE == edi_generate.datepicker_emissoes_end.VALUE
            sql += "t3.cte_ocor_quando = " + datetime_hb_to_mysql(edi_generate.datepicker_emissoes_start.VALUE)
        else
            sql += "t3.cte_ocor_quando BETWEEN " + datetime_hb_to_mysql(edi_generate.datepicker_emissoes_start.VALUE) + " AND " + datetime_hb_to_mysql(edi_generate.datepicker_emissoes_end.VALUE)
        endif

        sql += "ORDER BY cte_ocor_quando, cte_doc_serie, cte_doc_numero"
        // Debug - Apagar no deploy
        //System.Clipboard := sql

        ocor := TSQLQuery():new(sql)

        if ! ocor:isExecuted
            return {}
        endif

        if ocor:lastRec() == 0
            MsgExclamation('Não foi encontrado Ocorrências de Conhecimentos Emitidos ou Autorizados nesse período.', 'Ocorrências não encontradas!')
            return {}
        endif

        edi_generate.progress_bar_edi.VALUE := 1
        edi_generate.progress_bar_edi.RANGEMAX := ocor:lastRec() - 1
        edi_generate.progress_bar_edi.VISIBLE := true

        ocoren_file := get_edi_filename('OCOR')
        handle := hb_FCreate(ocoren_file, FC_NORMAL)

        // UNB - CABEÇALHO DE INTERCÂMBIO
        cab += 'OCO' + edi_date
        cab += edi_time
        cab += Space(25)   // Filler
        cab += hb_eol()

        // UNH - CABEÇALHO DE DOCUMENTO
        cab += '340'
        cab += 'OCORR' + edi_date
        cab += edi_time
        cab += Space(103)   // Filler
        cab += hb_eol()

        // TRA - DADOS DA TRANSPORTADORA
        cab += "341"
        cab += app:getCompanies('cnpj')
        cab += hb_UPadR(app:getCompanies('razao_social'), 40)
        cab += Space(63)   // Filler
        cab += hb_eol()
        FWrite(handle, cab)

        with object ocor

            :goTop()

            for o:=1 to :lastRec()

                edi_generate.progress_bar_edi.VALUE := :recNo()
                status_message('Status: Gerando OCOREN - CTe id# ' + :getField('cte_id', 'as string'))

                // OEN - OCORRÊNCIA NA ENTREGA
                cab := '342'
                cab += clie_edi:getField('cnpj')
                cab += :zeroFill('nfe_serie', 3)
                cab += :zeroFill('nfe_numero', 8)
                cab += :zeroFill('ocor_codigo', 2)
                cab += date_to_edi(:getField('ocorrencia_data'))
                cab += hb_ULeft(get_numbers(:getField('ocorrencia_hora')), 4)

                if :zeroFill('ocor_codigo', 2) == '00' .or. :getField('ocor_caracteristica') == 'ENTREGA'
                    cab += "03"
                else
                    cab += "01"
                endif

                cab += :padRight('ocor_nota', 70)
                cab += Space(6)
                cab += hb_eol()
                FWrite(handle, cab)
                :skip()

            next o

            status_message('Gerado ' + hb_ntos(:lastRec()) + " Ocorrências")

        end with

        FClose(handle)

        edi_generate.progress_bar_edi.VALUE := edi_generate.progress_bar_edi.RANGEMAX + 1

return AClone({ocoren_file})


function edi_generate_doccob(cab, edi_date, edi_time)
        local handle, doccob_file
        local sql, cob, ctes
        local j, k, n
        local qtde_doccob := 0
        local vtot_doccob := 0

        sql := "SELECT t1.id,"
        sql += "t1.doc_fatura,"
        sql += "DATE(t1.emitido_em) AS emitido_em,"
        sql += "t1.valor_original,"
        sql += "t1.vence_em,"
        sql += "t1.valor_multa + t1.valor_juros + t1.valor_acrescimo AS valor_juros,"
        sql += "t1.valor_desconto + t1.valor_abatimento AS valor_desconto,"
        sql += "t2.banco,"
        sql += "t2.agencia,"
        sql += "t2.digito_ver_agencia AS digito_verificador_agencia,"
        sql += "t2.conta_corrente,"
        sql += "t2.digito_ver_conta_corrente AS digito_verificador_cc "
        sql += "FROM contas_receber t1 "
        sql += "LEFT JOIN bancos t2 ON t2.id = t1.bco_id "
        sql += "WHERE t1.clie_id=" +  clie_edi:getField('id', 'as string') + " AND "
        sql += "t1.situacao = 'EM COBRANCA' AND "
        if edi_generate.datepicker_fatura_start.VALUE == edi_generate.datepicker_fatura_end.VALUE
            sql += "t1.emitido_em = " + datetime_hb_to_mysql(edi_generate.datepicker_fatura_start.VALUE) + " "
        else
            sql += "t1.emitido_em BETWEEN " + datetime_hb_to_mysql(edi_generate.datepicker_fatura_start.VALUE) + " AND " + datetime_hb_to_mysql(edi_generate.datepicker_fatura_end.VALUE) + " "
        endif

        sql += "ORDER BY t1.emitido_em, t1.doc_fatura"

        cob := TSQLQuery():new(sql)

        if ! cob:isExecuted
            return {}
        endif

        if cob:lastRec() == 0
            MsgExclamation('Não foi encontrado Cobrança no Contas à Receber nesse período.', 'Cobranças não encontradas!')
            return {}
        endif

        edi_generate.progress_bar_edi.VALUE := 1
        edi_generate.progress_bar_edi.RANGEMAX := cob:lastRec() - 1
        edi_generate.progress_bar_edi.VISIBLE := true

        doccob_file := get_edi_filename('DOCC')
        handle := hb_FCreate(doccob_file, FC_NORMAL)

        // UNB - CABEÇALHO DE INTERCÂMBIO
        cab += 'COB' + edi_date
        cab += edi_time
        cab += Space(75)   // Filler
        cab += hb_eol()

        // UNH - CABEÇALHO DE DOCUMENTO
        cab += '350'
        cab += 'COBRA' + edi_date
        cab += edi_time
        cab += Space(153)   // Filler
        cab += hb_eol()

        // TRA - DADOS DA TRANSPORTADORA
        cab += "351"
        cab += app:getCompanies('cnpj')
        cab += hb_UPadR(app:getCompanies('razao_social'), 40)
        cab += Space(113)   // Filler
        cab += hb_eol()
        FWrite(handle, cab)

        with object cob

            :goTop()

            for j:=1 to :lastRec()

                edi_generate.progress_bar_edi.VALUE := :recNo()
                status_message('Status: Gerando DOCCOB - Fatura id# ' + :getField('id', 'as string'))

                qtde_doccob++
                vtot_doccob += :getField('valor_original')

                // DCO - DOCUMENTO DE COBRANÇA
                cab := '352'
                cab += hb_UPadR('MATRIZ ' + app:getCompanies('sigla_cia'), 10)
                cab += '0'
                cab += 'UNI'
                cab += :zeroFill('doc_fatura', 10)
                cab += hb_DToC(:getField('emitido_em'), 'DDMMYYYY')
                cab += hb_DToC(:getField('vence_em'), 'DDMMYYYY')
                cab += number_to_edi(:getField('valor_original'), 15, 2)
                cab += 'COB'
                cab += '000000000000000' // valor icms fatura
                cab += number_to_edi(:getField('valor_juros'), 15, 2)
                cab += hb_DToC(:getField('vence_em'), 'DDMMYYYY')
                cab += number_to_edi(:getField('valor_desconto'), 15, 2)
                cab += :padRight('banco', 35)
                cab += :zeroFill('agencia', 4)
                cab += :padLeft('digito_verificador_agencia', 1)
                cab += :zeroFill('conta_corrente', 10)
                cab += :padRight('digito_verificador_cc', 2)
                cab += 'I'
                cab += Space(3)     // Filler
                cab += hb_eol()
                FWrite(handle, cab)

                ctes := doccob_select_ctes(:getField('id', 'as string'))

                if ctes:isExecuted

                    with object ctes

                        :goTop()

                        for k:=1 to :lastRec()

                            // CCO - CONHECIMENTOS EM COBRANÇA
                            cab := '353'
                            cab += hb_UPadR('MATRIZ ' + app:getCompanies('sigla_cia'), 10)
                            cab += :zeroFill('serie', 5)
                            cab += :zeroFill('numero', 12)
                            cab += number_to_edi(:getField('valor_frete'), 15, 2)
                            cab += hb_DToC(:getField('data_emissao'), 'DDMMYYYY')
                            cab += :getField('rem_cnpj')
                            cab += :getField('des_cnpj')
                            cab += app:getCompanies('cnpj')
                            cab += Space(75)
                            cab += hb_eol()
                            FWrite(handle, cab)

                            nfes := doccob_select_nfes(:getField('id', 'as string'))

                            if nfes:isExecuted
                                with object nfes
                                    :goTop()
                                    for n:=1 to :lastRec()
                                        // CNF - NOTAS FISCAIS EM COBRANÇA NO CONHECIMENTO
                                        cab := '354'
                                        cab += :zeroFill('serie', 3)
                                        cab += :zeroFill('numero', 8)
                                        cab += hb_DToC(:getField('data_emissao'), 'DDMMYYYY')
                                        cab += number_to_edi(:getField('peso'), 7, 2)
                                        cab += number_to_edi(:getField('valor'), 15, 2)
                                        cab += clie_edi:getField('cnpj')
                                        cab += Space(112)
                                        cab += hb_eol()
                                        FWrite(handle, cab)
                                        :skip()
                                    next n
                                end with
                            endif

                            :skip()

                        next k

                    end with

                endif


                :skip()

            next j

        end with

        // TDC - TOTAL DE DOCUMENTOS DE COBRANÇA
        cab := '355'
        cab += StrZero(qtde_doccob, 4)
        cab += number_to_edi(vtot_doccob, 15, 2)
        cab += Space(148)
        cab += hb_eol()
        FWrite(handle, cab)
        FClose(handle)

        edi_generate.progress_bar_edi.VALUE := edi_generate.progress_bar_edi.RANGEMAX + 1

return AClone({doccob_file})

/* Funções auxiliares aos EDI's **********************************************************************/

function get_edi_filename(prefix)
        local name
        local dir := 'edi\' + clie_edi:getField('cnpj') + '\'
        local account := 1

        if ! hb_DirExists(dir)
            hb_DirBuild(dir)
        endif

        name := prefix + hb_DToC(Date(), 'MMDD') + '_001.txt'

        do while hb_FileExists(dir + name)
            account++
            if account > 999
                account := 1
                name := hb_ULeft(name, hb_At('_', name)) + '*.txt'
                hb_FileDelete(dir + name)
            endif
            name := hb_ULeft(name, hb_At('_', name)) + hb_UPadL(account, 3, '0') + '.txt'
        enddo

return (dir + name)

function conemb_select_ctes()
        local sql
        sql := "SELECT cte_id AS id, "
        sql += "cte_serie AS serie,"
        sql += "cte_numero AS numero,"
        sql += "DATE(cte_data_hora_emissao) AS data_emissao,"
        sql += "IF(cte_forma_pgto, 'F', 'C') AS forma_pgto,"
        sql += "cte_peso_bc AS peso_bc,"
        sql += "cte_valor_total AS valor_total,"
        sql += "cte_valor_bc AS valor_bc,"
        sql += "cte_aliquota_icms AS aliquota_icms,"
        sql += "cte_valor_icms AS valor_icms,"
        sql += "IFNULL(cte_cfop, 0) AS cfop, "
        sql += "cte_chave,"
        sql += "IFNULL((SELECT SUM(ccc_valor_tarifa_kg) FROM ctes_comp_calculo AS t2 WHERE t2.cte_id=t1.cte_id AND t2.cc_id=2), 0) AS tarifa_por_kg,"
        sql += "IFNULL((SELECT SUM(ccc_valor) FROM ctes_comp_calculo AS t3 WHERE t3.cte_id=t1.cte_id AND t3.cc_id=15), 0) AS frete_peso,"
        sql += "IFNULL((SELECT SUM(ccc_valor) FROM ctes_comp_calculo AS t4 WHERE t4.cte_id=t1.cte_id AND t4.cc_id IN (6,8)), 0) AS sec_cat,"
        sql += "IFNULL((SELECT SUM(ccc_valor) FROM ctes_comp_calculo AS t5 WHERE t5.cte_id=t1.cte_id AND t5.cc_id IN (14,22)), 0) AS despacho,"
        sql += "IFNULL((SELECT SUM(ccc_valor) FROM ctes_comp_calculo AS t6 WHERE t6.cte_id=t1.cte_id AND t6.cc_id=9), 0) AS pedagio,"
        sql += "IFNULL((SELECT SUM(ccc_valor) FROM ctes_comp_calculo AS t7 WHERE t7.cte_id=t1.cte_id AND t7.cc_id IN (5,7,10,13)), 0) AS valor_outros "
        sql += "FROM view_ctes t1 "
        sql += "WHERE emp_id=" + app:getCompanies('id', 'as string') + " AND "

        if app:getCompanies('tipo_emitente') == 'CTE'
            sql += "cte_situacao='AUTORIZADO' AND "
        else
            sql += "cte_situacao='ME EMITIDA' AND "
        endif

        sql += "clie_tomador_id=" + clie_edi:getField('id', 'as string') + " AND "

        if edi_generate.datepicker_emissoes_start.VALUE == edi_generate.datepicker_emissoes_end.VALUE
            sql += "DATE(cte_data_hora_emissao) = " + datetime_hb_to_mysql(edi_generate.datepicker_emissoes_start.VALUE)
        else
            sql += "DATE(cte_data_hora_emissao) BETWEEN " + datetime_hb_to_mysql(edi_generate.datepicker_emissoes_start.VALUE) + " AND " + datetime_hb_to_mysql(edi_generate.datepicker_emissoes_end.VALUE)
        endif

        sql += " ORDER BY cte_data_hora_emissao, cte_numero"

return TSQLQuery():new(sql)

function doccob_select_ctes(rec_id)
        local sql := "SELECT t2.cte_id AS id, "
              sql += "t2.cte_serie AS serie,"
              sql += "t2.cte_numero AS numero,"
              sql += "t2.cte_valor_total AS valor_frete,"
              sql += "DATE(t2.cte_data_hora_emissao) AS data_emissao,"
              sql += "t3.clie_cnpj AS rem_cnpj,"
              sql += "t4.clie_cnpj AS des_cnpj "
              sql += "FROM ctes_faturados t1 "
              sql += "JOIN ctes t2 ON t2.cte_id = t1.cte_id "
              sql += "JOIN clientes t3 ON t3.clie_id = t2.clie_remetente_id "
              sql += "JOIN clientes t4 ON t4.clie_id = t2.clie_destinatario_id "
              sql += "WHERE t1.cta_rec_id=" + rec_id + " "
              sql += "ORDER BY t2.cte_data_hora_emissao, t2.cte_numero"
              saveLog(sql)
return TSQLQuery():new(sql)

function doccob_select_nfes(cte_id)
        local sql := "SELECT cte_doc_serie AS serie,"
              sql += "cte_doc_numero AS numero,"
              sql += "cte_doc_data_emissao AS data_emissao,"
              sql += "cte_doc_peso_total AS peso,"
              sql += "cte_doc_valor_nota AS valor "
              sql += "FROM ctes_documentos WHERE cte_id=" + cte_id
              saveLog(sql)
return TSQLQuery():new(sql)