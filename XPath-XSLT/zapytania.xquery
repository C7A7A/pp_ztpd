let $k := doc('file:///C:/studia/semestr_2/pp_ztpd/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW[ID_ZESP = /ZESPOLY/ROW/PRACOWNICY/ROW[NAZWISKO = 'BRZEZINSKI']/ID_ZESP]
return sum($k/PLACA_POD)

(:for $k in doc('file:///C:/studia/semestr_2/pp_ztpd/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW/PRACOWNICY/ROW[ID_SZEFA = 100]:)
(:return $k/NAZWISKO:)

(:for $k in count(doc('file:///C:/studia/semestr_2/pp_ztpd/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[ID_ZESP = 10]/PRACOWNICY/ROW):)
(:return $k:)

(:for $k in doc('file:///C:/studia/semestr_2/pp_ztpd/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[NAZWA = 'SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW:)
(:return $k/NAZWISKO:)
