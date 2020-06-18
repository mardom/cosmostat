FUNCTION PIOSETVALUE,DATA,ERRDATA,TYPE,UNIT,COMMENT,NAME,GROUPUNIT

PIOLibIDLSO=shared_lib_path('PIOLibIDL.so')

 CASE (STRING(TYPE)) OF
     "PIOLONG": BEGIN
         DATA = LONG64(DATA)
         ERRDATA = LONG64(ERRDATA)
         END
     "PIOBYTE": BEGIN
         DATA = BYTE(DATA)
         ERRDATA = BYTE(ERRDATA)
         END
     "PIOSHORT": BEGIN
         DATA = FIX(DATA)
         ERRDATA = FIX(ERRDATA)
         END
     "PIOFLOAT": BEGIN
         DATA = FLOAT(DATA)
         ERRDATA = FLOAT(ERRDATA)
         END
     "PIODOUBLE":BEGIN
          DATA = DOUBLE(DATA)
          ERRDATA = DOUBLE(ERRDATA)
         END
     "PIOCOMPLEX": BEGIN
         DATA = COMPLEX(DATA)
         DATA = COMPLEX(ERRDATA)
         END
     "PIODBLCOMPLEX": BEGIN
         DATA = DCOMPLEX(DATA)
         ERRDATA = DCOMPLEX(ERRDATA)
         END
     ELSE : return,0
 END

RETURN,call_external(PIOLibIDLSO,'piosetvalueidl', $
              DATA,ERRDATA,PIOSTRING2C(TYPE),PIOSTRING2C(NAME), $
              PIOSTRING2C(COMMENT),PIOSTRING2C(UNIT), $
              LONG64(GROUPUNIT),/L64_VALUE)

END
