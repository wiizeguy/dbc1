-- 1.1
CREATE TABLE infs_godlewskid.kreatura SELECT * FROM wikingowie.kreatura;
CREATE TABLE infs_godlewskid.zasob SELECT * FROM wikingowie.zasob;
CREATE TABLE infs_godlewskid.ekwipunek SELECT * FROM wikingowie.ekwipunek;

-- 1.2
SELECT * FROM zasob;

-- 1.3
SELECT * FROM zasob WHERE rodzaj='jedzenie';

-- 1.4
SELECT idZasobu, ilosc FROM ekwipunek WHERE idKreatury IN (1,3,5);

-- 2.1
SELECT * FROM kreatura WHERE rodzaj!='wiedzma' AND udzwig>=50;

-- 2.2
SELECT * FROM zasob WHERE waga BETWEEN 2 AND 5;

-- 2.3
SELECT * FROM kreatura WHERE nazwa LIKE '%or' AND udzwig BETWEEN 30 AND 70;

-- 3.1
SELECT * FROM zasob WHERE MONTH(dataPozyskania) IN (7,8);

-- 3.2
SELECT * FROM zasob WHERE rodzaj IS NOT NULL ORDER BY waga ASC;

-- 3.3
SELECT * FROM kreatura ORDER BY dataUr DESC LIMIT 5;

-- 4.1
SELECT DISTINCT rodzaj FROM zasob;

-- 4.2
SELECT CONCAT(nazwa, ' - ', rodzaj) FROM kreatura WHERE rodzaj LIKE 'wi%';

-- 4.3
SELECT *, waga * ilosc AS calkowitaWaga FROM zasob WHERE YEAR(dataPozyskania) BETWEEN 2000 AND 2007;

-- 5.1
SELECT SUM(waga - waga * 0.3) AS masaWlasciwegoJedzenia, SUM(waga * 0.3) AS masaOdpadkow FROM zasob WHERE rodzaj='jedzenie';

-- 5.2
SELECT * FROM zasob WHERE rodzaj IS NULL;

-- 5.3
SELECT DISTINCT nazwa FROM zasob WHERE nazwa LIKE 'Ba%' OR nazwa LIKE '%os' ORDER BY nazwa;
