# *Arquitectura de equipos microinformáticos*
[[FH]]
## **Conceptos generales sobre buses**

- ### **Definición de bus**:
	 #### Una o mas lineas de material conductor que conecta dos o mas dispositivos
- ### **Ancho de bus**:
	 #### Numero de lineas de que integran el bus. Como cada linea del bus equivale a una señal, la cantidad máxima de señales que pueden ser transmitidas simultáneamente viene determinadas por el numero de lineas que lo integran.
- ### **Tipos de buses**:

	- #### **Por numero de lineas y tecnología**
		- #### Buses serie
		- #### Buses paralelos

	- #### **Por el sentido permitido para la comunicación**
		- #### Buses simplex
		- #### Buses half duplex
		- #### Buses full duplex
	- #### **Por sincronizacion de las transferencias**
		- #### Buses asíncronos
		- #### Buses síncronos

--- 

# **Buses síncronos**

- La transmisión a través del bus se sincroniza mediante una señal de reloj externa.
- En principio solo se puede efectuar una transferencia por cada ciclo de reloj. Aunque tecnologías posteriores permiten aumentar el numero de transferencias por ciclo:
	- Factor de pumping: Es el numero de transferencias que el bus puede efectuar por cada ciclo de reloj
	- 