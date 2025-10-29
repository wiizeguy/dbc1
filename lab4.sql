-- 1
CREATE TABLE pracownik (
	id_pracownika INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	imie VARCHAR(40) NOT NULL,
	nazwisko VARCHAR(40) NOT NULL,
	data_urodzenia DATE NOT NULL
); -- 1.1

INSERT INTO pracownik(imie, nazwisko, data_urodzenia) VALUES ('Jan', 'Nowak', '1999-07-18'), ('Janusz', 'Kowalski', '1995-05-01'), ('Andrzej', 'Zet', '1988-01-15'); -- 1.2

UPDATE pracownik SET data_urodzenia='1810-08-08' WHERE id_pracownika=1; -- 1.3

-- 2
CREATE TABLE zadanie (
	id_zadania INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nazwa_zadania VARCHAR(150) NOT NULL,
	priorytet ENUM('normalny', 'wysoki', 'niski'),
	opis LONGTEXT,
	pracownik INT,
	FOREIGN KEY (pracownik) REFERENCES pracownik(id_pracownika) ON DELETE SET NULL
); -- 2.1

ALTER TABLE zadanie MODIFY COLUMN priorytet ENUM('normalny', 'wysoki', 'niski') DEFAULT 'normalny'; -- 2.2

INSERT INTO zadanie (nazwa_zadania, pracownik) VALUES ('Zadanie1', 1), ('Zadanie2', 2), ('Zadanie3', 3); -- 2.3

-- 3
CREATE TABLE projekt (
	id_projektu INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nazwa_projektu VARCHAR(150) NOT NULL,
	data_rozpoczecia DATE NOT NULL,
	data_zakonczenia DATE
); -- 3.1

ALTER TABLE projekt ADD COLUMN menadzer_projektu INT NOT NULL, ADD CONSTRAINT fk_menadzer_projektu FOREIGN KEY (menadzer_projektu) REFERENCES pracownik(id_pracownika); -- 3.2

INSERT INTO projekt(nazwa_projektu, data_rozpoczecia, menadzer_projektu) VALUES ('nazwaProj1', '1998-10-10', 1), ('nazwaProj2', '1991-04-05', 1); -- 3.3

ALTER TABLE zadanie ADD COLUMN projekt INT, ADD CONSTRAINT fk_projekt FOREIGN KEY (projekt) REFERENCES projekt(id_projektu) ON DELETE CASCADE; -- 3.4

UPDATE zadanie SET projekt=1; -- 3.5

-- 4
CREATE TABLE sprint (
	id_sprintu INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	numer_sprintu INT UNSIGNED,
	data_rozpoczecia DATE,
	data_zakonczenia DATE
); -- 4.1

ALTER TABLE zadanie ADD COLUMN sprint INT, ADD CONSTRAINT fk_sprint FOREIGN KEY (sprint) REFERENCES sprint(id_sprintu) ON DELETE SET NULL; -- 4.2

INSERT INTO sprint (numer_sprintu, data_rozpoczecia) VALUES (1337, '1995-10-10'); -- 4.3
UPDATE zadanie SET sprint=(SELECT id_sprintu FROM sprint) WHERE id_zadania IN (1, 2); -- 4.3

-- 5
CREATE TABLE status (
	id_statusu INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nazwa_statusu VARCHAR(20)
); -- 5.1

INSERT INTO status(nazwa_statusu) VALUES ('ok'), ('opoznienie'), ('katastrofa'); -- 5.2

CREATE TABLE zadanie_has_status (
	id_zdarzenia INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	id_zadania INT NOT NULL,
	id_statusu INT NOT NULL,
	data_zdarzenia DATETIME DEFAULT CURRENT_TIMESTAMP
); -- 5.3

INSERT INTO zadanie_has_status(id_zadania, id_statusu) VALUES (1, 1), (2, 2), (3, 3); -- 5.4

SELECT COUNT(id_zadania) AS 'zadania_przed_delete' FROM zadanie WHERE projekt = 1; DELETE FROM projekt WHERE id_projektu = 1; SELECT COUNT(id_zadania) AS 'zadania_po_delete' FROM zadanie WHERE projekt = 1; -- 5.5

-- ???
UPDATE zadanie SET sprint = NULL; ALTER TABLE zadanie DROP FOREIGN KEY fk_sprint; DROP TABLE sprint; -- 5.6

--
-- lab 4.
--

-- 1
ALTER TABLE zadanie DROP FOREIGN KEY zadanie_ibfk_1; -- 1.1 - zadanie(pracownik)
ALTER TABLE projekt DROP FOREIGN KEY fk_menadzer_projektu; -- 1.1

ALTER TABLE pracownik MODIFY COLUMN id_pracownika INT NOT NULL; -- 1.2
ALTER TABLE pracownik DROP PRIMARY KEY; -- 1.2

ALTER TABLE pracownik MODIFY COLUMN id_pracownika INT NOT NULL AUTO_INCREMENT PRIMARY KEY; -- 1.3

ALTER TABLE zadanie ADD CONSTRAINT fk_pracownik FOREIGN KEY (pracownik) REFERENCES pracownik(id_pracownika) ON DELETE SET NULL; -- 1.4
ALTER TABLE projekt ADD CONSTRAINT fk_menadzer_projektu FOREIGN KEY (menadzer_projektu) REFERENCES pracownik(id_pracownika); -- 1.4

-- 2
ALTER TABLE zadanie ADD COLUMN godziny_szacowane INTEGER DEFAULT 8; -- 2.1

UPDATE zadanie SET godziny_szacowane = 4 WHERE id_zadania = 1; -- 2.211. Wyznaczy¢ zredukowane postacie schodkowe danych macierzy i ich rz¦dy:
UPDATE zadanie SET godziny_szacowane = 12 WHERE id_zadania = 2; -- 2.2
UPDATE zadanie SET godziny_szacowane = 16 WHERE id_zadania = 3; -- 2.2 

ALTER TABLE zadanie MODIFY COLUMN godziny_szacowane INTEGER DEFAULT 6; -- 2.3

INSERT INTO zadanie (nazwa_zadania, priorytet, opis, pracownik) VALUES ('temp_task', 'normalny', 'Opis...', 1); -- 2.4
SELECT godziny_szacowane FROM zadanie WHERE nazwa_zadania = 'temp_task'; -- 2.4
DELETE FROM zadanie WHERE nazwa_zadania = 'temp_task'; -- 2.4

-- 3
ALTER TABLE projekt ADD COLUMN opis_kratki VARCHAR(50) NULL; -- 3.1

ALTER TABLE projekt MODIFY COLUMN opis_kratki VARCHAR(200) NULL; -- 3.2

UPDATE projekt SET opis_kratki = 'MVP' WHERE id_projektu = 1; -- 3.3
UPDATE projekt SET opis_kratki = 'pilne wdrożenie' WHERE id_projektu = 2; -- 3.3
UPDATE projekt SET opis_kratki = 'MVP' WHERE id_projektu = 3; -- 3.3

ALTER TABLE projekt DROP COLUMN opis_kratki; -- 3.4

-- 4
ALTER TABLE zadanie DROP FOREIGN KEY fk_projekt; -- 4.1

ALTER TABLE zadanie ADD CONSTRAINT fk_projekt FOREIGN KEY (projekt) REFERENCES projekt(id_projektu) ON DELETE SET NULL; -- 4.2

DELETE FROM projekt WHERE id_projektu = 1; -- 4.3

