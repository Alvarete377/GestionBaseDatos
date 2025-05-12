

En esta practica se abarcaran las VLANs de una forma poco practica, es decir, abriré un puente para cada VLAN. Obviamente esta forma de trabajar no es cómoda, ya que tendremos que levantar tantos puentes como VLANs queramos mantener. Configuraremos 4 nodos y un switch, cada par de nodos estará dentro de una VLAN, 2 en total.

Diagrama de la red: 

![[Diagram1.png]]

Para ello configuraremos el switch de la siguiente forma:

```bash

ifconfig eth0 up
ifconfig eth1 up
ifconfig eth2 up
ifconfig eth3 up

brctl addbr VLAN1
brctl addif VLAN1 eth0
brctl addif VLAN1 eth1
ifconfig VLAN1 up

brctl addbr VLAN2 
brctl addif VLAN2 eth2
brctl addif VLAN2 eth3
ifconfig VLAN2 up

```

Y la configuración de los pcs:

![[Pasted image 20250508074742.png]]

Para comprobar que cada par de pc esta en una VLAN diferente, capturaremos el trafico desde diferentes nodos en las distintas VLANs.

![[Pasted image 20250509012754.png]]

Capturando desde pc2:

- Haciendo ping desde pc1 (VLAN azul): ![[cap_pc1-pc2.pcap]]
- Haciendo ping desde pc3 (VLAN roja):![[cap_pc3-pc2.pcap]]
Una vez lista la red y las capturas de trafico, responderé a las preguntas del ejercicio:

1. ¿qué hosts pertenecen a cada vlan? Haz capturas que lo demuestren

Como ya han demostrado las capturas anteriores, pc1 y pc2 pertenecen a la vlan roja y pc3 y pc4 pertenecen a la vlan azul.

- crea un esquema de la red a partir de la configuración del laboratorio HECHO

- añade un pc más a cada una de las VLANs en distintos dominios de colisión

![[VAR_6HOST.png]]

Ahora tenemos 3 pcs por cada VLAN.

En esta variación al capturar el trafico, solo se podrán ver pc1,pc2 y pc3 y por otro lado pc4,pc5 y pc6.


laboratorio