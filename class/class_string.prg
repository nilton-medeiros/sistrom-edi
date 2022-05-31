#include <hmg.ch>
#include "hbclass.ch"

class TString

	data Text			init "" readonly
	data TextPrevious	init "" readonly
	data cargo
	data raw

	method Add(cText) SETGET
	method At(SearchFor,BeginIndex,EndIndex) INLINE hb_At(SearchFor,::Text,BeginIndex,EndIndex)
	method AtIgnoreCase(SearchFor,BeginIndex,EndIndex) INLINE hb_AtI(SearchFor,::Text,BeginIndex,EndIndex)
	method Capitalize() SETGET
	method CompareTo(otherSring) INLINE (::Text == otherSring)
	method CompareCITo(otherSring) INLINE (HMG_LOWER(::Text) == HMG_LOWER(otherSring))
	method Contains(SearchFor) INLINE (SearchFor$::Text)
	method Empty() INLINE Empty(::Text)
	method FirstString() SETGET
	method get_numbers() SETGET
	method ifNull() SETGET
	method isAlpha() INLINE aux_is_alpha(::Text)
	method isDigit() INLINE aux_is_digit(::Text)
	method isLower() INLINE IsLower(::Text)
	method isUpper() INLINE IsUpper(::Text)
	method LastString() SETGET
	method Left(width) INLINE hb_ULeft(::Text,width)
	method Length() SETGET
	method LeftTrim() SETGET
	method PadCenter(width,fill) INLINE hb_UPadC(AllTrim(Right(::Text, width)), width, fill)
	method PadLeft(width,fill) INLINE hb_UPadL(AllTrim(Right(::Text, width)), width, fill)
	method PadRight(width,fill) INLINE hb_UPadR(AllTrim(Right(::Text, width)), width, fill)
	method RAt(SearchFor,BeginIndex,EndIndex) INLINE hb_RAt(SearchFor,::Text,BeginIndex,EndIndex)
	method RemoveAccents() SETGET
	method Right(width) INLINE hb_URight(::Text,width)
	method RightTrim() SETGET
	method Replace(LocateString,ReplaceString,FirstOccurrence,NumberOcurrence) INLINE StrTran(::Text,LocateString,ReplaceString,FirstOccurrence,NumberOcurrence)
	method setText(cText) SETGET
	method SubString(BeginIndex,width) INLINE hb_USubStr(::Text,BeginIndex,width)
	method ToLowerCase() SETGET
	method ToUpperCase() SETGET
	method ToNumbers() SETGET
	method Trim() SETGET
	method ANSIwebToUnicode(cText) SETGET
	method UnicodeToANSIweb(cText) SETGET
	method NEW(cText) CONSTRUCTOR

END class

method NEW(cText) class TString
	if ValType(cText)=="C"
		::Text := cText
		::TextPrevious := cText
		::raw := ::get_numbers()
	endif
RETURN SELF

method Add(cText) class TString
	::Text += cText
RETURN NIL

method Capitalize() class TString
	LOCAL index AS NUMERIC
	LOCAL capText := AllTrim(::textCurrent)

	capText := HMG_UPPER(hb_ULeft(capText,1)) + HMG_LOWER(hb_utf8SubStr(capText,2))
	capText := hb_utf8StrTran(capText, " ", Chr(176))
	index := AT(Chr(176),capText)

	do while index > 0
		capText := hb_ULeft(capText,index-1) + " " + HMG_UPPER(hb_utf8SubStr(capText,index+1,1)) + hb_utf8SubStr(capText,index+2)
		index := AT(Chr(176),capText)
	enddo

RETURN capText

method FirstString() class TString
	LOCAL i AS NUMERIC
	LOCAL r := ""

	if ! Empty(::Text)
		r := AllTrim(::Text)
		i := hb_UAt(" ", r)
		if (i==0)
			i := hb_ULen(r)
		endif
		r := hb_ULeft(r,i)
	endif

RETURN r

method get_numbers() class TString
	LOCAL r := ""
	LOCAL c AS CHARACTER

	if ! Empty(::Text)
		for each c in ::Text
			if c $ "0123456789"
				r += c
			endif
		next
	endif

RETURN r

method LastString() class TString
	LOCAL r := ""
	if ! Empty(::Text)
		r := hb_USubStr(RTrim(::Text), hb_RAt(" ",RTrim(::Text)))
	endif
RETURN r

method Length(raw) class TString
	default raw := false
	if raw
	   return hb_ULen(::get_numbers())
	endif
RETURN hb_ULen(::Text)

method LeftTrim() class TString
	::Text := LTrim(::Text)
RETURN ::Text

