CREATE DATABASE  IF NOT EXISTS `bdreservavoos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bdreservavoos`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bdreservavoos
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aeronaves`
--

DROP TABLE IF EXISTS `aeronaves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aeronaves` (
  `matricula` varchar(20) NOT NULL,
  `marcaModelo` varchar(50) NOT NULL,
  `lotacao` int NOT NULL,
  `autonomia` int NOT NULL,
  PRIMARY KEY (`matricula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aeronaves`
--

LOCK TABLES `aeronaves` WRITE;
/*!40000 ALTER TABLE `aeronaves` DISABLE KEYS */;
INSERT INTO `aeronaves` VALUES ('CS-TNX','Airbus A320-200',174,5500),('CS-TNY','Airbus A320-200',174,5500),('CS-TRD','DHC-8-400',80,2500),('CS-TRE','DHC-8-400',80,2500);
/*!40000 ALTER TABLE `aeronaves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `destinos`
--

DROP TABLE IF EXISTS `destinos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `destinos` (
  `c_IATA` varchar(3) NOT NULL,
  `nome_Cidade` varchar(50) NOT NULL,
  PRIMARY KEY (`c_IATA`),
  UNIQUE KEY `nome_Cidade` (`nome_Cidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `destinos`
--

LOCK TABLES `destinos` WRITE;
/*!40000 ALTER TABLE `destinos` DISABLE KEYS */;
INSERT INTO `destinos` VALUES ('FAO','Faro (FAO)'),('FNC','Funchal (FNC)'),('LIS','Lisboa (LIS)'),('LHR','Londres (LHR)'),('MAD','Madrid (MAD)'),('CDG','Paris (CDG)'),('PDL','Ponta Delgada (PDL)'),('OPO','Porto (OPO)');
/*!40000 ALTER TABLE `destinos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paises`
--

DROP TABLE IF EXISTS `paises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paises` (
  `alpha2` varchar(2) NOT NULL,
  `pais` varchar(50) NOT NULL,
  PRIMARY KEY (`alpha2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paises`
--

LOCK TABLES `paises` WRITE;
/*!40000 ALTER TABLE `paises` DISABLE KEYS */;
INSERT INTO `paises` VALUES ('AO','Angola'),('AR','Argentina'),('BE','Béligica'),('BR','Brasil'),('CA','Canadá'),('CH','Suiça'),('CN','China'),('CV','Cabo Verde'),('DE','Alemanha'),('DK','Dinamarca'),('ES','Espanha'),('FI','Finlandia'),('FR','França'),('GB','Reino Unido (UK)'),('GW','Guiné-Bissau'),('IT','Italia'),('MO','Macau'),('MZ','Moçambique'),('NL','Países Baixos'),('PT','Portugal'),('SE','Suécia'),('TL','Timor-Leste'),('US','EUA');
/*!40000 ALTER TABLE `paises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passageiros`
--

DROP TABLE IF EXISTS `passageiros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passageiros` (
  `id_Pax` varchar(50) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `pais` varchar(50) NOT NULL,
  `titulo` enum('Mr','Mrs','Ms','Chld','Inft') DEFAULT NULL,
  `dataNascimento` date NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id_Pax`),
  KEY `pais` (`pais`),
  CONSTRAINT `passageiros_ibfk_1` FOREIGN KEY (`pais`) REFERENCES `paises` (`alpha2`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passageiros`
--

LOCK TABLES `passageiros` WRITE;
/*!40000 ALTER TABLE `passageiros` DISABLE KEYS */;
INSERT INTO `passageiros` VALUES ('10023345','Kika Nazareth','PT','Ms','2003-03-07','kika@slb.pt'),('10080888','Carlos Santos','PT','Mr','1975-11-10','csantos@empresa.pt'),('10080976','José Silva','PT','Mr','1965-11-18','jsilva@gimail.com'),('10080978','Maria Silva','PT','Mrs','1967-08-10','jsilva@gimail.com'),('10089956','Jessica Silva','PT','Ms','1999-03-17','jessica@slb.pt'),('10099999','Mario P','PT','Mr','1973-04-02','mariop@gimail.pt'),('10122569','Bruno Fernandes','PT','Mr','1998-04-05','bf@mu.com'),('11100022','João Félix','PT','Mr','2002-02-05','jf@barca.pt'),('DE 12345678910','Roger Schnidt','DE','Mr','1969-09-15','rschmidt@slb.pt');
/*!40000 ALTER TABLE `passageiros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rotas`
--

DROP TABLE IF EXISTS `rotas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rotas` (
  `id_Rota` varchar(10) NOT NULL,
  `aeropPartida` varchar(50) NOT NULL,
  `aeropChegada` varchar(50) NOT NULL,
  `distancia` int NOT NULL,
  `tarifa_OW` varchar(20) NOT NULL,
  `tarifa_RT` varchar(20) NOT NULL,
  PRIMARY KEY (`id_Rota`),
  KEY `aeropPartida` (`aeropPartida`),
  KEY `aeropChegada` (`aeropChegada`),
  KEY `tarifa_OW` (`tarifa_OW`),
  KEY `tarifa_RT` (`tarifa_RT`),
  CONSTRAINT `rotas_ibfk_1` FOREIGN KEY (`aeropPartida`) REFERENCES `destinos` (`nome_Cidade`) ON UPDATE CASCADE,
  CONSTRAINT `rotas_ibfk_2` FOREIGN KEY (`aeropChegada`) REFERENCES `destinos` (`nome_Cidade`) ON UPDATE CASCADE,
  CONSTRAINT `rotas_ibfk_3` FOREIGN KEY (`tarifa_OW`) REFERENCES `tarifas` (`id_Tarifa`) ON UPDATE CASCADE,
  CONSTRAINT `rotas_ibfk_4` FOREIGN KEY (`tarifa_RT`) REFERENCES `tarifas` (`id_Tarifa`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rotas`
--

LOCK TABLES `rotas` WRITE;
/*!40000 ALTER TABLE `rotas` DISABLE KEYS */;
INSERT INTO `rotas` VALUES ('R100','Lisboa (LIS)','Madrid (MAD)',530,'Y','YRT'),('R101','Madrid (MAD)','Lisboa (LIS)',530,'Y','YRT'),('R200','Lisboa (LIS)','Paris (CDG)',1450,'Y','YRT'),('R201','Paris (CDG)','Lisboa (LIS)',1450,'Y','YRT'),('R300','Lisboa (LIS)','Londres (LHR)',1610,'Y','YRT'),('R301','Londres (LHR)','Lisboa (LIS)',1610,'Y','YRT');
/*!40000 ALTER TABLE `rotas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`MarioP`@`%`*/ /*!50003 TRIGGER `Part_dif_Chegad` BEFORE INSERT ON `rotas` FOR EACH ROW BEGIN
   IF NEW.aeropPartida = NEW.aeropChegada THEN 
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Aeroporto de partida não pode ser igual ao de chegada!';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tarifas`
--

DROP TABLE IF EXISTS `tarifas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifas` (
  `id_Tarifa` varchar(20) NOT NULL,
  `descricaoTarifa` varchar(50) NOT NULL,
  `valorTarifa` decimal(12,2) NOT NULL,
  `tipo` enum('OW','RT') NOT NULL,
  PRIMARY KEY (`id_Tarifa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifas`
--

LOCK TABLES `tarifas` WRITE;
/*!40000 ALTER TABLE `tarifas` DISABLE KEYS */;
INSERT INTO `tarifas` VALUES ('W','C. Econ - Procura alta ida',0.80,'OW'),('WRT','C.Econ - Procura alta ida e volta',0.70,'RT'),('Y','Classe económica ida',0.20,'OW'),('YRT','Classe económica ida e volta',0.15,'RT');
/*!40000 ALTER TABLE `tarifas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendas`
--

DROP TABLE IF EXISTS `vendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendas` (
  `tkt` int NOT NULL AUTO_INCREMENT,
  `dataTkt` date NOT NULL,
  `id_Pax` varchar(50) DEFAULT NULL,
  `id_Tarifa` varchar(20) DEFAULT NULL,
  `id_Voo` int DEFAULT NULL,
  `receita` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`tkt`),
  KEY `id_Pax` (`id_Pax`),
  KEY `id_Tarifa` (`id_Tarifa`),
  KEY `id_Voo` (`id_Voo`),
  CONSTRAINT `vendas_ibfk_1` FOREIGN KEY (`id_Pax`) REFERENCES `passageiros` (`id_Pax`) ON UPDATE CASCADE,
  CONSTRAINT `vendas_ibfk_2` FOREIGN KEY (`id_Tarifa`) REFERENCES `tarifas` (`id_Tarifa`) ON UPDATE CASCADE,
  CONSTRAINT `vendas_ibfk_3` FOREIGN KEY (`id_Voo`) REFERENCES `voos` (`id_Voo`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendas`
--

LOCK TABLES `vendas` WRITE;
/*!40000 ALTER TABLE `vendas` DISABLE KEYS */;
INSERT INTO `vendas` VALUES (1,'2024-02-03','10080976','YRT',1,159.00),(2,'2024-02-03','10080978','YRT',1,159.00),(3,'2024-02-03','10080976','YRT',2,159.00),(4,'2024-02-03','10080978','YRT',2,159.00),(6,'2024-04-14','10099999','YRT',5,435.00),(7,'2024-04-14','10099999','YRT',9,435.00),(14,'2024-04-15','10023345','YRT',1,79.50),(15,'2024-04-15','10023345','YRT',2,79.50),(16,'2024-04-15','DE 12345678910','YRT',5,217.50),(17,'2024-04-15','DE 12345678910','YRT',9,217.50),(18,'2024-04-15','10122569','Y',7,322.00);
/*!40000 ALTER TABLE `vendas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`MarioP`@`%`*/ /*!50003 TRIGGER `calc_receita` BEFORE INSERT ON `vendas` FOR EACH ROW BEGIN
	DECLARE valorTarifa DECIMAL(12,2);
    DECLARE distancia INT;
    
    SELECT Tarifas.valorTarifa INTO valorTarifa FROM Tarifas WHERE Tarifas.id_Tarifa = NEW.id_Tarifa;
    SELECT Rotas.distancia INTO distancia FROM Rotas WHERE Rotas.id_Rota = (
		SELECT id_Rota FROM Voos WHERE id_Voo = NEW.id_Voo
        );
    
    SET NEW.receita = valorTarifa * distancia;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `voos`
--

DROP TABLE IF EXISTS `voos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voos` (
  `id_Voo` int NOT NULL AUTO_INCREMENT,
  `id_Rota` varchar(10) NOT NULL,
  `matricula` varchar(20) DEFAULT NULL,
  `dataVoo` date NOT NULL,
  `horaPartida` time NOT NULL,
  `horaChegada` time NOT NULL,
  `estado` enum('P','F','C') NOT NULL DEFAULT 'P',
  `numLugares` int NOT NULL,
  PRIMARY KEY (`id_Voo`),
  KEY `id_Rota` (`id_Rota`),
  KEY `matricula` (`matricula`),
  CONSTRAINT `voos_ibfk_1` FOREIGN KEY (`id_Rota`) REFERENCES `rotas` (`id_Rota`) ON UPDATE CASCADE,
  CONSTRAINT `voos_ibfk_2` FOREIGN KEY (`matricula`) REFERENCES `aeronaves` (`matricula`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voos`
--

LOCK TABLES `voos` WRITE;
/*!40000 ALTER TABLE `voos` DISABLE KEYS */;
INSERT INTO `voos` VALUES (1,'R100','CS-TNX','2024-05-02','09:50:00','10:55:00','P',180),(2,'R101','CS-TNX','2024-05-06','08:05:00','09:10:00','P',180),(3,'R100','CS-TNY','2024-05-10','08:05:00','09:10:00','P',180),(4,'R101',NULL,'2024-05-14','08:05:00','09:05:00','P',180),(5,'R200',NULL,'2024-05-02','07:30:00','10:35:00','P',180),(6,'R201',NULL,'2024-05-02','11:00:00','14:05:00','P',180),(7,'R300',NULL,'2024-05-03','09:15:00','11:55:00','P',180),(8,'R200',NULL,'2024-05-06','07:30:00','10:35:00','P',180),(9,'R201',NULL,'2024-05-06','11:00:00','14:05:00','P',180),(10,'R301',NULL,'2024-05-03','13:00:00','15:40:00','P',180),(11,'R101',NULL,'2024-05-10','11:30:00','12:35:00','P',180),(12,'R200',NULL,'2024-05-12','07:30:00','10:35:00','P',180);
/*!40000 ALTER TABLE `voos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'bdreservavoos'
--

--
-- Dumping routines for database 'bdreservavoos'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-15 22:36:12
