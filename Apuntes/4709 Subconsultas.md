## Asignatura [[GBD]] [[09_Subconsultas]]

---

### Subconsultas

#### Definición de subconsulta

Una consulta es una sentencia `select` . Una subconsulta es una sentencia `select` incrustada(Anidada) en otra sentencia SQL.

```
SELECT nombre, salario 
FROM empleados 
WHERE salario > (SELECT AVG(salario) FROM empleados);
```

En este ejemplo la subconsulta `(SELECT AVG(salario) FROM empleados);` calcula el promedio, y la sentencia principal selecciona el nombre y salario de los empleados cuyo salario sea > el promedio.

---

#### Las subconsultas pueden ser:
- Autónomas:
	- Funcionan por si solas ``(SELECT AVG(salario) FROM empleados);``
	- Si la extraemos de la consulta padre, sigue funcionando
- Correlacionales:
	- Dependen de la consulta principal para ejecutarse. Necesitan valores de cada fila de la consulta principal
	- Hacen referencia a columnas de la consulta padre

```
SELECT e1.nombre, e1.salario 
FROM empleados e1
WHERE salario > (SELECT AVG(e2.salario) 
                 FROM empleados e2 
                 WHERE e1.departamento_id = e2.departamento_id 
```

En este ejemplo, suponiendo la siguiente tabla:

>NOTA: PRIMERO SE EJECUTA LA CONSULTA HIJA, CALCULA EL AVG PARA CADA DEPARTAMENTO Y LUEGO LA CONSULTA PADRE EVALÚA.
> La clave esta en la clausula where e1.departamento = e2.departamento ; esto le dice a la subconsulta que para cada fila de la tabla principal e1.departamento calcule la media de solo aquellos empleados cuyo id de departamento coincida con el id departamento de e1.
> La idea es la siguiente, para cada fila de la tabla e1 de la consulta padre, se calculara la media de su salario con aquellos empleados cuyo id_departamento sea igual al id_departamento del empleado evaluado y ya el resto de la ejecución te la sabes.

| id  | nombre | salario | departamento_id |
| --- | ------ | ------- | --------------- |
| 1   | Ana    | 3000    | 1               |
| 2   | Luis   | 4000    | 1               |
| 3   | Pedro  | 2500    | 2               |
| 4   | Marta  | 3500    | 2               |
| 5   | Juan   | 5000    | 1               |

> - La subconsulta correlacionada, se procesara por cada fila de la tabla seleccionada por la consulta padre. Para Ana, se hará la media de salario de su departamento, en este caso, `departamento_id = 1` 
 > - Una vez hecha la media, que en este caso es `(3000 + 4000 + 5000) / 3 = 4000`. Luego se ejecuta la consulta padre que devolverá el nombre de Ana y su salario, solo si este ultimo cumple la condición de ser mayor a la media de su departamento.
> - En este caso, el salario de Ana = 3000 y la media de su departamento es = 4000. Por lo que no se devolverán los valores de la lista de selección de la consulta padre.


Una consulta puede contener una subconsulta, y a su vez esta puede contener otra, así sucesivamente. Esta jerarquia de consultas puede ser tan compleja como se requiera. La jerga para referirte a cada nivel es la siguiente: “la consulta de más
alto nivel”, “la más externa”, “el padre de”, “la hija de”. 

> Consulta padre e hija no tienen por que actuar sobre la misma tabla

--- 

#### Problemas que se resuelven con subconsultas

1. - **Consultas complejas multinivel:**  La subconsulta devuelve la respuesta a una pregunta, y esta es utilizada por la consulta padre para responder la suya propia.

	- Ejemplo: 
	
```sql
SELECT nombre, salario, departamento_id 
FROM empleados 
WHERE departamento_id = (
    SELECT departamento_id 
    FROM (
        SELECT departamento_id, AVG(salario) AS salario_promedio 
        FROM empleados 
        GROUP BY departamento_id 
        ORDER BY salario_promedio DESC 
        LIMIT 1 -- Esto es simplemente para devolver el primer valor
    ) AS subquery
);
```

