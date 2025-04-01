
## Fab 

![[fab.pdf]]

```python
import sys

def fab(a):
    equipos = {}
    partes = {}
    for linea in a:
        linea = linea.strip().split(',')
        evento = linea[0]
    
        if evento[0] == 'Q':
            idcuar = int(evento[1])
            partes[idcuar] = {}
            
            for ideq in equipos:
                partes[idcuar][ideq] = 0
            
        elif evento == 'eq':
            ideq = int(linea[1])
            nomeq = linea[2]
            equipos[ideq] = nomeq

        elif evento == 'b':
            linea_canastas = linea[1].split('#')
            puntos = int(linea[2])
            ideq = int(linea_canastas[0])
            
            if partes[idcuar][ideq] == 0:
                partes[idcuar][ideq] = puntos
            else:
                partes[idcuar][ideq] += puntos
        
    return equipos, partes

archivo = open(sys.argv[1], 'r')
lista = fab(archivo)
equipos = lista[0]
puntaje = lista[1]

for idcuar in puntaje:
    print(f"{idcuar}° Cuarto.", end='\t')
    
    for ideq,nomeq in equipos.items():
        print('{}:{}\t'.format(nomeq, puntaje[idcuar][ideq]) , end='\t')
        
    print()

archivo.close()
```


## Fab Parte 2

