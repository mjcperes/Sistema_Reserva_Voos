-- DROP DATABASE IF EXISTS BDReservaVoos;

CREATE DATABASE BDReservaVoos;

USE BDReservaVoos;

CREATE TABLE Aeronaves(
matricula VARCHAR(20),
marcaModelo VARCHAR(50) NOT NULL,
lotacao INT NOT NULL,
autonomia INT NOT NULL,
PRIMARY KEY (matricula)
);

CREATE TABLE Destinos(
c_IATA VARCHAR(3),
nome_Cidade VARCHAR(50) UNIQUE NOT NULL,
PRIMARY KEY (c_IATA)
);

CREATE TABLE Rotas(
id_Rota VARCHAR(10),
aeropPartida VARCHAR(50) NOT NULL,
aeropChegada VARCHAR(50) NOT NULL,
distancia INT NOT NULL,
PRIMARY KEY (id_Rota),
FOREIGN KEY (aeropPartida) REFERENCES Destinos (nome_Cidade)
	ON UPDATE CASCADE,
FOREIGN KEY (aeropChegada) REFERENCES Destinos (nome_Cidade)
	ON UPDATE CASCADE
-- CONSTRAINT Part_dif_Chegad CHECK (aeropPartida != aeropChegada)
);

-- Remoção da constraint Part_dif_Chegad para poder adicionar ON UPDATE CASCADE
-- ALTER TABLE Rotas
-- DROP CONSTRAINT Part_dif_Chegad;

-- Verificar nome das foreign keys
-- SELECT CONSTRAINT_NAME
-- FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
-- WHERE TABLE_NAME = 'Rotas';
-- AND COLUMN_NAME = 'aeropPartida' 
-- AND REFERENCED_TABLE_NAME IS NOT NULL; -- Esta linha exclui a primary key

-- Adicionar ON UPDATE CASCADE
-- ALTER TABLE Rotas
-- ADD CONSTRAINT rotas_ibfk_1b
-- ADD CONSTRAINT rotas_ibfk_2b
-- FOREIGN KEY (aeropPartida) REFERENCES Destinos (nome_Cidade)
-- FOREIGN KEY (aeropChegada) REFERENCES Destinos (nome_Cidade)
-- ON UPDATE CASCADE;

-- Adicionar trigger Part_dif_Chegad porque não se consegue usar uma constraint 
-- por as tabelas estarem a ser usadas como foreign keys e cláusula on update cascade
DELIMITER //
CREATE TRIGGER Part_dif_Chegad BEFORE INSERT ON Rotas
FOR EACH ROW
BEGIN
   IF NEW.aeropPartida = NEW.aeropChegada THEN 
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Aeroporto de partida não pode ser igual ao de chegada!';
   END IF;
END;//
DELIMITER ;

-- DROP TRIGGER Part_dif_Chegad;
-- DROP TABLE Vendas;
-- DROP TABLE Voos;
-- DROP TABLE Rotas;

CREATE TABLE Tarifas(
id_Tarifa VARCHAR(20),
descricaoTarifa VARCHAR(50) NOT NULL,
valorTarifa DECIMAL(12,2) NOT NULL,
tipo ENUM ('OW', 'RT') NOT NULL,
PRIMARY KEY (id_Tarifa)
);

-- ALTER TABLE Tarifas
-- ADD COLUMN tipo ENUM ('OW', 'RT') NOT NULL;

-- Alteração da tabela Rotas:
-- inserção das colunas tarifa OW (ida) e RT (ida e volta)
ALTER TABLE Rotas
ADD COLUMN tarifa_OW VARCHAR(20) NOT NULL,
ADD COLUMN tarifa_RT VARCHAR(20) NOT NULL,
ADD FOREIGN KEY (tarifa_OW) REFERENCES Tarifas (id_Tarifa)
	ON UPDATE CASCADE,
ADD FOREIGN KEY (tarifa_RT) REFERENCES Tarifas (id_Tarifa)
	ON UPDATE CASCADE;


CREATE TABLE Passageiros(
id_Pax VARCHAR(50),		-- cartão de cidadão / passaporte
nome VARCHAR(100) NOT NULL,
pais VARCHAR(50) NOT NULL,
titulo ENUM ('Mr', 'Mrs', 'Ms', 'Chld', 'Inft'),
dataNascimento DATE NOT NULL,
email VARCHAR(100) NOT NULL,
PRIMARY KEY (id_Pax),
FOREIGN KEY (pais) REFERENCES Paises (alpha2)
	ON UPDATE CASCADE
);

