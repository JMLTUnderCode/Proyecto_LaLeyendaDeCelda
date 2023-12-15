# Proyecto_2_LLP1_La_Leyenda_de_Celda

## Ejecución

```prolog
$ swipl
?- [main].
?- leer(Mapa), data/mapa.txt.
?- cruzar(Mapa, Palancas, Seguro).
?- siempre_seguro(Mapa)
```

## Implementación

### Predicados auxiliares
El proyecto se compone de los siguientes predicados auxiliares:

* $concatenar/3$: Predicado para la concatenación de dos listas.

* $eliminar\_elem/3$: Predicado que dado un elemento y una lista, obtiene una 
nueva lista que elimina todas las existencias del elemento.

* $eliminar/3$: Predicado que convierte una cadena de texto en una lista de 
carateres, aplica el predicado $eliminar_char/3$ sobre cada elemento de la lista
y vuelve a construir una nueva cadena de texto.

* $cargar/2$: Utilidad para la carga del contenido de un archivo de texto como 
un término.


### Predicados principales
 
* $cruzar/3$: Predicado principal que verifica si un Mapa y una configuración de
Palancas es cruzable o no. Este predicado se descompone de la siguiente manera:
    
    * Verificación de pasillos: Verifica si un pasillo es _seguro_ o _trampa_. 
    Compara el tipo de pasillo (_regular_, _de_cabeza_) con el modo de la 
    palanca (_arriba_, _abajo_) asociado al pasillo con el mismo nombre.

    * Verificación de juntas: Verifica si una junta es segura o trampa. Para 
    esto, valida si la junta se compose de pasillos o de sub mapas. Si es un
    pasillo entonces se valida usando la verificación de pasillos. Si es un
    sub mapa (junta o bifurcación), se valida ya sea usando verificación de 
    juntas o bifurcaciones según corresponda.

    * Verificación de juntas: Caso análogo al anterior, Verifica si una
    bifurcación es segura o trampa. 

* $siempre\_seguro/2$: Verifica si un mapa es siempre cruzable 
independientemente de la configuración de las palancas. Devuelve verdadero o
falso dependiendo del valor obtenido por cruzar sin suministrar una Palanca
específica.

* $leer/1$: Solicita al usuario la ruta del archivo que contiene el mapa a 
utilizar. Luego, obtiene el contenido del archivo en forma de término usando el
predicado $cargar/2$.
