DROP TABLE inNaehe;
DROP TABLE Tattraktion;
DROP TABLE FWhatA;
DROP TABLE Ausstattung;
DROP TABLE Foto;
DROP TABLE Anzahlung;
DROP TABLE Buchung;
DROP TABLE Fwohnung;
DROP TABLE Kunde;
DROP TABLE Adresse;
DROP TABLE Land;

DROP SEQUENCE bnmr_ID;
DROP SEQUENCE rnmr_ID;
DROP SEQUENCE anmr_ID;
DROP SEQUENCE foto_ID;
DROP SEQUENCE adress_ID;

/*REFERENCE REIHENFOLGE:
Land -> Adresse -> Kunde -> Fwohnung -> Buchung -> Anzahlung -> Foto ->  Ausstattung -> FWhatA -> Tattraktion -> inNaehe
*/
CREATE TABLE Land
(
    lname       varchar2(30) NOT NULL,
    CONSTRAINT Land_pk PRIMARY KEY (lname),
    CONSTRAINT Land_lname CHECK(LENGTH(lname) > 1)
);

CREATE TABLE Adresse
(
    adressID    integer         NOT NULL,
    plz         varchar2(10)    NOT NULL,
    strasse     varchar2(64)    NOT NULL,
    hnmr        varchar2(10)    NOT NULL,
    stadt       varchar2(30)    NOT NULL,
    lname       varchar2(30)    NOT NULL,
    CONSTRAINT Adresse_pk PRIMARY KEY (adressID),
    CONSTRAINT Adresse_fk FOREIGN KEY (lname)
    		REFERENCES Land(lname),
    CONSTRAINT Adresse_plz  CHECK(LENGTH(plz) > 0),
    CONSTRAINT Adresse_strasse CHECK(LENGTH(strasse) > 0),
    CONSTRAINT Adresse_hnmr CHECK(LENGTH(hnmr) > 0),
    CONSTRAINT Adresse_stadt CHECK(LENGTH(stadt) > 0 )
);


CREATE TABLE Kunde
(
    email       varchar2(64)    NOT NULL,
    vname       varchar2(30)    NOT NULL,
    nname       varchar2(30)    NOT NULL,
    iban        varchar2(34)    NOT NULL,
    pw          varchar2(20)    NOT NULL,
    newsletter  char(1) NOT NULL, /* Boolean */
    adressID    integer NOT NULL,
    
    CONSTRAINT Kunde_pk PRIMARY KEY (email),
    CONSTRAINT Kunde_fk FOREIGN KEY (adressID)
    		REFERENCES Adresse(adressID),
    CONSTRAINT Kunde_email CHECK(email LIKE '%_@_%._%'),
    CONSTRAINT Kunde_vname CHECK(LENGTH(vname) > 1),
    CONSTRAINT Kunde_nname CHECK(LENGTH(nname) > 1),
    CONSTRAINT Kunde_iban CHECK(LENGTH(iban) > 14),
    CONSTRAINT Kunde_pw CHECK(LENGTH(pw) > 7),
    CONSTRAINT Kunde_newsletter CHECK(newsletter in ('0', '1'))
);


CREATE TABLE Fwohnung
(
    fwname      varchar2(64)    NOT NULL,
    groesse     integer         NOT NULL,
    preis       integer         NOT NULL,
    zanzahl     integer         NOT NULL,
    adressID    integer         NOT NULL,
    CONSTRAINT Fwohnung_pk PRIMARY KEY (fwname),
    CONSTRAINT Fwohnung_fk FOREIGN KEY (adressID)
    		REFERENCES Adresse(adressID),
    CONSTRAINT Fwohnung_fwname CHECK(LENGTH(fwname) > 1),
    CONSTRAINT Fwohnung_groesse CHECK(groesse > 0),
    CONSTRAINT Fwohnung_preis CHECK(preis > 0),
    CONSTRAINT Fwohnung_zanzahl CHECK(zanzahl > 0)
             
);

CREATE TABLE Buchung
(
    bnmr        integer     NOT NULL,
    ende        Date        NOT NULL,
    anfang      Date        NOT NULL,
    status      char(1)     NOT NULL, /* Boolean */
    bdatum      Date        NOT NULL,
    bwdatum     Date,
    stern       integer,
    rdatum      Date,
    rnmr        integer,
    rbetrag     integer,
    email       varchar2(64)NOT NULL,
    fwname      varchar2(64) NOT NULL,
    CONSTRAINT Buchung_pk PRIMARY KEY (bnmr),
    CONSTRAINT Buchung_fk1 FOREIGN KEY (fwname)
    		REFERENCES Fwohnung(fwname),
    CONSTRAINT Buchung_fk2 FOREIGN KEY (email) 
    		REFERENCES Kunde(email),
    CONSTRAINT Buchung_datum CHECK ((ende - anfang) > 2),
    CONSTRAINT Buchung_bwdatum CHECK((bwdatum - ende) > 0),
    CONSTRAINT Buchung_stern CHECK(stern > 0 AND stern < 7),
    CONSTRAINT Buchung_status CHECK(status in ('0', '1'))
);



