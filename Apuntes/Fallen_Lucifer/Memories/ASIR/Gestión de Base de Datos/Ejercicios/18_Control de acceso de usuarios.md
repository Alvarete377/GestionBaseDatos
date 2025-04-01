
# 📌 Preguntas sobre Privilegios y Administración en Bases de Datos

## 1️⃣ Privilegios y Usuarios

1. Los privilegios son concedidos a las cuentas de usuario y, ¿a quién más?

	**Son concedidos también a los roles, y si se admite como respuesta
	valorar que también se concede a public.**
    
2. ¿Cómo se denomina la capacidad de realizar determinada tarea sobre la base de datos?

	**privilegios de sistema**

3. ¿Qué permite la concesión del privilegio `CREATE TABLE`?

	**Crear tablas sobre tu propio esquema**

    
4. ¿`CREATE SESSION` es un privilegio de sistema o sobre objetos? ¿Por qué?
    
    **Es un privilegio de sistema, por que te permite acceder a la base de datos(sistema). Ademas ese privilegio no involucra ningún objeto de base de datos ni otorga acceso a objetos específicos dentro de ella**

---

## 2️⃣ Gestión de Usuarios

5. Indica la sentencia a emitir para borrar el usuario `AURORA` (contraseña `boreal`) y todos los objetos de su pertenencia.

	`drop user aurora cascade;`
	**Desde una cuenta con privilegios sobre aurora, sys, o su creador/owner**


6. La cuenta `OSITO` puede conectar, crear tablas en su esquema y poblar dichas tablas,
    
    - a) Impide que siga poblando sus tablas.
        `revoke create table from osito;` PREGUNTAR 
        quizá create session directamente?
    - b) Impide que conecte.
        `revoke create session from osito;`
    - c) ¿Puede seguir creando tablas en su esquema? ¿Y eso?
        **Al haberle quitado el create table ya no puede seguir creando tablas**

---

## 3️⃣ Privilegios sobre Objetos

7. El usuario `BOBESPONJA` tiene concedido el privilegio `CREATE TABLE`:
    
    - a) ¿Puede automáticamente poblar sus tablas?
        **No, primero le deben conceder un espacio de tablas**
    - b) ¿Y modificar sus estructuras?
        **Si, puede seguir modificando su estructura, esto incluye update, delete e insert** PREGUNTAR
    - c) ¿Y crear secuencias asociadas a los identificadores de las mismas?
		**No, para crear secuencias se necesita el rol `create sequence` **

8. Muchos privilegios van precedidos por la palabra `ANY`. ¿Qué implica este prefijo?
    **Que incluyen privilegios sobre todo el sistema, por ejemplo `grant select any table to ....` Permite que el grantee consulte cualquier tabla de cualquier esquema. Así con todos los privilegios**
    
9. ¿Puede un usuario crear una tabla en el esquema de otra cuenta? ¿ Qué privilegio necesita?
    **Podría, si le han concedido el privilegio `create any table`**
    
10. En un ejemplo de este tema `MARIO` crea una tabla en el esquema `ALASKA`, ¿cuál de los dos es propietario de la misma?
    **El propietario de la tabla es ALASKA aunque la haya creado mario. Al estar en su mismo esquema, se considera que esa cuenta es la propietaria aunque la tabla la haya creado otro esquema**

---

## 4️⃣ Seguridad y Administración

11. ¿Qué regla básica de la administración viola el uso indiscriminado de `ALL PRIVILEGES`?

	**LA REGLA DEL MENOR PRIVILEGIO** **, esta regla se define como realizar las acciones necesarias con la cuenta con los requisitos mínimos indispensables para llevarlas a cabo. Si damos all privileges a diestro y siniestro estaremos dando mas privilegios de los necesarios.**

12. ¿Hay (o puede haber) un esquema asociado a la cuenta `PUBLIC`? (cenicero)

	**No, esta cuenta no tiene asociado un esquema, es simplemente un identificador para representar todas las cuentas de la base de datos.**

13. ¿Qué significa que `PUBLIC` sea una cuenta integrada?

	**Que por defecto la traen todas las bases de datos oracle, y es utilizada para gestionar privilegios a nivel de todas las cuentas, es decir, cualquier privilegio concedido a public, sera concedido a todas las cuentas de la base de datos.**

14. ¿Puede la propietaria de una tabla, por ser propietaria y sin haber recibido ningún otro privilegio, conceder a otra cuenta derechos de borrado de las filas de dicha tabla?
    
	**Sí, la propietaria de la tabla puede conceder derechos de borrado de las filas de la tabla a otra cuenta, aunque no haya recibido privilegios explícitos sobre la misma. Esto es porque la propietaria tiene privilegios implícitos sobre sus tablas, y esos privilegios pueden ser concedidos a otros usuarios.**
---

## 5️⃣ Sinónimos en Bases de Datos

15. ¿Con qué finalidad se crean los sinónimos públicos?

	**Con la finalidad de facilitar la vida a otras cuentas a la hora de consultar tus tablas, y con el fin de ocultar el esquema propietario de dicha tabla, al no tener que usar el prefijo para referirse a ella.**

16. ¿Qué cuentas pueden hacer referencia a un sinónimo público?

	**Las cuentas que tengan el privilegio de consulta sobre esa tabla o sobre ese sinónimo publico**
    
17. Si hago `SELECT` usando como argumento de `FROM` un sinónimo público, ¿qué necesito para que funcione?

	**Necesitas privilegios `select` sobre el sinónimo publico o sobre la tabla**

---

## 6️⃣ Actividades sobre Privilegios y Usuarios

18. Le quito un privilegio a un usuario y éste sigue manteniendo la capacidad de realizar la acción que acabo de prohibir. ¿Qué dos comprobaciones debo realizar?

