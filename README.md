# Arithmetische Ausdrücke

## 1.Transformation arithmetischer Ausdrücke
Wie Sie wissen, können einfache arithmetische Ausdrücke in der Infix-Notation, z. B. (a + b) * c, durch folgende Grammatik beschrieben werden:

Expr = Term{'+'Term|'-'Term}. Term = Fact{'*'Fact|'/'Fact}. Fact = number | ident | '(' Expr ')' .

Die folgende attributierte Grammatik (ATG) beschreibt die Transformation einfacher arithmetischer Ausdrücke von der Infix- in die Postfix-Notation, z. B. von (a + b) * c nach a b + c *.

a) Entwickeln Sie eine ATG zur Transformation einfacher arithmetischer Ausdrücke von der Infix- in die Präfix-Notation, also z. B. von (a + b) * c nach * + a b c.
b) Implementieren Sie die ATG aus a) und testen Sie Ihre Implementierung ausführlich.

## 2. Arithmetische Ausdrücke und Binärbäume
Arithmetische Ausdrücke können auch in Form von Binärbäumen dar- gestellt werden. Z. B. entspricht dem Infix-Ausdruck (a + b) * c der rechts dargestellte Binärbaum.
a) Entwickeln Sie eine ATG, die arithmetische Infix-Ausdrücke in
Binärbäume (gemäß der Deklarationen unten) umwandelt.
b) Implementieren Sie die ATG aus a) und testen Sie Ihre Implementierung ausführlich.
c) Geben Sie die Ergebnisbäume durch entsprechende Baumdurchläufe in-order, pre-order und
post-order aus: Was stellen Sie dabei fest?
d) Implementieren Sie eine rekursive Funktion
### FUNCTION ValueOf(t: TreePtr): INTEGER;
die den Baum "auswertet", also den Wert des Ausdrucks berechnet, der durch den Baum reprä- sentiert wird. (Hinweis: In einem post-order-Baumdurchlauf zuerst den Wert des linken Unter- baums, dann den Wert des rechten Unterbaums berechnen und zum Schluss in Abhängigkeit vom Operator in der Wurzel den Gesamtwert berechnen).
