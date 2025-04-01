### 1. Mostrar cada plaza y cada matador que haya actuado en ellas.

```sql

select nombre from plazas p
union
select nombre from matadores m
where exists (
	select 1 -- Valor arbitrario
	from actuaciones a
	where a.id_matador = m.id_matador
);

```

>Esta consulta te devuelve todos los nombres de las plazas y con la expresión where exists (QUE NO EXIST) verifica si el matador ha actuado en alguna de las actuaciones registradas. Hay un pequeño error, Que pasa si el matador ha toreado en alguna de las actuaciones registradas pero en esa actuación se recoge una plaza no registrada en la tabla plazas? 
>
>> Corrección, toda actuación debe tener un id_plaza, lo que impide que se registre un matador en una actuación  con una plaza no registrada (No podemos meter un id que no existe en esa foreign key).


### 2. Mostrar cada plaza y el número de matadores distintos que han actuado en ellas.

> Podemos reutilizar código? Yo digo si

```sql

select p.nombre,
	(select count(distinct a.id_matador)
	from actuaciones a
	where a.id_plaza = p.id_plaza) AS matadores -- Devuelve lo mismo para cada plaza si no introducimos esta condicion
from plazas p;

```

NOTA: `WHERE a.id_plaza = p.id_plaza` es lo que asegura que **solo se cuenten** los matadores de la plaza que estamos iterando en la consulta principal



> La consulta anterior devuelve el nombre de cada plaza existente y en su lista de selección tenemos una subconsulta, donde, para cada plaza, cuenta el numero de actuaciones que se han dado en ella. Como para cada actuación debemos tener un matador (evidentemente), si queremos devolver el numero de matadores que han toreado en cada plaza, solo debemos contar el numero de actuaciones que se han dado en cada una.

> Actualización, la afirmación anterior es falsa, si le ponemos un `distinct a.id_matador` y no un `count(*)` general, no nos hace falta el razonamiento de que para cada actuación debemos tener un matador. Lo que me facilita mucho la vida en la siguiente consulta, ya que sin saber si debe haber un subalterno en cada actuación, no sabia como sustituir el `count(*)`

### 3. Mostrar cada plaza y el número de subalternos distintos que han actuado en ellas.

> Ahora si reutilizamos código, lo prometo


```sql


select p.nombre,
	(select count(distinct a.id_subalterno)
	from actuaciones a
	where a.id_plaza = p.id_plaza) AS matadores -- Devuelve lo mismo para cada plaza si no introducimos esta condicion
from plazas p;

```

> Básicamente lo mismo que el anterior


### 4. Mostrar cada plaza y el número de lidiadores distintos que han actuado en ellas.

Lo mismo:

```sql



select p.nombre,
	(select count(distinct a.id_lidiador)
	from actuaciones a
	where a.id_plaza = p.id_plaza) AS matadores -- Devuelve lo mismo para cada plaza si no introducimos esta condicion
from plazas p;



```




### 5. Máximo número de matadores distintos que ha actuado en una plaza.

```sql

select max(matadores) 
from (select count(distinct a.matadores)
	from actuaciones a
	where a.id_plaza = plazas.id_plaza)
union
select p.nombre
from plazas p

```




### 6. Máximo número de subalternos distintos que ha actuado en una plaza.



### 7. Máximo número de lidiadores distintos que ha actuado en una plaza.



### 8. Nombre de la plaza en la que han actuado mayor número de matadores distintos.



### 9. Nombre de la plaza en la que han actuado mayor número de subalternos distintos.



### 10. Nombre de la plaza en la que han actuado mayor número de lidiadores distintos.



### 11. ¿Cuál de las siguientes palabras reservadas no tiene que ver con los operadores de conjuntos?
- a) all.

- b) set.

- c) minus.

- d) union.


### 12.Tienes una tabla de PEDIDOS con todos los pedidos y otra PEDIDOS_DEVUELTOS que duplica cada línea de PEDIDOS para todo pedido que haya sido devuelto. Tu tarea es de limpieza: se trata de verificar, usando algún operador de conjuntos, si alguna fila de PEDIDOS_DEVUELTOS no está en PEDIDOS (una situación no deseada).


### 13.Al combinar el resultado de dos sentencias select, cual de los siguientes operadores de conjunto genera una salida distinta dependiendo de cual de los dos select preceda o siga al operador:
- a) minus.

- b) union all.

- c) intersect.

- d) union.


### 14. ¿Cual de la siguientes afirmaciones es cierta respecto a los operadores de conjunto?


- a) Añadiendo la palabra reservada all a cualquier operador de conjunto se modifica su comportamiento en el sentido que elimina de sus proceso las filas duplicadas.


- b) Añadiendo la palabra reservada all a cualquier operador de conjunto se modifica su comportamiento en el sentido que elimina de su proceso las filas duplicadas.