- **Mirar si public tiene concedido ese privilegio**
- **Revisar los roles del usuario, y los privilegios asignados a cada rol**

---

19. ¿Cuál de las siguientes sentencias SQL autorizará al usuario MERIDA a crear tablas en cada uno y en todos los esquemas de la base de datos?

a) grant create all table to MERIDA;
b) grant create public table to MERIDA;
c) **grant create any table to MERIDA;**
d) grant create table to MERIDA with public option;

---

20. Te conectas como el usuario SKYRIM y se te pide que le des privilegios a la cuenta OBLIVION. Ejecutas las siguientes sentencias SQL:

```sql

grant create any table to OBLIVION with admin option;
revoke create any table from OBLIVION;

```

Asumiendo que ambas sentencias se ejecutan correctamente, ¿cuál es el resultado?

**a) OBLIVION no tiene el privilegio de sistema create any table, ni por tanto el
derecho de conceder create any table a ninguna otra cuenta.**

b) OBLIVION mantiene el privilegio de sistema create any table porque no se ha
incluido la cláusula with admin option en la sentencia revoke.

c) OBLIVION no tiene ya el privilegio de sistema create any table, pero todavía
puede transmitir dicho privilegio ya que se ha omitido la cláusula with admin
option en la sentencia revoke. Con una única restricción: OBLIVION no puede volver
a otorgarse el privilegio a sí mismo.

d) OBLIVION no tiene ya el privilegio de sistema create any table, pero todavía
puede transmitir dicho privilegio ya que se ha omitido la cláusula with admin
option en la sentencia revoke. Más aún: OBLIVION puede volver a otorgarse el
privilegio a sí mismo.


21. ¿Cuál de los siguientes es el privilegio de sistema mínimo para permitir que un usuario se conecte a una base de datos?


a) create any login

b) create any session

**c) create session**

d) create table

22. ¿Cuál de los siguientes es el privilegio de sistema que capacita al receptor del mismo para crear un índice en su propia cuenta pero no en la cuenta de otros?


a) create table

b) create any table

**c) create index**

d) create any index


23. Tu cuenta posee una tabla CADENAS y quieres conceder privilegios sobre la misma a una cuenta llamada DJANGO, que ya posee los privilegios de sistema create session y unlimited tablespace. Examina la siguiente sentencia:

`grant select on CADENAS to DJANGO;`

Una vez ejecutada, ¿cuál de la siguientes afirmaciones será cierta para el usuario DJANGO?

**a) DJANGO tendrá privilegio de lectura sobre CADENAS, pero no la capacidad de transmitir dicho privilegio a otros usuarios.**

b) DJANGO tendrá privilegio de lectura sobre CADENAS, así como la capacidad de transmitir dicho privilegio a otros usuarios.

c) DJANGO tendrá privilegio de lectura, inserción, actualización y borrado sobre CADENAS, pero no la posibilidad de transmitir dichos privilegios a otros usuarios.

d) DJANGO tendrá privilegio de lectura y de alter table sobre CADENAS, pero no la
posibilidad de transmitir dichos privilegios a otros usuarios.


24. Tu cuenta de usuario posee una vista actualizable PENDIENTES que está basada en la tabla PROYECTOS. Se te pide que proporciones las capacidades select y update sobre dicha vista a otra cuenta llamada GNOMEO. Ahora mismo GNOMEO no tiene privilegios ni sobre la tabla, ni sobre la vista. También quieres que GNOMEO sea capaz de transmitir dicho privilegio. Se lanzan las siguientes sentencias:


`grant select on PENDIENTES to GNOMEO with grant option;`
`grant update on PENDIENTES to GNOMEO;`

¿Cuál de las siguientes sentencias es cierta?

a) Las sentencias fallan y GNOMEO no será capaz de usar la vista.

b) Las sentencias se ejecutan correctamente pero GNOMEO no será capaz de leer de la vista porque no se le ha concedido lectura sobre la tabla PROYECTOS.

c) Las sentencias se ejecutan correctamente GNOMEO será capaz de leer de PENDIENTES pero no de actualizarla.

**d) Las sentencias se ejecutan y todo funciona como estaba previsto.**



25. La cuenta LOCOVITCH posee la tabla CONVERTIBLES ¿Cuál de las siguientes sentencias debe ejecutar LOCOVITCH para permitir al usuario OSOMIEDOSO ejecutar sentencias update sobre la tabla CONVERTIBLES ? (elige todas las que valgan y di cuál es la mejor)


a) grant all on CONVERTIBLES to OSOMIEDOSO;

b) grant all privileges to OSOMIEDOSO;

c) grant all to OSOMIEDOSO;

**d) grant insert, update on CONVERTIBLES to OSOMIEDOSO;**


26. Examina la dos siguientes afirmaciones:

[1] La vista del diccionario de datos DBA_TAB_PRIVS permite a una cuenta de usuario
examinar los privilegios sobre objetos que ha otorgado a otras cuentas.

[2] La vista del diccionario de datos DBA_TAB_PRIVS permite a una cuenta de usuario
examinar los privilegios sobre objetos que le han otorgado otras cuentas de usuario

¿Cuál de las afirmaciones es cierta?

a) Sólo [1]
b) Sólo [2]
**c) Tanto [1] como [2]**
d) Ni [1] ni [2]

27. ¿Cuál de las siguientes vistas del diccionario de datos contiene información de concesiones sobre tablas que han sido hechas por otros usuarios a tu cuenta, así como concesiones sobre tablas llevadas a cabo por tu cuenta de usuario a otras cuentas?

a) USER_TAB_COLUMNS

b) **USER_TAB_PRIVS**

c) USER_TABLES

d) ALL_TAB_PRIVS_RECD

