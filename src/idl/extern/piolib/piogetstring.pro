
;--------------------------------------------------------------#
;
; AUTOMATICALLY GENERATED DO NOT MODIFY 

;--------------------------------------------------------------#




;	Wrapping PIOGetString

FUNCTION PIOGETSTRING,MyData,Name,Attribs,MyIMO
     ON_ERROR,1
     PIOLibIDLSO=shared_lib_path('PIOLibIDL.so')
    MyData_TMP=BYTARR(128)
    MyData_TMP(*)=0
    if (N_ELEMENTS(MyData) GT 0) THEN if (STRLEN(MyData) GT 0) THEN MyData_TMP(0:STRLEN(MyData)-1)=BYTE(MyData)
    Name_TMP=BYTARR(128)
    Name_TMP(*)=0
    if (N_ELEMENTS(Name) GT 0) THEN if (STRLEN(Name) GT 0) THEN Name_TMP(0:STRLEN(Name)-1)=BYTE(Name)
    Attribs_TMP=BYTARR(128)
    Attribs_TMP(*)=0
    if (N_ELEMENTS(Attribs) GT 0) THEN if (STRLEN(Attribs) GT 0) THEN Attribs_TMP(0:STRLEN(Attribs)-1)=BYTE(Attribs)

 PIOGETSTRING=call_external(PIOLibIDLSO,'piogetstring_tempoidl', $
        MyData_TMP, $
        Name_TMP, $
        Attribs_TMP, $
        MyIMO, $
               /L64_VALUE) 
  MyData=STRING(MyData_TMP)
  Name=STRING(Name_TMP)
  Attribs=STRING(Attribs_TMP)

 RETURN,PIOGETSTRING
END
