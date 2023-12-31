mostrar_estadisticas_proyectos :-
    proyecto(Proyecto, _, _, _, _),
    estadisticaProyecto(Proyecto),
    fail.
mostrar_estadisticas_proyectos.

estadisticaProyecto(Proyecto) :-
    extraerPersona(Proyecto, Nombre),
    persona(Nombre, _, Costo, _, _),
    costo_tarea(Nombre, Costo),
    suma_tareas(Proyecto, CostoTotal),
    estado_financiero_proyecto(Proyecto, CostoTotal, Estado),
    mostrar_estados_financieros(Proyecto, Estado).

extraerPersona(Proyecto, Nombre) :-
    tarea(Proyecto, _, _, _, Nombre, _).

costo_tarea(Persona, Costo) :-
    persona(Persona, _, Costo, _, _).

suma_tareas(Proyecto, CostoTotal) :-
    findall(Costo, (extraerPersona(Proyecto, Nombre), costo_tarea(Nombre, Costo)), Costos),
    sum_list(Costos, CostoTotal).

estado_financiero_proyecto(Nombre, CostoTotal, Estado) :-
    proyecto(Nombre, _, Presupuesto, _, _),
    (
        Presupuesto =:= CostoTotal -> Estado = 'Tablas';
        Presupuesto < CostoTotal -> Estado = 'Sobre costo';
        Presupuesto > CostoTotal -> Estado = 'Bajo costo'
    ).

mostrar_estados_financieros(Proyecto, Estado) :-
    format('Nombre: ~w ~nEstado financiero: ~w ~n~n', [Proyecto, Estado]), !.

% ========================================================================

% Predicado para determinar el tipo de cierre del proyecto
tipo_cierre_proyecto(NombreProyecto, TipoCierre) :-
    proyecto(NombreProyecto, _, _, _, FechaCierreProyecto),
    split_string(FechaCierreProyecto, "/", "", [D1, M1, A1]),
    number_string(Dia1, D1),
    number_string(Mes1, M1),
    number_string(Anio1, A1),

    (
        (tarea(NombreProyecto, _, _, _, _, FechaMaxCierre),
        FechaMaxCierre \== 'Sin fecha',
        split_string(FechaMaxCierre, "/", "", [D2, M2, A2]),
        number_string(Dia2, D2),
        number_string(Mes2, M2),
        number_string(Anio2, A2),

        validarAldia(Dia1, Mes1, Anio1, Dia2, Mes2, Anio2)) -> TipoCierre = 'Al d�a';

        (tarea(NombreProyecto, _, _, _, _, FechaMaxCierre),
        FechaMaxCierre \== 'Sin fecha',
        split_string(FechaMaxCierre, "/", "", [D2, M2, A2]),
        number_string(Dia2, D2),
        number_string(Mes2, M2),
        number_string(Anio2, A2),

        validarTardia(Dia1, Mes1, Anio1, Dia2, Mes2, Anio2)) -> TipoCierre = 'Tard�a';

        TipoCierre = 'No aplicable' % Asigna un tipo por defecto para las tareas sin fecha o proyectos sin tareas
    ).

mostrar_tipos_cierre :-
    proyecto(NombreProyecto, _, _, _, _),
    tipo_cierre_proyecto(NombreProyecto, TipoCierre),
    format('Proyecto: ~w ~nTipo de cierre: ~w ~n~n', [NombreProyecto, TipoCierre]),
    fail.

mostrar_tipos_cierre :- !.


% Verifica si la tarea est� al d�a respecto a la fecha de cierre del proyecto
validarAldia(Dia1, Mes1, Anio1, Dia2, Mes2, Anio2) :-
    date_time_stamp(date(Anio2, Mes2, Dia2, 0, 0, 0, _, _, 0), Stamp2),
    date_time_stamp(date(Anio1, Mes1, Dia1, 0, 0, 0, _, _, 0), Stamp1),
    Stamp2 =< Stamp1.

% Verifica si la tarea est� tard�a respecto a la fecha de cierre del proyecto
validarTardia(Dia1, Mes1, Anio1, Dia2, Mes2, Anio2) :-
    date_time_stamp(date(Anio2, Mes2, Dia2, 0, 0, 0, _, _, 0), Stamp2),
    date_time_stamp(date(Anio1, Mes1, Dia1, 0, 0, 0, _, _, 0), Stamp1),
    Stamp2 > Stamp1.

% =======================================================================

tareas_asignadas_por_persona :-
    findall(Persona, tarea(_, _, _, _, Persona, _), ListaPersonas),
    sort(ListaPersonas, PersonasUnicas),
    contar_tareas_por_persona(PersonasUnicas).

contar_tareas_por_persona([]).
contar_tareas_por_persona([Persona | Resto]) :-
    (Persona \= 'Sin asignar' ->
        findall(_, tarea(_, _, _, _, Persona, _), ListaTareas),
        length(ListaTareas, Cantidad),
        format('Persona: ~w - Cantidad de tareas asignadas: ~w~n', [Persona, Cantidad])
    ;
        true
    ),
    contar_tareas_por_persona(Resto).
