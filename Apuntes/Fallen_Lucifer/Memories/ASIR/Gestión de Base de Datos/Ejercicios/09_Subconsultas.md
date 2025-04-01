
## Preguntas sobre Subconsultas SQL [[4709 Subconsultas]] [[GBD]] 

---

### 1. ¿Cuál de las siguientes formas de subconsulta nunca devuelve más de una fila?

- **a) Escalar**
- b) Correlacionada  
- c) De múltiples columnas  
- d) Ninguna de las de arriba  

---

### 2. ¿Cuál de las siguientes misiones puede ser llevada a cabo usando una subconsulta?

- a) Poblar una tabla con datos nuevos en el momento en el que se crea.  
- **b) Poblar una tabla en el momento en el que se crea con datos procedentes de la propia base.**  
- c) Poblar una tabla en el momento en el que se crea con datos nuevos no procedentes de la propia base.  
- d) Ninguna de las de arriba.  

---

### 3. ¿Cuál o cuáles de las siguientes afirmaciones son ciertas?

- **a) Una subconsulta puede ser de fila única y también multi-fila.**  
- b) **Una subconsulta puede ser de fila única y también multi-columna**.  
- c) Una subconsulta puede ser escalar y también multi-columna.  
- d) **Una subconsulta puede ser correlacionada y también escalar.**  

---

### 4. Una subconsulta que incluye una referencia a su consulta padre y que por tanto no podría ejecutarse como una consulta independiente es: (elige la mejor respuesta)

- a) Una subconsulta escalar.  
- b) **Una subconsulta correlacionada.** 
- c) Una subconsulta multi-columna.  
- d) Una subconsulta referencial.  

---

### 5. ¿Cuál o cuáles de los siguientes operadores de comparación puede usarse con una subconsulta multi-fila?

- a) **` = `** Este
- b) `>= all`  
- c) `like`  
- d) `in`  Este

---

### 6. Sobre el esquema E4709 revisa las tablas de PUERTOS y BARCOS. Examina también el siguiente código SQL:

```sql
select mar, capacidad
from PUERTOS
where idPue > (select puertobase
               from BARCOS where eslora > 900);
```

- a) Un error de ejecución: la consulta padre espera una fila y la hija devuelve más.  
- b) Un error de sintaxis: idPue y puertobase tienen nombres distintos.  
- c) La sentencia se ejecuta correctamente.  
- d) Ninguna de las de arriba.  

---

### 7. Indica lo que es cierto sobre una consulta multi-columna:

- a) Sólo pueden compararse dos columnas entre la consulta padre y la subconsulta.  
- b) Los nombres de las columnas que se comparan deben coincidir.  
- c) **Los tipos de datos de las columnas que se comparan deben coincidir.** 
- d) Una subconsulta puede ser multi-columna y escalar.  

---

### 8. Una subconsulta escalar no debe ser usada en cuál o cuáles de las siguientes cláusulas y/o sentencias SQL:

- a) La lista de selección de una sentencia `select`.  
- b) La lista `values` de una sentencia `insert`.  
- c) La cláusula `set` de una sentencia `update`.  
- **d) La cláusula `group by` de una sentencia `select`.**  

📌 **Razón:** No se puede usar una subconsulta escalar en `GROUP BY`, ya que espera una columna, no un único valor.

---

### 9. Repasa la tabla VIDAS_LABORALES en el contexto del esquema E4709:

```sql
create table VIDAS_LABORALES(
    idVL number,
    tripulante number,
    sueldo number(10,2),
    fini date,
    ffin date,
    constraint fk_tripu foreign key(tripulante)
    references TRIPULANTES(idTri),
    constraint pk_vidas_laborales primary key(IdVL)
);
```



##### Tu misión es construir una consulta que liste, para cada barco, el nombre y apellidos del tripulante con el contrato más corto de su barco. Señala todas las correctas:

### Opciones:

#### a)
```sql
select T.nomTri||' '||T.apeTri Tripulante
from VIDAS_LABORALES VL inner join TRIPULANTES T
on VL.tripulante = T.idTri
where abs(VL.fini - VL.ffin) = (
    select min(abs(fini - ffin))
    from VIDAS_LABORALES inner join TRIPULANTES
    on tripulante = idTri
    where barco = T.barco
);
```


#### b)

```sql
select T.nomTri||' '||T.apeTri Tripulante
from VIDAS_LABORALES VL inner join TRIPULANTES T
on VL.tripulante = T.idTri
where abs(VL.fini - VL.ffin) = (
    select min(abs(fini - ffin))
    from VIDAS_LABORALES inner join TRIPULANTES
    on tripulante = idTri
);
```

#### c)

```sql
select T.nomTri||' '||T.apeTri Tripulante
from VIDAS_LABORALES VL inner join TRIPULANTES T
on VL.tripulante = T.idTri
where abs(VL.fini - VL.ffin) <= all (
    select abs(fini - ffin)
    from VIDAS_LABORALES inner join TRIPULANTES
    on tripulante = idTri
    where barco = T.barco
);
```

#### d)

```sql
select T.nomTri||' '||T.apeTri Tripulante
from VIDAS_LABORALES VL inner join TRIPULANTES T
on VL.tripulante = T.idTri
where abs(VL.fini - nvl(VL.ffin, sysdate)) <= all (
    select abs(fini - nvl(ffin, sysdate))
    from VIDAS_LABORALES inner join TRIPULANTES
    on tripulante = idTri
    where barco = T.barco
);
```

#### e) DIRÍA QUE ES ESTE

```sql
select T.nomTri||' '||T.apeTri Tripulante
from VIDAS_LABORALES VL inner join TRIPULANTES T
on VL.tripulante = T.idTri
where abs(VL.fini - VL.ffin) < (
    select min(abs(fini - ffin))
    from VIDAS_LABORALES inner join TRIPULANTES
    on tripulante = idTri
    where barco = T.barco
);
```

---

### 10. Revisa el esquema E4709. Tu misión es crear una lista con los barcos con la menor capacidad de cada puerto.

```sql
01 select B1.nomBar "Barco", (
02     select nomPue
03     from PUERTOS
04     where idPue = B1.puertoBase
05 ) "Puerto Base"
06 from BARCOS B1
07 where capacidad = (
08     select min(capacidad)
09     from BARCOS B2
10     where B2.puertoBase = B1.puertoBase
11 );
```


¿Cuál de las siguientes afirmaciones es cierta respecto a esta consulta?

- a) La sentencia falla. Hay un error en la subconsulta que va de las líneas 1 a 3.
    
- b) La sentencia falla. Hay un error de ejecución en la subconsulta que va de las líneas 1 a 3.
    
- c) La sentencia se ejecuta pero la salida no tiene sentido alguno.
    
- **d) La sentencia se ejecuta y hace lo que se espera de ella.**
    

---

### 11. Una consulta correlacionada puede usarse en: (elige todas las correctas):

- **a) La cláusula `set` de una sentencia `update`.**
    
- **b) La cláusula `where` de una sentencia `update`.**
    
- c) La cláusula `where` de una sentencia `delete`.
    
- d) La cláusula `from` de una sentencia `delete`.