% predicado para concatenar dos listas
concatenar([], Y, Y).
concatenar([A|X], Y, [A|Z]) :- concatenar(X,Y,Z).


% Utilidad para cargar archivos y transformar la entrada
eliminar_char(_, [], []).
eliminar_char(C, [C|T], R) :- eliminar_char(C, T, R).
eliminar_char(C, [H|T], [H|R]) :- H \= C, eliminar_char(C, T, R).

eliminar(S, C, R) :-
    string_chars(S, L),
    eliminar_char(C, L, L2),
    string_chars(R, L2).

cargar(File, Contenido):-
    (exists_file(File) -> 
        open(File, read, Stream),
        read_stream_to_codes(Stream, Code),
        close(Stream),
        atom_codes(Atom, Code),
		eliminar(Atom, '\n', Atom2),
		eliminar(Atom2, ' ', Atom3),
        eliminar(Atom3, '\t', Atom4),
        term_string(Contenido, Atom4)
		% write(Atom4)
    ; write('Error: El archivo no existe.'), fail).

/**************************** DEFINICION DE 'cruzar' ********************************/
% cruzar pasillos
cruzar(X,_,_) :- var(X) -> write('ERROR: Mapa siempre debe ser instanciado'), !, fail.

cruzar(pasillo(X, regular), [(X, arriba)], seguro).
cruzar(pasillo(X, regular), [(X, abajo)], trampa).
cruzar(pasillo(X, de_cabeza), [(X, arriba)], trampa).
cruzar(pasillo(X, de_cabeza), [(X, abajo)], seguro).

% cruzar pasillos que se juntan 
cruzar(junta(pasillo(X, Modo), pasillo(X, Modo)), Palancas, Seguro) :- 
    cruzar(pasillo(X, Modo), Palancas, Seguro), !.
cruzar(junta(pasillo(X, Modo1), pasillo(X, Modo2)), _, seguro) :- Modo1 \= Modo2, !, fail.
cruzar(junta(pasillo(X, Modo1), pasillo(X, Modo2)), Palancas, trampa) :- 
    (
        cruzar(pasillo(X, Modo1), Palancas, trampa)
    ;
        cruzar(pasillo(X, Modo2), Palancas, trampa),!
    ).
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

% cruzar bifurcaciones de pasillos
cruzar(bifurcacion(pasillo(X, Modo), pasillo(X, Modo)), Palancas, Seguro) :- 
    cruzar(pasillo(X, Modo), Palancas, Seguro), !.
cruzar(bifurcacion(pasillo(X, Modo1), pasillo(X, Modo2)), _, seguro) :- Modo1 \= Modo2, !, fail.
cruzar(bifurcacion(pasillo(X, Modo1), pasillo(X, Modo2)), Palancas, trampa) :- 
    (
        cruzar(pasillo(X, Modo1), Palancas, trampa)
    ;
        cruzar(pasillo(X, Modo2), Palancas, trampa),!
    ).
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

/**************************** DEFINICION DE 'siempre_seguro' ********************************/
siempre_seguro(Mapa) :- cruzar(Mapa,_,seguro), !.