:- consult('gestionPersona.pl').

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
    read(Opcion),
    (Opcion = 1 -> menuPersona;
     Opcion = 2 -> write("Gestion de proyectos"), nl;
     Opcion = 3 -> write("Gestion de tareas."), nl;
     Opcion = 4 -> write("Buscar tareas"), nl;
     Opcion = 5 -> write("Recomendar personas."), nl;
     Opcion = 6 -> write("Asignar a tarea."), nl;
     Opcion = 7 -> write("cerrar tarea."), nl;
     Opcion = 8 -> write("Estadisticas."), nl;
     Opcion = 9 -> write("Saliendo del programa."), nl, !).

% ================ Submenu persona ============================================================
consult('gestionPersona.pl').
menuPersona :-
    repeat,
    write("Menú: "), nl,
    write("1. Ingresar persona"), nl,
    write("2. Mostrar personas"), nl,
    write("3. Volver"), nl,
    read(Opcion),
    (Opcion = 1 -> agregar_persona, menuPersona;
     Opcion = 2 -> mostrar_personas, menuPersona;
     Opcion = 3 -> menu).
