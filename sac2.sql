
--DROP SEQUENCE IF EXISTS men_id_seq CASCADE;
DROP TABLE IF EXISTS Mensajes;
CREATE TABLE Mensajes (
  ID int DEFAULT NEXTVAL('men_id_seq'),
  ConversacionID int DEFAULT NULL,
  Mensaje varchar(60) DEFAULT NULL,
  Tipo_Declaracion varchar(4) DEFAULT NULL,
  PRIMARY KEY (ID)
);
--CREATE SEQUENCE men_id_seq;

--DROP SEQUENCE IF EXISTS resp_id_seq CASCADE;
DROP TABLE IF EXISTS Respuestas;
CREATE TABLE Respuestas (
  ID int DEFAULT NEXTVAL('resp_id_seq'),
  MensajeID int DEFAULT NULL,
  Texto varchar(60) DEFAULT NULL,
  PRIMARY KEY (ID)
);
--CREATE SEQUENCE resp_id_seq;

--DROP SEQUENCE IF EXISTS resph_id_seq CASCADE;
DROP TABLE IF EXISTS RespuestasHistorial;
CREATE TABLE RespuestasHistorial (
  ID int DEFAULT NEXTVAL('resph_id_seq'),
  RespuestaID int DEFAULT NULL,
  Texto varchar(80) DEFAULT NULL,
  MensajeID int DEFAULT NULL,
  PRIMARY KEY (ID)
);
--CREATE SEQUENCE resph_id_seq;


--DROP SEQUENCE IF EXISTS origenresp_id_seq CASCADE;
DROP TABLE IF EXISTS OrigenesDeRespuestas;
CREATE TABLE OrigenesDeRespuestas (
  ID int DEFAULT NEXTVAL('origenresp_id_seq'),
  RespuestaOrigenID int DEFAULT NULL,
  ConversacionID int DEFAULT NULL,
  MensajeID int DEFAULT NULL,
  PRIMARY KEY (ID),
  UNIQUE (RespuestaOrigenID)
);
--CREATE SEQUENCE origenresp_id_seq;


--DROP SEQUENCE IF EXISTS origenmens_id_seq CASCADE;
DROP TABLE IF EXISTS OrigenesDeMensajes;
CREATE TABLE OrigenesDeMensajes (
  ID int DEFAULT NEXTVAL('origenmens_id_seq'),
  MensajeOrigenID int DEFAULT NULL,
  ConversacionID int DEFAULT NULL,
  MensajeID int DEFAULT NULL,
  PRIMARY KEY (ID),
  UNIQUE (MensajeOrigenID)
);
--CREATE SEQUENCE origenmens_id_seq;


--DROP SEQUENCE IF EXISTS con_id_seq CASCADE;
DROP TABLE IF EXISTS conversacion;
CREATE TABLE conversacion (
  ID int DEFAULT NEXTVAL('con_id_seq'),
  Clave varchar(10) DEFAULT NULL,
  FechaCreacion timestamp DEFAULT current_timestamp,
  FechaModificacion timestamp DEFAULT NULL,
  PRIMARY KEY (ID)
);
--CREATE SEQUENCE con_id_seq;
INSERT INTO conversacion(ID) VALUES('1');

