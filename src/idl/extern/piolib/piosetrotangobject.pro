
;--------------------------------------------------------------#
;
; AUTOMATICALLY GENERATED DO NOT MODIFY 

;--------------------------------------------------------------#




;	Wrapping PIOSetRotAngObject

FUNCTION PIOSETROTANGOBJECT,RotAng,Objectname,MyGroup
     ON_ERROR,1
     PIOLibIDLSO=shared_lib_path('PIOLibIDL.so')
    if (N_ELEMENTS(RotAng) EQ 0) THEN     RotAng=DOUBLE(0) ELSE    RotAng=DOUBLE(RotAng)
     Objectname_TMP=BYTARR(128)
    Objectname_TMP(*)=0
    if (N_ELEMENTS(Objectname) GT 0) THEN if (STRLEN(Objectname) GT 0) THEN Objectname_TMP(0:STRLEN(Objectname)-1)=BYTE(Objectname)
IF (N_PARAMS() LT 3) THEN BEGIN
    MyGroup=long64(0)
END ELSE BEGIN
    MyGroup=long64(MyGroup)
END

 PIOSETROTANGOBJECT=call_external(PIOLibIDLSO,'piosetrotangobject_tempoidl', $
        RotAng, $
        Objectname_TMP, $
        MyGroup, $
               /L64_VALUE) 

 RETURN,PIOSETROTANGOBJECT
END