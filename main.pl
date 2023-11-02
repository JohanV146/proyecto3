:- consult('gestionPersona.pl').
:- consult('gestionProyecto.pl').
:- consult('gestionTareas.pl').
:- consult('acciones.pl').
:- consult('estadisticas.pl').


cargar_desde_archivo(NombreArchivo) :-
    open(NombreArchivo, read, Stream),
    repeat,
    read(Stream, Term),
    ( Term == end_of_file -> ! ; assert(Term), fail ),
    close(Stream).

main :-
    cargar_desde_archivo('bc.txt'), menu.
menu :-
    repeat,
    write("Menú: "), nl,
    write("1. Gestión de personas"), nl,
    write("2. Gestión de proyectos"), nl,
    write("3. Gestión de tareas"), nl,
    write("4. Buscar tareas libres"), nl,
    write("5. Recomendar persona"), nl,
    write("6. Asignar a tarea"), nl,
    write("7. Cerrar tarea"), nl,
    write("8. Estadísticas"), nl,
    write("9. Salir"), nl,
    read_line_to_string(user_input, Opcion1),
    number_string(Opcion, Opcion1),
    (Opcion = 1 -> menuPersona;
     Opcion = 2 -> menuProyecto;
     Opcion = 3 -> menuTarea;
     Opcion = 4 -> buscaTarea, menu;
     Opcion = 5 -> recomendar_personas, menu;
     Opcion = 6 -> asignar_tarea, menu;
     Opcion = 7 -> cerrar_tarea, menu;
     Opcion = 8 -> menuEstadisticas, menu;
     Opcion = 9 -> guardar_en_archivo('bc.txt'), write("Saliendo del programa."), nl, !).

guardar_en_archivo(NombreArchivo) :-
    tell(NombreArchivo),
    telling(OldStream),
    tell(NombreArchivo),
    listing(proyecto/5), % Listar hechos del predicado 'proyecto/5'
    listing(tarea/6),    % Listar hechos del predicado 'tarea/6'
    listing(persona/5),  % Listar hechos del predicado 'persona/5'
    tell(OldStream),    % Restaurar el flujo de escritura anterior
    told.

% ================ Submenu persona ============================================================
menuPersona :-
    repeat,
    write("Menú: "), nl,
    write("1. Ingresar persona"), nl,
    write("2. Mostrar personas"), nl,
    write("3. Volver"), nl,
    read_line_to_string(user_input, Opcion1),
    number_string(Opcion, Opcion1),
    (Opcion = 1 -> agregar_persona, menuPersona;
     Opcion = 2 -> mostrar_personas, menuPersona;
     Opcion = 3 -> menu).

% ================ Submenu Proyecto ============================================================
menuProyecto :-
    repeat,
    write("Menú: "), nl,
    write("1. Ingresar proyecto"), nl,
    write("2. Mostrar proyectos"), nl,
    write("3. Volver"), nl,
    read_line_to_string(user_input, Opcion1),
    number_string(Opcion, Opcion1),
    (Opcion = 1 -> agregar_proyecto, menuProyecto;
     Opcion = 2 -> mostrar_proyectos, menuProyecto;
     Opcion = 3 -> menu).

% ================ Submenu Tareas ============================================================
menuTarea :-
    repeat,
    write("Menú: "), nl,
    write("1. Ingresar Tarea"), nl,
    write("2. Mostrar Tareas"), nl,
    write("3. Volver"), nl,
    read_line_to_string(user_input, Opcion1),
    number_string(Opcion, Opcion1),
    (Opcion = 1 -> agregar_tarea(_Proyecto, _Nombre, _Tipo), menuTarea;
     Opcion = 2 -> mostrar_tareas, menuTarea;
     Opcion = 3 -> menu).

% ================ Submenu Tareas ============================================================
menuEstadisticas :-
    repeat,
    write("Menú: "), nl,
    write("1. Estatus financiero de proyecto"), nl,
    write("2. Tipo de cierre de proyecto"), nl,
    write("3. Cantidad de tareas por persona"), nl,
    write("4. Volver"), nl,
    read_line_to_string(user_input, Opcion1),
    number_string(Opcion, Opcion1),
    (Opcion = 1 -> mostrar_estadisticas_proyectos, menuEstadisticas;
     Opcion = 2 -> mostrar_tipos_cierre, menuEstadisticas;
     Opcion = 3 -> tareas_asignadas_por_persona, menuEstadisticas;
     Opcion = 4 -> menu).


