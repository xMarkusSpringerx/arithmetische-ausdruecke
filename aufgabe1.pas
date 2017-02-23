PROGRAM ExprPrg;


TYPE
    symbolCode = (
                  noSy,
                  eofSy,
                  plusSy, minusSy, timesSy, divSy,
                  leftParSy, rightParSy, numberSy
    );

CONST
  eofCh = Chr(0);

VAR
  line : STRING;
  cnr : INTEGER;
  ch : CHAR;
  sy : symbolCode;
  numberVal : INTEGER;
  success : BOOLEAN;
  numberStr : STRING;

PROCEDURE NewCh;
BEGIN
  IF cnr < Length(line) THEN BEGIN
    Inc(cnr);
    ch := Line[cnr];
  END ELSE BEGIN
    ch := eofCh;
  END;
END;


PROCEDURE NewSy;
VAR
  code : INTEGER;
BEGIN
  WHILE ch = ' ' DO BEGIN
    NewCh;
  END;

  CASE ch OF
    eofCh : BEGIN
              sy := eofSy;
            END;
    '+' : BEGIN
            sy := plusSy; NewCh;
          END;
    '-' : BEGIN
            sy := minusSy; NewCh;
          END;        
    '*' : BEGIN
            sy := timesSy; NewCh;
          END;  
    '/' : BEGIN
            sy := divSy; NewCh;
          END;  
    '(' : BEGIN
            sy := leftParSy; NewCh;
          END;  
    ')' : BEGIN
            sy := rightParSy; NewCh;
          END;  
    '0'..'9' : BEGIN
            sy := numberSy;
            numberStr := '';
            WHILE (ch >= '0') AND (ch<= '9') DO BEGIN
              numberStr := Concat(numberStr, ch);
              Newch;
            END;
          END;   
    ELSE
      sy := noSy;
  END;


END;

PROCEDURE Expr(VAR e: STRING); FORWARD;
PROCEDURE Term(VAR t: STRING); FORWARD;
PROCEDURE Fact(VAR f: STRING); FORWARD;


PROCEDURE S;
VAR
  e : STRING;
BEGIN
  cnr := 0;
  success := TRUE;
  NewCh;

  NewSy;
  
  Expr(e);


  IF sy <> eofSy THEN BEGIN
    success := FALSE;
  END;

  (* SEM *)
  
  IF success THEN BEGIN
    WriteLn('result =', e);

  END; 
  (* ENDSEM *)

END;

PROCEDURE Expr(VAR e: STRING);
VAR
  t : STRING;

BEGIN
  Term(e);
  WHILE(success) AND ((sy = plusSy) OR (sy = minusSy)) DO BEGIN
    CASE sy OF
      plusSy : BEGIN
                 
                 (* SEM *) e := '+' + e; (* ENDSEM *)
                 NewSy;
                 Term(t);
                 e := e + t;

               END;
      minusSy : BEGIN
                 (* SEM *) e := '-' + e; (* ENDSEM *)
                 NewSy;
                 Term(t);
                 e := e + t;
                END; 
    END;

  END;
END;

PROCEDURE Term(VAR t: STRING);
VAR
  f : STRING;

BEGIN
  Fact(t);
  WHILE(success) AND ((sy = timesSy) OR (sy = divSy)) DO BEGIN
    CASE sy OF
      timesSy : BEGIN
                  t := '*' + t;
                  NewSy;
                  Fact(f);
                  (* SEM *) t := t + f; (*ENDSEM*)
               END;
      divSy : BEGIN
                  t := '/' + t;
                  NewSy;
                  Fact(f);
                  (* SEM *) t := t + f; (*ENDSEM*)
                END; 
    END;
    
  END;
END;

PROCEDURE Fact(VAR f: STRING);
BEGIN
  CASE sy OF
    numberSy :  BEGIN
                  (* SEM *) f := numberStr; (* ENDSEM *)
                  NewSy;
                END;
    leftParSy : BEGIN
                  NewSy;
                  Expr(f);
                  IF (success) AND (sy <> rightParSy) THEN BEGIN
                    success := FALSE;
                  END;
                  IF (success) THEN BEGIN
                    NewSy;
                  END;
                END;
    ELSE
      success := FALSE;
  END;
END;

BEGIN

  REPEAT
    Write('enter arithmetic expression: ');
    ReadLn(line);

    IF Length(line) > 0 THEN BEGIN
      
      S;

      IF success THEN BEGIN
        WriteLn('valid expression');
      END ELSE BEGIN
        WriteLn('error in column', cnr);
      END;

    END;

  UNTIL Length(line) = 0;

END.