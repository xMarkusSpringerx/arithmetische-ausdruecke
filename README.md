# Arithmetische Ausdrücke

## 1.Transformation arithmetischer Ausdrücke
Wie Sie wissen, können einfache arithmetische Ausdrücke in der Infix-Notation, z. B. (a + b) * c, durch folgende Grammatik beschrieben werden:

Expr = Term{'+'Term|'-'Term}. Term = Fact{'*'Fact|'/'Fact}. Fact = number | ident | '(' Expr ')' .

Die folgende attributierte Grammatik (ATG) beschreibt die Transformation einfacher arithmetischer Ausdrücke von der Infix- in die Postfix-Notation, z. B. von (a + b) * c nach a b + c *.

a) Entwickeln Sie eine ATG zur Transformation einfacher arithmetischer Ausdrücke von der Infix- in die Präfix-Notation, also z. B. von (a + b) * c nach * + a b c.
b) Implementieren Sie die ATG aus a) und testen Sie Ihre Implementierung ausführlich.
