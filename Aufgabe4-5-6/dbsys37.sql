/*
Aufgabe 5
f) Wie viele Ferienwohnungen sind pro Stadtnamen gespeichert?
g) Geben Sie für einen Kunden Empfehlungen aus. Wenn ein Kunde K1 eine Wohnung W1 mit 5 Sterne
bewertet hat und ein Kunde K2 die Wohnung W1 ebenfalls mit 5 Sterne bewertet hat, dann sollen alle
weiteren Wohnungen, die K2 mit 5 Sternen bewertet hat als Empfehlung für K1 ausgegeben werden.
h) Untersuchen Sie, ob es Doppelbuchungen gibt. Geben Sie dazu alle Ferienwohnungen aus, für die es
zwei Buchungen gibt, die die Ferienwohnung am gleichen Tag reservieren. Hinweis: es ist kein
Problem, wenn ein Kunde die Ferienwohnung verlässt, und am gleichen Tag ein anderer Kunde
einzieht.
i) Welche Ferienwohnungen mit Sauna sind in Spanien in der Zeit vom 1.11.2021 ? 21.11.2021 noch
frei? Geben Sie den Ferienwohnungs-Namen und deren durchschnittliche Bewertung an.
Ferienwohnungen mit guten Bewertungen sollen zuerst angezeigt werden. Ferienwohnungen ohne
Bewertungen sollen am Ende ausgegeben werden.
*/

/*
a) Wie viele Ferienwohnungen wurden noch nie gebucht?
*/

SELECT COUNT(DISTINCT fw.fwname) as "Noch nie gebuchte Ferienwohnungen"
FROM DBSYS20.Fwohnung fw LEFT OUTER JOIN DBSYS20.Buchung b ON fw.fwname = b.fwname
WHERE b.fwname IS NULL;


/*
b) Welche Kunden haben eine Ferienwohnung bereits mehrmals gebucht?
*/

SELECT DISTINCT k.email
FROM DBSYS20.Kunde k, DBSYS20.Fwohnung fw, DBSYS20.Buchung b1, DBSYS20.Buchung b2
WHERE fw.fwname = b1.fwname
AND k.email = b1.email
AND b1.fwname = b2.fwname
AND b1.email = b2.email
AND b1.bnmr != b2.bnmr;

/*
c) Welche Ferienwohnungen in Spanien haben durchschnittlich mehr als 4 Sterne erhalten? |Gruppieren anstatt sub select
*/

SELECT fw.fwname/*, AVG(b1.stern)*/
FROM DBSYS20.Fwohnung fw, DBSYS20.Buchung b1, DBSYS20.Adresse adr
WHERE fw.fwname = b1.fwname
AND fw.adressID = adr.adressID
AND adr.lname = 'Spanien'
GROUP BY fw.fwname
    HAVING AVG(b1.stern) > 4


/*
d) Welche Ferienwohnung hat die meisten Ausstattungen?
*/

CREATE OR REPLACE VIEW anza(fwname, anz) AS
SELECT fw.fwname, COUNT(a.bez)
FROM DBSYS20.Fwohnung fw, DBSYS20.FWhatA fwa, DBSYS20.Ausstattung a
WHERE fw.fwname = fwa.fwname
AND fwa.bez = a.bez
GROUP BY fw.fwname;

SELECT fw.fwname, anza.anz as Anzahl
FROM anza, DBSYS20.Fwohnung fw
WHERE anza.fwname = fw.fwname
AND anz = (SELECT MAX(anz) from anza);

/*
e) Wie viele Reservierungen gibt es für die einzelnen Länder? Länder, in denen keine Reservierungen
existieren, sollen mit der Anzahl 0 ebenfalls aufgeführt werden. Das Ergebnis soll nach der Anzahl
Reservierungen absteigend sortiert werden.
*/

CREATE OR REPLACE VIEW wieRes(fwna, la) AS
SELECT fw.fwname, adr.lname
FROM DBSYS20.Fwohnung fw, DBSYS20.Adresse adr
WHERE fw.adressid = adr.adressID


SELECT wR.la, COUNT(b.bnmr)
FROM wieRes wR LEFT OUTER JOIN DBSYS20.Buchung b ON wR.fwna = b.fwname
GROUP BY wR.la
ORDER BY COUNT(b.bnmr) DESC;

/*
f) Wie viele Ferienwohnungen sind pro Stadtnamen gespeichert?
*/
SELECT ad.Stadt, Count(fw.fwname)
FROM DBSYS20.Adresse ad, DBSYS20.Fwohnung fw
WHERE ad.adressID = fw.adressID
GROUP BY ad.Stadt;

