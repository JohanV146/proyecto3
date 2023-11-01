:- dynamic(tarea/6).  % Hecho dinámico para tareas: proyecto, nombre, tipo, estado, persona_asignada, fecha_cierre.

% Verificar si un proyecto existe en la base de conocimientos
proyecto_existente(Proyecto) :- proyecto(Proyecto, _, _, _, _).

% Tipos de tareas permitidos
tipos_de_tarea_permitidos(['requerimientos', 'disenio', 'desarrollo', 'qa', 'fullstack', 'frontend', 'backend', 'administracion']).

% Validar si un tipo de tarea está permitido
tipo_de_tarea_permitido(Tipo) :-
    tipos_de_tarea_permitidos(Tipos),
    member(Tipo, Tipos).

% Predicado para agregar una nueva tarea a la base de conocimientos.
agregar_tarea(Proyecto, Nombre, Tipo) :-
    Estado = 'Pendiente',
    PersonaAsignada = 'Sin asignar',
    FechaCierre = 'Sin fecha',
    write('Ingrese el nombre del proyecto: '),
    read(Proyecto),
    (proyecto_existente(Proyecto) ->
        write('Ingrese el nombre de la tarea: '),
        read(Nombre),
        write('Ingrese el tipo de tarea: '),
        read(Tipo),
        (tipo_de_tarea_permitido(Tipo) ->
            assertz(tarea(Proyecto, Nombre, Tipo, Estado, PersonaAsignada, FechaCierre))
        ;
            write('El tipo de tarea ingresado no está permitido.')
        )
    ;
        write('El proyecto no existe en la base de conocimientos.')
    ).


% Predicado para mostrar todas las tareas almacenadas en la base de conocimientos.
mostrar_tareas :-
    tarea(Proyecto, Nombre, Tipo, Estado, PersonaAsignada, FechaCierre),
    write('Proyecto: '), write(Proyecto), nl,
    write('Nombre de la Tarea: '), write(Nombre), nl,
    write('Tipo de Tarea: '), write(Tipo), nl,
    write('Estado: '), write(Estado), nl,
    write('Persona Asignada: '), write(PersonaAsignada), nl,
    write('Fecha de Cierre: '), write(FechaCierre), nl,
    nl,
    fail.
mostrar_tareas.
