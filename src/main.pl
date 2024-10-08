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
* Comportamiento: Concatena dos listas, sin repetir elementos
*/
concatenar([], Y, Y).
concatenar([A|X], Y, Z) :- member(A,Y), !, concatenar(X, Y, Z).
concatenar([A|X], Y, [A|Z]) :- concatenar(X, Y, Z).


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
* Predicado: negacion/2
* Argumentos:
*   - Expresión: Expresión (Modo, pasillo, bifurcación o junta)
*   - negacion: Expresión negada
* Comportamiento: Verifica si una expresión es la negación de otra
*/

% (!true = false)
negacion(regular, de_cabeza).
negacion(de_cabeza, regular).

% !P
negacion(pasillo(X, Modo), pasillo(X, Modo2)) :- negacion(Modo, Modo2).

% De Morgan
negacion(junta(P, Q), bifurcacion(negacion(P), negacion(Q))).
negacion(bifurcacion(P, Q), junta(negacion(P), negacion(Q))).

/*
* Predicado: miembro/2
* Argumentos:
*   - A: Elemento a buscar (Letra)
*   - L: Lista de pares (Letra, Modo)
* Comportamiento: Verifica si un elemento (Letra) pertenece a una lista
*                 de pares (Letra, Modo)
*/
miembro(A, [(A,_)|_]).
miembro(A, [(_,B)|T]) :- A \= B, miembro(A, T).

/*
* Predicado: noHayRepetidos/1
* Argumentos:
*   - L: Lista de pares (Letra, Modo)
* Comportamiento: Verifica si una lista de pares (Letra, Modo) no
*                 tiene elementos repetidos
*/
noHayRepetidos([]).
noHayRepetidos([(A,_)|T]) :- not(miembro(A,T)), noHayRepetidos(T).


/******************************** cruzar/3 ************************************/

/* 
* Predicado: cruzar/3
* Argumentos: 
*   - Mapa: Representación de un laberinto como pasillos, bifurcaciones y juntas
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

% P /\ P = P
cruzar(junta(Submapa, Submapa), Palancas, Seguro) :- 
    cruzar(Submapa, Palancas, Seguro), !.

% P /\ !P = false
cruzar(junta(Submapa, Negado), _, seguro) :- negacion(Submapa, Negado), !, fail.

% not (P /\ !P) = true (pero se buscan todas las soluciones)
cruzar(junta(Submapa, Negado), Palancas, trampa) :- 
    negacion(Submapa, Negado),
    (cruzar(Negado, Palancas, trampa);
    cruzar(Submapa, Palancas, trampa), !).

% P /\ Q
cruzar(junta(Submapa1, Submapa2), Palancas, seguro) :- 
    cruzar(Submapa1, P1, seguro),
    cruzar(Submapa2, P2, seguro),
    concatenar(P1,P2,Palancas),
    noHayRepetidos(Palancas).

% not (P /\ Q)
cruzar(junta(Submapa1, Submapa2), Palancas, trampa) :- 
    cruzar(Submapa1, P1, _),
    cruzar(Submapa2, P2, _),
    concatenar(P1, P2, Palancas),
    noHayRepetidos(Palancas),
    not(cruzar(junta(Submapa1, Submapa2), Palancas, seguro)).


/* Verificación de bifurcaciones */

% P \/ P = P
cruzar(bifurcacion(Submapa, Submapa), Palancas, Seguro) :- 
    cruzar(Submapa, Palancas, Seguro), !.

% not (P \/ !P) = false
cruzar(bifurcacion(Submapa, Negado), _, trampa) :-
    negacion(Submapa,Negado), !, fail.

% P \/ !P = true (pero se buscan todas las soluciones)
cruzar(bifurcacion(Submapa, Negado), Palancas, seguro) :-
    negacion(Submapa, Negado),
    (cruzar(Submapa, Palancas, seguro);
    cruzar(Negado, Palancas, seguro), !).

% not (P \/ Q)
cruzar(bifurcacion(Submapa1, Submapa2), Palancas, trampa) :- 
    cruzar(Submapa1, P1, trampa),
    cruzar(Submapa2, P2, trampa),
    concatenar(P1,P2,Palancas),
    noHayRepetidos(Palancas).
    
% P \/ Q
cruzar(bifurcacion(Submapa1, Submapa2), Palancas, seguro) :- 
    cruzar(Submapa1, P1, _),
    cruzar(Submapa2, P2, _),
    concatenar(P1, P2, Palancas),
    noHayRepetidos(Palancas),
    not(cruzar(bifurcacion(Submapa1, Submapa2), Palancas, trampa)).



/***************************** siempre_seguro/1 *******************************/

/* 
* Predicado: siempre_seguro/1
* Argumentos: 
*   - Mapa: Representación de un laberinto como pasillos, bifurcaciones y juntas
* Comportamiento: Verifica si un Mapa es siempre cruzable
*/
siempre_seguro(Mapa) :- not(cruzar(Mapa,_,trampa)).

/********************************** leer/1 ************************************/

/* 
* Predicado: leer/1
* Argumentos: 
*   - Mapa: Representación de un laberinto como pasillos, bifurcaciones y juntas
* Comportamiento: Captura de la consola la ruta del archivo que contiene el mapa
*                 a utilizar
*/
leer(Mapa) :-
    write('Ingrese el nombre del archivo: '),
    read_line_to_string(user_input, ArchivoStr),
    atom_string(Archivo, ArchivoStr),
    (exists_file(Archivo) -> 
        see(Archivo),
        read(Mapa),
        seen
    ; write('Error: El archivo no existe.'), fail).

/******************************* para ejecutar con archivo ********************/
siempre_seguro_desde_archivo(Path) :-
    once(cargar(Path, Mapa)),
    siempre_seguro(Mapa), !.

cruzar_seguro_desde_archivo(PathMapa, PathPalancas) :-
    once(cargar(PathMapa, Mapa)),
    once(cargar(PathPalancas, Palancas)),
    cruzar(Mapa, Palancas, Seguro),
    writeln(Seguro), !.

cruzar_palancas_desde_archivo(PathMapa, Seguro) :-
    once(cargar(PathMapa, Mapa)),
    (findall(Palancas, cruzar(Mapa, Palancas, Seguro), AllPalancas),
    AllPalancas \= [], 
    forall(member(Palancas, AllPalancas), writeln(Palancas)));
    writeln('false').