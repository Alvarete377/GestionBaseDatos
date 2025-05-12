
| **Acción**                | **Comando moderno (`ip`)**                                                       | **Comando clásico (`ifconfig`, `route`, etc.)**                   |
| ------------------------- | -------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| Ver interfaces            | `ip addr` o `ip a`                                                               | `ifconfig`                                                        |
| Levantar interfaz         | `ip link set eth0 up`                                                            | `ifconfig eth0 up`                                                |
| Bajar interfaz            | `ip link set eth0 down`                                                          | `ifconfig eth0 down`                                              |
| Asignar IP                | `ip addr add 192.168.1.10/24 dev eth0`                                           | `ifconfig eth0 192.168.1.10 netmask 255.255.255.0`                |
| Eliminar IP               | `ip addr del 192.168.1.10/24 dev eth0`                                           | ❌ (no directo con `ifconfig`)                                     |
| Ver rutas                 | `ip route`                                                                       | `route -n`                                                        |
| Añadir ruta estática      | `ip route add 192.168.2.0/24 via 192.168.1.1`                                    | `route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.1.1` |
| Eliminar ruta             | `ip route del 192.168.2.0/24`                                                    | `route del -net 192.168.2.0 netmask 255.255.255.0`                |
| Establecer gateway        | `ip route add default via 192.168.1.1`                                           | `route add default gw 192.168.1.1`                                |
| Eliminar gateway          | `ip route del default`                                                           | `route del default`                                               |
| Configurar VLAN           | `ip link add link eth0 name eth0.10 type vlan id 10`<br>`ip link set eth0.10 up` | `vconfig add eth0 10`<br>`ifconfig eth0.10 up`                    |
| Ver interfaces VLAN       | `ip -d link show`                                                                | `ifconfig -a` (menos detalle)                                     |
| Crear puente (bridge)     | `ip link add name br0 type bridge`<br>`ip link set br0 up`                       | `brctl addbr br0`<br>`ifconfig br0 up`                            |
| Añadir interfaz al puente | `ip link set eth0 master br0`                                                    | `brctl addif br0 eth0`                                            |
| Eliminar puente           | `ip link del br0`                                                                | `brctl delbr br0`                                                 |
| Ver estado del enlace     | `ip link show`                                                                   | `ifconfig` (limitado)                                             |
| Ver tabla ARP             | `ip neigh`                                                                       | `arp -a`                                                          |


Ambos se pueden mezclar en una misma configuración siempre y cuando la versión de kathara acepte los dos " No es buena practica "


``` bash

iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to 88.88.66.66

```

| Segmento           | Significado                                                                                             |
| ------------------ | ------------------------------------------------------------------------------------------------------- |
| `iptables`         | Herramienta para manipular reglas del cortafuegos (firewall) en Linux.                                  |
| `-t nat`           | Indica que vamos a trabajar en la **tabla NAT** (para traducción de direcciones).                       |
| `-A POSTROUTING`   | Añade (`-A`) una regla a la **cadena POSTROUTING**, que actúa después de decidir a dónde va un paquete. |
| `-o eth0`          | Aplica solo a los paquetes que **salen por la interfaz `eth0`**.                                        |
| `-j SNAT`          | Especifica que la acción será **Source NAT**: cambiar la dirección IP **de origen**.                    |
| `--to 88.88.66.66` | Nueva IP de origen que se asignará a los paquetes salientes.                                            |
