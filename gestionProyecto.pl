:- dynamic(proyecto/5).  % Hecho dinámico para proyectos: nombre, empresa, presupuesto, fecha_inicio, fecha_fin.

% ============= pide el nombre del proyecto =======================================================================
obtener_nombre_proyecto(Nombre) :-
    write('Ingrese el nombre del proyecto: '),
    read_line_to_string(user_input, Nombre).

% ============= pide el nombre de la empresa ======================================================================
obtener_nombre_empresa(Empresa) :-
    write('Ingrese el nombre de la empresa: '),
    read_line_to_string(user_input, Empresa).

% ============= pide el Presupuesto para el proyecto ==============================================================
obtener_presupuesto(Presupuesto) :-
    write('Ingrese el presupuesto del proyecto: '),
    read_line_to_string(user_input, NewPresupuesto1),
    number_string(NewPresupuesto, NewPresupuesto1),
    (   validar_presupuesto(NewPresupuesto)
    ->  Presupuesto = NewPresupuesto
    ;   obtener_presupuesto(Presupuesto)
    ).

% ============= Valida que el Presupuesto sea un numero entero positivo ===========================================
validar_presupuesto(Presupuesto) :-
    (   number(Presupuesto), Presupuesto >= 0
    ->  true
    ;   write('Error: El costo debe ser un número positivo.'), nl,
        fail
    ).

% ============= pide las fechas para el proyecto ======================================================
% Predicado para verificar si un mes tiene el número correcto de días
dias_mes(1, 31).
dias_mes(2, 28).
dias_mes(3, 31).
dias_mes(4, 30).
dias_mes(5, 31).
dias_mes(6, 30).
dias_mes(7, 31).
dias_mes(8, 31).
dias_mes(9, 30).
dias_mes(10, 31).
dias_mes(11, 30).
dias_mes(12, 31).

% Predicado para validar una fecha
fecha_valida(_, Month, Day) :-
    Month >= 1,
    Month =< 12,
    dias_mes(Month, DaysInMonth),
    Day >= 1,
    Day =< DaysInMonth.

% Predicado para pedir la fecha al usuario con formato "dd/mm/aaaa" y validarla
obtener_fecha_inicio(FechaInicio) :-
    repeat,
    write('Ingrese la fecha Inicial (en formato dd/mm/aaaa): '),
    read_line_to_codes(user_input, CodesI),
    string_codes(StringI, CodesI),
    split_string(StringI, "/", "", [D, M, A]),
    number_string(Dia, D),
    number_string(Mes, M),
    number_string(Anio, A),
    (   fecha_valida(Anio, Mes, Dia) ->
        FechaInicio = StringI
    ;   write('Fecha ingresada inválida. Intente nuevamente.'), nl,
        obtener_fecha_inicio(FechaInicio)
    ).

obtener_fecha_fin(FechaFin) :-
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


% Predicado principal que llama a los predicados de entrada y validación de datos
agregar_proyecto :-
    obtener_nombre_proyecto(Nombre),
    obtener_nombre_empresa(Empresa),
    obtener_presupuesto(Presupuesto),
    obtener_fecha_inicio(FechaInicio),
    obtener_fecha_fin(FechaFin),
    assertz(proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin)),
    write('Proyecto agregado con éxito a la base de conocimientos.').

costo_proyecto(Nombre, CostoTotal) :-
    findall(CostoTarea, (tarea(Nombre, _, _, _, Persona, _), persona(Persona, _, CostoTarea, _, _)), Costos),
    sum_list(Costos, CostoTotal).

mostrar_proyectos :-
    proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin),
    costo_proyecto(Nombre, CostoTotal),
    format('Nombre: ~w ~nEmpresa: ~w ~nPresupuesto: ~w ~nFecha de inicio: ~w ~nFecha de fin: ~w ~nCosto Total: ~w ~n~n', [Nombre, Empresa, Presupuesto, FechaInicio, FechaFin, CostoTotal]),
    fail.
mostrar_proyectos.

