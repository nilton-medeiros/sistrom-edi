/**********************************************************************************
 Programa: SistromEDI - Sistema de EDI (Electronic Data Interchange) padrão PROCEDA
 By Nilton Gonçalves Medeiros - 11-Nov-2021
 Todos os direitos reservados: SISTROM SITEMAS WEB LTDA

 Arquivo: change_company.prg
 Rotinas: Faz a troca de empresas e filiais para se trabalhar
***********************************************************************************/

#include <hmg.ch>

declare window change_company
declare window Main

procedure change_company()

			if (app:lenCompanies() > 1)

				if IsWIndowActive(change_company)
					change_company.MINIMIZE
					change_company.RESTORE
					change_company.SETFOCUS
				else
					load window change_company
					on key escape of change_company action change_company.RELEASE
					change_company.ACTIVATE
				endif

			endif

return

procedure change_company_form_on_init()
			local nCol := Main.WIDTH //- change_company.WIDTH ** o form change_company não está ativo/definido ainda aqui
			local oRow

			nCol -= change_company.WIDTH    // Aqui já está definido/ativo o form
			change_company.ROW := 90
			change_company.COL := nCol - 10
			change_company.grid_change_company.DELETEALLITEMS

			for each oRow in app:companies
				ADD ITEM {oRow:getField('sigla_cia') + ' - ' + oRow:getField('nome_fantasia')} TO grid_change_company OF change_company
			next each

return

procedure grid_change_company_on_dblclick()
			app:setCompanies(This.CellRowIndex)
			RegistryWrite(app:pathUser + 'lastCompany', This.CellRowIndex)
			change_company.RELEASE
return
