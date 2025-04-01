
Para que una cuenta de usuario pueda llevar a cabo una determinada acción, necesita su correspondiente privilegio, o conjunto de estos.

Los privilegios pueden ser otorgados a **una cuenta de usuario o a un rol.** 
Un rol es otro objeto de base de datos.


## Privilegios de sistema vs Privilegios sobre objeto

### Privilegio sobre sistema
> Capacidad de ejecutar determinada acción sobre la base de datos.
### Privilegios sobre objeto
>  Capacidad de ejecutar una determinada tarea sobre un objeto concreto de base de datos.
### Rol
>  Es una colección de privilegios de sistema y/o privilegios de objetos y/o otros roles.



#### Privilegios de sistema

Capacidad de iniciar sesión, crear tablas, vistas, secuencias, roles etc...

![[Pasted image 20250326052224.png]]![[Pasted image 20250326052249.png]]![[Pasted image 20250326052313.png]]![[Pasted image 20250326052326.png]]
Los privilegios de objetos se diferencian por tener en su sintaxis "on"
por ejemplo: `grant select on alumnos to alvarovava;`

## Crear, Modificar y eliminar cuentas

`Create user alvarovava identified by alvarovava;`
`Alter user alvarovava identified by alvarovava1;`
`Drop user alvarovava;`
`Drop user alvarovava cascade;`

##### Conceder espacios para crear esquemas y conectar
`connect alvarovava/alvarovava1@DELFOS`
`Grant unlimited tablespace to alvarovava;`

##### Conceder y abolir privilegios
1. Creación del usuario
	`Create user PACO identified by paquito;`
2. Privilegios para conectar y para crear esquemas
	`Grant create session to PACO;`
	`Grant unlimited tablespace to PACO`
	`Grant create table to PACO;`

	>PACO podrá crear tablas con espacio ilimitado, conectarse a la base de datos, pero no podrá por ejemplo, crear una secuencia

![[Pasted image 20250326053806.png]]

Cuando se le conceda el privilegio `Create sequence` con `Grant create sequence to PACO` ya podrá crear una secuencia.

Nota: se pueden conceder varios privilegios a una misma cuenta separandolos por comas, también se puede conceder el mismo privilegio a varias cuentas, separandolas también por comas.

##### Abolir privilegios `Revoke`

Para abolir un privilegio se usa `Revoke`, en este caso se hace con from, no con to.

Siguiendo el ejemplo de PACO:

`revoke create table from PACO;`
`revoke create session from PACO;`
`revoke unlimited tablespace from PACO;`
`Drop user PACO cascade;`

Atención, las acciones previas a la revocación de un privilegio se hacen permanentes. Los revokes hacen commits implícitos si son sobre privilegios de roles o de sistema. 

##### Any

Any significa que el privilegio es aplicable a cualquier esquema

`Grant select any table to PACO;` 
Esto privilegio le permite a PACO consultar cualquier tabla de cualquier esquema

`Grant create any table to PACO;`
Este privilegio le concede la capacidad a PACO de crear una tabla en cualquier esquema. Si PACO no tiene cuota de espacio en la base de datos, no podrá crear tablas en su propia cuenta, pero si lo podrá hacer en cualquier otro esquema.

![[Pasted image 20250326065015.png]]

![[Pasted image 20250326065411.png]]

![[Pasted image 20250326065630.png]]

"Paco ya tenia la tabla prueba" 

Paca no tiene privilegios para crear tablas, PACO no tiene cuota, luego la tabla la puede crear en el esquema PACA, quien si tiene cuota. El owner es PACA aunque PACO la haya creado.


##### Admin option

La opción with admin option al conceder un privilegio le concede al grantee la posibilidad de propagar ese privilegio 

Por ejemplo: Si SYS le concede el privilegio `Grant create table to PACO;`
Pero lo hace con 
"With admin option" -> `Grant create table to PACO with admin option;`

PACO podrá conceder el privilegio de crear tablas a cualquier otra cuenta.

> Nota: Si concedemos un privilegio with admin option a PACO y PACO le concede ese privilegio a PACA. Si luego SYS le revoka el privilegio en cascada a PACO, PACA mantendrá el privilegio aunque PACO ya no lo tenga. 

##### All privileges

Concede todos los privilegios de sistema a una cuenta.
`Grant all privileges to PACO;`


##### Public

Es una cuenta integrada del sistema, que representa a todas las cuentas de usuario

Si ejecutamos la  sentencia: `Grant select on PACA.TEQUIERO to public` 
CUALQUIER CUENTA DE LA BASE DE DATOS PODRÁ CONSULTAR ESA TABLA.

## Concesión de privilegios sobre tablas

> Nota: La cuenta propietaria de una tabla, no necesita privilegios explícitos para realizar cualquier acción DML sobre la misma. La cuenta propietaria de una tabla puede conceder privilegios sobre la misma.

![[Concesion_Sobre_Tablas.sql]]


```sql

connect PACA/paca@DB
drop table TEQUIERO;
create table TEQUIERO(id_tq number(5));
insert into TEQUIERO(id_tq) values (1);
insert into TEQUIERO(id_tq) values (2);
insert into TEQUIERO(id_tq) values (3);
grant update on TEQUIERO to PACO;

connect PACO/paco@DB
update PACA.TEQUIERO
set id_tq = 4
where id_tq = 1;

```

