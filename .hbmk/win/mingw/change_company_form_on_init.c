/*
 * Harbour 3.2.0dev (r1703241902)
 * MinGW GNU C 5.3 (32-bit)
 * Generated C source from "C:\Users\nilto\OneDrive\Desenvolvimento\Projetos\harbour\apoio_tms\sistrom-edi\change_company_form_on_init.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( CHANGE_COMPANY_FORM_ON_INIT );
HB_FUNC_EXTERN( ERRORSYS );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_CHANGE_COMPANY_FORM_ON_INIT )
{ "CHANGE_COMPANY_FORM_ON_INIT", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( CHANGE_COMPANY_FORM_ON_INIT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_CHANGE_COMPANY_FORM_ON_INIT, "C:\\Users\\nilto\\OneDrive\\Desenvolvimento\\Projetos\\harbour\\apoio_tms\\sistrom-edi\\change_company_form_on_init.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_CHANGE_COMPANY_FORM_ON_INIT
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_CHANGE_COMPANY_FORM_ON_INIT )
   #include "hbiniseg.h"
#endif

HB_FUNC( CHANGE_COMPANY_FORM_ON_INIT )
{
	static const HB_BYTE pcode[] =
	{
		36,8,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

