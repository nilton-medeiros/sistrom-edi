/*
 * Harbour 3.2.0dev (r1703241902)
 * MinGW GNU C 5.3 (32-bit)
 * Generated C source from "C:\Users\nilto\OneDrive\Desenvolvimento\Projetos\harbour\apoio_tms\sistrom-edi\funcs\rotinas_auxiliares.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( SAVELOG );
HB_FUNC_EXTERN( DTOC );
HB_FUNC_EXTERN( DATE );
HB_FUNC_EXTERN( HB_PS );
HB_FUNC_EXTERN( HB_URIGHT );
HB_FUNC_EXTERN( HB_USUBSTR );
HB_FUNC_EXTERN( HB_FILEEXISTS );
HB_FUNC_EXTERN( FOPEN );
HB_FUNC_EXTERN( FSEEK );
HB_FUNC_EXTERN( FCREATE );
HB_FUNC_EXTERN( FWRITE );
HB_FUNC_EXTERN( HB_EOL );
HB_FUNC_EXTERN( TIME );
HB_FUNC_EXTERN( HB__UPADR );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( PROCNAME );
HB_FUNC_EXTERN( TRANSFORM );
HB_FUNC_EXTERN( PROCLINE );
HB_FUNC_EXTERN( FCLOSE );
HB_FUNC( IS_TRUE );
HB_FUNC_EXTERN( VALTYPE );
HB_FUNC( STATUS_MESSAGE );
HB_FUNC_EXTERN( GETLASTACTIVEFORMINDEX );
HB_FUNC_EXTERN( GETFORMNAMEBYINDEX );
HB_FUNC_EXTERN( _ISCONTROLDEFINED );
HB_FUNC_EXTERN( GETPROPERTY );
HB_FUNC_EXTERN( SETPROPERTY );
HB_FUNC( ANSI_TO_UNICODE );
HB_FUNC_EXTERN( HMG_ANSI_TO_UNICODE );
HB_FUNC( UNICODE_TO_ANSI );
HB_FUNC_EXTERN( HMG_UNICODE_TO_ANSI );
HB_FUNC_EXTERN( MYSQL_ESCAPE_STRING );
HB_FUNC( FIRST_WORD );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( LTRIM );
HB_FUNC_EXTERN( HB_UAT );
HB_FUNC_EXTERN( HMG_LEN );
HB_FUNC_EXTERN( HB_ULEFT );
HB_FUNC( PAUSE_SYSTEM );
HB_FUNC_EXTERN( SECONDS );
HB_FUNC_EXTERN( INKEY );
HB_FUNC( CAPITALIZE );
HB_FUNC_EXTERN( HMG_UPPER );
HB_FUNC_EXTERN( HMG_LOWER );
HB_FUNC_EXTERN( STRTRAN );
HB_FUNC( TEXTBOX_ON_GOTO_FOCUS );
HB_FUNC( TEXTBOX_ON_LOST_FOCUS );
HB_FUNC( GET_NUMBERS );
HB_FUNC_EXTERN( SONUMEROS );
HB_FUNC( SELECT_COUNT );
HB_FUNC_EXTERN( TSQLQUERY );
HB_FUNC( EXTENDED_DATE );
HB_FUNC_EXTERN( DOW );
HB_FUNC_EXTERN( HB_NTOS );
HB_FUNC_EXTERN( DAY );
HB_FUNC_EXTERN( MONTH );
HB_FUNC_EXTERN( YEAR );
HB_FUNC_EXTERN( ERRORSYS );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_ROTINAS_AUXILIARES )
{ "SAVELOG", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( SAVELOG )}, NULL },
{ "DTOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( DTOC )}, NULL },
{ "DATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DATE )}, NULL },
{ "PATHREGISTRY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APP", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "HB_PS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_PS )}, NULL },
{ "HB_URIGHT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_URIGHT )}, NULL },
{ "HB_USUBSTR", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_USUBSTR )}, NULL },
{ "HB_FILEEXISTS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_FILEEXISTS )}, NULL },
{ "FOPEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( FOPEN )}, NULL },
{ "FSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( FSEEK )}, NULL },
{ "FCREATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FCREATE )}, NULL },
{ "FWRITE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FWRITE )}, NULL },
{ "VERSION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_EOL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_EOL )}, NULL },
{ "TIME", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIME )}, NULL },
{ "HB__UPADR", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB__UPADR )}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "PROCNAME", {HB_FS_PUBLIC}, {HB_FUNCNAME( PROCNAME )}, NULL },
{ "TRANSFORM", {HB_FS_PUBLIC}, {HB_FUNCNAME( TRANSFORM )}, NULL },
{ "PROCLINE", {HB_FS_PUBLIC}, {HB_FUNCNAME( PROCLINE )}, NULL },
{ "FCLOSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FCLOSE )}, NULL },
{ "IS_TRUE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( IS_TRUE )}, NULL },
{ "VALTYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALTYPE )}, NULL },
{ "STATUS_MESSAGE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( STATUS_MESSAGE )}, NULL },
{ "GETLASTACTIVEFORMINDEX", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETLASTACTIVEFORMINDEX )}, NULL },
{ "GETFORMNAMEBYINDEX", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETFORMNAMEBYINDEX )}, NULL },
{ "_ISCONTROLDEFINED", {HB_FS_PUBLIC}, {HB_FUNCNAME( _ISCONTROLDEFINED )}, NULL },
{ "GETPROPERTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETPROPERTY )}, NULL },
{ "SETPROPERTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETPROPERTY )}, NULL },
{ "ANSI_TO_UNICODE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( ANSI_TO_UNICODE )}, NULL },
{ "HMG_ANSI_TO_UNICODE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HMG_ANSI_TO_UNICODE )}, NULL },
{ "UNICODE_TO_ANSI", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( UNICODE_TO_ANSI )}, NULL },
{ "HMG_UNICODE_TO_ANSI", {HB_FS_PUBLIC}, {HB_FUNCNAME( HMG_UNICODE_TO_ANSI )}, NULL },
{ "MYSQL_ESCAPE_STRING", {HB_FS_PUBLIC}, {HB_FUNCNAME( MYSQL_ESCAPE_STRING )}, NULL },
{ "FIRST_WORD", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( FIRST_WORD )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "LTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( LTRIM )}, NULL },
{ "HB_UAT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_UAT )}, NULL },
{ "HMG_LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( HMG_LEN )}, NULL },
{ "HB_ULEFT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ULEFT )}, NULL },
{ "PAUSE_SYSTEM", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( PAUSE_SYSTEM )}, NULL },
{ "SECONDS", {HB_FS_PUBLIC}, {HB_FUNCNAME( SECONDS )}, NULL },
{ "INKEY", {HB_FS_PUBLIC}, {HB_FUNCNAME( INKEY )}, NULL },
{ "CAPITALIZE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( CAPITALIZE )}, NULL },
{ "HMG_UPPER", {HB_FS_PUBLIC}, {HB_FUNCNAME( HMG_UPPER )}, NULL },
{ "HMG_LOWER", {HB_FS_PUBLIC}, {HB_FUNCNAME( HMG_LOWER )}, NULL },
{ "STRTRAN", {HB_FS_PUBLIC}, {HB_FUNCNAME( STRTRAN )}, NULL },
{ "TEXTBOX_ON_GOTO_FOCUS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TEXTBOX_ON_GOTO_FOCUS )}, NULL },
{ "TEXTBOX_ON_LOST_FOCUS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TEXTBOX_ON_LOST_FOCUS )}, NULL },
{ "GET_NUMBERS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( GET_NUMBERS )}, NULL },
{ "SONUMEROS", {HB_FS_PUBLIC}, {HB_FUNCNAME( SONUMEROS )}, NULL },
{ "SELECT_COUNT", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( SELECT_COUNT )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSQLQUERY", {HB_FS_PUBLIC}, {HB_FUNCNAME( TSQLQUERY )}, NULL },
{ "ISEXECUTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DESTROY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EXTENDED_DATE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( EXTENDED_DATE )}, NULL },
{ "DOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOW )}, NULL },
{ "HB_NTOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_NTOS )}, NULL },
{ "DAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( DAY )}, NULL },
{ "MONTH", {HB_FS_PUBLIC}, {HB_FUNCNAME( MONTH )}, NULL },
{ "YEAR", {HB_FS_PUBLIC}, {HB_FUNCNAME( YEAR )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_ROTINAS_AUXILIARES, "C:\\Users\\nilto\\OneDrive\\Desenvolvimento\\Projetos\\harbour\\apoio_tms\\sistrom-edi\\funcs\\rotinas_auxiliares.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_ROTINAS_AUXILIARES
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_ROTINAS_AUXILIARES )
   #include "hbiniseg.h"
#endif

HB_FUNC( SAVELOG )
{
	static const HB_BYTE pcode[] =
	{
		13,5,1,36,15,0,176,1,0,176,2,0,12,0,
		12,1,80,4,36,16,0,48,3,0,98,4,0,112,
		0,106,4,108,111,103,0,72,176,5,0,12,0,72,
		80,5,36,17,0,106,4,108,111,103,0,176,6,0,
		95,4,92,2,12,2,72,176,7,0,95,4,92,4,
		92,2,12,3,72,106,5,46,116,120,116,0,72,80,
		6,36,19,0,176,8,0,95,5,95,6,72,12,1,
		28,33,36,20,0,176,9,0,95,5,95,6,72,122,
		12,2,80,3,36,21,0,176,10,0,95,3,121,92,
		2,20,3,25,94,36,23,0,176,11,0,95,5,95,
		6,72,121,12,2,80,3,36,24,0,176,12,0,95,
		3,106,43,76,111,103,32,100,111,32,83,105,115,116,
		101,109,97,32,100,101,32,83,105,115,116,114,111,109,
		45,69,68,73,32,80,114,111,99,101,100,97,32,45,
		32,118,46,0,48,13,0,98,4,0,112,0,72,176,
		14,0,12,0,72,176,14,0,12,0,72,20,2,36,
		27,0,95,4,106,2,32,0,72,176,15,0,12,0,
		72,176,16,0,106,14,32,124,32,80,114,111,99,101,
		115,115,111,58,32,0,176,17,0,176,18,0,122,12,
		1,12,1,72,92,35,12,2,72,106,10,124,32,76,
		105,110,104,97,58,32,0,72,176,19,0,176,20,0,
		122,12,1,106,5,57,57,57,57,0,12,2,72,80,
		2,36,28,0,96,2,0,106,4,32,124,32,0,95,
		1,72,176,14,0,12,0,72,135,36,30,0,176,12,
		0,95,3,95,2,20,2,36,31,0,176,21,0,95,
		3,20,1,36,33,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( IS_TRUE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,36,0,176,23,0,95,1,12,1,106,
		2,76,0,8,28,9,36,37,0,95,1,110,7,36,
		38,0,176,23,0,95,1,12,1,106,2,78,0,8,
		28,11,36,39,0,95,1,121,15,110,7,36,41,0,
		9,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( STATUS_MESSAGE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,44,0,106,7,83,116,97,116,117,115,
		0,80,2,36,45,0,106,1,0,80,3,36,46,0,
		176,25,0,12,0,80,4,36,48,0,95,1,100,8,
		28,13,106,7,83,116,97,116,117,115,0,25,4,95,
		1,80,1,36,50,0,95,4,121,15,28,114,36,51,
		0,176,26,0,95,4,12,1,80,3,36,52,0,176,
		27,0,106,10,83,116,97,116,117,115,66,97,114,0,
		95,3,12,2,31,14,36,53,0,106,5,77,97,105,
		110,0,80,3,36,55,0,176,28,0,95,3,106,10,
		83,116,97,116,117,115,66,97,114,0,106,5,73,116,
		101,109,0,122,12,4,80,2,36,56,0,176,29,0,
		95,3,106,10,83,116,97,116,117,115,66,97,114,0,
		106,5,73,116,101,109,0,122,95,1,20,5,36,59,
		0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( ANSI_TO_UNICODE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,62,0,176,31,0,176,17,0,95,1,
		12,1,20,1,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( UNICODE_TO_ANSI )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,65,0,176,33,0,176,34,0,176,17,
		0,95,1,12,1,12,1,20,1,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( FIRST_WORD )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,70,0,176,36,0,95,1,12,1,31,
		70,36,71,0,176,37,0,95,1,12,1,80,1,36,
		72,0,176,38,0,106,2,32,0,95,1,12,2,80,
		2,36,73,0,95,2,121,8,28,19,36,74,0,176,
		39,0,176,17,0,95,1,12,1,12,1,80,2,36,
		76,0,176,40,0,95,1,95,2,12,2,80,1,36,
		79,0,176,17,0,95,1,20,1,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( PAUSE_SYSTEM )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,82,0,176,42,0,12,0,80,2,36,
		83,0,95,1,100,8,28,6,92,2,25,4,95,1,
		80,1,36,84,0,176,42,0,12,0,95,2,49,95,
		1,35,28,13,36,85,0,176,43,0,122,20,1,25,
		231,36,87,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( CAPITALIZE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,92,0,176,17,0,95,1,12,1,80,
		1,36,93,0,176,45,0,176,40,0,95,1,122,12,
		2,12,1,176,46,0,176,7,0,95,1,92,2,12,
		2,12,1,72,80,1,36,94,0,176,47,0,95,1,
		106,2,32,0,106,2,176,0,12,3,80,1,36,95,
		0,176,38,0,106,2,176,0,95,1,12,2,80,2,
		36,97,0,95,2,121,15,28,72,36,98,0,176,40,
		0,95,1,95,2,122,49,12,2,106,2,32,0,72,
		176,45,0,176,7,0,95,1,95,2,122,72,122,12,
		3,12,1,72,176,7,0,95,1,95,2,92,2,72,
		12,2,72,80,1,36,99,0,176,38,0,106,2,176,
		0,95,1,12,2,80,2,25,179,36,102,0,95,1,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TEXTBOX_ON_GOTO_FOCUS )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,105,0,176,29,0,95,1,95,2,106,
		10,66,97,99,107,67,111,108,111,114,0,93,190,0,
		93,215,0,93,250,0,4,3,0,20,4,36,106,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TEXTBOX_ON_LOST_FOCUS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,111,0,176,29,0,95,1,95,2,106,
		10,66,97,99,107,67,111,108,111,114,0,93,255,0,
		93,255,0,93,255,0,4,3,0,20,4,36,112,0,
		176,23,0,95,3,12,1,106,2,67,0,8,28,92,
		36,113,0,176,50,0,176,28,0,95,1,95,2,106,
		6,86,97,108,117,101,0,12,3,12,1,80,4,36,
		114,0,176,36,0,95,4,12,1,31,53,176,39,0,
		95,4,12,1,176,39,0,176,51,0,95,3,12,1,
		12,1,8,28,31,36,115,0,176,29,0,95,1,95,
		2,106,6,86,97,108,117,101,0,176,19,0,95,4,
		95,3,12,2,20,4,36,119,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( GET_NUMBERS )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,122,0,106,1,0,80,2,36,125,0,
		176,23,0,95,1,12,1,106,2,67,0,8,28,61,
		176,36,0,95,1,12,1,31,52,36,126,0,95,1,
		96,3,0,129,1,1,28,38,36,127,0,95,3,106,
		11,48,49,50,51,52,53,54,55,56,57,0,24,28,
		11,36,128,0,96,2,0,95,3,135,36,130,0,130,
		31,222,132,36,133,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( SELECT_COUNT )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,136,0,121,80,2,36,137,0,48,53,
		0,176,54,0,12,0,106,22,83,69,76,69,67,84,
		32,67,79,85,78,84,40,42,41,32,70,82,79,77,
		32,0,95,1,72,112,1,80,3,36,139,0,48,55,
		0,95,3,112,0,28,49,36,140,0,48,56,0,95,
		3,122,112,1,80,2,36,141,0,48,57,0,95,3,
		112,0,73,36,142,0,176,23,0,95,2,12,1,106,
		2,78,0,8,31,8,36,143,0,121,80,2,36,147,
		0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( EXTENDED_DATE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,151,0,106,8,100,111,109,105,110,103,
		111,0,106,14,115,101,103,117,110,100,97,45,102,101,
		105,114,97,0,106,13,116,101,114,195,167,97,45,102,
		101,105,114,97,0,106,13,113,117,97,114,116,97,45,
		102,101,105,114,97,0,106,13,113,117,105,110,116,97,
		45,102,101,105,114,97,0,106,12,115,101,120,116,97,
		45,102,101,105,114,97,0,106,8,115,195,161,98,97,
		100,111,0,4,7,0,80,3,36,152,0,106,8,74,
		97,110,101,105,114,111,0,106,10,70,101,118,101,114,
		101,105,114,111,0,106,7,77,97,114,195,167,111,0,
		106,6,65,98,114,105,108,0,106,5,77,97,105,111,
		0,106,6,74,117,110,104,111,0,106,6,74,117,108,
		104,111,0,106,7,65,103,111,115,116,111,0,106,9,
		83,101,116,101,109,98,114,111,0,106,8,79,117,116,
		117,98,114,111,0,106,9,78,111,118,101,109,98,114,
		111,0,106,9,68,101,122,101,109,98,114,111,0,4,
		12,0,80,4,36,153,0,95,1,100,8,28,9,176,
		2,0,12,0,25,4,95,1,80,1,36,155,0,95,
		3,176,59,0,95,1,12,1,1,106,3,44,32,0,
		72,176,60,0,176,61,0,95,1,12,1,12,1,72,
		106,5,32,100,101,32,0,72,95,4,176,62,0,95,
		1,12,1,1,72,106,5,32,100,101,32,0,72,176,
		60,0,176,63,0,95,1,12,1,12,1,72,80,2,
		36,157,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