CREATE TABLE Anzahlung
(
    anmr        integer         NOT NULL,
    abetrag     integer         NOT NULL, 
    zdatum      date            NOT NULL,
    enthaelt    integer    	 NOT NULL, 
    CONSTRAINT Anzahlung_pk PRIMARY KEY (anmr),
    CONSTRAINT Anzahlung_fk FOREIGN KEY (enthaelt)
    		REFERENCES Buchung(bnmr)
);


CREATE TABLE Foto
(
    fotoID      integer         NOT NULL,
    jpg         blob            NOT NULL,
    fwname      varchar2(64)    NOT NULL,
    
    CONSTRAINT Foto_pk PRIMARY KEY(fotoID),
    CONSTRAINT Foto_fk FOREIGN KEY(fwname)
    		REFERENCES Fwohnung(fwname)
   		ON DELETE CASCADE
);


CREATE TABLE Ausstattung
(
    bez         varchar(128)    NOT NULL,
    
    CONSTRAINT Ausstattung_pk PRIMARY KEY(bez),
    CONSTRAINT Ausstattung_bez CHECK(LENGTH(bez) > 0)
);


CREATE TABLE FWhatA
(
    fwname      varchar2(64)    NOT NULL,
    bez         varchar2(128)   NOT NULL,
    CONSTRAINT FWhatA_pk PRIMARY KEY(fwname, bez),
    CONSTRAINT FWhatA_fk1 FOREIGN KEY(fwname) 
    		REFERENCES Fwohnung(fwname)
    		ON DELETE CASCADE,
    CONSTRAINT FWhatA_fk2 FOREIGN KEY(bez)
    		REFERENCES Ausstattung(bez)
    		ON DELETE CASCADE  
);


CREATE TABLE Tattraktion
(
    tname       varchar2(64)    NOT NULL,
    bes         varchar(128)    NOT NULL,
    adressID    integer         NOT NULL,
    CONSTRAINT Tattraktion_pk PRIMARY KEY (tname),
    CONSTRAINT Tattraktion_fk FOREIGN KEY (adressID)
    		REFERENCES Adresse(adressID),
    CONSTRAINT Tattraktion_tname CHECK(LENGTH(tname) > 1),
    CONSTRAINT Tattraktion_bes CHECK(LENGTH(bes) > 1)
);




CREATE TABLE inNaehe
(
    fwname      varchar2(64)    NOT NULL,
    tname       varchar2(64)    NOT NULL,
    entfernung  integer         NOT NULL,
    CONSTRAINT inNaehe_pk PRIMARY KEY (fwname, tname),
    CONSTRAINT inNaehe_fk1 FOREIGN KEY (fwname) 
    		REFERENCES Fwohnung(fwname)
    		ON DELETE CASCADE,
    CONSTRAINT inNaehe_fk2 FOREIGN KEY (tname) 
    		REFERENCES Tattraktion(tname)
    		ON DELETE CASCADE,
    CONSTRAINT inNaehe_entfernung CHECK(entfernung <= 50)
);



CREATE SEQUENCE bnmr_ID INCREMENT BY 1 START WITH 100000;
CREATE SEQUENCE rnmr_ID INCREMENT BY 1 START WITH 100000;
CREATE SEQUENCE anmr_ID INCREMENT BY 1 START WITH 100000;
CREATE SEQUENCE foto_ID INCREMENT BY 1 START WITH 100000;

/*
a) Wie viele Ferienwohnungen wurden noch nie gebucht?
b) Welche Kunden haben eine Ferienwohnung bereits mehrmals gebucht?
c) Welche Ferienwohnungen in Spanien haben durchschnittlich mehr als 4 Sterne erhalten?
d) Welche Ferienwohnung hat die meisten Ausstattungen?
e) Wie viele Reservierungen gibt es für die einzelnen Länder? Länder, in denen keine Reservierungen
existieren, sollen mit der Anzahl 0 ebenfalls aufgeführt werden. Das Ergebnis soll nach der Anzahl
Reservierungen absteigend sortiert werden.
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

~10 buchung
~5 FW
*/

