/*
 * Harbour 3.2.0dev (r1703241902)
 * MinGW GNU C 5.3 (32-bit)
 * Generated C source from "C:\Users\nilto\OneDrive\Desenvolvimento\Projetos\harbour\apoio_tms\sistrom-edi\routines\general_routines.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( SAVELOG );
HB_FUNC_EXTERN( DTOC );
HB_FUNC_EXTERN( DATE );
HB_FUNC_EXTERN( HB_CWD );
HB_FUNC_EXTERN( HB_PS );
HB_FUNC_EXTERN( HB_URIGHT );
HB_FUNC_EXTERN( HB_USUBSTR );
HB_FUNC_EXTERN( HB_FILEEXISTS );
HB_FUNC_EXTERN( FOPEN );
HB_FUNC_EXTERN( FSEEK );
HB_FUNC_EXTERN( HB_FCREATE );
HB_FUNC_EXTERN( FWRITE );
HB_FUNC_EXTERN( HB_EOL );
HB_FUNC_EXTERN( TIME );
HB_FUNC_EXTERN( HB_UPADR );
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
HB_FUNC_EXTERN( HB_ULEFT );
HB_FUNC_EXTERN( HMG_LOWER );
HB_FUNC_EXTERN( HB_AT );
HB_FUNC_EXTERN( MESSAGEBOXTIMEOUT );
HB_FUNC( MSG_DEBUG_INFO );
HB_FUNC_EXTERN( HB_NTOS );
HB_FUNC_EXTERN( AADD );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC( FIRST_WORD );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( LTRIM );
HB_FUNC_EXTERN( HB_UAT );
HB_FUNC_EXTERN( HB_ULEN );
HB_FUNC( LAST_WORD );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC_EXTERN( HB_RAT );
HB_FUNC( PAUSE_SYSTEM );
HB_FUNC_EXTERN( SECONDS );
HB_FUNC_EXTERN( INKEY );
HB_FUNC( CAPITALIZE );
HB_FUNC_EXTERN( HMG_UPPER );
HB_FUNC_EXTERN( STRTRAN );
HB_FUNC( GET_NUMBERS );
HB_FUNC( EXTENDED_DATE );
HB_FUNC_EXTERN( DOW );
HB_FUNC_EXTERN( DAY );
HB_FUNC_EXTERN( MONTH );
HB_FUNC_EXTERN( YEAR );
HB_FUNC( BACKGROUND_COLOR_ACTIVE_RECORDS );
HB_FUNC( GRID_COLUMN_INDEX );
HB_FUNC( DATE_AND_WEEK );
HB_FUNC( DATE_TO_EDI );
HB_FUNC_EXTERN( HB_DTOC );
HB_FUNC( NUMBER_TO_EDI );
HB_FUNC_EXTERN( STRZERO );
HB_FUNC( INDEX_OF_COMBOBOX );
HB_FUNC( CHECKBUTTON_ATIVO_ON_CHANGE );
HB_FUNC( TEXTBOX_ON_GOTO_FOCUS );
HB_FUNC( TEXTBOX_ON_LOST_FOCUS );
HB_FUNC( FORMAT_TEXT );
HB_FUNC_EXTERN( HB_UPADL );
HB_FUNC_EXTERN( HB_VAL );
HB_FUNC( FORMAT_NUMBER );
HB_FUNC( AUX_IS_ALPHA );
HB_FUNC( AUX_IS_DIGIT );
HB_FUNC_EXTERN( ERRORSYS );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_GENERAL_ROUTINES )
{ "SAVELOG", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( SAVELOG )}, NULL },
{ "DTOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( DTOC )}, NULL },
{ "DATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DATE )}, NULL },
{ "HB_CWD", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_CWD )}, NULL },
{ "HB_PS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_PS )}, NULL },
{ "HB_URIGHT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_URIGHT )}, NULL },
{ "HB_USUBSTR", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_USUBSTR )}, NULL },
{ "HB_FILEEXISTS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_FILEEXISTS )}, NULL },
{ "FOPEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( FOPEN )}, NULL },
{ "FSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( FSEEK )}, NULL },
{ "HB_FCREATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_FCREATE )}, NULL },
{ "FWRITE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FWRITE )}, NULL },
{ "VERSION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APP", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "HB_EOL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_EOL )}, NULL },
{ "TIME", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIME )}, NULL },
{ "HB_UPADR", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_UPADR )}, NULL },
{ "GETUSER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
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
{ "HB_ULEFT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ULEFT )}, NULL },
{ "HMG_LOWER", {HB_FS_PUBLIC}, {HB_FUNCNAME( HMG_LOWER )}, NULL },
{ "HB_AT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_AT )}, NULL },
{ "MESSAGEBOXTIMEOUT", {HB_FS_PUBLIC}, {HB_FUNCNAME( MESSAGEBOXTIMEOUT )}, NULL },
{ "MSG_DEBUG_INFO", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( MSG_DEBUG_INFO )}, NULL },
{ "HB_NTOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_NTOS )}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "FIRST_WORD", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( FIRST_WORD )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "LTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( LTRIM )}, NULL },
{ "HB_UAT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_UAT )}, NULL },
{ "HB_ULEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ULEN )}, NULL },
{ "LAST_WORD", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( LAST_WORD )}, NULL },
{ "RTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( RTRIM )}, NULL },
{ "HB_RAT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_RAT )}, NULL },
{ "PAUSE_SYSTEM", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( PAUSE_SYSTEM )}, NULL },
{ "SECONDS", {HB_FS_PUBLIC}, {HB_FUNCNAME( SECONDS )}, NULL },
{ "INKEY", {HB_FS_PUBLIC}, {HB_FUNCNAME( INKEY )}, NULL },
{ "CAPITALIZE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( CAPITALIZE )}, NULL },
{ "HMG_UPPER", {HB_FS_PUBLIC}, {HB_FUNCNAME( HMG_UPPER )}, NULL },
{ "STRTRAN", {HB_FS_PUBLIC}, {HB_FUNCNAME( STRTRAN )}, NULL },
{ "GET_NUMBERS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( GET_NUMBERS )}, NULL },
{ "EXTENDED_DATE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( EXTENDED_DATE )}, NULL },
{ "DOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOW )}, NULL },
{ "DAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( DAY )}, NULL },
{ "MONTH", {HB_FS_PUBLIC}, {HB_FUNCNAME( MONTH )}, NULL },
{ "YEAR", {HB_FS_PUBLIC}, {HB_FUNCNAME( YEAR )}, NULL },
{ "BACKGROUND_COLOR_ACTIVE_RECORDS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( BACKGROUND_COLOR_ACTIVE_RECORDS )}, NULL },
{ "_HMG_SYSDATA", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "GRID_COLUMN_INDEX", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( GRID_COLUMN_INDEX )}, NULL },
{ "DATE_AND_WEEK", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( DATE_AND_WEEK )}, NULL },
{ "DATE_TO_EDI", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( DATE_TO_EDI )}, NULL },
{ "HB_DTOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_DTOC )}, NULL },
{ "NUMBER_TO_EDI", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( NUMBER_TO_EDI )}, NULL },
{ "STRZERO", {HB_FS_PUBLIC}, {HB_FUNCNAME( STRZERO )}, NULL },
{ "INDEX_OF_COMBOBOX", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( INDEX_OF_COMBOBOX )}, NULL },
{ "CHECKBUTTON_ATIVO_ON_CHANGE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( CHECKBUTTON_ATIVO_ON_CHANGE )}, NULL },
{ "MENUCOLOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AVATAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TEXTBOX_ON_GOTO_FOCUS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TEXTBOX_ON_GOTO_FOCUS )}, NULL },
{ "TEXTBOX_ON_LOST_FOCUS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TEXTBOX_ON_LOST_FOCUS )}, NULL },
{ "FORMAT_TEXT", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( FORMAT_TEXT )}, NULL },
{ "UTC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_UPADL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_UPADL )}, NULL },
{ "HB_VAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_VAL )}, NULL },
{ "FORMAT_NUMBER", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( FORMAT_NUMBER )}, NULL },
{ "AUX_IS_ALPHA", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( AUX_IS_ALPHA )}, NULL },
{ "AUX_IS_DIGIT", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( AUX_IS_DIGIT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_GENERAL_ROUTINES, "C:\\Users\\nilto\\OneDrive\\Desenvolvimento\\Projetos\\harbour\\apoio_tms\\sistrom-edi\\routines\\general_routines.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_GENERAL_ROUTINES
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_GENERAL_ROUTINES )
   #include "hbiniseg.h"
#endif

HB_FUNC( SAVELOG )
{
	static const HB_BYTE pcode[] =
	{
		13,5,1,36,15,0,176,1,0,176,2,0,12,0,
		12,1,80,4,36,16,0,176,3,0,12,0,106,4,
		108,111,103,0,72,176,4,0,12,0,72,80,5,36,
		17,0,106,4,108,111,103,0,176,5,0,95,4,92,
		2,12,2,72,176,6,0,95,4,92,4,92,2,12,
		3,72,106,5,46,116,120,116,0,72,80,6,36,19,
		0,176,7,0,95,5,95,6,72,12,1,28,33,36,
		20,0,176,8,0,95,5,95,6,72,122,12,2,80,
		3,36,21,0,176,9,0,95,3,121,92,2,20,3,
		25,94,36,23,0,176,10,0,95,5,95,6,72,121,
		12,2,80,3,36,24,0,176,11,0,95,3,106,43,
		76,111,103,32,100,111,32,83,105,115,116,101,109,97,
		32,100,101,32,83,105,115,116,114,111,109,45,69,68,
		73,32,80,114,111,99,101,100,97,32,45,32,118,46,
		0,48,12,0,98,13,0,112,0,72,176,14,0,12,
		0,72,176,14,0,12,0,72,20,2,36,27,0,95,
		4,106,2,32,0,72,176,15,0,12,0,72,106,13,
		124,32,85,115,117,195,161,114,105,111,58,32,0,72,
		176,16,0,48,17,0,109,13,0,112,0,92,20,12,
		2,72,176,16,0,106,14,32,124,32,80,114,111,99,
		101,115,115,111,58,32,0,176,18,0,176,19,0,122,
		12,1,12,1,72,92,35,12,2,72,106,10,124,32,
		76,105,110,104,97,58,32,0,72,176,20,0,176,21,
		0,122,12,1,106,5,57,57,57,57,0,12,2,72,
		80,2,36,28,0,96,2,0,106,4,32,124,32,0,
		95,1,72,176,14,0,12,0,72,135,36,30,0,176,
		11,0,95,3,95,2,20,2,36,31,0,176,22,0,
		95,3,20,1,36,33,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( IS_TRUE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,36,0,176,24,0,95,1,12,1,106,
		2,76,0,8,28,9,36,37,0,95,1,110,7,36,
		38,0,176,24,0,95,1,12,1,106,2,78,0,8,
		28,11,36,39,0,95,1,121,15,110,7,36,41,0,
		9,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( STATUS_MESSAGE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,5,36,44,0,106,7,83,116,97,116,117,115,
		0,80,6,36,45,0,106,1,0,80,7,36,46,0,
		176,26,0,12,0,80,8,36,48,0,95,1,100,8,
		28,13,106,7,83,116,97,116,117,115,0,25,4,95,
		1,80,1,36,49,0,95,2,100,8,28,5,9,25,
		4,95,2,80,2,36,50,0,95,5,100,8,28,7,
		93,16,39,25,4,95,5,80,5,36,52,0,95,8,
		121,15,28,114,36,53,0,176,27,0,95,8,12,1,
		80,7,36,54,0,176,28,0,106,10,83,116,97,116,
		117,115,66,97,114,0,95,7,12,2,31,14,36,55,
		0,106,5,77,97,105,110,0,80,7,36,57,0,176,
		29,0,95,7,106,10,83,116,97,116,117,115,66,97,
		114,0,106,5,73,116,101,109,0,122,12,4,80,6,
		36,58,0,176,30,0,95,7,106,10,83,116,97,116,
		117,115,66,97,114,0,106,5,73,116,101,109,0,122,
		95,1,20,5,36,61,0,95,2,28,72,36,62,0,
		176,31,0,176,32,0,95,1,12,1,92,6,12,2,
		106,7,115,116,97,116,117,115,0,8,28,27,36,63,
		0,176,6,0,95,1,176,33,0,106,2,32,0,95,
		1,12,2,122,72,12,2,80,1,36,65,0,176,34,
		0,95,1,95,3,95,4,95,5,20,4,36,68,0,
		95,6,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( MSG_DEBUG_INFO )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,71,0,106,13,67,104,97,109,97,100,
		111,32,100,101,58,32,0,176,19,0,122,12,1,106,
		2,40,0,72,176,36,0,176,21,0,122,12,1,12,
		1,72,106,6,41,32,45,45,62,0,72,176,14,0,
		12,0,4,3,0,80,2,36,73,0,176,24,0,95,
		1,12,1,106,2,65,0,8,28,36,36,74,0,95,
		1,96,3,0,129,1,1,28,20,36,75,0,176,37,
		0,95,2,95,3,20,2,36,76,0,130,31,240,132,
		25,14,36,78,0,176,37,0,95,2,95,1,20,2,
		36,80,0,176,38,0,95,2,106,11,68,69,66,85,
		71,32,73,78,70,79,0,20,2,36,81,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( FIRST_WORD )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,86,0,176,40,0,95,1,12,1,31,
		70,36,87,0,176,41,0,95,1,12,1,80,1,36,
		88,0,176,42,0,106,2,32,0,95,1,12,2,80,
		2,36,89,0,95,2,121,8,28,19,36,90,0,176,
		43,0,176,18,0,95,1,12,1,12,1,80,2,36,
		92,0,176,31,0,95,1,95,2,12,2,80,1,36,
		95,0,176,18,0,95,1,20,1,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( LAST_WORD )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,98,0,176,40,0,95,1,12,1,31,
		37,36,99,0,176,45,0,95,1,12,1,80,1,36,
		100,0,176,6,0,95,1,176,46,0,106,2,32,0,
		95,1,12,2,12,2,80,1,36,102,0,176,18,0,
		95,1,20,1,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( PAUSE_SYSTEM )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,105,0,176,48,0,12,0,80,2,36,
		106,0,95,1,100,8,28,6,92,2,25,4,95,1,
		80,1,36,107,0,176,48,0,12,0,95,2,49,95,
		1,35,28,13,36,108,0,176,49,0,122,20,1,25,
		231,36,110,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( CAPITALIZE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,115,0,176,18,0,95,1,12,1,80,
		1,36,116,0,176,51,0,176,31,0,95,1,122,12,
		2,12,1,176,32,0,176,6,0,95,1,92,2,12,
		2,12,1,72,80,1,36,117,0,176,52,0,95,1,
		106,2,32,0,106,2,176,0,12,3,80,1,36,118,
		0,176,42,0,106,2,176,0,95,1,12,2,80,2,
		36,120,0,95,2,121,15,28,72,36,121,0,176,31,
		0,95,1,95,2,122,49,12,2,106,2,32,0,72,
		176,51,0,176,6,0,95,1,95,2,122,72,122,12,
		3,12,1,72,176,6,0,95,1,95,2,92,2,72,
		12,2,72,80,1,36,122,0,176,42,0,106,2,176,
		0,95,1,12,2,80,2,25,179,36,125,0,95,1,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( GET_NUMBERS )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,128,0,106,1,0,80,2,36,131,0,
		176,24,0,95,1,12,1,106,2,67,0,8,28,61,
		176,40,0,95,1,12,1,31,52,36,132,0,95,1,
		96,3,0,129,1,1,28,38,36,133,0,95,3,106,
		11,48,49,50,51,52,53,54,55,56,57,0,24,28,
		11,36,134,0,96,2,0,95,3,135,36,136,0,130,
		31,222,132,36,139,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( EXTENDED_DATE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,143,0,106,8,100,111,109,105,110,103,
		111,0,106,14,115,101,103,117,110,100,97,45,102,101,
		105,114,97,0,106,13,116,101,114,195,167,97,45,102,
		101,105,114,97,0,106,13,113,117,97,114,116,97,45,
		102,101,105,114,97,0,106,13,113,117,105,110,116,97,
		45,102,101,105,114,97,0,106,12,115,101,120,116,97,
		45,102,101,105,114,97,0,106,8,115,195,161,98,97,
		100,111,0,4,7,0,80,3,36,144,0,106,8,74,
		97,110,101,105,114,111,0,106,10,70,101,118,101,114,
		101,105,114,111,0,106,7,77,97,114,195,167,111,0,
		106,6,65,98,114,105,108,0,106,5,77,97,105,111,
		0,106,6,74,117,110,104,111,0,106,6,74,117,108,
		104,111,0,106,7,65,103,111,115,116,111,0,106,9,
		83,101,116,101,109,98,114,111,0,106,8,79,117,116,
		117,98,114,111,0,106,9,78,111,118,101,109,98,114,
		111,0,106,9,68,101,122,101,109,98,114,111,0,4,
		12,0,80,4,36,145,0,95,1,100,8,28,9,176,
		2,0,12,0,25,4,95,1,80,1,36,147,0,95,
		3,176,55,0,95,1,12,1,1,106,3,44,32,0,
		72,176,36,0,176,56,0,95,1,12,1,12,1,72,
		106,5,32,100,101,32,0,72,95,4,176,57,0,95,
		1,12,1,1,72,106,5,32,100,101,32,0,72,176,
		36,0,176,58,0,95,1,12,1,12,1,72,80,2,
		36,149,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( BACKGROUND_COLOR_ACTIVE_RECORDS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,153,0,95,3,100,8,28,5,9,25,
		4,95,3,80,3,36,157,0,176,29,0,95,1,95,
		2,106,7,67,101,108,108,69,120,0,98,60,0,93,
		195,0,1,176,61,0,95,1,95,2,106,7,83,116,
		97,116,117,115,0,12,3,12,5,106,6,65,84,73,
		86,79,0,8,28,39,36,158,0,95,3,28,16,93,
		234,0,93,244,0,93,255,0,4,3,0,25,14,93,
		255,0,93,255,0,93,255,0,4,3,0,80,4,25,
		19,36,160,0,93,192,0,93,192,0,93,192,0,4,
		3,0,80,4,36,163,0,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( GRID_COLUMN_INDEX )
{
	static const HB_BYTE pcode[] =
	{
		13,2,3,36,166,0,121,80,5,36,169,0,122,165,
		80,4,25,107,36,170,0,176,52,0,176,29,0,95,
		1,95,2,106,13,67,111,108,117,109,110,72,69,65,
		68,69,82,0,95,4,12,4,106,4,226,134,145,0,
		12,2,80,5,36,171,0,176,52,0,95,5,106,4,
		226,134,147,0,12,2,80,5,36,172,0,176,51,0,
		176,18,0,95,5,12,1,12,1,176,51,0,176,18,
		0,95,3,12,1,12,1,8,28,11,36,173,0,95,
		4,80,5,25,35,36,169,0,175,4,0,176,29,0,
		95,1,95,2,106,12,67,111,108,117,109,110,67,79,
		85,78,84,0,12,3,15,29,127,255,36,178,0,95,
		5,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( DATE_AND_WEEK )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,181,0,106,4,68,111,109,0,106,4,
		83,101,103,0,106,4,84,101,114,0,106,4,81,117,
		97,0,106,4,81,117,105,0,106,4,83,101,120,0,
		106,4,83,97,98,0,4,7,0,80,3,36,182,0,
		95,3,176,55,0,95,1,12,1,1,106,2,32,0,
		72,176,1,0,95,1,12,1,72,80,2,36,183,0,
		95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( DATE_TO_EDI )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,186,0,176,64,0,95,1,106,9,68,
		68,77,77,89,89,89,89,0,20,2,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( NUMBER_TO_EDI )
{
	static const HB_BYTE pcode[] =
	{
		13,0,3,36,189,0,176,52,0,176,66,0,95,1,
		95,2,122,72,95,3,12,3,106,2,46,0,20,2,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( INDEX_OF_COMBOBOX )
{
	static const HB_BYTE pcode[] =
	{
		13,4,3,36,192,0,121,80,4,176,29,0,95,1,
		95,2,106,10,73,84,69,77,67,79,85,78,84,0,
		12,3,80,5,36,195,0,176,18,0,95,3,12,1,
		80,3,36,196,0,122,165,80,6,25,88,36,197,0,
		176,29,0,95,1,95,2,106,5,73,84,69,77,0,
		95,6,12,4,80,7,36,198,0,176,24,0,95,7,
		12,1,106,2,65,0,8,28,12,95,7,92,2,1,
		95,3,5,31,23,176,24,0,95,7,12,1,106,2,
		67,0,8,28,18,95,7,95,3,5,28,11,36,199,
		0,95,6,80,4,25,13,36,196,0,175,6,0,95,
		5,15,28,167,36,204,0,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( CHECKBUTTON_ATIVO_ON_CHANGE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,207,0,48,69,0,109,13,0,112,0,
		80,3,36,208,0,95,2,106,18,99,104,101,99,107,
		98,117,116,116,111,110,95,97,116,105,118,111,0,8,
		28,35,36,209,0,48,70,0,109,13,0,112,0,122,
		8,28,11,106,5,66,108,117,101,0,25,9,106,5,
		80,105,110,107,0,80,3,36,211,0,176,30,0,95,
		1,95,2,106,8,80,73,67,84,85,82,69,0,176,
		29,0,95,1,95,2,106,6,86,65,76,85,69,0,
		12,3,28,19,106,10,98,116,116,84,117,114,110,79,
		110,0,95,3,72,25,15,106,11,98,116,116,84,117,
		114,110,79,102,102,0,20,4,36,212,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TEXTBOX_ON_GOTO_FOCUS )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,215,0,176,30,0,95,1,95,2,106,
		10,66,65,67,75,67,79,76,79,82,0,93,190,0,
		93,215,0,93,250,0,4,3,0,20,4,36,216,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TEXTBOX_ON_LOST_FOCUS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,220,0,176,30,0,95,1,95,2,106,
		10,66,65,67,75,67,79,76,79,82,0,93,255,0,
		93,255,0,93,255,0,4,3,0,20,4,36,221,0,
		176,24,0,95,3,12,1,106,2,67,0,8,28,65,
		36,222,0,176,73,0,176,29,0,95,1,95,2,106,
		6,86,65,76,85,69,0,12,3,95,3,12,2,80,
		4,36,223,0,176,40,0,95,4,12,1,31,24,36,
		224,0,176,30,0,95,1,95,2,106,6,86,65,76,
		85,69,0,95,4,20,4,36,228,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( FORMAT_TEXT )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,231,0,95,1,80,3,36,233,0,176,
		32,0,95,2,12,1,80,2,36,235,0,26,35,3,
		36,237,0,176,50,0,95,1,12,1,80,3,26,195,
		3,36,240,0,176,39,0,176,50,0,95,1,12,1,
		12,1,80,3,26,175,3,36,243,0,176,39,0,95,
		1,12,1,80,3,26,160,3,36,246,0,176,52,0,
		95,1,106,2,32,0,106,2,84,0,12,3,80,3,
		26,137,3,36,249,0,176,52,0,95,1,106,2,32,
		0,106,2,84,0,12,3,48,74,0,109,13,0,112,
		0,72,80,3,26,105,3,36,252,0,176,53,0,95,
		1,12,1,80,3,36,253,0,176,40,0,95,3,12,
		1,32,252,0,36,254,0,176,43,0,95,3,12,1,
		92,10,35,28,34,36,255,0,176,75,0,176,18,0,
		176,5,0,95,3,92,10,12,2,12,1,92,10,106,
		2,48,0,12,3,80,3,25,107,36,0,1,176,43,
		0,95,3,12,1,92,11,15,28,92,36,1,1,176,
		36,0,176,76,0,95,3,12,1,12,1,80,3,36,
		2,1,176,40,0,95,3,12,1,31,63,36,3,1,
		176,43,0,95,3,12,1,92,11,35,28,34,36,4,
		1,176,75,0,176,18,0,176,5,0,95,3,92,11,
		12,2,12,1,92,11,106,2,48,0,12,3,80,3,
		25,16,36,6,1,176,5,0,95,3,92,11,12,2,
		80,3,36,10,1,176,43,0,95,3,12,1,92,10,
		8,28,36,36,11,1,176,20,0,95,3,106,18,64,
		82,32,40,57,57,41,32,57,57,57,57,45,57,57,
		57,57,0,12,2,80,3,25,50,36,12,1,176,43,
		0,95,3,12,1,92,11,8,28,35,36,13,1,176,
		20,0,95,3,106,19,64,82,32,40,57,57,41,32,
		57,57,57,57,57,45,57,57,57,57,0,12,2,80,
		3,26,84,2,36,18,1,176,53,0,95,1,12,1,
		80,3,36,19,1,176,43,0,95,3,12,1,92,14,
		35,28,34,36,20,1,176,75,0,176,18,0,176,5,
		0,95,3,92,14,12,2,12,1,92,14,106,2,48,
		0,12,3,80,3,25,31,36,21,1,176,43,0,95,
		3,12,1,92,14,15,28,16,36,22,1,176,5,0,
		95,3,92,14,12,2,80,3,36,24,1,176,20,0,
		95,3,106,22,64,82,32,57,57,46,57,57,57,46,
		57,57,57,47,57,57,57,57,45,57,57,0,12,2,
		80,3,26,213,1,36,27,1,176,53,0,95,1,12,
		1,80,3,36,28,1,176,43,0,95,3,12,1,92,
		11,35,28,34,36,29,1,176,75,0,176,18,0,176,
		5,0,95,3,92,11,12,2,12,1,92,11,106,2,
		48,0,12,3,80,3,25,31,36,30,1,176,43,0,
		95,3,12,1,92,11,15,28,16,36,31,1,176,5,
		0,95,3,92,11,12,2,80,3,36,33,1,176,20,
		0,95,3,106,18,64,82,32,57,57,57,46,57,57,
		57,46,57,57,57,45,57,57,0,12,2,80,3,26,
		90,1,36,36,1,176,53,0,95,1,12,1,80,3,
		36,37,1,176,43,0,95,3,12,1,92,8,35,28,
		34,36,38,1,176,75,0,176,18,0,176,5,0,95,
		3,92,8,12,2,12,1,92,8,106,2,48,0,12,
		3,80,3,25,31,36,39,1,176,43,0,95,3,12,
		1,92,8,15,28,16,36,40,1,176,5,0,95,3,
		92,8,12,2,80,3,36,42,1,176,20,0,95,3,
		106,13,64,82,32,57,57,57,57,57,45,57,57,57,
		0,12,2,80,3,26,228,0,36,45,1,176,53,0,
		95,1,12,1,80,3,36,47,1,176,31,0,95,2,
		92,2,12,2,106,3,64,82,0,8,29,195,0,36,
		48,1,176,20,0,95,1,95,2,12,2,80,3,26,
		178,0,95,2,133,11,0,106,11,99,97,112,105,116,
		97,108,105,122,101,0,26,206,252,106,21,102,105,114,
		115,116,32,119,111,114,100,32,99,97,112,116,97,108,
		105,122,101,0,26,195,252,106,11,102,105,114,115,116,
		32,119,111,114,100,0,26,199,252,106,19,100,97,116,
		101,116,105,109,101,32,97,115,32,115,116,114,105,110,
		103,0,26,190,252,106,16,100,97,116,101,116,105,109,
		101,32,97,115,32,116,100,122,0,26,192,252,106,9,
		97,115,32,112,104,111,110,101,0,26,210,252,106,8,
		97,115,32,99,110,112,106,0,26,218,253,106,7,97,
		115,32,99,112,102,0,26,77,254,106,7,97,115,32,
		99,101,112,0,26,188,254,106,7,97,115,32,114,97,
		119,0,26,38,255,100,26,46,255,36,52,1,95,3,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( FORMAT_NUMBER )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,56,1,95,1,80,3,36,57,1,95,
		2,100,8,28,7,106,1,0,25,4,95,2,80,2,
		36,59,1,95,2,106,10,97,115,32,115,116,114,105,
		110,103,0,8,28,16,36,60,1,176,36,0,95,1,
		12,1,80,3,25,35,36,61,1,95,2,106,11,97,
		115,32,108,111,103,105,99,97,108,0,8,28,14,36,
		62,1,176,23,0,95,1,12,1,80,3,36,65,1,
		95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( AUX_IS_ALPHA )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,68,1,121,80,3,36,70,1,95,1,
		96,2,0,129,1,1,28,55,36,71,1,95,2,106,
		2,46,0,8,28,10,36,72,1,174,3,0,25,29,
		36,74,1,95,2,106,11,48,49,50,51,52,53,54,
		55,56,57,0,24,31,8,36,75,1,120,110,7,36,
		78,1,130,31,205,132,36,80,1,95,3,122,15,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( AUX_IS_DIGIT )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,83,1,121,80,3,36,85,1,95,1,
		96,2,0,129,1,1,28,55,36,86,1,95,2,106,
		2,46,0,8,28,10,36,87,1,174,3,0,25,29,
		36,89,1,95,2,106,11,48,49,50,51,52,53,54,
		55,56,57,0,24,31,8,36,90,1,9,110,7,36,
		93,1,130,31,205,132,36,95,1,95,3,92,2,15,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