/*
g) Geben Sie für einen Kunden Empfehlungen aus. Wenn ein Kunde K1 eine Wohnung W1 mit 5 Sterne
bewertet hat und ein Kunde K2 die Wohnung W1 ebenfalls mit 5 Sterne bewertet hat, dann sollen alle
weiteren Wohnungen, die K2 mit 5 Sternen bewertet hat als Empfehlung für K1 ausgegeben werden
*/

CREATE OR REPLACE VIEW bewe(Kunaus, KunausFW, KunEmpf) AS
SELECT k1.email, b1.fwname, b2.email
FROM DBSYS20.Kunde k1, DBSYS20.Buchung b1, DBSYS20.Buchung b2
WHERE k1.email = b1.email
AND b1.stern = 5
AND b2.stern = 5
AND b1.fwname = b2.fwname
AND b1.email != b2.email;


SELECT vie.Kunaus as K1,vie.KunausFW as W1, vie.KunEmpf as K2, b.fwname as W2
FROM bewe vie, DBSYS20.Buchung b
WHERE b.email = vie.KunEmpf
AND vie.KunausFW != b.fwname
AND b.stern = 5;


/*
h) Untersuchen Sie, ob es Doppelbuchungen gibt. Geben Sie dazu alle Ferienwohnungen aus, für die es
zwei Buchungen gibt, die die Ferienwohnung am gleichen Tag reservieren. Hinweis: es ist kein
Problem, wenn ein Kunde die Ferienwohnung verlässt, und am gleichen Tag ein anderer Kunde
einzieht.
*/

SELECT DISTINCT b1.fwname
FROM DBSYS20.Buchung b1, DBSYS20.Buchung b2
WHERE b1.anfang <= b2.anfang
AND b1.ende > b2.anfang
AND b1.fwname = b2.fwname
AND b1.bnmr != b2.bnmr;

/*
i) Welche Ferienwohnungen mit Sauna sind in Spanien in der Zeit vom 1.11.2021 – 21.11.2021 noch
frei? Geben Sie den Ferienwohnungs-Namen und deren durchschnittliche Bewertung an.
Ferienwohnungen mit guten Bewertungen sollen zuerst angezeigt werden. Ferienwohnungen ohne
Bewertungen sollen am Ende ausgegeben werden.
*/

CREATE OR REPLACE VIEW durchschn(Fwname, Sterne) AS
SELECT fw.fwname, AVG(b.Stern)
FROM DBSYS20.FWohnung fw LEFT OUTER JOIN DBSYS20.Buchung b ON fw.fwname = b.fwname, DBSYS20.Adresse adr
WHERE fw.adressID = adr.adressID
AND adr.lname = 'Spanien'
GROUP BY fw.fwname;

SELECT d.fwname, d.sterne
FROM DBSYS20.FWhatA fwa, durchschn d
WHERE fwa.fwname = d.Fwname
AND fwa.bez = 'Sauna'
AND fwa.fwname NOT IN (SELECT b.fwname FROM DBSYS20.Buchung b
                        WHERE (TO_DATE(b.anfang, 'DD.MM.YY') <= '01.11.2021' AND TO_DATE(b.ende, 'DD.MM.YY') >= '21.11.2021')
                        OR (TO_DATE(b.anfang, 'DD.MM.YY') > '01.11.2021' AND TO_DATE(b.anfang, 'DD.MM.YY') < '21.11.2021')
                        OR (TO_DATE(b.ende, 'DD.MM.YY') > '01.11.2021' AND TO_DATE(b.ende, 'DD.MM.YY') <= '21.11.2021'))
ORDER BY d.sterne ASC;


/*
Aufgabe 7
*/
CREATE OR REPLACE VIEW durchschnFWBew(Fwname, Sterne) AS
SELECT fw.fwname, AVG(b.Stern)
FROM DBSYS20.FWohnung fw LEFT OUTER JOIN DBSYS20.Buchung b ON fw.fwname = b.fwname
GROUP BY fw.fwname;

SELECT * FROM durchschnFWBew;

commit;

SELECT * FROM DBSYS20.Fwohnung fw, DBSYS20.Adresse adr, DBSYS20.FWhatA fwa, DBSYS20.durchschnFWBew dFWb
WHERE fwa.fwname=fw.fwname
AND fw.adressID = adr.adressID
AND adr.lname='Spanien'
AND dFWb.Fwname = fw.fwname;


SELECT * FROM DBSYS20.Fwohnung fw, DBSYS20.Adresse adr, DBSYS20.FWhatA fwa, DBSYS20.durchschnFWBew dFWb WHERE fwa.fwname=fw.fwname AND fw.adressID=adr.adressID AND adr.lname='Spanien' AND dFWb.Fwname=fw.fwname;


SELECT l.bez FROM DBSYS20.Ausstattung l;

SELECT fw.preis from dbsys20.fwohnung fw;