
En esta practica se creara una red con 4 nodos conectados a 2 switches de tal manera que solo los nodos pertenecientes a una misma VLAN se puedan ver entre si. Para ello deberemos configurar 1 puerto etiquetado en cada switch.


Diagrama de la red: 

![[4host-2sw-2taggedports.png]]

Configuración de los 4 pcs respectivamente:

```bash

ifconfig eth0 10.0.0.1/24 up
ifconfig eth0 10.0.0.2/24 up
ifconfig eth0 10.0.0.3/24 up
ifconfig eth0 10.0.0.4/24 up

```

Configuración de sw1:

```bash

ifconfig eth0 up
ifconfig eth1 up
ifconfig eth2 up

vconfig add eth0 10
vconfig add eth0 20

ifconfig eth0.10 up
ifconfig eth0.20 up


brctl addbr ROJO
brctl addif ROJO eth1
brctl addif ROJO eth0.10
ifconfig ROJO up

brctl addbr AZUL
brctl addif AZUL eth2
brctl addif AZUL eth0.20
ifconfig AZUL up


```

Configuración de sw2:

```bash

ifconfig eth0 up
ifconfig eth1 up
ifconfig eth2 up

vconfig add eth0 10
vconfig add eth0 20

ifconfig eth0.10 up
ifconfig eth0.20 up


brctl addbr ROJO
brctl addif ROJO eth1
brctl addif ROJO eth0.10
ifconfig ROJO up

brctl addbr AZUL
brctl addif AZUL eth2
brctl addif AZUL eth0.20
ifconfig AZUL up


```

lab.conf:

```bash

sw1[0]=C
sw1[1]=A
sw1[2]=B

sw2[0]=C
sw2[1]=E
sw2[2]=D

pc1[0]=A
pc2[0]=B
pc3[0]=E
pc4[0]=D


```

Capturas de trafico capturadas desde pc3:

- pc1 a pc3:![[cap-pc1-pc3.pcap]]
- pc2 a pc3: ![[cap-pc2-pc3.pcap]]

Capturas de trafico capturadas desde pc4:

- pc1 a pc4:![[cap-pc1-pc4.pcap]]
- pc2 a pc4: ![[cap-pc2-pc4.pcap]]

## ¿qué hosts pertenecen a cada vlan? Haz capturas que lo demuestren


Según estas capturas de trafico, determinamos que pc1 y pc3 pertenecen a una VLAN y pc2 y pc4 pertenecen a otra VLAN.


## intercambia dos pc entre una vlan y la otra sin detener la simulación

Para ello deberemos acceder a la CLI (Command Line Interface) de uno de los switches, borrar las interfaces que comunica cada puente con el pc de cada VLAN y levantar la contraria, es decir: 

![[Pasted image 20250509060013.png]]

Probamos la conectividad: 

![[Pasted image 20250509060059.png]]
![[Pasted image 20250509060118.png]]


## añade un pc más a cada una de las vlans (en distintos dominios de colisión) (prueba a usar **_kathara lconfig_** sin detener la simulación)

Diagrama de la red:

![[var_1pc+*VLAN.png]]

