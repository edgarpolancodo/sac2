-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: sac
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Mensajes`
--

DROP TABLE IF EXISTS `Mensajes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Mensajes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ConversacionID` int(11) DEFAULT NULL,
  `Mensaje` varchar(60) DEFAULT NULL,
  `Tipo_Declaracion` varchar(4) DEFAULT NULL,
  `MensajeAnterior` int(11) DEFAULT NULL,
  `BasadoRespuesta` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `MensajeAnterior` (`MensajeAnterior`,`BasadoRespuesta`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Mensajes`
--

LOCK TABLES `Mensajes` WRITE;
/*!40000 ALTER TABLE `Mensajes` DISABLE KEYS */;
INSERT INTO `Mensajes` VALUES (9,1,'hola tu','abcd',NULL,NULL),(10,1,'como estas','abcd',9,0),(11,1,'me guta juntame con gente como tu','abcd',0,26),(12,1,'y por ke tu ta mal','abcd',0,27),(13,6,'que lo kentucky','abcd',NULL,NULL),(14,7,'monta','abcd',NULL,NULL),(15,8,'montame','abcd',NULL,NULL),(16,9,'hola linda','abcd',NULL,NULL),(17,10,'eo','abcd',NULL,NULL),(18,11,'publicita, ke hay pal sabado de seminario de grado','abcd',NULL,NULL),(19,11,'como ke examen? tu ta loco','abcd',0,35),(20,11,'ya yo toy jarto de eso','abcd',0,36),(26,13,'mensaje libre','FREE',0,0);
/*!40000 ALTER TABLE `Mensajes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Respuestas`
--

DROP TABLE IF EXISTS `Respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Respuestas` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MensajeID` int(11) DEFAULT NULL,
  `Texto` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Respuestas`
--

LOCK TABLES `Respuestas` WRITE;
/*!40000 ALTER TABLE `Respuestas` DISABLE KEYS */;
INSERT INTO `Respuestas` VALUES (24,9,'hola\r\n'),(25,9,'dime tu'),(26,10,'bien\r\n'),(27,10,'mal'),(28,11,'hahahah\r\n'),(29,11,'y tu como ta?'),(30,12,'por na\r\n'),(31,12,'por eto\r\n'),(32,12,'... y eto'),(33,17,'wey\r\n'),(34,17,'uepa'),(35,18,'examen\r\n'),(36,18,'entregar el marco teorico'),(37,19,'haha es chercha\r\n'),(38,19,'es en serio'),(39,20,'yo tambien\r\n'),(40,20,'jajajaja'),(43,26,'');
/*!40000 ALTER TABLE `Respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RespuestasHistorial`
--

DROP TABLE IF EXISTS `RespuestasHistorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RespuestasHistorial` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `RespuestaID` int(11) DEFAULT NULL,
  `Texto` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RespuestasHistorial`
--

LOCK TABLES `RespuestasHistorial` WRITE;
/*!40000 ALTER TABLE `RespuestasHistorial` DISABLE KEYS */;
INSERT INTO `RespuestasHistorial` VALUES (18,43,'respuesta libre');
/*!40000 ALTER TABLE `RespuestasHistorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conversacion`
--

DROP TABLE IF EXISTS `conversacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conversacion` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conversacion`
--

LOCK TABLES `conversacion` WRITE;
/*!40000 ALTER TABLE `conversacion` DISABLE KEYS */;
INSERT INTO `conversacion` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13);
/*!40000 ALTER TABLE `conversacion` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-06-20  0:22:28