method RemoveAccents() class TString
	::Text := hb_utf8StrTran(::Text, "Ã", "A")
	::Text := hb_utf8StrTran(::Text, "Á", "A")
	::Text := hb_utf8StrTran(::Text, "À", "A")
	::Text := hb_utf8StrTran(::Text, "Â", "A")
	::Text := hb_utf8StrTran(::Text, "ã", "a")
	::Text := hb_utf8StrTran(::Text, "á", "a")
	::Text := hb_utf8StrTran(::Text, "à", "a")
	::Text := hb_utf8StrTran(::Text, "â", "a")
	::Text := hb_utf8StrTran(::Text, "Ä", "A")
	::Text := hb_utf8StrTran(::Text, "ä", "a")
	::Text := hb_utf8StrTran(::Text, "É", "A")
	::Text := hb_utf8StrTran(::Text, "È", "E")
	::Text := hb_utf8StrTran(::Text, "Ê", "E")
	::Text := hb_utf8StrTran(::Text, "é", "E")
	::Text := hb_utf8StrTran(::Text, "è", "e")
	::Text := hb_utf8StrTran(::Text, "ê", "e")
	::Text := hb_utf8StrTran(::Text, "Ë", "E")
	::Text := hb_utf8StrTran(::Text, "ë", "e")
	::Text := hb_utf8StrTran(::Text, "Í", "I")
	::Text := hb_utf8StrTran(::Text, "Ì", "I")
	::Text := hb_utf8StrTran(::Text, "Î", "I")
	::Text := hb_utf8StrTran(::Text, "í", "i")
	::Text := hb_utf8StrTran(::Text, "ì", "i")
	::Text := hb_utf8StrTran(::Text, "î", "i")
	::Text := hb_utf8StrTran(::Text, "Ï", "I")
	::Text := hb_utf8StrTran(::Text, "ï", "i")
	::Text := hb_utf8StrTran(::Text, "Õ", "o")
	::Text := hb_utf8StrTran(::Text, "Ó", "o")
	::Text := hb_utf8StrTran(::Text, "Ò", "o")
	::Text := hb_utf8StrTran(::Text, "Ô", "o")
	::Text := hb_utf8StrTran(::Text, "õ", "o")
	::Text := hb_utf8StrTran(::Text, "ó", "o")
	::Text := hb_utf8StrTran(::Text, "ò", "o")
	::Text := hb_utf8StrTran(::Text, "ô", "o")
	::Text := hb_utf8StrTran(::Text, "Ö", "O")
	::Text := hb_utf8StrTran(::Text, "ö", "o")
	::Text := hb_utf8StrTran(::Text, "Ú", "U")
	::Text := hb_utf8StrTran(::Text, "Ù", "U")
	::Text := hb_utf8StrTran(::Text, "Û", "U")
	::Text := hb_utf8StrTran(::Text, "ú", "U")
	::Text := hb_utf8StrTran(::Text, "ù", "U")
	::Text := hb_utf8StrTran(::Text, "û", "U")
	::Text := hb_utf8StrTran(::Text, "Ü", "U")
	::Text := hb_utf8StrTran(::Text, "ü", "u")
	::Text := hb_utf8StrTran(::Text, "Ý", "Y")
	::Text := hb_utf8StrTran(::Text, "ý", "y")
	::Text := hb_utf8StrTran(::Text, "ÿ", "y")
	::Text := hb_utf8StrTran(::Text, "Ç", "C")
	::Text := hb_utf8StrTran(::Text, "ç", "c")
	::Text := hb_utf8StrTran(::Text, "º", "o.")
	::Text := hb_utf8StrTran(::Text, "", "A")
	::Text := hb_utf8StrTran(::Text, "", "a")
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(173), "i") // i acentuado minusculo
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(135), "C") // c cedilha maiusculo
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(141), "I") // i acentuado maiusculo
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(163), "a") // a acentuado minusculo
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(167), "c") // c acentuado minusculo
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(161), "a") // a acentuado minusculo
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(131), "A") // a acentuado maiusculo
	::Text := hb_utf8StrTran(::Text, Chr(194) + Chr(186), "o.") // numero simbolo
	// so pra corrigir no MySql
	::Text := hb_utf8StrTran(::Text, "+" + Chr(129), "A")
	::Text := hb_utf8StrTran(::Text, "+" + Chr(137), "E")
	::Text := hb_utf8StrTran(::Text, "+" + Chr(131), "A")
	::Text := hb_utf8StrTran(::Text, "+" + Chr(135), "C")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(167), "c")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(163), "a")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(173), "i")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(131), "A")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(161), "a")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(141), "I")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(135), "C")
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(156), "a")
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(159), "A")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(129), "A")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(137), "E")
	::Text := hb_utf8StrTran(::Text, Chr(195) + "?", "C")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(149), "O")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(154), "U")
	::Text := hb_utf8StrTran(::Text, "+" + Chr(170), "o")
	::Text := hb_utf8StrTran(::Text, "?" + Chr(128), "A")
	::Text := hb_utf8StrTran(::Text, Chr(195) + Chr(166), "e")
	::Text := hb_utf8StrTran(::Text, Chr(135) + Chr(227), "ca")
	::Text := hb_utf8StrTran(::Text, "n" + Chr(227), "na")
	::Text := hb_utf8StrTran(::Text, Chr(162), "o")
RETURN ::Text

method RightTrim() class TString
	::Text := RTrim(::Text)
RETURN ::Text

method ToLowerCase() class TString
	::Text := HMG_LOWER(::Text)
RETURN ::Text

method ToUpperCase() class TString
	::Text := HMG_UPPER(::Text)
RETURN ::Text

method ToNumbers() class TString
RETURN hb_Val(::Text)

method setText(cText) class TString
	if ValType(cText)=="C"
		::TextPrevious := ::Text
		::Text := cText
	endif
RETURN ::Text

method Trim() class TString
	::Text := AllTrim(::Text)
RETURN ::Text

method ANSIwebToUnicode(cText) class TString
	DEFAULT cText := ::Text
	if ! Empty(cText)
		::Text := ansi_to_unicode(cText)
	endif
RETURN ::Text

method UnicodeToANSIweb(cText) class TString
	DEFAULT cText := ::Text
	if ! Empty(cText)
		cText := unicode_to_ansi(cText)
	endif
RETURN cText

method IFNULL() class TString
	LOCAL cText := "NULL"
	IF ! Empty(::Text)
		cText := "'" + ::UnicodeToANSIweb() + "'"
  END
Return cText