-- Alterações na tabela passageiros (script acima atualizado para colunas definitivas)
-- SET SQL_SAFE_UPDATES = 0; -- Desabilitar safe update mode
-- ALTER TABLE Passageiros
-- MODIFY genero ENUM ('M', 'F', 'O', 'Mr', 'Mrs', 'Ms', 'Chld', 'Inft');
-- UPDATE Passageiros SET genero = 'Mr' WHERE genero = 'M';
-- UPDATE Passageiros SET genero = 'Mrs' WHERE genero = 'F';
-- SET SQL_SAFE_UPDATES = 1; -- Habilitar safe update mode
-- MODIFY genero ENUM ('Mr', 'Mrs', 'Ms', 'Chld', 'Inft');
-- CHANGE COLUMN genero titulo ENUM ('Mr', 'Mrs', 'Ms', 'Chld', 'Inft');
-- ADD COLUMN email VARCHAR(100);
-- ADD FOREIGN KEY (pais) REFERENCES Paises (alpha2)
	-- ON UPDATE CASCADE;
-- MODIFY email VARCHAR(100) NOT NULL;


CREATE TABLE Voos(
id_Voo INT AUTO_INCREMENT,
id_Rota VARCHAR(10) NOT NULL,
matricula VARCHAR(20),
dataVoo DATE NOT NULL,
horaPartida TIME NOT NULL,
horaChegada TIME NOT NULL,
estado ENUM ('P', 'F', 'C') NOT NULL DEFAULT 'P', -- (P-planeado / F-fechado / C-cancelado)
numLugares INT NOT NULL,
PRIMARY KEY (id_Voo),
FOREIGN KEY (id_Rota) REFERENCES Rotas(id_Rota)
	ON UPDATE CASCADE,
FOREIGN KEY (matricula) REFERENCES Aeronaves(matricula)
	ON UPDATE CASCADE
);

-- UPDATE Voos SET estado = 'P' WHERE id_Voo = 2;
-- ALTER TABLE Voos
-- MODIFY estado ENUM ('P', 'F', 'C') NOT NULL DEFAULT 'P'; 
-- MODIFY id_Rota VARCHAR(10) NOT NULL;
-- ADD COLUMN numLugares INT NOT NULL;
-- UPDATE Voos SET numLugares = 180 WHERE id_Voo > 0;


CREATE TABLE Vendas(
tkt INT AUTO_INCREMENT,
dataTkt DATE NOT NULL,
id_Pax VARCHAR(50),
id_Tarifa VARCHAR(20),
id_Voo INT,
receita DECIMAL(12,2),
PRIMARY KEY (tkt),
FOREIGN KEY (id_Pax) REFERENCES Passageiros(id_Pax)
	ON UPDATE CASCADE,
FOREIGN KEY (id_Tarifa) REFERENCES Tarifas(id_Tarifa)
	ON UPDATE CASCADE,
FOREIGN KEY (id_Voo) REFERENCES Voos(id_Voo)
	ON UPDATE CASCADE
);

-- Inserção de trigger para cálculo da coluna receita na tabela Vendas
DELIMITER //
CREATE TRIGGER calc_receita
BEFORE INSERT ON Vendas
FOR EACH ROW
BEGIN
	DECLARE valorTarifa DECIMAL(12,2);
    DECLARE distancia INT;
    
    SELECT Tarifas.valorTarifa INTO valorTarifa FROM Tarifas WHERE Tarifas.id_Tarifa = NEW.id_Tarifa;
    SELECT Rotas.distancia INTO distancia FROM Rotas WHERE Rotas.id_Rota = (
		SELECT id_Rota FROM Voos WHERE id_Voo = NEW.id_Voo
        );
    
    SET NEW.receita = valorTarifa * distancia;
END//
DELIMITER ;

insert into Vendas (tkt, dataTkt, id_Pax, id_Tarifa, id_Voo)
values (0, curdate(), '10099999', 'YRT', '5');
insert into Vendas (tkt, dataTkt, id_Pax, id_Tarifa, id_Voo)
values (0, curdate(), '10099999', 'YRT', '9');

CREATE TABLE Paises(
alpha2 VARCHAR(2),
pais VARCHAR(50) NOT NULL,
PRIMARY KEY(alpha2)
);

INSERT INTO Aeronaves (matricula, marcaModelo, lotacao, autonomia) VALUES
('CS-TNX', 'Airbus A320-200', 174, 5500),
('CS-TNY', 'Airbus A320-200', 174, 5500);

