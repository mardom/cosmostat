FUNCTION PIOREADTOIOBJECT,DATA,OBJNAME,TYPE,COMMAND,GROUP, $
              INDEX=INDEX,MASK=MASK,FLGOBJ=FLGOBJ,ATIDX=ATTIDX
ON_ERROR,1
PIOLibIDLSO=shared_lib_path('PIOLibIDL.so')

NBDATA = LONG64(0)
TPDATA =  LONG64(0)
TPDATA2 =  LONG64(0)
TPOBJ =  LONG64(0)
IFL=LONG64(0)
AtIdx=LONG64(0)

COMMAND=COMMAND+" "

IF (KEYWORD_SET(ATTIDX)) THEN BEGIN
    AtIdx=LONG64(N_ELEMENTS(ATTIDX))
    INDEX=LONG64(ATTIDX)
END

IF (KEYWORD_SET(MASK) AND NOT KEYWORD_SET(FLGOBJ)) THEN BEGIN
    MESSAGE,"If keyword MASK is set put also FLGOBJ",/continue
    RETURN,0
    END
IF (KEYWORD_SET(FLGOBJ) AND NOT KEYWORD_SET(MASK)) THEN BEGIN
    MESSAGE,"If keyword FLGOBJ is set put also MASK",/continue
    RETURN,0
    END
IF (KEYWORD_SET(FLGOBJ)) THEN IFL=LONG64(1) ELSE FLGOBJ=""

IF (N_PARAMS() LT 5) then BEGIN
    GROUP=long64(0)
    VGRP =byte(0)
END ELSE BEGIN
    GROUP=long64(GROUP)
    VGRP=byte(1)
END

GRPOBJ=PIOSTRING2C("")
testroi=0b

A = call_external(PIOLibIDLSO,'pioreadxxx_1idl',NBDATA, $
                  PIOSTRING2C(OBJNAME),PIOSTRING2C(FLGOBJ), $
                  PIOSTRING2C(TYPE),PIOSTRING2C(COMMAND), $
                  GROUP,TPOBJ,TPDATA,TPDATA2, $
                  PIOSTRING2C("TOI"),PIOSTRING2C("TOI"), $
                  GRPOBJ,testroi,IFL,AtIdx)

MULTI2D=0
MULTI3D=0
IF (NBDATA GT 0) THEN BEGIN

    CASE (STRING(TYPE)) OF
        "PIOFLAG": DATA = BYTARR(NBDATA)
        "PIOLONG": DATA = LON64ARR(NBDATA)
        "PIOBYTE": DATA = BYTARR(NBDATA)
        "PIOINT": DATA = LONARR(NBDATA)
        "PIOSTRING": DATA = BYTARR(128L*NBDATA)
        "PIOSHORT": DATA = INTARR(NBDATA)
        "PIOFLOAT": DATA = FLTARR(NBDATA)
        "PIODOUBLE": DATA = DBLARR(NBDATA)
        "PIOCOMPLEX": DATA = COMPLEXARR(NBDATA)
        "PIODBLCOMPLEX": DATA = DCOMPLEXARR(NBDATA)
    END
    
    IF (KEYWORD_SET(MASK) AND KEYWORD_SET(FLGOBJ)) THEN BEGIN
        MASK=BYTARR(NBDATA) 
        MDF=1
    END ELSE BEGIN
        MASK=0 
        MDF=0
    END 

    INDEX2=0
    INDEX3=0
    
    IF (KEYWORD_SET(INDEX) AND NOT KEYWORD_SET(ATIDX)) THEN BEGIN
        IF ('TOI' EQ 'TAB2D' OR 'TOI' EQ 'IMG2D') THEN BEGIN
            INDEX=LON64ARR(NBDATA)
            INDEX2=LON64ARR(NBDATA)
            MULTI2D=1
        END ELSE BEGIN
            IF ('TOI' EQ 'TAB3D' OR 'TOI' EQ 'IMG3D') THEN BEGIN
                INDEX=LON64ARR(NBDATA)
                INDEX2=LON64ARR(NBDATA)
                INDEX3=LON64ARR(NBDATA)
                MULTI3D=1
            END ELSE INDEX=LON64ARR(NBDATA)
        END
        IDF=1
    END ELSE BEGIN
        IF (NOT KEYWORD_SET(ATIDX)) THEN INDEX=0
        IDF=0
    END 
    IF (KEYWORD_SET(ATTIDX)) THEN BEGIN
        A = call_external(PIOLibIDLSO,'piosetobjectinfoidl',LONG(1),TPOBJ)
    END
    
    A = call_external(PIOLibIDLSO,'pioreadxxx_2idl',NBDATA, $
                  DATA,INDEX,INDEX2,INDEX3,MASK, $
                  PIOSTRING2C(OBJNAME),PIOSTRING2C(TYPE), $
                  PIOSTRING2C(COMMAND),PIOSTRING2C(FLGOBJ), $
                  GROUP,TPOBJ,TPDATA,TPDATA2,byte(IDF),byte(MDF),VGRP, $
                  PIOSTRING2C("TOI"),PIOSTRING2C("TOI"), $
                  GRPOBJ,testroi)
END

IF (STRING(TYPE) EQ "PIOSTRING" AND NBDATA GT 0) THEN BEGIN
    RES=STRARR(NBDATA)
    FOR I=0L,NBDATA-1 DO RES(I)=PIOSTRING2C(DATA[128*i:128*i+127])
    DATA=RES
    END
IF (NBDATA LT 0) THEN PIOERRMESS,NBDATA
IF (MULTI2D EQ 1) THEN BEGIN
    IDX=LON64ARR(NBDATA,2)
    IDX(*,0)=INDEX(0:NBDATA-1)
    IDX(*,1)=INDEX2(0:NBDATA-1)
    INDEX=IDX
    INDEX2=0
    IDX=0
END
IF (MULTI3D EQ 1) THEN BEGIN
    IDX=LON64ARR(NBDATA,3)
    IDX(*,0)=INDEX(0:NBDATA-1)
    IDX(*,1)=INDEX2(0:NBDATA-1)
    IDX(*,2)=INDEX3(0:NBDATA-1)
    INDEX=IDX
    INDEX3=0
    INDEX2=0
    IDX=0
END
RETURN,NBDATA
END
