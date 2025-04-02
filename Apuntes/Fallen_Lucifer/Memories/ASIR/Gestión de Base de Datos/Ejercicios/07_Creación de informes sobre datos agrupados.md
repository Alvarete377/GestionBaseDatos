
## Cuestionario SQL

1. En [O'Hearn, 2010] se dice que las funciones de totalización y las escalares no pueden mezclarse en la lista de selección. Por tanto esta consulta fallará, ¿no?:


   ```sql
   select upper(NomAlu), count(*)
   from ALUMNOS
   group by NomAlu;
   ```

En este caso no fallara por que aunque no se puedan mezclar funciones de totalización con funciones escalares en la lista de selección, el argumento de la función escalar (Que devuelve un solo valor para cada fila), se recoge en la clausula del group by.

Las funciones de totalización, devuelven un solo valor por conjunto de filas. En el caso de no agrupar con una clausula group by, esta devuelve un solo valor en razón de todas las filas de la tabla. Cuando agrupas, y agrupas por el argumento de la función escalar, esta ultima devolverá un valor por cada 



2. Investiga un manual de estadística y dime en qué consisten la varianza y la desviación estándar.

3. Las funciones de totalización (elige 2):
   - a) Devuelven un único valor por cada grupo de filas.
   - b) Se llaman también funciones de grupo (group functions).
   - c) Deben emplearse en una sentencia select que devuelva varias filas.
   - d) Sólo pueden operar sobre datos numéricos.

4. Mira esta sentencia:
   ```sql
   select idFac, count(fFac)
   from FACTURAS;
   ```
   ¿Qué opinas?
   - a) Fallará porque fFac es de tipo fecha.
   - b) Fallará porque mezcla datos escalares y agregados.
   - c) Funciona pero su salida carece de sentido.
   - d) Es totalmente correcta.

5. Comparación de consultas:
   ```sql
   select count(*) from ALUMNOS;
   select count(rowid) from ALUMNOS;
   ```
   ¿Mismo resultado pero mejor rendimiento? Razona la respuesta.

6. Supón la tabla TAB con columna colu (todos valores NULL):
   ```sql
   select count(colu) from TAB;
   ```
   ¿Resultado?

7. Diferencia entre:
   ```sql
   select count(apeTri) from TRIPULANTES;
   select count(all apeTri) from TRIPULANTES;
   ```