INSERT INTO Destinos (c_IATA, nome_cidade) VALUES
('LIS', 'Lisboa (LIS)'),
('MAD', 'Madrid (MAD)'),
('OPO', 'Porto (OPO)'),
('FNC', 'Funchal (FNC)'),
('PDL', 'Ponta Delgada (PDL)'),
('CDG', 'Paris (CDG)'),
('LHR', 'Londres Heathrow (LHR)');

INSERT INTO Rotas (id_Rota, aeropPartida, aeropChegada, distancia) VALUES
('R100', 'Lisboa (LIS)', 'Madrid (MAD)', 530),
('R101', 'Madrid (MAD)','Lisboa (LIS)', 530);

INSERT INTO Tarifas (id_Tarifa, descricaoTarifa, valorTarifa) VALUES
('Y', 'Classe económica ida', 0.4, 'OW'),
('YRT', 'Classe económica ida e volta', 0.3, 'RT');

-- UPDATE Tarifas SET tipo = 'OW' WHERE id_Tarifa = 'Y';
-- UPDATE Tarifas SET tipo = 'RT' WHERE id_Tarifa = 'YRT';

INSERT INTO Passageiros (id_Pax, nome, pais, genero, dataNascimento) VALUES
('10080976', 'José Silva', 'PT', 'M', '1965-11-18'),
('10080978', 'Maria Silva', 'PT', 'F', '1967-08-10');

INSERT INTO Voos (id_Voo, id_Rota, dataVoo, horaPartida, horaChegada) VALUES
-- ('R100', '2024-05-02', '09:50', '10:55'),
-- ('R101', '2024-05-06', '08:05', '09:10');
(0,'R100', '2024-05-10', '08:05', '09:10');

INSERT INTO Vendas (dataTkt, id_Pax, id_Tarifa, id_Voo) VALUES
('2024-02-03', '10080976', 'YRT', '1'),
('2024-02-03', '10080978', 'YRT', '1'),
('2024-02-03', '10080976', 'YRT', '2'),
('2024-02-03', '10080978', 'YRT', '2');

INSERT INTO Paises (alpha2, pais) VALUES
('AO', 'Angola'),
('AR', 'Argentina'),
('BE', 'Béligica'),
('BR', 'Brasil'),
('CV', 'Cabo Verde'),
('CA', 'Canadá'),
('CN', 'China'),
('DK', 'Dinamarca'),
('FI', 'Finlandia'),
('FR', 'França'),
('DE', 'Alemanha'),
('GW', 'Guiné-Bissau'),
('IT', 'Italia'),
('MO', 'Macau'),
('MZ', 'Moçambique'),
('NL', 'Países Baixos'),
('PT', 'Portugal'),
('ES', 'Espanha'),
('SE', 'Suécia'),
('CH', 'Suiça'),
('TL', 'Timor-Leste'),
('GB', 'Reino Unido (UK)'),
('US', 'EUA');


SELECT * FROM Aeronaves;
SELECT * FROM Destinos;
SELECT * FROM Rotas;
SELECT * FROM Tarifas;
SELECT * FROM Passageiros;
SELECT * FROM Voos;
SELECT * FROM Vendas;
SELECT * FROM Paises;

select distinct aeropChegada from Rotas where aeropPartida = 'Lisboa (LIS)' order by aeropChegada;

SELECT COUNT(*) FROM Destinos WHERE c_IATA = 'FAO';

-- Método PesquisarIdRota (em DBConnect)
SELECT R.aeropPartida, D1.c_IATA AS c_IATA_Partida, 
	   R.aeropChegada, D2.c_IATA AS c_IATA_Chegada, 
       R.distancia
	FROM Rotas R
    LEFT JOIN Destinos D1 ON R.aeropPartida = D1.nome_Cidade
    LEFT JOIN Destinos D2 ON R.aeropChegada = D2.nome_Cidade 
    WHERE id_Rota = 'R100';
    
-- query para métodos PreencherDataGridViewVoos com e sem parâmetros
SELECT V.id_Voo, V.matricula, R.aeropPartida, R.aeropChegada, V.dataVoo,
	V.horaPartida, V.horaChegada, V.estado, V.numLugares,
    COUNT(Vd.id_Voo) AS numPax
    FROM Voos V
    LEFT JOIN Rotas R ON V.id_Rota = R.id_Rota
    LEFT JOIN Vendas Vd ON V.id_Voo = Vd.id_Voo
    WHERE V.dataVoo BETWEEN '2024-04-01' AND '2024-05-03'
    AND V.estado = 'P'
    AND V.matricula IS NULL
    AND R.aeropPartida = 'Lisboa (LIS)'
    -- DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
    GROUP BY V.id_Voo;

