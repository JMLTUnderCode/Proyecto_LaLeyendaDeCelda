# **La Leyenda de Celda**
### CI-3641: Lenguajes de Programación I
### Septiembre - Diciembre 2023
#### Integrantes:  
Carlos Sivira, 15-11377  
Daniel Figueroa, 16-10371  
Junior Lara, 17-10303  
Astrid Alvarado, 18-10938

## Ejecución

La variable Mapa siempre debe ser instanciada con un mapa válido. Para esto, se
puede utilizar el predicado $leer/1$ que solicita al usuario la ruta del archivo
que contiene el mapa a utilizar.

Las variables Palancas y Seguro pueden ser o no instanciadas. Si no se
instancian se obtendrán todas las configuraciones de palancas posibles
para el mapa dado.

```bash
    $ swipl
    ?- [main].
    ?- leer(Mapa), cruzar(Mapa, <Palancas>, <Seguro>).
    ?- leer(Mapa), siempre_seguro(Mapa).
```

## Implementación

### Predicados auxiliares
El proyecto se compone de los siguientes predicados auxiliares:

* $concatenar/3$: Predicado para la concatenación de dos listas,
omitiendo repeticiones.

* $eliminar\_elem/3$: Predicado que dado un elemento y una lista, obtiene una 
nueva lista que elimina todas las existencias del elemento.

* $eliminar/3$: Predicado que convierte una cadena de texto en una lista de 
carateres, aplica el predicado $eliminar_char/3$ sobre cada elemento de la lista
y vuelve a construir una nueva cadena de texto.

* $negacion/2$: Predicado que obtiene la negación de una expresión que puede ser
el estado de una palanca o un sub mapa.

* $miembro/2$: Predicado que verifica si un par (palanca, estado) pertenece a
una lista de pares solamente según el nombre de la palanca.

* $noHayRepetidos/1$: Predicado que verifica si una lista de pares no tiene
palancas repetidas, donde el nombre de la palanca es el criterio de comparación.


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
utilizar. Luego, obtiene el contenido del archivo en la variable Mapa.


### Predicados para pruebas desde archivos

* $siempre\_seguro\_desde\_archivo/1$: Predicado que verifica si un mapa es siempre
cruzable independientemente de la configuración de las palancas. Dado un archivo
de mapa.

* $cruzar\_seguro\_desde\_archivo/2$: Predicado que verifica si un Mapa y una configuración de palancas es cruzable o no. Dados los archivos de mapa y configuración de palancas.

* $cruzar\_palancas\_desde\_archivo/2$: Predicado que busca todas las configuraciones de palancas de un mapa. Dado un archivo de mapa y el atomo 'seguro' o 'trampa'. Se utilizó el predicado $findall/3$ para poder realizar la impresión del resultado obtenido en $cruzar/3$.
