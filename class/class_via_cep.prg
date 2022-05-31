#include <hmg.ch>
#include "hbclass.ch"

CLASS TViaCEP
	VAR cCEP         INIT ''
	VAR cIBGE        INIT ''
	VAR cLogradouro  INIT ''
	VAR cComplemento INIT ''
	VAR cBairro      INIT ''
	VAR cLocalidade  INIT ''
	VAR cUF          INIT ''
	VAR aCEP         INIT {}
	METHOD New(cSeekCEP) CONSTRUCTOR
END CLASS

METHOD New(cSeekCEP) CLASS TViaCEP
	 LOCAL oHttp := TIPClientHTTP():new("http://viacep.com.br/ws/" + cSeekCEP + "/json/")
	 LOCAL ahResult
	 LOCAL cHtml

	 IF ! oHttp:Open()
		 RETURN NIL
	 ENDIF

	 cHtml := oHttp:ReadAll()
	 oHttp:Close()
	 hb_JSonDecode(cHtml, @ahResult)

	 IF ValType(ahResult) == "H"
		::cCEP         := ahResult['cep']
		::cLogradouro  := ahResult['logradouro']
		::cComplemento := ahResult['complemento']
		::cBairro      := ahResult['bairro']
		::cLocalidade  := ahResult['localidade']
		::cUF          := ahResult['uf']
		::cIBGE        := ahResult['ibge']
		::aCEP         := {}
	 ELSEIF !(ValType(ahResult) == "A") .OR. Empty(ahResult)
		RETURN NIL
	 ELSEIF hmg_len(ahResult) > 1
		::cCEP         := ''
		::cLogradouro  := ''
		::cComplemento := ''
		::cBairro      := ''
		::cLocalidade  := ''
		::cUF          := ''
		::cIBGE        := ''
		::aCEP := ahResult
	 ELSE
		::cCEP         := ahResult[1,'cep']
		::cLogradouro  := ahResult[1,'logradouro']
		::cComplemento := ahResult[1,'complemento']
		::cBairro      := ahResult[1,'bairro']
		::cLocalidade  := ahResult[1,'localidade']
		::cUF          := ahResult[1,'uf']
		::cIBGE        := ahResult[1,'ibge']
		::aCEP         := {}
	 ENDIF

RETURN Self