##### En esta consulta:

1️⃣ **Subconsulta más interna:**

- Agrupa las filas de la tabla `empleados` por departamento (`GROUP BY departamento_id`).
- Calcula el **salario promedio** en cada departamento (`AVG(salario)`).
- Ordena los departamentos de mayor a menor salario promedio (`ORDER BY salario_promedio DESC`).
- Devuelve solo el **departamento con el salario promedio más alto** (`LIMIT 1`).

2️⃣ **Subconsulta intermedia:**

- Toma el **departamento devuelto por la subconsulta interna**, es decir, el que tiene el **mayor salario promedio**.
- Extrae únicamente el `departamento_id` para que la consulta principal lo pueda usar.

3️⃣ **Consulta principal:**

- Usa el **departamento obtenido en la subconsulta intermedia** para filtrar (`where departamento_id`) la tabla `empleados`. 
- Devuelve el **nombre, salario y departamento de todos los empleados que trabajan en ese departamento**.

2. - **Crear tablas pobladas:** Cuando vinculamos una subconsulta a un `CREATE TABLE` te permite crear la tabla y a la vez poblarla con los datos de una fuente existente

	- Ejemplo: 
	
```sql
CREATE TABLE empleados_altos 
SELECT nombre, salario, departamento_id 
FROM empleados 
WHERE salario > (
    SELECT AVG(salario) 
    FROM empleados
);
```


- Explicación:

**1️⃣ Consulta hija:** Esta consulta devuelve el salario medio de la tabla `empleados`

2️⃣ **Consulta principal:** Esta sentencia crea la tabla `empleados_altos` y a su vez, inserta los valores `nombre` , `salario` , `departamento_id` en ella de la tabla empleados, pero solo aquellos cuyo salario sea > a la media calculada por la sentencia hija.


3. **Manipulación de grandes volúmenes de datos:** Las subconsultas de incorporan en sentencias `INSERT` o `UPDATE` para mover grandes cantidades de datos de un almacén a otro y *actualizar* o *insertar* muchas filas con una sola sentencia.

Supongamos que tenemos una tabla **`empleados`** y queremos **actualizar los salarios** de los empleados en departamentos con un salario promedio superior al promedio global de la empresa.

**Objetivo:** Actualizar el salario de los empleados en esos departamentos para que tengan un aumento del 10%.

```sql
UPDATE empleados e
SET salario = salario * 1.10
WHERE departamento_id IN (
    SELECT departamento_id
    FROM empleados
    GROUP BY departamento_id
    HAVING AVG(salario) > (SELECT AVG(salario) FROM empleados)
);
```

### **1️⃣ Subconsulta más interna:**

- **Función**: Calcula el salario promedio global de toda la empresa. `AVG(salario)`
- **Resultado**: Devuelve un **solo valor**: el salario promedio global de todos los empleados.
- **Descripción adicional**: Este valor es utilizado por la subconsulta intermedia para filtrar los departamentos.

### **2️⃣ Subconsulta intermedia:**

- **Función**: Agrupa los empleados por **departamento_id** y calcula el salario promedio de cada departamento `AVG(salario)`.
- **Condición**: (`HAVING AVG(salario)`) Selecciona aquellos departamentos cuyo **salario promedio es mayor que el salario promedio global de la empresa** (valor calculado por la subconsulta más interna) .
- **Resultado**: Puede devolver **uno o más valores**: los `departamento_id` que cumplen la condición.

### **3️⃣ Consulta externa:**

- **Función**: (`UPDATE`) Actualiza los **salarios** de los empleados en los departamentos seleccionados por la subconsulta intermedia.
- **Operación**: Multiplica el salario de esos empleados por **1.10**, es decir, les otorga un aumento del 10%.
- **Resultado**: Actualiza **solo los empleados de los departamentos seleccionados** por la subconsulta intermedia.


#### Tipos de subconsultas

- **Subconsultas de fila única (Single-row):** Devuelven una única fila.

