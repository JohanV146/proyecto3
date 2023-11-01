% ============ Buscar tareas ===============================================================================================================================

buscaTarea :-
    mostrar_tareas_pendientes, buscar_tareas_libres_para_persona.

% Predicado para buscar todas las tareas pendientes en la base de conocimientos.
mostrar_tareas_pendientes :-
    tarea(Proyecto, Nombre, Tipo, 'Pendiente', PersonaAsignada, FechaCierre),
    format('Proyecto: ~w, Tarea: ~w, Tipo: ~w, Persona Asignada: ~w, Fecha de Cierre: ~w~n', [Proyecto, Nombre, Tipo, PersonaAsignada, FechaCierre]),
    fail.
mostrar_tareas_pendientes.

obtener_nombre_existente(Nombre) :-
    write('Ingrese el nombre de la persona: '),
    read(Nombre),
    (   persona(Nombre, _, _, _, _)  % Verificar si el nombre existe en la base de conocimientos
    ->  true
    ;   write('El nombre de la persona no existe en la base de conocimientos.'), nl,
        obtener_nombre_existente(Nombre)  % Volver a solicitar el nombre si no existe
    ).

buscar_tareas_libres_para_persona :-
    obtener_nombre_existente(Persona),  % Pedir el nombre de la persona existente
    persona(Persona, _, _, _, TiposTareasPersona),  % Obtener los tipos de tareas de la persona
    tarea(_, Nombre, TipoTarea, 'Pendiente', 'Sin asignar', _),
    member(TipoTarea, TiposTareasPersona),
    write('Nombre de la Tarea: '), write(Nombre), nl,
    write('Tipo de Tarea: '), write(TipoTarea), nl,
    nl,
    fail.
buscar_tareas_libres_para_persona.

% ================ Recomendar =========================================================================================================
% Verificar si un proyecto existe en la base de conocimientos
proyecto_existenten(Proyecto) :- proyecto(Proyecto, _, _, _, _).

% Verificar si una tarea existe en la base de conocimientos para un proyecto
tarea_existenten(Proyecto, Tarea) :- tarea(Proyecto, Tarea, _, _, _, _).

obtener_nombre_proyecton(Proyecto) :-
    write('Ingrese el nombre del proyecto: '),
    read(Proyecto).

obtener_nombre_tarea(Tarea) :-
    write('Ingrese el nombre de la tarea: '),
    read(Tarea).

% Lógica para obtener personas recomendadas para una tarea en un proyecto
recomendar_personas :-
    obtener_nombre_proyecton(Proyecto),
    obtener_nombre_tarea(Tarea),
    (   proyecto_existenten(Proyecto), tarea_existenten(Proyecto, Tarea) ->
        personas_recomendadas(Proyecto, Tarea)
    ;
        write('El proyecto o la tarea no existen en la base de conocimientos.')
    ).

tareas_activas_persona(Persona, TareasActivas) :-
    findall(Tarea, tarea(_, Tarea, _, 'Pendiente', Persona, _), TareasActivas).

puntuacion_desarrollo_previo(Persona, TipoTarea, Puntuacion) :-
    findall(Tarea, tarea(_, Tarea, TipoTarea, _, Persona, _), Tareas),
    length(Tareas, NumeroTareas),
    Puntuacion is NumeroTareas * 2.

puntuacion_afinidad_proyecto(Persona, Proyecto, Puntuacion) :-
    tarea(Proyecto, _, _, _, Persona, _),
    Puntuacion is 5;
    Puntuacion is 0.

puntuacion_total(Persona, Proyecto, Tarea, PuntuacionTotal) :-
    tarea(Proyecto, Tarea, _, _, _Persona, _),
    persona(Persona, _, _, Rating, TiposTareasPersona),
    member(Tarea, TiposTareasPersona),
    puntuacion_desarrollo_previo(Persona, Tarea, PuntuacionDesarrollo),
    puntuacion_afinidad_proyecto(Persona, Proyecto, PuntuacionAfinidad),
    tareas_activas_persona(Persona, TareasActivas),
    length(TareasActivas, TareasAbiertas),
    PuntuacionTotal is PuntuacionDesarrollo + PuntuacionAfinidad + Rating - (TareasAbiertas * 3).

personas_recomendadas(Proyecto, Tarea) :-
    findall([Persona, Puntuacion, TiposTareasPersona], puntuacion_total(Persona, Proyecto, Tarea, Puntuacion), PersonasConPuntuacion),
    sort(2, @>=, PersonasConPuntuacion, PersonasOrdenadas),
    mostrar_personas_ordenadas(PersonasOrdenadas).

mostrar_personas_ordenadas([]).
mostrar_personas_ordenadas([[Persona, Puntuacion, _] | Resto]) :-
    write('Nombre: '), write(Persona), nl,
    write('Puntuacion: '), write(Puntuacion), nl,
    nl,
    mostrar_personas_ordenadas(Resto).


% ================ Asignar =========================================================================================================
tarea_sin_asignar(Proyecto, Tarea) :-
    tarea(Proyecto, Tarea, _, 'Pendiente', 'Sin asignar', _).

% Asignar una tarea a una persona
asignar_tarea :-
    obtener_nombre_proyecton(Proyecto),
    obtener_nombre_tarea(Tarea),
    obtener_nombre_existente(Persona),
    (   proyecto_existenten(Proyecto), tarea_existenten(Proyecto, Tarea) ->
        (   tarea_sin_asignar(Proyecto, Tarea) ->
            retract(tarea(Proyecto, Tarea, Tipo, 'Pendiente', 'Sin asignar', Fecha)),
            assertz(tarea(Proyecto, Tarea, Tipo, 'Activa', Persona, Fecha)),
            write('La tarea se ha asignado a '), write(Persona), write(' y su estado se ha cambiado a Activa.')
        ;
            write('La tarea ya está asignada o no existe en la base de conocimientos.')
        )
    ;
        write('El proyecto, la tarea o la persona no existen en la base de conocimientos.')
    ).

% ------------------------------------------------------------------------
cerrar_tarea :-
    obtener_nombre_proyectol(Proyecto),
    obtener_nombre_tareal(Tarea),
    obtener_fecha(FechaFin),
    (   tarea(Proyecto, Tarea, _, 'Pendiente', _, _) ->
        retract(tarea(Proyecto, Tarea, Tipo, 'Pendiente', Asignada, 'Sin fecha')),
        assertz(tarea(Proyecto, Tarea, Tipo, 'Finalizada', Asignada, FechaFin)),
        write('La tarea se ha cerrado y marcado como finalizada.')
    ;
        write('La tarea ya está cerrada o no existe en la base de conocimientos.')
    ).

obtener_nombre_proyectol(Proyecto) :-
    write('Ingrese el nombre del proyecto: '),
    read(Proyecto).

obtener_nombre_tareal(Tarea) :-
    write('Ingrese el nombre de la tarea: '),
    read(Tarea).

obtener_fecha(FechaFin) :-
    repeat,
    write('Ingrese la fecha Final (en formato dd/mm/aaaa): '),
    read_line_to_codes(user_input, Codes),
    string_codes(String, Codes),
    split_string(String, "/", "", [D, M, A]),
    number_string(Dia, D),
    number_string(Mes, M),
    number_string(Anio, A),
    (   fecha_valida(Anio, Mes, Dia) ->
        FechaFin = String
    ;   write('Fecha ingresada inválida. Intente nuevamente.'), nl,
        obtener_fecha_fin(FechaFin)
    ).
