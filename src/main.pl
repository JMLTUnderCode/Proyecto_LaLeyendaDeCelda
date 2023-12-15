/* 
* Universidad Simón Bolívar
* Departamento de computación y Tecnología de la Información
* CI3661 - Laboratorio de Lenguajes de Programación
* Profesor: Ricardo Monascal
* Integrantes: 
*     - Carlos Sivira      15-11377
*     - Daniel Figueroa    16-10371
*     - Junior Lara        17-10303
*     - Astrid Alvarado    18-10938
* 
* Proyecto 2 - La Leyenda Celda y la Matriz Traspuesta
*/


/******************************* Utilidades ***********************************/

/* 
* Predicado: concatenar/3
* Argumentos: 
*   - X: Lista base
*   - Y: Lista a concatenar
*   - Z: Lista resultante de concatenar X y Y
* Comportamiento: Concatena dos listas
*/
concatenar([], Y, Y).
concatenar([A|X], Y, [A|Z]) :- concatenar(X,Y,Z).


/* 
* Predicado: eliminar_elem/3
* Argumentos: 
*   - C: Elemento a eliminar
*   - L: Lista base
*   - R: Lista resultante de eliminar todas las ocurrencias del elemento C
* Comportamiento: Elimina las ocurrencias de un elemento en una lista
*/
eliminar_elem(_, [], []).
eliminar_elem(C, [C|T], R) :- eliminar_elem(C, T, R).
eliminar_elem(C, [H|T], [H|R]) :- H \= C, eliminar_elem(C, T, R).


/* 
* Predicado: eliminar/3
* Argumentos: 
*   - S: Cadena de texto base
*   - C: Caracter a eliminar
*   - R: Cadena de texto resultande de eliminar todas las ocurrencias de C.
* Comportamiento: Elimina las ocurrencias de un caracter en una cadena de texto
*/
eliminar(S, C, R) :-
    string_chars(S, L),
    eliminar_elem(C, L, L2),
    string_chars(R, L2).


/* 
* Predicado: cargar/2
* Argumentos: 
*   - Archivo: Path a un archivo de texto
*   - Contenido: Contenido del archivo como término
* Comportamiento: Lee un archivo texto y convierte su contenido en un término
*/
cargar(Archivo, Contenido):-
    (exists_file(Archivo) -> 
        open(Archivo, read, Stream),
        read_stream_to_codes(Stream, Code),
        close(Stream),
        atom_codes(Atom, Code),
		eliminar(Atom, '\n', Atom2),
		eliminar(Atom2, ' ', Atom3),
        eliminar(Atom3, '\t', Atom4),
        term_string(Contenido, Atom4)
    ; write('Error: El archivo no existe.'), fail).



/******************************** cruzar/3 ************************************/

/* 
* Predicado: cruzar/3
* Argumentos: 
*   - Mapa: Representación de un laberinto como pasillos, bifucaciones y juntas
*   - Palancas: Arreglo de pares (Letra, Modo)
*   - Seguro: Verificación del estado del Mapa y Palancas en seguro o trampa
* Comportamiento: Verifica si un Mapa con una configuración de Palancas se puede
*                 cruzar. Retorna seguro si es cruzable, trampa si no 
*/

/* Verificación de pasillos */
cruzar(pasillo(X, regular), [(X, arriba)], seguro).
cruzar(pasillo(X, regular), [(X, abajo)], trampa).
cruzar(pasillo(X, de_cabeza), [(X, arriba)], trampa).
cruzar(pasillo(X, de_cabeza), [(X, abajo)], seguro).

/* Verificación de juntas */
cruzar(junta(pasillo(X, Modo), pasillo(X, Modo)), Palancas, Seguro) :- 
    cruzar(pasillo(X, Modo), Palancas, Seguro), !.

cruzar(junta(pasillo(X, Modo1), pasillo(X, Modo2)), _, seguro) :- 
    Modo1 \= Modo2, !, fail.

cruzar(junta(pasillo(X, Modo1), pasillo(X, Modo2)), Palancas, trampa) :- 
    cruzar(pasillo(X, Modo1), Palancas, trampa);
    cruzar(pasillo(X, Modo2), Palancas, trampa), !.

cruzar(junta(Submapa1, Submapa2), Palancas, seguro) :- 
    cruzar(Submapa1, P1, seguro),
    cruzar(Submapa2, P2, seguro),
    concatenar(P1,P2,Palancas).

cruzar(junta(Submapa1, Submapa2), Palancas, trampa) :- 
    cruzar(Submapa1, P1, _),
    cruzar(Submapa2, P2, _),
    concatenar(P1, P2, PosiblesPalancas),
    not(cruzar(junta(Submapa1, Submapa2), PosiblesPalancas, seguro)),
    PosiblesPalancas = Palancas.

/* Verificación de bifurcaciones */
cruzar(bifurcacion(pasillo(X, Modo), pasillo(X, Modo)), Palancas, Seguro) :- 
    cruzar(pasillo(X, Modo), Palancas, Seguro), !.

cruzar(bifurcacion(pasillo(X, Modo1), pasillo(X, Modo2)), _, seguro) :- 
    Modo1 \= Modo2, !, fail.

cruzar(bifurcacion(pasillo(X, Modo1), pasillo(X, Modo2)), Palancas, trampa) :- 
    cruzar(pasillo(X, Modo1), Palancas, trampa);
    cruzar(pasillo(X, Modo2), Palancas, trampa), !.

cruzar(bifurcacion(Submapa1, Submapa2), Palancas, trampa) :- 
    cruzar(Submapa1, P1, trampa),
    cruzar(Submapa2, P2, trampa),
    concatenar(P1,P2,Palancas).
    
cruzar(bifurcacion(Submapa1, Submapa2), Palancas, seguro) :- 
    cruzar(Submapa1, P1, _),
    cruzar(Submapa2, P2, _),
    concatenar(P1, P2, PosiblesPalancas),
    not(cruzar(bifurcacion(Submapa1, Submapa2), PosiblesPalancas, trampa)),
    PosiblesPalancas = Palancas.



/***************************** siempre_seguro/1 *******************************/

/* 
* Predicado: siempre_seguro/1
* Argumentos: 
*   - Mapa: Representación de un laberinto como pasillos, bifucaciones y juntas
* Comportamiento: Verifica si un Mapa es siempre cruzable
*/
siempre_seguro(Mapa) :- 
    var(Mapa),
    (
        cruzar(Mapa,_,seguro),
        write('true.'), nl
    ; 
        write('false.'), nl
    ), !.
siempre_seguro(Mapa) :- cruzar(Mapa,_,seguro), !.



/********************************** leer/1 ************************************/

/* 
* Predicado: leer/1
* Argumentos: 
*   - Mapa: Representación de un laberinto como pasillos, bifucaciones y juntas
* Comportamiento: Captura de la consola la ruta del archivo que contiene el mapa
*                 a utilizar
*/
leer(Mapa) :-
    write('Ingrese en nombre del archivo: '),
    read(Archivo),
    term_string(Archivo, ArchivoString),
    cargar(ArchivoString, Mapa).