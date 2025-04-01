```
-- Elimina el esquema
DROP USER e4712 CASCADE;

-- Crear el esquema e4712
CREATE USER e4712 IDENTIFIED BY oracle;

-- Asignar permisos necesarios
GRANT CONNECT, RESOURCE TO e4712;
GRANT CREATE SESSION TO e4712;
GRANT CREATE TABLE TO e4712;
GRANT CREATE VIEW TO e4712;
GRANT CREATE PROCEDURE TO e4712;
GRANT CREATE SEQUENCE TO e4712;

-- GRANT DBA TO e4712;  -- Opcional, solo si se requiere acceso completo a la base de datos

-- Asignar espacio para los objetos del esquema (opciunal)
-- ALTER USER e4712 QUOTA UNLIMITED ON USERS;

```


```

set echo on
set pagesize 300
set linesize 300

DROP TABLE actuaciones CASCADE CONSTRAINTS;
DROP TABLE lidiadores CASCADE CONSTRAINTS;
DROP TABLE subalternos CASCADE CONSTRAINTS;
DROP TABLE matadores CASCADE CONSTRAINTS;
DROP TABLE plazas CASCADE CONSTRAINTS;


-- Creación de la tabla 'plazas'
CREATE TABLE plazas (
    id_plaza INT PRIMARY KEY,
    nombre VARCHAR(255),
    ubicacion VARCHAR(255)
);

-- Inserción de datos de ejemplos en ella
INSERT INTO plazas (id_plaza, nombre, ubicacion) VALUES (1, 'Plaza de Toros Madrid', 'Madrid');
INSERT INTO plazas (id_plaza, nombre, ubicacion) VALUES (2, 'Plaza de Toros Sevilla', 'Sevilla');
INSERT INTO plazas (id_plaza, nombre, ubicacion) VALUES (3, 'Plaza de Toros Valencia', 'Valencia');

-- Creación de la tabla 'matadores'
CREATE TABLE matadores (
    id_matador INT PRIMARY KEY,
    nombre VARCHAR(255)
);

-- Inserción de datos de ejemplo
INSERT INTO matadores (id_matador, nombre) VALUES (1, 'Juan Garcia');
INSERT INTO matadores (id_matador, nombre) VALUES (2, 'Carlos Lopez');
INSERT INTO matadores (id_matador, nombre) VALUES (3, 'Pedro Martinez');
-- nuevo matador que no estara en ninguna actuacion para practicar ejemplos donde no aparezca
INSERT INTO matadores (id_matador, nombre) VALUES (4, 'Luis Pérez');

-- No vamos a insertar ninguna actuación relacionada con este matador.


-- Creación de la tabla 'subalternos'
CREATE TABLE subalternos (
    id_subalterno INT PRIMARY KEY,
    nombre VARCHAR(255)
);

-- Inserción de datos en ella
INSERT INTO subalternos (id_subalterno, nombre) VALUES (1, 'Manuel Diaz');
INSERT INTO subalternos (id_subalterno, nombre) VALUES (2, 'Jose Garcia');
INSERT INTO subalternos (id_subalterno, nombre) VALUES (3, 'Luis Fernandez');

-- Creación de la tabla 'lidiadores'
CREATE TABLE lidiadores (
    id_lidiador INT PRIMARY KEY,
    nombre VARCHAR(255)
);

-- Inserción de datos ella
INSERT INTO lidiadores (id_lidiador, nombre) VALUES (1, 'Juan Garcia');
INSERT INTO lidiadores (id_lidiador, nombre) VALUES (2, 'Carlos Lopez');
INSERT INTO lidiadores (id_lidiador, nombre) VALUES (3, 'Manuel Diaz');
INSERT INTO lidiadores (id_lidiador, nombre) VALUES (4, 'Jose Garcia');

-- Creación de la tabla 'actuaciones'
CREATE TABLE actuaciones (
    id_plaza INT,
    id_matador INT,
    id_subalterno INT,
    id_lidiador INT,
    fecha DATE,
    PRIMARY KEY (id_plaza, id_matador, id_subalterno, id_lidiador),
    FOREIGN KEY (id_plaza) REFERENCES plazas(id_plaza),
    FOREIGN KEY (id_matador) REFERENCES matadores(id_matador),
    FOREIGN KEY (id_subalterno) REFERENCES subalternos(id_subalterno),
    FOREIGN KEY (id_lidiador) REFERENCES lidiadores(id_lidiador)
);

-- Inserción de datos en ella
INSERT INTO actuaciones (id_plaza, id_matador, id_subalterno, id_lidiador, fecha) VALUES (1, 1, 1, 1, TO_DATE('2023-05-10', 'YYYY-MM-DD'));
INSERT INTO actuaciones (id_plaza, id_matador, id_subalterno, id_lidiador, fecha) VALUES (1, 2, 2, 2, TO_DATE('2023-05-12', 'YYYY-MM-DD'));
INSERT INTO actuaciones (id_plaza, id_matador, id_subalterno, id_lidiador, fecha) VALUES (2, 3, 3, 3, TO_DATE('2023-06-15', 'YYYY-MM-DD'));
INSERT INTO actuaciones (id_plaza, id_matador, id_subalterno, id_lidiador, fecha) VALUES (3, 1, 1, 1, TO_DATE('2023-07-20', 'YYYY-MM-DD'));
INSERT INTO actuaciones (id_plaza, id_matador, id_subalterno, id_lidiador, fecha) VALUES (1, 3, 2, 3, TO_DATE('2023-08-15', 'YYYY-MM-DD'));
INSERT INTO actuaciones (id_plaza, id_matador, id_subalterno, id_lidiador, fecha) VALUES (2, 1, 1, 1, TO_DATE('2023-09-10', 'YYYY-MM-DD'));

```