![[Pasted image 20250326072911.png]]


PACO solo puede leer y actualizar los datos de la tabla TEQUIERO, pero no puede insertar datos en la misma. 

#### Prefijos de esquema / SINÓNIMOS PÚBLICOS

PACO tiene que utilizar el prefijo PACA para referirse a la tabla TEQUIERO. Una forma de ocultarle a PACO, la existencia de PACA (o facilitarle la vida) es la creación de un sinónimo publico (alias para referirse a una tabla, global para todas las cuentas de la base de datos).
Primero desde SYS `grant create public synonym to PACA;`

desde PACA:

```sql

create public synonym TQ for PACA.TEQUIERO;

```

desde PACO:

```sql

select * from TQ; -- FUNCIONA

```

Pero si desde PACA le revokamos a PACO el privilegio de consultar TEQUIERO con:
`revoke select on PACA.TEQUIERO from PACO;`

Esto fallara aunque este usando el nombre del sinónimo:
```sql
-- Desde paco
select * from TQ;
-- Privilegios insuficientes
```

Esto no es así con vistas y con sus tablas subyacentes: si tengo privilegio sobre una vista, lo mantengo aunque pierda el privilegio de lectura sobre la tabla subyacente.
Ya que una vista se considera otro objeto de base de datos, no un simple alias.

##### With grant option

Es parecido a la opción `with admin option` pero ahora es sobre privilegios de objetos. 

Es decir, si PACA le concede el privilegio `Grant select on PACA.TEQUIERO to PACO with grant option;`

PACO podrá prorrogar el privilegio sobre TEQUIERO a cualquier cuenta por ejemplo a PAQUI.

```sql

create user PAQUITA identified by paquita;
grant create session to PAQUITA;

connect PACA/paca@DB
drop table TEQUIERO;

create table TEQUIERO(id_tq number(5));
insert into TEQUIERO(id_tq) values (1);
insert into TEQUIERO(id_tq) values (2);
insert into TEQUIERO(id_tq) values (3);
grant select on TEQUIERO to PACO with grant option;

  

connect PACO/paco@DB
grant select on PACA.TEQUIERO to PAQUITA;

  

connect PAQUITA/paquita@DB
select * from PACA.tequiero;

```


NOTA: Al contrario que con `with admin option` la revokacion de los privilegios si se hace en cascada.

```sql

-- Prueba del revoke en cascade
connect PACA/paca@DB
revoke select on TEQUIERO from PACO;

connect PAQUITA/paquita@DB
select * from PACA.tequiero;

```


##### All privileges 

El all privileges sobre objetos, concede todos los privilegios sobre el objeto en cuestión, pero no incluye el with grant option a no ser que se indique expresamente.

Sintaxis:
`Grant all on TEQUIERO to PAQUITA;`

![[Pasted image 20250326080638.png]]

## Consultar privilegios de una cuenta

El diccionario de datos guarda el grantee y el grantor para privilegios sobre objetos
**Pero solo guarda el grantee para privilegios sobre sistemas.**

![[Pasted image 20250326081047.png]]

> Un privilegio puede ser obtenido de forma directa o a través de un rol, de forma indirecta. Si tu intención es quitar un privilegio a una cuenta revisa el diccionario de datos para comprobar que tal privilegio no lo tiene concedido también a través de un rol.

> Para comprobar los privilegios de una cuenta busca en las vistas DBA_SYS_PRIVS 
>  o en DBA_TAB_PRIVS y filtra por el grantee.
>  NO OLVIDES ECHAR UN OJO A LOS PRIVILEGIOS DE PUBLIC, TODOS LOS PRIVILEGIOS DE PUBLIC LOS TIENE TAMBIÉN LA CUENTA QUE ESTAS INVESTIGANDO.

Ver Walrus

##### Concesión de roles

Un rol es un objeto de base de datos que puedes crear y al que se le pueden asignar privilegios de sistema y/o sobre objetos. También puedes conceder otros roles a un rol dado. Una vez creado un rol puede concederse a una cuenta como si de un privilegio se tratara

Pregunta: el with admin option de la pagina 33 es por que se concede como rol, y se considera que un rol, por mas que contenga privilegios sobre objetos, sea de sistema?

![[Pasted image 20250326105144.png]]

MUCHO OJO:

```sql

SQL> select * from DBA_ROLE_PRIVS
  2  where grantee = 'paquita';

no rows selected

SQL> select * from DBA_ROLE_PRIVS
  2  where grantee = 'PAQUITA';

GRANTEE 		       GRANTED_ROLE		      ADM DEF
------------------------------ -----------------------
PAQUITA 		       PACOS			      NO  YES



```


> Si le concedes privilegios sobre un objeto a un rol, y le das este rol a una cuenta, al borrar el objeto, el privilegio desaparece del rol, pero la cuenta sigue manteniendo ese rol, por lo que si vuelves a crear el objeto y le concedes el privilegio anterior al rol, obtendremos la situación inicial.


## Distinción entre privilegios y roles

Roles y privilegios coexisten independientemente, si una cuenta tiene un privilegio, por ejemplo `select any table` y otro rol que contenga el mismo privilegio, debemos revokarle ambos rol y privilegio, para lograr denegarle dicho permiso.
Pero vamos esto te ha quedado muy claro ya, verdad?.

VER [[18_Control de acceso de usuarios]]