-- query para método PreencherComboDataIda
SELECT V.dataVoo FROM Voos V
    JOIN Rotas R ON V.id_Rota = R.id_Rota
    LEFT JOIN Vendas Vd ON V.id_Voo = Vd.id_Voo 
    WHERE R.aeropPartida = 'Lisboa (LIS)' 
		AND R.aeropChegada = 'Madrid (MAD)'
        AND V.dataVoo > CURDATE()
GROUP BY V.dataVoo, V.numLugares
HAVING COUNT(Vd.id_Voo) <= V.numLugares OR COUNT(Vd.id_Voo) IS NULL
ORDER BY V.dataVoo;   

-- query para método PreencherDataGridViewItinerario
SELECT V.id_Voo, R.aeropPartida, R.aeropChegada, V.dataVoo, V.horaPartida,
 V.horaChegada, R.tarifa_RT, T.valorTarifa * R.distancia AS Valor
	FROM Voos V 
    LEFT JOIN Rotas R on V.id_Rota = R.id_Rota
    LEFT JOIN Tarifas T on R.tarifa_RT = T.id_Tarifa
    WHERE V.estado = 'P' 
    AND (
		(V.dataVoo = '2024-05-02' AND R.aeropPartida = 'Lisboa (LIS)' AND R.aeropChegada = 'Madrid (MAD)') 
		OR
		(V.dataVoo = '2024-05-06' AND R.aeropPartida = 'Madrid (MAD)' AND R.aeropChegada = 'Lisboa (LIS)')
	)
    ORDER BY V.dataVoo;

-- Ignora a inserção sem dar erro se a PK já existir
insert ignore into Passageiros (id_Pax, nome, pais, titulo, dataNascimento, email) values
 ('10080888', 'Carlos Santos', 'PT', 'Mr', '1975-11-10', 'csantos@empresa.pt');

-- query para método PersquisarBilhete
select Vd.tkt, R.aeropPartida, R.aeropChegada, T.tipo, V1.dataVoo, P.nome, 
	Vd.id_Pax, P.titulo, P.pais, P.dataNascimento, P.email 
from Vendas Vd 
left join Tarifas T on Vd.id_Tarifa = T.id_Tarifa
left join Voos V1 on Vd.id_Voo = V1.id_Voo 
-- left join Voos V2 on Vd.id_Voo = V2.id_Voo
left join Rotas R on V1.id_Rota = R.id_Rota 
left join Passageiros P on Vd.id_Pax = P.id_Pax
where (Vd.dataTkt, Vd.id_Pax) in (
	select Vd.dataTkt, Vd.id_Pax 
    from Vendas Vd
    where Vd.tkt = '17'
)
order by Vd.tkt
limit 1;

select V.dataVoo from Voos V
right join Vendas Vd on Vd.id_Voo = V.id_Voo
where (Vd.dataTkt, Vd.id_Pax) in (
	select Vd.dataTkt, Vd.id_Pax 
    from Vendas Vd
    where Vd.tkt = '17'
)
order by Vd.tkt desc
limit 1;

-- query para preencher DataGridViewItinerario depois do bilhete emitido
select Vd.id_Voo, R.aeropPartida, R.aeropChegada, V.dataVoo, V.horaPartida,
 V.horaChegada, Vd.id_Tarifa, Vd.receita
 from Vendas Vd 
 left join Voos V on Vd.id_Voo = V.id_Voo
 left join Rotas R on V.id_Rota = R.id_Rota 
 left join Tarifas T on Vd.id_Tarifa = T.id_Tarifa 
-- where T.tipo = 'OW' and ((V.dataVoo = '2024-05-02' 
-- and R.aeropPartida = 'Lisboa (LIS)' and R.aeropChegada = 'Paris (CDG)'
 where T.tipo = 'RT' and Vd.id_Pax = 'DE 12345678910' 
 and ((V.dataVoo = '2024-05-02' and R.aeropPartida = 'Lisboa (LIS)'
	and R.aeropChegada = 'Paris (CDG)') 
 or (V.dataVoo = '2024-05-06' and R.aeropPartida = 'Paris (CDG)' 
	and R.aeropChegada = 'Lisboa (LIS)')) 
order by V.dataVoo;


