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
		write(Atom3)
    ; write('Error: El archivo no existe.'), fail).