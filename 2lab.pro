domains
    station = string
    transport = string
    route_null = string*
    type = symbol

predicates
    nondeterm transport_type(transport, type)
    nondeterm route(transport, route_null)
    nondeterm direct_route(station, station)
    nondeterm my_member(station,route_null)
    nondeterm transfer_route(station, station)
    nondeterm common_station(route_null, route_null, station)
    nondeterm find_route(station,station)


clauses
    % Определения типов транспорта
    transport_type("green", metro).
    transport_type("blue", metro).
    transport_type("red", metro).
    transport_type("white", metro).
    transport_type("37", bus).
    transport_type("26k", bus).
    transport_type("5a", bus).
    transport_type("17", trolley).
    transport_type("35", trolley).
    transport_type("160", tram).
    transport_type("35a", tram).
    transport_type("1a", tram).
    
     transport_type("98", tram).
     transport_type("98a", tram).
     transport_type("98b", tram).

    % Маршруты
    route("green", ["st2", "st4", "st6", "st7"]).
    route("blue", ["st1", "st5", "st13"]).
    route("red", ["st3", "st5", "st9", "st12"]).
    route("white", ["st1", "st2", "st6", "st8", "st10", "st12"]).
    
    route("37", ["st1", "st2", "st3", "st4", "st5", "st6"]).
    route("26k", ["st1", "st2", "st3", "st4", "st7", "st8", "st9", "st10"]).
    route("5a", ["st3", "st4", "st7", "st10", "st11"]).
    
    route("17", ["st1", "st3", "st6", "st7", "st8", "st12"]).
    route("35", ["st5", "st7", "st9", "st10"]).
    
    route("160", ["st1", "st3", "st5", "st7", "st11"]).
    route("35a", ["st6", "st7", "st9"]).
    route("1a", ["st1", "st5", "st12"]).
    
    route("98",["st22","st24"]).
    route("98a",["st20","st22"]).
    route("98b",["st18","st20"]).



    % Поиск прямого маршрута
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).

direct_route(Start, End) :- 
    route(Transport, Stations),
    transport_type(Transport,Type),
    my_member(Start, Stations),
    my_member(End, Stations),
    write(Transport),nl,
    write(Type),nl,
    write(Stations),nl,
    fail.
    
direct_route(_, _).




    % Поиск маршрута с пересадками
common_station([H|_], List2, H) :- my_member(H, List2), !.
    common_station([_|T], List2, CommonStation) :- common_station(T, List2, CommonStation).

    transfer_route(Start, End) :-
        route(Transport1, Stations1),
        route(Transport2, Stations2),
        my_member(Start, Stations1),
        my_member(End, Stations2),
        common_station(Stations1, Stations2, CommonStation),
        not(CommonStation = Start),
        CommonStation <> End,
        write("Route 1: "), write(Transport1), write(" -> Stations: "), write(Stations1), nl,
        write("Route 2: "), write(Transport2), write(" -> Stations: "), write(Stations2), nl,
        write("Common Station: "), write(CommonStation), nl,
        fail.
        
     transfer_route(_,_).
      
      

        

    % Общий поиск маршрута
find_route(Start, End) :- 
    direct_route(Start, End), !.

find_route(Start, End) :-
    transfer_route(Start, End).
        
goal
find_route("st18", X), find_route(X, "st24").