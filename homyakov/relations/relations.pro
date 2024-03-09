% Copyright

implement relations
    open core, famDB

clauses
    male(Id) :-
        person_nd(Id, _, _, _, "м", _).

    female(Id) :-
        person_nd(Id, _, _, _, "ж", _).

    father(X, Y) :-
        male(X),
        parent_nd(X, Y).

    mother(X, Y) :-
        female(X),
        parent_nd(X, Y).

    sister(X, Y) :-
        female(X),
        parent_nd(Z, X),
        parent_nd(Z, Y),
        X <> Y.

    brother(X, Y) :-
        male(X),
        parent_nd(Z, X),
        parent_nd(Z, Y),
        X <> Y.

    son(X, Y) :-
        male(X),
        parent_nd(Y, X).

    daughter(X, Y) :-
        female(X),
        parent_nd(Y, X).

    wife(X, Y) :-
        female(X),
        spouse_nd(Y, X).

    husband(X, Y) :-
        male(X),
        spouse_nd(X, Y).

    ancestor(X, Y) :-
        parent_nd(X, Y).
    ancestor(X, Y) :-
        parent_nd(X, Z),
        ancestor(Z, Y).

    descendant(X, Y) :-
        ancestor(Y, X).

    nephew_m(X, Y) :-
        son(X, Z),
        sister(Z, Y)
        or
        son(X, Z),
        brother(Z, Y).

    nephew_f(X, Y) :-
        daughter(X, Z),
        sister(Z, Y)
        or
        daughter(X, Z),
        brother(Z, Y).

    aunt(X, Y) :-
        parent_nd(Z, Y),
        sister(X, Z).

    uncle(X, Y) :-
        parent_nd(Z, Y),
        brother(X, Z).

    grandmother(X, Y) :-
        female(X),
        parent_nd(Z, Y),
        parent_nd(X, Z).
    grandfather(X, Y) :-
        male(X),
        parent_nd(Z, Y),
        parent_nd(X, Z).

    grandson(X, Y) :-
        male(X),
        parent_nd(Z, X),
        parent_nd(Y, Z).
    granddaughter(X, Y) :-
        female(X),
        parent_nd(Z, X),
        parent_nd(Y, Z).

    cousin_f(X, Y) :-
        female(X),
        parent_nd(T, K),
        parent_nd(T, Z),
        K <> Z,
        parent_nd(K, X),
        parent_nd(Z, Y).

    cousin_m(X, Y) :-
        male(X),
        parent_nd(T, K),
        parent_nd(T, Z),
        K <> Z,
        parent_nd(K, X),
        parent_nd(Z, Y).

end implement relations
