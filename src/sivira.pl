pasillo(a, regular).

cruzar(Mapa, Palancas) :- 
	member(Mapa, Palanca), !, mapa_seguro(Mapa, Palancas).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pasillo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

$ Es pasillo y el modo es regular
pasillo_seguro(pasillo(Letra, Modo), [(Letra, Posicion)|_]) :- 
	Modo = regular, Posicion = arriba.

$ Es pasillo y el modo es de_cabeza
pasillo_seguro(pasillo(Letra, Modo), [(Letra, Posicion)|_]) :- 
	Modo = de_cabeza, Posicion = abajo.

$ Es pasillo pero no coincide la letra
pasillo_seguro(pasillo(Letra, Modo), [_|Resto]) :- 
	pasillo_seguro(pasillo(Letra, Modo), Resto).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pasillo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bifurcacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Una bifurcacion de dos pasillos
bifurcacion_segura(Mapa1, Mapa2, Palancas) :-
	pasillo_seguro(Mapa1, Palancas), !.	

% Una bifurcacion de dos pasillos
bifurcacion_segura(Mapa1, Mapa2, Palancas) :-
	pasillo_seguro(Mapa2, Palancas), !.	

% Una bifurcacion de una bifurcacion y un pasillo
bifurcacion_segura(bifurcacion(Mapa1Sub1, Mapa1Sub2), Mapa2, Palancas) :-
	bifurcacion_segura(Mapa1Sub1, Mapa1Sub2, Palancas), !,
	pasillo_seguro(Mapa2, Palancas).

% Una bifurcacion de un pasillo y una bifurcacion 
bifurcacion_segura(Mapa1, bifurcacion(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	pasillo_seguro(Mapa1, Palancas), !,
	bifurcacion_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una bifurcacion de una junta y un pasillo
bifurcacion_segura(junta(Mapa1Sub1, Mapa1Sub2), Mapa2, Palancas) :-
	junta_segura(Mapa1Sub1, Mapa1Sub2, Palancas).
	pasillo_seguro(Mapa2, Palancas).

% Una bifurcacion de un pasillo y una junta
bifurcacion_segura(Mapa1, junta(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	pasillo_seguro(Mapa1, Palancas), !,
	junta_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una bifurcacion de dos bifurcaciones
bifurcacion_segura(bifurcacion(Mapa1Sub1, Mapa1Sub2), bifurcacion(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	bifurcacion_segura(Mapa1Sub1, Mapa1Sub2, Palancas), !,
	bifurcacion_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una bifurcacion de una bifurcacion y una junta
bifurcacion_segura(bifurcacion(Mapa1Sub1, Mapa1Sub2), junta(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	bifurcacion_segura(Mapa1Sub1, Mapa1Sub2, Palancas), !,
	junta_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una bifurcacion de una junta y una bifurcacion
bifurcacion_segura(junta(Mapa1Sub1, Mapa1Sub2), bifurcacion(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	junta_segura(Mapa1Sub1, Mapa1Sub2, Palancas), !,
	bifurcacion_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una bifurcacion de dos juntas
bifurcacion_segura(junta(Mapa1Sub1, Mapa1Sub2), junta(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	junta_segura(Mapa1Sub1, Mapa1Sub2, Palancas), !,
	junta_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bifurcacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Junta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Una junta de dos pasillos
junta_segura(Mapa1, Mapa2, Palancas) :-
	pasillo_seguro(Mapa1, Palancas),	
	pasillo_seguro(Mapa2, Palancas).	

% Una junta de una junta y un pasillo
junta_segura(junta(Mapa1Sub1, Mapa1Sub2), Mapa2, Palancas) :-
	junta_segura(Mapa1Sub1, Mapa1Sub2, Palancas),
	pasillo_seguro(Mapa2, Palancas).

% Una junta de un pasillo y una junta 
junta_segura(Mapa1, junta(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	pasillo_seguro(Mapa1, Palancas),
	junta_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una junta de una bifurcacion y un pasillo
junta_segura(bifurcacion(Mapa1Sub1, Mapa1Sub2), Mapa2, Palancas) :-
	bifurcacion_segura(Mapa1Sub1, Mapa1Sub2, Palancas),
	pasillo_seguro(Mapa2, Palancas).

% Una junta de un pasillo y una bifurcacion
junta_segura(Mapa1, bifurcacion(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	pasillo_seguro(Mapa1, Palancas),
	bifurcacion_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una junta de dos bifurcaciones
junta_segura(junta(Mapa1Sub1, Mapa1Sub2), junta(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	bifurcacion_segura(Mapa1Sub1, Mapa1Sub2, Palancas),
	bifurcacion_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una junta de una junta y una bifurcacion
junta_segura(junta(Mapa1Sub1, Mapa1Sub2), bifurcacion(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	junta_segura(Mapa1Sub1, Mapa1Sub2, Palancas),
	bifurcacion_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una junta de una bifurcacion y una junta
junta_segura(bifurcacion(Mapa1Sub1, Mapa1Sub2), junta(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	bifurcacion_segura(Mapa1Sub1, Mapa1Sub2, Palancas),
	junta_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

% Una junta de dos juntas
junta_segura(junta(Mapa1Sub1, Mapa1Sub2), junta(Mapa2Sub1, Mapa2Sub2), Palancas) :-
	junta_segura(Mapa1Sub1, Mapa1Sub2, Palancas),
	junta_segura(Mapa2Sub1, Mapa2Sub2, Palancas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Junta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mapa %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mapa_seguro(Mapa, Palancas) :- pasillo_seguro(Mapa, Palancas).
mapa_seguro(Mapa, Palancas) :- bifurcacion_segura(bifurcacion(MapaSub1, MapaSub2), Palancas).
mapa_seguro(Mapa, Palancas) :- junta_segura(junta(MapaSub1, MapaSub2), Palancas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mapa %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%