PROGRAM ExprPrg;

TYPE
    symbolCode = (
                  noSy,
                  eofSy,
                  plusSy, minusSy, timesSy, divSy,
                  leftParSy, rightParSy, numberSy
    );

    NodePtr = ^Node;
    Node = RECORD
            left, right : NodePtr;
            txt: STRING;
           END;


    TreePtr = NodePtr;

CONST
  eofCh = Chr(0);

VAR
  line : STRING;
  cnr : INTEGER;
  ch : CHAR;
  sy : symbolCode;
  success : BOOLEAN;
  numberStr : STRING;


FUNCTION NewNode(val : STRING) : TreePtr;
VAR 
  n : TreePtr;
BEGIN
  New(n);
  n^.txt := val;
  n^.left := NIL;
  n^.right := NIL;
  
  NewNode := n;
END;

FUNCTION ValueOf(t : TreePtr):INTEGER;
VAR
  res : INTEGER;
BEGIN
  IF t <> NIL THEN BEGIN    
    CASE t^.txt[1] OF
    '+' : BEGIN
            ValueOf := ValueOf(t^.left) + ValueOf(t^.right); 
          END;
    '-' : BEGIN
            ValueOf := ValueOf(t^.left) - ValueOf(t^.right); 
          END;
    '*' : BEGIN
            ValueOf := ValueOf(t^.left) * ValueOf(t^.right); 
          END;
    '/' : BEGIN
            ValueOf := ValueOf(t^.left) DIV ValueOf(t^.right); 
          END;
    ELSE
      Val(t^.txt, res);
      ValueOf := res;
    END;

  END ELSE BEGIN

    ValueOf := 0;

  END;
  
END;

PROCEDURE WriteTreeInOrder(t : TreePtr);
BEGIN
  IF(t <> NIL) THEN BEGIN
    WriteTreeInOrder(t^.left);
    Write(t^.txt, ' ');
    WriteTreeInOrder(t^.right);
  END; (* ELSE DO NOTHING *)
END;

PROCEDURE WriteTreePostOrder(t : TreePtr);
BEGIN
  IF(t <> NIL) THEN BEGIN
    WriteTreePostOrder(t^.left);
    WriteTreePostOrder(t^.right);
    Write(t^.txt, ' ');
  END; (* ELSE DO NOTHING *)
END;

PROCEDURE WriteTreePreOrder(t : TreePtr);
BEGIN
  IF(t <> NIL) THEN BEGIN
    Write(t^.txt, ' ');
    WriteTreePreOrder(t^.left);
    WriteTreePreOrder(t^.right);
  END; (* ELSE DO NOTHING *)
END;


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

PROCEDURE Expr(VAR e: TreePtr); FORWARD;
PROCEDURE Term(VAR t: TreePtr); FORWARD;
PROCEDURE Fact(VAR f: TreePtr); FORWARD;


PROCEDURE S;
VAR
  tree : TreePtr;
BEGIN
  cnr := 0;
  success := TRUE;
  NewCh;

  NewSy;
  
  Expr(tree);


  IF sy <> eofSy THEN BEGIN
    success := FALSE;
  END;

  (* SEM *)
  WriteLn('InOrder: ');
  WriteTreeInOrder(tree);
  WriteLn();
  WriteLn('PreOrder: ');
  WriteTreePreOrder(tree);
  WriteLn();
  WriteLn('PostOrder: ');
  WriteTreePostOrder(tree);
  WriteLn();
  WriteLn('_________________');
  Write('Ergebnis: ', ValueOf(tree));
  WriteLn();
  WriteLn();
  IF success THEN BEGIN
    //WriteLn('result =', e);

  END; 
  (* ENDSEM *)

END;

PROCEDURE Expr(VAR e: TreePtr);
VAR
  tree : TreePtr;

BEGIN
  Term(e);
  
  WHILE(success) AND ((sy = plusSy) OR (sy = minusSy)) DO BEGIN

    CASE sy OF
      plusSy : BEGIN   
                  tree := NewNode('+');
                  tree^.left := e;
                  NewSy;
                  Term(tree^.right);
                  e := tree;
                END;

      minusSy : BEGIN
                  tree := NewNode('-');
                  tree^.left := e;
                  NewSy;
                  Term(tree^.right);
                  e := tree;
                END; 
    END;

  END;
END;


PROCEDURE Term(VAR t: TreePtr);
VAR
  tree : TreePtr;

BEGIN
  Fact(t);
  WHILE(success) AND ((sy = timesSy) OR (sy = divSy)) DO BEGIN
    CASE sy OF
      timesSy : BEGIN                 
                  tree := NewNode('*');
                  tree^.left := t;
                  NewSy;
                  Fact(tree^.right);
                  t := tree;
               END;
      divSy : BEGIN

                  tree := NewNode('/');
                  tree^.left := t;
                  NewSy;
                  Fact(tree^.right);
                  t := tree;
                  
                END; 
    END;
    
  END;
END;

PROCEDURE Fact(VAR f: TreePtr);
BEGIN
  CASE sy OF
    numberSy :  BEGIN
                  (* SEM *) f := NewNode(numberStr); (* ENDSEM *)
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