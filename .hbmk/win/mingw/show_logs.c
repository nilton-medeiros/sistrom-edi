/*
 * Harbour 3.2.0dev (r1703241902)
 * MinGW GNU C 5.3 (32-bit)
 * Generated C source from "C:\Users\nilto\OneDrive\Desenvolvimento\Projetos\harbour\apoio_tms\sistrom-edi\routines\show_logs.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( OPEN_LOG_FOLDER );
HB_FUNC_EXTERN( HB_CWD );
HB_FUNC_EXTERN( SAVELOG );
HB_FUNC_EXTERN( _EXECUTE );
HB_FUNC_EXTERN( GETACTIVEWINDOW );
HB_FUNC_EXTERN( ERRORSYS );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_SHOW_LOGS )
{ "OPEN_LOG_FOLDER", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( OPEN_LOG_FOLDER )}, NULL },
{ "HB_CWD", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_CWD )}, NULL },
{ "SAVELOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( SAVELOG )}, NULL },
{ "_EXECUTE", {HB_FS_PUBLIC}, {HB_FUNCNAME( _EXECUTE )}, NULL },
{ "GETACTIVEWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETACTIVEWINDOW )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_SHOW_LOGS, "C:\\Users\\nilto\\OneDrive\\Desenvolvimento\\Projetos\\harbour\\apoio_tms\\sistrom-edi\\routines\\show_logs.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_SHOW_LOGS
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_SHOW_LOGS )
   #include "hbiniseg.h"
#endif

HB_FUNC( OPEN_LOG_FOLDER )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,13,0,176,1,0,12,0,106,5,108,
		111,103,92,0,72,80,1,36,14,0,176,2,0,106,
		23,65,99,101,115,115,111,32,97,32,112,97,115,116,
		97,32,100,101,32,76,111,103,115,0,20,1,36,15,
		0,176,3,0,176,4,0,12,0,100,106,9,69,120,
		112,108,111,114,101,114,0,95,1,100,92,5,20,6,
		36,16,0,7
	};

	hb_vmExecute( pcode, symbols );
}