INSERT INTO Land(lname)
    VALUES ('Deutschland');
INSERT INTO Land(lname)
    VALUES ('Schweiz');
INSERT INTO Land(lname)
    VALUES ('Österreich');
INSERT INTO Land(lname)
    VALUES ('Spanien');

/* Ausstattungen */
INSERT INTO Ausstattung(bez)
    VALUES('Sauna');
    
INSERT INTO Ausstattung(bez)
    VALUES('Pool');

INSERT INTO Ausstattung(bez)
    VALUES('Balkon');
    
INSERT INTO Ausstattung(bez)
    VALUES('Gym');

/* Personen */

/* Max muster */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (111100, '50667', 'Marie Strasse', '20', 'Köln', 'Deutschland');
INSERT INTO Kunde(email, vname, nname, iban, pw, newsletter, adressID)
    VALUES ('maxmuster@gmail.com', 'Max', 'Muster', 'CH21500105176686774648', 'abcdefgh', '0', 111100);

/* Hanswurst */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (111110, '50667', 'Albert Strasse', '3', 'Köln', 'Deutschland');
INSERT INTO Kunde(email, vname, nname, iban, pw, newsletter, adressID)
    VALUES ('hanswurst@gmail.com', 'Hans', 'Wurst', 'DE21500105176686774648', '12345678', '1', 111110);

/* nina natz */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (000011, '8280', 'Kreuzstrasse', '10', 'Kreuzlingen', 'Schweiz');
INSERT INTO Kunde(email, vname, nname, iban, pw, newsletter, adressID)
    VALUES ('ninanatz@gmail.com', 'Nina', 'Natz', 'DE123215001051766867', 'a22d445gh', '0', 000011);

/* hanna hall */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (110000, '8280', 'Sonnenstrasse', '10', 'Kreuzlingen', 'Schweiz');
INSERT INTO Kunde(email, vname, nname, iban, pw, newsletter, adressID)
    VALUES ('hannahall@gmail.com', 'Hanna', 'Hall', 'IT215001051766867', 'abcd445gh', '1', 110000);

/* Ferienwohnungen */
    
/* JupiterHaus */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (845627, '46001', 'la calle del sol', '5', 'Valencia', 'Spanien');
INSERT INTO Fwohnung(fwname, groesse, preis, zanzahl, adressID)
    VALUES ('Jupiterhaus', 150, 230, 5, 845627);
INSERT INTO Foto(fotoID, jpg, fwname)
    VALUES(foto_ID.NextVal, '1001', 'Jupiterhaus');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Jupiterhaus', 'Sauna');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Jupiterhaus', 'Balkon');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Jupiterhaus', 'Pool');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Jupiterhaus', 'Gym');

/* Saturnhaus */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (789456, '46001', 'la calle del luna', '7', 'Valencia', 'Spanien');
INSERT INTO Fwohnung(fwname, groesse, preis, zanzahl, adressID)
    VALUES ('Saturnhaus', 80, 80, 2, 789456);
INSERT INTO Foto(fotoID, jpg, fwname)
    VALUES(foto_ID.NextVal, '1001', 'Saturnhaus');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Saturnhaus', 'Sauna');

/* Bruchbude */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (654872, '50667', 'Albert Goethe Strasse', '4', 'Köln', 'Deutschland');
INSERT INTO Fwohnung(fwname, groesse, preis, zanzahl, adressID)
    VALUES ('Bruchbude', 15, 30, 2, 654872);
INSERT INTO Foto(fotoID, jpg, fwname)
    VALUES(foto_ID.NextVal, '1001', 'Bruchbude');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Bruchbude', 'Sauna');

/* Marshaus */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (852963, '46001', 'la calle del mars', '51', 'Valencia', 'Spanien');
INSERT INTO Fwohnung(fwname, groesse, preis, zanzahl, adressID)
    VALUES ('Marshaus', 150, 230, 5, 852963);
INSERT INTO Foto(fotoID, jpg, fwname)
    VALUES(foto_ID.NextVal, '1001', 'Marshaus');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Marshaus','Sauna');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Marshaus','Balkon');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Marshaus','Pool');
    
/* Neptunhaus */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (782615, '41201', 'la calle del nemptun', '1', 'Barcelona', 'Spanien');
INSERT INTO Fwohnung(fwname, groesse, preis, zanzahl, adressID)
    VALUES ('Neptunhaus', 90, 130, 2, 782615);
INSERT INTO Foto(fotoID, jpg, fwname)
    VALUES(foto_ID.NextVal, '1001', 'Neptunhaus');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Neptunhaus','Balkon');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Neptunhaus','Pool');