- **Subconsultas multi-fila (multi-row):** Devuelven ninguna, una o varias filas. La consulta padre debe prever que el resultado de la subconsulta puede traer varias filas. 
	>El ejemplo UPDATE de la solución con subconsultas -> manipulación de grandes volúmenes.

- **Subconsultas multi-columna:** Devuelven mas de una columna.

- **Subconsultas correlacionadas:** Una **subconsulta correlacionada** usa columnas especificadas en la consulta padre, lo que la hace **dependiente** de la consulta principal. No puede ejecutarse de manera independiente, ya que se evalúa para **cada fila** que la consulta padre está procesando. La subconsulta utiliza los valores de la fila actual de la consulta padre para realizar su evaluación.

- **Subconsultas escalares:** Devuelven un único valor (fila, columna...). Puede utilizarse en cualquier ubicación donde tuviera sentido situar una expresión del mismo tipo que lo devuelto.

--- 

## Explicación en detalle de cada una de las subconsultas

### Una única fila o muchas (Single-row/Multi-row)

#### Subconsultas Single-row

> Con las subconsultas podemos lograr que consultas en varios pasos, se puedan resumir en una sola consulta

Por ejemplo:  Queremos devolver los empleados que trabajan en el mismo `BARCO` que `PAU GASOL`. Para ejecutar esta tarea, primero debemos buscar el id del barco donde trabaja `PAU GASOL`.

```sql
SQL > SELECT BARCO
	  FROM TRIPULANTES
	  WHERE apeTri = 'Gasol' and nomTri = 'Pau';
```

Esto generara una salida como:

BARCO |
--------| 
	1   |

Luego de saber el id del `barco`, debemos buscar todos los `empleados` que trabajan en el.

```sql
SQL > SELECT idTri, apeTri, nomTri
	  FROM TRIPULANTES
	  WHERE BARCO = 1 
	  AND NOT (apeTri = 'Gasol' and nomTri = 'Pau');
```

Salida esperada:

| IDTRI | APETRI      | NOMTRI |
| ----- | ----------- | ------ |
| 1     | Bryant      | Kobe   |
| 2     | Bynum       | Andrew |
| 3     | World Peace | Metta  |
| 4     | Fisher      | Derek  |
| 5     | Walton      | Luke   |
| 6     | Barnes      | Mat    |
| 7     | Blake       | Steve  |

--- 

Sin embarco con una subconsulta habríamos dado respuesta con una sola sentencia:

```sql
SQL > SELECT idTri, apeTri, nomTri
	  FROM TRIPULANTES
	  WHERE BARCO = ( SELECT BARCO
					  FROM TRIPULANTES
					  WHERE apeTri = 'Gasol'
					  AND nomTri = 'Pau')
	  AND NOT (apeTri = 'Gasol' AND apeTri = 'Pau');
```

Con esto habremos conseguido sustituir el `id_Barco = 1` obtenido en el primer paso, por una subconsulta similar al primer paso.

##### ⚠️ Sin embargo hay un peligro ⚠️
La consulta padre esta estructurada para recibir un solo valor por parte de la consulta hija. En este caso barco = 1. Si la consulta hija devuelve mas de un valor el sistema devolverá un error. 

**para vitar esto tenemos varias soluciones:** 

- Construir la clausula where de la subconsulta en base a una clave primaria

`SELECT BARCO FROM TRIPULANTES WHERE idTri = 5;`

- Que la subconsulta devuelva una función de totalización sobre la tabla completa (Sin incluir un group by)

```sql
SQL > select min(barco)
	  from TRIPULANES
	  where apeTri = 'Gasol';
```


Al incluir una función de totalización sin una clausula group by, estaremos obligando a la subconsulta a devolver un solo valor.


- Incluir una restricción explicita para evitarlo en la subconsulta. Utilizando la seudocolumna rownum

```sql
SQL > SELECT min(BARCO)
	  FROM TRIPULANTES
	  WHERE apeTri = 'Gasol' AND rownum > 2;
```

