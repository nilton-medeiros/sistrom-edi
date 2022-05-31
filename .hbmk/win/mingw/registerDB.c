/*
 * Harbour 3.2.0dev (r1703241902)
 * MinGW GNU C 5.3 (32-bit)
 * Generated C source from "C:\Users\nilto\OneDrive\Desenvolvimento\Projetos\harbour\apoio_tms\sistrom-edi\app\registerDB.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( REGISTERDB_BUTTONSAVEACTION );
HB_FUNC_EXTERN( GETPROPERTY );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC( IPARRAYTOSTRING );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( TMYSQL );
HB_FUNC_EXTERN( DOMETHOD );
HB_FUNC_EXTERN( MSGEXCLAMATION );
HB_FUNC_EXTERN( HB_EOL );
HB_FUNC_EXTERN( LTRIM );
HB_FUNC_EXTERN( STR );
HB_FUNC( REGISTERDB_ESCAPE );
HB_FUNC_EXTERN( TURNOFF );
HB_FUNC_EXTERN( ERRORSYS );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_REGISTERDB )
{ "REGISTERDB_BUTTONSAVEACTION", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( REGISTERDB_BUTTONSAVEACTION )}, NULL },
{ "GETPROPERTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETPROPERTY )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "IPARRAYTOSTRING", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( IPARRAYTOSTRING )}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "_MYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APP", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TMYSQL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TMYSQL )}, NULL },
{ "SETDB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CONNECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MYSQL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DOMETHOD", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOMETHOD )}, NULL },
{ "MSGEXCLAMATION", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGEXCLAMATION )}, NULL },
{ "USERNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_EOL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_EOL )}, NULL },
{ "LTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( LTRIM )}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "REGISTERDB_ESCAPE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( REGISTERDB_ESCAPE )}, NULL },
{ "TURNOFF", {HB_FS_PUBLIC}, {HB_FUNCNAME( TURNOFF )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_REGISTERDB, "C:\\Users\\nilto\\OneDrive\\Desenvolvimento\\Projetos\\harbour\\apoio_tms\\sistrom-edi\\app\\registerDB.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_REGISTERDB
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_REGISTERDB )
   #include "hbiniseg.h"
#endif

HB_FUNC( REGISTERDB_BUTTONSAVEACTION )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,5,0,176,1,0,106,11,82,101,103,
		105,115,116,101,114,68,66,0,106,15,73,112,65,100,
		100,114,101,115,115,95,104,111,115,116,0,106,6,86,
		97,108,117,101,0,12,3,80,2,36,9,0,95,2,
		122,1,121,8,32,151,2,176,2,0,176,1,0,106,
		11,82,101,103,105,115,116,101,114,68,66,0,106,14,
		84,101,120,116,95,68,97,116,97,66,97,115,101,0,
		106,6,86,97,108,117,101,0,12,3,12,1,32,101,
		2,176,2,0,176,1,0,106,11,82,101,103,105,115,
		116,101,114,68,66,0,106,10,84,101,120,116,95,85,
		115,101,114,0,106,6,86,97,108,117,101,0,12,3,
		12,1,32,55,2,176,2,0,176,1,0,106,11,82,
		101,103,105,115,116,101,114,68,66,0,106,14,84,101,
		120,116,95,80,97,115,115,119,111,114,100,0,106,6,
		86,97,108,117,101,0,12,3,12,1,32,5,2,36,
		15,0,106,8,97,100,100,114,101,115,115,0,176,3,
		0,95,2,12,1,106,9,117,115,101,114,78,97,109,
		101,0,176,4,0,176,1,0,106,11,82,101,103,105,
		115,116,101,114,68,66,0,106,10,84,101,120,116,95,
		85,115,101,114,0,106,6,86,97,108,117,101,0,12,
		3,12,1,106,9,112,97,115,115,119,111,114,100,0,
		176,4,0,176,1,0,106,11,82,101,103,105,115,116,
		101,114,68,66,0,106,14,84,101,120,116,95,80,97,
		115,115,119,111,114,100,0,106,6,86,97,108,117,101,
		0,12,3,12,1,177,3,0,80,1,36,21,0,48,
		5,0,98,6,0,48,7,0,176,8,0,12,0,106,
		8,97,100,100,114,101,115,115,0,176,3,0,95,2,
		12,1,106,9,117,115,101,114,78,97,109,101,0,176,
		4,0,176,1,0,106,11,82,101,103,105,115,116,101,
		114,68,66,0,106,10,84,101,120,116,95,85,115,101,
		114,0,106,6,86,97,108,117,101,0,12,3,12,1,
		106,9,112,97,115,115,119,111,114,100,0,176,4,0,
		176,1,0,106,11,82,101,103,105,115,116,101,114,68,
		66,0,106,14,84,101,120,116,95,80,97,115,115,119,
		111,114,100,0,106,6,86,97,108,117,101,0,12,3,
		12,1,177,3,0,112,1,112,1,73,36,22,0,48,
		9,0,98,6,0,112,0,73,36,24,0,48,10,0,
		48,11,0,98,6,0,112,0,112,0,28,36,36,25,
		0,176,12,0,106,11,114,101,103,105,115,116,101,114,
		68,66,0,106,8,82,69,76,69,65,83,69,0,20,
		2,26,221,0,36,27,0,176,13,0,106,29,65,99,
		101,115,115,111,32,110,101,103,97,100,111,32,112,97,
		114,97,32,117,115,117,195,161,114,105,111,32,0,48,
		14,0,48,11,0,98,6,0,112,0,112,0,106,2,
		46,0,176,15,0,12,0,176,15,0,12,0,72,106,
		57,86,101,114,105,102,105,113,117,101,32,97,115,32,
		105,110,102,111,114,109,97,195,167,195,181,101,115,32,
		100,105,103,105,116,97,100,97,115,32,111,117,32,99,
		104,97,109,101,32,111,32,115,117,112,111,114,116,101,
		46,0,4,5,0,106,26,73,110,102,111,114,109,97,
		195,167,195,181,101,115,32,105,110,99,111,114,114,101,
		116,97,115,33,0,20,2,25,61,36,31,0,176,13,
		0,106,26,80,114,101,101,110,99,104,101,114,32,116,
		111,100,111,115,32,111,115,32,99,97,109,112,111,115,
		0,106,21,68,97,100,111,115,32,105,110,115,117,102,
		105,99,105,101,110,116,101,115,33,0,20,2,36,34,
		0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( IPARRAYTOSTRING )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,37,0,176,16,0,176,17,0,95,1,
		122,1,12,1,12,1,80,2,36,38,0,96,2,0,
		106,2,46,0,176,16,0,176,17,0,95,1,92,2,
		1,12,1,12,1,72,135,36,39,0,96,2,0,106,
		2,46,0,176,16,0,176,17,0,95,1,92,3,1,
		12,1,12,1,72,135,36,40,0,96,2,0,106,2,
		46,0,176,16,0,176,17,0,95,1,92,4,1,12,
		1,12,1,72,135,36,41,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( REGISTERDB_ESCAPE )
{
	static const HB_BYTE pcode[] =
	{
		36,44,0,176,12,0,106,11,114,101,103,105,115,116,
		101,114,68,66,0,106,8,82,69,76,69,65,83,69,
		0,20,2,36,45,0,176,19,0,120,20,1,36,46,
		0,7
	};

	hb_vmExecute( pcode, symbols );
}