/* Bierlounge */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (123456, '8280', 'Kreuzlingerstrasse', '2', 'Kreuzlingen', 'Schweiz');
INSERT INTO Fwohnung(fwname, groesse, preis, zanzahl, adressID)
    VALUES ('Bierlounge', 150, 300, 2, 123456);
INSERT INTO Foto(fotoID, jpg, fwname)
    VALUES(foto_ID.NextVal, '1001', 'Bierlounge');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Bierlounge','Sauna');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Bierlounge','Pool');

/* Gaudihaus */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (232323, '1100', 'Tellgasse', '3', 'Wien', 'Österreich');
INSERT INTO Fwohnung(fwname, groesse, preis, zanzahl, adressID)
    VALUES ('Gaudihaus', 120, 250, 3, 232323);
INSERT INTO Foto(fotoID, jpg, fwname)
    VALUES(foto_ID.NextVal, '1001', 'Gaudihaus');
INSERT INTO FWhatA(fwname, bez)
    VALUES ('Gaudihaus','Sauna');

    
/* Attraktionen */

/* Bierhaus */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (000788, '8280', 'Kreuzlingerstrasse', '10', 'Kreuzlingen', 'Schweiz');
INSERT INTO Tattraktion(tname, bes, adressID)
    VALUES ('Bierhaus', 'Viel Durst.', 000788);

/* Planetarium */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (789457, '46001', 'Porto nuovo', '10', 'Valencia', 'Spanien');
INSERT INTO Tattraktion(tname, bes, adressID)
    VALUES ('Planetarium', 'Viele Runden drehen', 789457);

/* Todesrad */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (159264, '50667', 'Albert Goethe Strasse', '20', 'Köln', 'Deutschland');
INSERT INTO Tattraktion(tname, bes, adressID)
    VALUES ('Todesrad', 'Viel Glück.', 159264);

/* Freudenhaus */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (852964, '46001', 'Porto anno', '10', 'Valencia', 'Spanien');
INSERT INTO Tattraktion(tname, bes, adressID)
    VALUES ('Freudenhaus', 'Viel Spass.', 852964);

/* Pirateninsel */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (782616, '41201', 'la calle del sole', '11', 'Barcelona', 'Spanien');
INSERT INTO Tattraktion(tname, bes, adressID)
    VALUES ('Pirateninsel', 'Achtung, diebisch gut!.', 782616);

/* Rutschpark */
INSERT INTO Adresse(adressID, plz, strasse, hnmr, stadt, lname)
    VALUES (852961, '46001', 'Porto male', '10', 'Valencia', 'Spanien');
INSERT INTO Tattraktion(tname, bes, adressID)
    VALUES ('Rutschpark', 'Achtung, Rutschgefahr!', 852961);


/* in Naehe */
INSERT INTO inNaehe(fwname, tname, entfernung)
    VALUES ('Bierlounge', 'Bierhaus', 1);

INSERT INTO inNaehe(fwname, tname, entfernung)
    VALUES ('Saturnhaus', 'Planetarium', 11);

INSERT INTO inNaehe(fwname, tname, entfernung)
    VALUES ('Bruchbude', 'Todesrad', 15);

INSERT INTO inNaehe(fwname, tname, entfernung)
    VALUES ('Jupiterhaus', 'Freudenhaus', 2);

INSERT INTO inNaehe(fwname, tname, entfernung)
    VALUES ('Marshaus', 'Rutschpark', 20);

INSERT INTO inNaehe(fwname, tname, entfernung)
    VALUES ('Neptunhaus', 'Pirateninsel', 2);

/* fwohnung ohne buchung, Bierlounge, schweiz  a) */

/* fwohnung ohne buchung , Saturnhaus, spanien valencia , f)*/

/* buchung nummer eins, hans wurst bruchbude 01.01.2021 03.01.2021 b) */

INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
    VALUES(bnmr_ID.NextVal, '25.05.2021', '10.05.2021', 0, '01.05.2021', NULL, NULL, '05.05.2021', rnmr_ID.NextVal, 30, 'hanswurst@gmail.com', 'Bruchbude');

INSERT INTO Anzahlung(anmr, abetrag, zdatum, enthaelt)
    VALUES(anmr_ID.NextVal, 30, '06.05.2021', bnmr_ID.CurrVal);


/* buchung nummer 2 , 5 sterne , Jupiterhaus bewertet, 05.05.2021 - 09.05.2021 d) h)*/

INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
    VALUES(bnmr_ID.NextVal, '21.11.2021', '1.11.2021', 0, '10.10.2021', '23.11.2021', 5, '15.10.2021', rnmr_ID.NextVal, 450, 'maxmuster@gmail.com', 'Jupiterhaus');

INSERT INTO Anzahlung(anmr, abetrag, zdatum, enthaelt)
    VALUES(anmr_ID.NextVal, 230, '20.10.2021', bnmr_ID.CurrVal);


/* buchung nummer drei hans wurst bruchbude 01.01.2020 - 03.01.2020 b)*/

INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
    VALUES(bnmr_ID.NextVal, '12.12.2021', '01.12.2021', 0, '10.11.2021', NULL, NULL, '15.11.2021', rnmr_ID.NextVal, 30, 'hanswurst@gmail.com', 'Bruchbude');

INSERT INTO Anzahlung(anmr, abetrag, zdatum, enthaelt)
    VALUES(anmr_ID.NextVal, 30, '20.11.2021', bnmr_ID.CurrVal);
    

/* buchung nummer vier hanna hall jupiterhaus 05.05.2021 - 09.05.2021 d) h)  */

INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
    VALUES(bnmr_ID.NextVal, '05.12.2021', '21.11.2021', 0, '30.10.2021', '06.12.2021', 5, '03.11.2021', rnmr_ID.NextVal, 150, 'hannahall@gmail.com', 'Jupiterhaus');

INSERT INTO Anzahlung(anmr, abetrag, zdatum, enthaelt)
    VALUES(anmr_ID.NextVal, 150, '10.11.2021', bnmr_ID.CurrVal);


/* buchung nummer fünf nina natz marshaus 01.11.2021 - 21.11.2021 d) h) g) */

INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
    VALUES(bnmr_ID.NextVal, '12.12.2021', '01.12.2021', 0, '30.10.2021', '15.12.2021', 5, '03.11.2021', rnmr_ID.NextVal, 150, 'ninanatz@gmail.com', 'Marshaus');

INSERT INTO Anzahlung(anmr, abetrag, zdatum, enthaelt)
    VALUES(anmr_ID.NextVal, 150, '10.11.2021', bnmr_ID.CurrVal);


/* buchung nummer sechs hanna hall marshaus 05.05.2021 - 09.05.2021  K1 g) */

INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
    VALUES(bnmr_ID.NextVal, '11.12.2021', '01.12.2021', 0, '01.11.2021', '22.12.2021', 5, '11.11.2021', rnmr_ID.NextVal, 150, 'hannahall@gmail.com', 'Marshaus');

INSERT INTO Anzahlung(anmr, abetrag, zdatum, enthaelt)
    VALUES(anmr_ID.NextVal, 150, '20.11.2021', bnmr_ID.CurrVal);
    

/* buchung nummer sieben nina natz Neptunhaus  05.05.2021 - 09.05.2021  K2 g) */

INSERT INTO Buchung(bnmr, ende, anfang, status, bdatum, bwdatum, stern, rdatum, rnmr, rbetrag, email, fwname)
    VALUES(bnmr_ID.NextVal, '02.02.2022', '20.01.2022', 0, '02.01.2022', '05.02.2022', 5, '05.01.2022', rnmr_ID.NextVal, 130, 'ninanatz@gmail.com', 'Neptunhaus');

INSERT INTO Anzahlung(anmr, abetrag, zdatum, enthaelt)
    VALUES(anmr_ID.NextVal, 130, '20.01.2022', bnmr_ID.CurrVal);



GRANT SELECT
ON Land
TO dbsys37;

GRANT SELECT
ON Anzahlung
TO dbsys37;

GRANT SELECT, INSERT/*, INSERT, UPDATE*/
ON Buchung
TO dbsys37;

GRANT SELECT/*, INSERT, UPDATE*/
ON Kunde
TO dbsys37;

GRANT SELECT/*, INSERT, UPDATE*/
ON Adresse
TO dbsys37;

GRANT SELECT
ON Fwohnung
TO dbsys37;

GRANT SELECT
ON Foto
TO dbsys37;

GRANT SELECT
ON Ausstattung
TO dbsys37;

GRANT SELECT
ON FWhatA
TO dbsys37;

GRANT SELECT
ON Tattraktion
TO dbsys37;

GRANT SELECT
ON inNaehe
TO dbsys37;

/*
Aufgabe 7
*/
GRANT SELECT
ON durchschnFWBew
TO dbsys37;

GRANT SELECT, ALTER
ON bnmr_ID
TO dbsys37;

GRANT SELECT, ALTER
ON rnmr_ID
TO dbsys37;

COMMIT;
rollback;