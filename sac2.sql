-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: sac2
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.8
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,POSTGRESQL' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table Mensajes
--

DROP TABLE IF EXISTS Mensajes;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE Mensajes (
  ID int NOT NULL AUTO_INCREMENT,
  ConversacionID int DEFAULT NULL,
  Mensaje varchar(60) DEFAULT NULL,
  Tipo_Declaracion varchar(4) DEFAULT NULL,
  MensajeAnterior int DEFAULT NULL,
  BasadoRespuesta int DEFAULT NULL,
  PRIMARY KEY (ID),
  UNIQUE (MensajeAnterior,BasadoRespuesta)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table Mensajes
--


--
-- Table structure for table Respuestas
--

DROP TABLE IF EXISTS Respuestas;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE Respuestas (
  ID int NOT NULL AUTO_INCREMENT,
  MensajeID int DEFAULT NULL,
  Texto varchar(60) DEFAULT NULL,
  PRIMARY KEY (ID)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table Respuestas
--


--
-- Table structure for table RespuestasHistorial
--

DROP TABLE IF EXISTS RespuestasHistorial;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE RespuestasHistorial (
  ID int NOT NULL AUTO_INCREMENT,
  RespuestaID int DEFAULT NULL,
  Texto varchar(80) DEFAULT NULL,
  PRIMARY KEY (ID)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table RespuestasHistorial
--


--
-- Table structure for table conversacion
--

DROP TABLE IF EXISTS conversacion;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE conversacion (
  ID int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (ID)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table conversacion
--

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-07-09 12:11:17