> Estas 3 técnicas evitaremos un error aunque lo que debemos hacer es estructurar la consulta ante la previsión de que la subconsulta no devuelva mas de una fila.

---

En una clausula `where` de una consulta pueden aparecer mas de una subconsulta: 


```sql
SQL > SELECT idTri, apeTri, nomTri
	  FROM TRIPULANTES
	  WHERE barco = (
	  SELECT barco
      FROM TRIPULANTES
      WHERE apeTri = 'Gasol'
	        AND nomTri = 'Pau')
		AND NOT (apeTri = 'Gasol' AND nomTri = 'Pau')
		AND nss = (
		    SELECT numSegSoc
		    FROM BENEFICIOS_FISCALES
		    WHERE idBF = 1);
```

> aquí `nss` es el numero de la seguridad social, y es conseguido a través de una subconsulta. Por lo que en la clausula `where` de la consulta padre, tiene dos subconsultas como predicado.

--- 

#### Subconsultas multi-row

> Este tipo de subconsultas devuelven mas de una fila a la consulta padre

En el ejemplo anterior si eliminamos `AND nomTri = 'Pau')` , la subconsulta nos podría devolver mas de un valor, ya que pueden haber mas de un tripulante con apellido "Gasol". Esto devolvería un error, ya que la consulta padre no esta estructurada para recibir mas de un valor (Como hemos explicado antes)

```sql
SQL > SELECT idTri, apeTri, nomTri
	  FROM TRIPULANTES
	  WHERE BARCO = ( SELECT BARCO
					  FROM TRIPULANTES
					  WHERE apeTri = 'Gasol')
	  AND NOT (apeTri = 'Gasol' AND apeTri = 'Pau');
```

> La petición de información en este caso es "Dame los nombres de los empleados que trabajen en el mismo barco que Gasol" Lo que precisa que solo haya un Gasol por propia sintaxis de la petición (Puede acarrear errores).

> La solución real a este problema, es la estructuración de la consulta padre de forma adecuada

```sql
SQL > SELECT BARCO, apeTri, nomTri
	  FROM TRIPULANTES
	  WHERE BARCO IN (SELECT BARCO
					  FROM TRIPULANTES
					  WHERE apeTri = 'Gasol')
```

> Al introducir `IN` en realidad hemos cambiado la petición de información: "Dame los nombres de los empleados que trabajen en el mismo barco que un Gasol". Lo que por sintaxis permite que haya mas de un Gasol.

*Aquí se compara un valor de la sentencia padre, con varios "En este caso" de la sentencia hija.*

---

#### Subconsultas multi-columna

Las subconsultas anteriores comparan cada valor del padre con uno (single-row) o varios (multi-row) de la hija. Pero con las subconsultas multi-columna podemos comparar varias columnas a la vez.

```sql
SQL > SELECT idTri
	  FROM TRIPULANTES
	  WHERE (nomTri, apeTri) IN
		    (SELECT nomCli, apeCli FROM CLIENTES)
		    AND BARCO = 1;
```

1️⃣ **La subconsulta (sentencia interna)**

- Devuelve **todas** las combinaciones de valores de las columnas seleccionadas en la tabla `CLIENTES`.
- En el ejemplo: `(nomCli, apeCli) FROM CLIENTES`.
- No filtra en función de `TRIPULANTES`, simplemente obtiene datos.

2️⃣ **La consulta principal (sentencia externa o padre)**

- Compara cada fila de `TRIPULANTES` con los valores devueltos por la subconsulta.
- Filtra la tabla `TRIPULANTES`, devolviendo **solo aquellas filas cuyo `(nomTri, apeTri)` coincidan con los valores obtenidos en la subconsulta**.


*Aquí comparamos cada par de valores (nombre y apellidos) de cada fila de la tabla TRIPULANTES en la consulta padre con cada par de valores (nombre y apellidos) de cada fila de la tabla CLIENTES en la subconsulta*

---

#### Subconsultas escalares

