:- dynamic(persona/5).
% ============= pide el nombre de la persona =======================================================================
obtener_nombre(Nombre) :-
    write('Ingrese el nombre de la persona: '),
    read_line_to_string(user_input, Nombre).

% ============= pide el Puesto de la persona =======================================================================
obtener_puesto(Puesto) :-
    write('Ingrese el puesto de la persona: '),
    read_line_to_string(user_input, Puesto).

% ============= pide el costo por tarea ============================================================================
obtener_costo(Costo) :-
    write('Ingrese el costo por tarea de la persona: '),
    read_line_to_string(user_input, NewCosto1),
    number_string(NewCosto, NewCosto1),
    (   validar_costo(NewCosto)
    ->  Costo = NewCosto
    ;   obtener_costo(Costo)
    ).

% ============= Valida que el costo sea un numero entero positivo ==================================================
validar_costo(Costo) :-
    (   number(Costo), Costo >= 0
    ->  true
    ;   write('Error: El costo debe ser un número positivo.'), nl,
        fail
    ).

% ============= pide el rating de la persona =======================================================================
obtener_rating(Rating) :-
    write('Ingrese el rating de la persona: '),
    read_line_to_string(user_input, NewRating1),
    number_string(NewRating, NewRating1),
    (   validar_rating(NewRating)
    ->  Rating = NewRating
    ;   obtener_rating(Rating)
    ).

% ============= Valida que el rating debe ser un número entre 1 y 5 ================================================
validar_rating(Rating) :-
    (   number(Rating), Rating >= 1, Rating =< 5
    -> true
    ;  write('¡Error! Rating inválido. Debe ser un número entre 1 y 5. Intente nuevamente.'), nl,
       fail
    ).

% ============= pide las tareas que puede realizar la persona ======================================================
obtener_tareas(TareasLista) :-
    write('Ingrese las tareas separadas por comas: '),
    read_string(user_input, "\n", "\r", _, TareasString),
    atomic_list_concat(TareasSplit, ', ', TareasString), % Separar por comas y espacio
    maplist(atom_string, Tareas, TareasSplit),  % Convierte a lista de cadenas
    tareas_permitidas(TareasPermitidas), % Obtiene la lista de tareas permitidas
    validar_tareas(Tareas, TareasPermitidas, TareasLista).

% ============= validaciones multiples para las tareas =============================================================
validar_tareas(Tareas, TareasPermitidas, TareasLista) :-
    \+ tiene_tareas_repetidas(Tareas),
    validar_tareas_individuales(Tareas, TareasPermitidas),
    TareasLista = Tareas.
validar_tareas(_, _, TareasLista) :-
    write('Error: Tareas repetidas encontradas. Vuelva a ingresar las tareas.'), nl,
    obtener_tareas(TareasLista).

tiene_tareas_repetidas(Lista) :-
    sort(Lista, SinRepetir),
    length(Lista, LongitudOriginal),
    length(SinRepetir, LongitudSinRepetir),
    LongitudOriginal \= LongitudSinRepetir.

validar_tareas_individuales([], _).
validar_tareas_individuales([Tarea | Resto], TareasPermitidas) :-
    member(Tarea, TareasPermitidas),
    validar_tareas_individuales(Resto, TareasPermitidas).

% ============= tipos de tareas permitidas =========================================================================
tareas_permitidas([requerimientos, diseno, desarrollo, qa, fullstack, frontend, backend, administracion]).

% =============== agrega una nueva persona =========================================================================
agregar_persona :-
    obtener_nombre(Nombre),
    obtener_puesto(Puesto),
    obtener_costo(Costo),
    obtener_rating(Rating),
    obtener_tareas(TareasLista),

    assertz(persona(Nombre, Puesto, Costo, Rating, TareasLista)),
    write('¡La persona ha sido agregada a la base de conocimientos!'), nl.

% ================ Muestra las personas ===========================================================================
mostrar_personas :-
    persona(Nombre, Puesto, Costo, Rating, Tareas),
    write('Nombre: '), write(Nombre), nl,
    write('Puesto: '), write(Puesto), nl,
    write('Costo: '), write(Costo), nl,
    write('Rating: '), write(Rating), nl,
    write('Tareas:'), nl, nl,
    mostrar_tareas_persona(Nombre, Tareas),
    nl,
    fail.
mostrar_personas.

mostrar_tareas_persona(_, []) :- !.  % Agrega un corte para evitar elecciones innecesarias
mostrar_tareas_persona(Nombre, [Tarea | Resto]) :-
    tarea(Proyecto, NombreT, _, Estado, Nombre, _),
    write('  Proyecto: '), write(Proyecto), nl,
    write('  Tarea: '), write(NombreT), nl,
    write('  Estado: '), write(Estado), nl,
    Tarea = 'xd',
    nl, nl,
    mostrar_tareas_persona(Nombre, Resto).
