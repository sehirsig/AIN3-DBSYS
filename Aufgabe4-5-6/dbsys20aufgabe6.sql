/*
Aufgabe 6
a)
Buchungen sollen nicht gelöscht werden, sondern nur „storniert“. Erweitern Sie ihr Datenbankschema um
eine Tabelle für diese „stornierte Buchungen“. Nutzen Sie das Triggerkonzept, um sicherzustellen, dass
beim Löschen einer Buchung ein passender Eintrag in der Tabelle für „stornierte Buchungen“
vorgenommen wird. Für stornierte Buchungen soll zusätzlich das Stornierungsdatum automatisch
hinzugefügt werden.
*/
DROP TABLE Stornierung;

CREATE TABLE Stornierung
(
    bnmr        integer     NOT NULL,
    ende        Date        NOT NULL,
    anfang      Date        NOT NULL,
    bdatum      Date        NOT NULL,
    email       varchar2(64)NOT NULL,
    fwname      varchar2(64)NOT NULL,
    stodatum    Date        NOT NULL,
    CONSTRAINT Stornierung_pk PRIMARY KEY (bnmr),
    CONSTRAINT Stornierung_fk1 FOREIGN KEY (fwname)
    		REFERENCES Fwohnung(fwname),
    CONSTRAINT Stornierung_fk2 FOREIGN KEY (email) 
    		REFERENCES Kunde(email),
    CONSTRAINT Stornierung_datum CHECK ((ende - anfang) > 2)
);


CREATE OR REPLACE TRIGGER stornos
    BEFORE DELETE ON Buchung
    FOR EACH ROW
    BEGIN
        INSERT INTO Stornierung(bnmr, ende, anfang, bdatum, email, fwname, stodatum)
            VALUES(:old.bnmr, :old.ende, :old.anfang, :old.bdatum, :old.email, :old.fwname, TO_DATE(CURRENT_DATE, 'DD.MM.YY'));
    END;
/
    
/*
b)
Damit ein Mitarbeiter der Agentur schnell erkennen kann, ob ein Kunde ein geschätzter Stammkunde ist,
sollen Informationen wie die Anzahl bisher getätigter Buchungen und die Summe aller bisher gezahlter
Rechnungsbeträge zusammengefasst werden. Da diese Informationen sehr verteilt in der Datenbank
gespeichert sind, soll ein View erstellt werden, der diese Informationen zusammenfasst. Definieren Sie
einen View Kundenstatistik, der folgende Attribute besitzt: Kundennummer, Anzahl Buchungen, Anzahl
Stornierungen, Summe aller Zahlungen. Falls ein Kunde noch keine Buchungen bzw. keine Stornierungen
durchgeführt hat, soll die Zahl 0 erscheinen (nicht NULL).
*/

CREATE OR REPLACE VIEW KundenBuch(Kundennmr, anzBuchung, sumZahlung) AS
SELECT k.email, COUNT(b.bnmr), SUM(b.rbetrag)
FROM DBSYS20.Kunde k 
    LEFT OUTER JOIN DBSYS20.Buchung b ON k.email = b.email
GROUP BY k.email;

CREATE OR REPLACE VIEW KundenStor(Kundennmr, anzStornierung) AS
SELECT k.email, COUNT(s.bnmr)
FROM DBSYS20.Kunde k 
    LEFT OUTER JOIN DBSYS20.Stornierung s ON k.email = s.email
GROUP BY k.email;

CREATE OR REPLACE VIEW Kundenstatistik(Kundennmr, anzBuchung, anzStornierung, sumZahlung) AS
SELECT b.Kundennmr, b.anzBuchung , s.anzStornierung, b.sumZahlung
FROM DBSYS20.KundenBuch b, DBSYS20.KundenStor s
WHERE b.Kundennmr = s.Kundennmr;

SELECT * from Kundenstatistik;

INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
    VALUES(bnmr_ID.NextVal, '20.02.2022', '10.02.2022', 0, '02.06.2021', NULL, NULL, NULL, NULL, 30, 'hanswurst@gmail.com', 'Bruchbude');

DELETE FROM Buchung where bnmr = 100040;
/*
c)
Angenommen, der Befehl aus Aufgabe 4c ist zu langsam. Eine Analyse hat gezeigt, dass die Suche nach
Bewertungen mit mind. 4 Sternen die Ursache ist.
Definieren Sie einen Index, der die Suche beschleunigt
*/

CREATE INDEX idx_sterne on DBSYS20.Buchung(stern);