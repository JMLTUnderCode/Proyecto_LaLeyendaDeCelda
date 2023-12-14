# Proyecto_2_LLP1_La_Leyenda_de_Celda

# Ejecución

```bash
$ swipl
?- [main].
?- cargar('data/mapa.txt', Mapa), cargar('data/palancas.txt', Palancas), cruzar(Mapa, Palancas, Seguro).
```