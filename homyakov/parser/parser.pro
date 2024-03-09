% Copyright

implement parser
    open core, famDB, relations, stdio

clauses
    query(Text) = AnswerList :-
        Text1 = string::toLowerCase(Text),
        L = scan(Text1),
        TokList = list::filter(L, { (Tok) :- not(Tok in ignore) }),
        parser(expr, TokList, Term, Rest),
        !,
        write(Rest),
        nl,
        write(Term),
        nl,
        AnswerList = calc2(Term).
        %AnswerList = list::map(IdList, { (Id) = getInfo(Id) }).
    query(_) = [].

class predicates
    scan : (string) -> string*.
clauses
    scan(Str) = [Tok | scan(Rest)] :-
        string::frontToken(Str, Tok, Rest),
        !.
    scan(_) = [].

class facts
    ignore : string* :=
        [
            "найти",
            "'",
            "для",
            "найди",
            "вычислить",
            "но",
            "которые",
            "являются",
            "также",
            "тех",
            "всех",
            "того",
            "ту",
            "кто",
            "был",
            "была",
            "были",
            "году",
            "годах",
            "года",
            "год",
            "г",
            "гг",
            ",",
            ".",
            "!",
            "?"
        ].

/*
найти потомков Михаила Федоровича, которые умерли после 1720 года
найти супругов детей Петра I, которые жили в 1720 г., и братьев Петра I, и тех, кто родился в 1600-1650 гг.
сын Петра
Михаил
найти царевичей, которые были потомками Анны Леопольдовны

expr ::= item items | item2 items
item ::= elem elems | elems
items ::= union item items | empty
elems ::= intersection elem elems | empty
elem ::= timerel [в] year [-] year | timerel prep year | rel elem
    | name1 name2 | name1 | status


item2 :: = [кем] elem elems | empty

timerel ::= [родился] | [жил] | [умер]
rel ::= [родитель] | [отец] | [сестра] | ...
prep ::= [в] | [до] | [после]
union ::= [и] | [или]
intersection ::= [который] | [среди]
*/
domains
    term =
        union(term, term);
        inters(term, term);
        period(string, integer, integer);
        time(string, string Prep, integer);
        rel(string, term);
        family(string);
        name3(string, string, string);
        name2(string, string);
        name4(string, string);
        name(string);
        bywho(term); %статус
        bywhorel(term Who, term To).
    neterm = expr; item; item2; items; elem; elems. %item3;

class predicates
    parser : (neterm, string*, term [out], string* [out]) determ.
    parser : (neterm, string*, term, term [out], string* [out]) determ.

clauses
    parser(expr, L, Term, Rest) :-
        parser(item, L, Term1, L1),
        !,
        parser(items, L1, Term1, Term, Rest).

    parser(expr, L, Term, Rest) :-
        parser(item2, L, Term1, L1),
        !,
        parser(items, L1, Term1, Term, Rest).

    parser(expr, L, Term, Rest) :-
        parser(item2, L, Term1, L1),
        !,
        parser(items, L1, Term1, Term, Rest).

    parser(item2, ["кем", "приходится" | L], bywhorel(Term1, Term), Rest) :-
        parser(elem, L, Term1, L1),
        parser(elem, L1, Term2, L2),
        !,
        parser(elems, L2, Term2, Term, Rest).

    parser(item2, ["кем" | L], bywho(Term), Rest) :-
        parser(elem, L, Term1, L1),
        !,
        parser(elems, L1, Term1, Term, Rest).

    parser(item, L, Term, Rest) :-
        parser(elem, L, Term1, L1),
        !,
        parser(elems, L1, Term1, Term, Rest).

%    parser(elem, L, Term, Rest) :-
%        нач комментария
%        parser(elem2, L, Term, Rest),
%        !.
%    parser(elem2, ["кем" | L], bywho(Term), Rest) :-
%        parser(elem, L, Term, Rest),
%        !. %конч комментария
    parser(elem, [Timerel, "в", Y1, "-", Y2 | L], period(Norm, Year1, Year2), L) :-
        Norm = norm("timerel", Timerel),
        Year1 = tryToTerm(integer, Y1),
        Year2 = tryToTerm(integer, Y2),
        !.

    parser(elem, [Timerel, Prep, Y | L], time(Norm, Prep, Year), L) :-
        Norm = norm("timerel", Timerel),
        preposition(Prep),
        Year = tryToTerm(integer, Y),
        !.

    parser(elem, [Rel | L], rel(Norm, Term), Rest) :-
        Norm = norm("rel", Rel),
        parser(elem, L, Term, Rest),
        !.

    parser(elem, [Name1, Name2, Name3 | L], name3(Norm1, Norm2, Norm3), L) :-
        %имя3
        norm3(Name1, Name2, Name3, Norm1, Norm2, Norm3),
        !.
    parser(elem, [Name1, Name2 | L], name2(Norm1, Norm2), L) :-
        norm2(Name1, Name2, Norm1, Norm2),
        !.
    parser(elem, [Name1, Name2 | L], name4(Norm1, Norm2), L) :-
        norm4(Name1, Name2, Norm1, Norm2),
        !.
    parser(elem, [Family | L], family(Norm), L) :-
        Norm = norm("family", Family),
        !.

    parser(elem, [Name | L], name(Norm), L) :-
        Norm = norm("name", Name).

    parser(items, [Union | L], Term1, Term, Rest) :-
        union(Union),
        parser(item, L, Term2, L1),
        !,
        parser(items, L1, union(Term1, Term2), Term, Rest).
    parser(items, [Union | L], Term1, Term, Rest) :-
        union(Union),
        parser(item2, L, Term2, L1),
        !,
        parser(items, L1, union(Term1, Term2), Term, Rest).

    parser(elems, [Inters | L], Term1, Term, Rest) :-
        intersection(Inters),
        parser(elem, L, Term2, L1),
        !,
        parser(elems, L1, inters(Term1, Term2), Term, Rest).
    parser(_, L, Term, Term, L).

class facts
    preposition : (string).
    union : (string).

clauses
    preposition("в").
    preposition("до").
    preposition("после").

    union("и").
    union("или").
    union(";").

class predicates
    intersection : (string) determ.
clauses
    intersection("среди") :-
        !.
    intersection(Tok) :-
        string::hasPrefix(Tok, "котор", _).

class facts
    timerel : (string Root, string Norm).
    relation : (string Root, string Norm).

clauses
    timerel("родил", "родился").
    timerel("родивш", "родился").
    timerel("рожд", "родился").
    timerel("родились", "родился").
    timerel("умер", "умер").
    timerel("сконча", "умер").
    timerel("жил", "жил").
    timerel("живш", "жил").

    relation("родител", "родитель").
    relation("ребен", "ребенок").
    relation("ребён", "ребенок").
    relation("детей", "ребенок").
    relation("дети", "ребенок").
    relation("дитя", "ребенок").
    relation("дитем", "ребенок").
    relation("дитём", "ребенок").
    relation("отц", "отец").
    relation("отец", "отец").
    relation("матер", "мать").
    relation("мать", "мать").
    relation("сын", "сын").
    relation("доч", "дочь").
    relation("жен", "жена").
    relation("жён", "жена").
    relation("мужа", "муж").
    relation("мужья", "муж").
    relation("мужей", "муж").
    relation("муж", "муж").
    relation("супруг", "супруг").
    relation("брат", "брат").
    relation("сест", "сестра").
    relation("сёст", "сестра").
    relation("предок", "предок").
    relation("предк", "предок").
    relation("потом", "потомок").
    relation("кузена", "кузен").
    relation("кузену", "кузен").
    relation("кузенов", "кузен").
    relation("кузеном", "кузен").
    relation("кузен", "кузен").
    relation("кузину", "кузина").
    relation("кузине", "кузина").
    relation("кузин", "кузина").
    relation("кузины", "кузина").
    relation("кузинам", "кузина").
    relation("родител", "родитель").
    relation("род", "род").
    relation("рода", "род").
    relation("племянник", "племянник").
    relation("племянника", "племянник").
    relation("племянников", "племянник").
    relation("племянница", "племянница").
    relation("племянницу", "племянница").
    relation("племянницы", "племянница").
    relation("племянниц", "племянница").
    relation("тётя", "тётя").
    relation("тётю", "тётя").
    relation("тёти", "тётя").
    relation("тётей", "тётя").
    relation("дядя", "дядя").
    relation("дядю", "дядя").
    relation("дяди", "дядя").
    relation("дядей", "дядя").
    relation("бабушка", "бабушка").
    relation("бабушки", "бабушка").
    relation("бабушку", "бабушка").
    relation("бабушек", "бабушка").
    relation("дедушка", "дедушка").
    relation("дедушки", "дедушка").
    relation("дедушку", "дедушка").
    relation("дедушек", "дедушка").
    relation("дед", "дедушка").
    relation("деду", "дедушка").
    relation("деда", "дедушка").
    relation("внук", "внук").
    relation("внука", "внук").
    relation("внуков", "внук").
    relation("внучка", "внучка").
    relation("внучку", "внучка").
    relation("внучки", "внучка").
    relation("внучек", "внучка").
    relation("кузина", "кузина").
    relation("кузины", "кузина").
    relation("кузину", "кузина").
    relation("кузин", "кузина").
    relation("кузен", "кузен").
    relation("кузена", "кузен").
    relation("кузенов", "кузен").

class predicates
    reduce : (string Tok) -> string Reduced multi.
    reduce1 : (string Tok, charCount) -> string Reduced multi.

clauses
    reduce(Tok) = reduce1(Tok, N) :-
        N = string::length(Tok).

    reduce1(Tok, _) = Tok.
    reduce1(Tok, N) = reduce1(First, N - 1) :-
        N > 3,
        string::lastChar(Tok, First, _).

class predicates
    norm : (string, string Token) -> string determ.
    norm2 : (string, string, string [out], string [out]) determ. %тут коммент тест
    norm4 : (string, string, string [out], string [out]) determ. %тут коммент тест
    norm3 : (string, string, string, string [out], string [out], string [out]) determ.
    calc : (term) -> unsigned* determ.
    calc2 : (term) -> string*.

clauses
    norm("timerel", Tok) = Norm :-
        timerel(Root, Norm),
        string::hasPrefix(Tok, Root, _),
        !.
    norm("rel", Tok) = Norm :-
        relation(Root, Norm),
        string::hasPrefix(Tok, Root, _),
        !.
    norm("family", Tok) = Norm :-
        Reduced = reduce(Tok),
        person_nd(_, _, _, _, _, Norm),
        Family = string::toLowerCase(Norm),
        string::hasPrefix(Family, Reduced, _),
        !.

    norm("name", "лии") = "Лия" :-
        person_nd(_, "Лия", _, _, _, _),
        !.
    norm("name", "лия") = "Лия" :-
        person_nd(_, "Лия", _, _, _, _),
        !.
    norm("name", Tok) = Norm :-
        Reduced = reduce(Tok),
        person_nd(_, Norm, _, _, _, _),
        Name = string::toLowerCase(Norm),
        string::hasPrefix(Name, Reduced, _),
        !.
%тут коммент тест

    norm2(Tok1, Tok2, Norm1, Norm2) :-
        Reduced1 = reduce(Tok1),
        Reduced2 = reduce(Tok2),
        person_nd(_, Norm1, Norm2, _, _, _),
        Name1 = string::toLowerCase(Norm1),
        Name2 = string::toLowerCase(Norm2),
        string::hasPrefix(Name1, Reduced1, _),
        string::hasPrefix(Name2, Reduced2, _),
        !.
    norm4(Tok1, Tok2, Norm1, Norm2) :-
        Reduced1 = reduce(Tok1),
        Reduced2 = reduce(Tok2),
        person_nd(_, Norm1, _, Norm2, _, _),
        Name1 = string::toLowerCase(Norm1),
        Name2 = string::toLowerCase(Norm2),
        string::hasPrefix(Name1, Reduced1, _),
        string::hasPrefix(Name2, Reduced2, _),
        !.
    norm3(Tok1, Tok2, Tok3, Norm1, Norm2, Norm3) :-
        Reduced1 = reduce(Tok1),
        Reduced2 = reduce(Tok2),
        Reduced3 = reduce(Tok3),
        person_nd(_, Norm1, Norm2, Norm3, _, _),
        Name1 = string::toLowerCase(Norm1),
        Name2 = string::toLowerCase(Norm2),
        Name3 = string::toLowerCase(Norm3),
        string::hasPrefix(Name1, Reduced1, _),
        string::hasPrefix(Name2, Reduced2, _),
        string::hasPrefix(Name3, Reduced3, _),
        !.

/*
 term =
        union(term, term);
        inters(term, term);
        period(string, integer, integer);
        time(string, string Prep, integer);
        rel(string, term);
        status(string);
        name3(string, string, string);
        name2(string, string);
        name(string).

 */
class predicates
    namerelation : (unsigned, unsigned) -> string determ.
clauses
    namerelation(Id1, Id2) = "отец" :-
        father(Id1, Id2),
        !.
    namerelation(Id1, Id2) = "сестра" :-
        sister(Id1, Id2),
        !.
    namerelation(Id1, Id2) = "брат" :-
        brother(Id1, Id2),
        !.
    namerelation(Id1, Id2) = "мать" :-
        mother(Id1, Id2),
        !.

    calc2(bywho(Term)) =
            list::removeDuplicates(
                [ Family ||
                    Id in L,
                    person_nd(Id, _, _, _, _, Family)
                ]) :-
        L = calc(Term),
        L <> [],
        !.
    calc2(bywhorel(Term1, Term2)) =
            list::removeDuplicates(
                [ Rel ||
                    Id1 in L1,
                    Id2 in L2,
                    Id1 <> Id2,
                    Rel = namerelation(Id1, Id2)
                ]) :-
        L1 = calc(Term1),
        L1 <> [],
        L2 = calc(Term2),
        L2 <> [],
        !.
    calc2(union(Term1, Term2)) = list::union(X1, X2) :-
        X1 = calc2(Term1),
        X2 = calc2(Term2),
        (X1 <> [] or X2 <> []),
        !.
    calc2(inters(Term1, Term2)) = list::intersection(X1, X2) :-
        X1 = calc2(Term1),
        X2 = calc2(Term2),
        (X1 <> [] or X2 <> []),
        !.
    calc2(Term) = list::map(L, { (Id) = getInfo(Id) }) :-
        L = calc(Term),
        L <> [],
        !.
    calc2(_) = [].

    calc(name(Name)) = [ Id || person_nd(Id, Name, _, _, _, _) ] :-
        !.
        %тут коммент тест
    calc(name2(Name1, Name2)) = [ Id || person_nd(Id, Name1, Name2, _, _, _) ] :-
        !.
    calc(name3(Name1, Name2, Name3)) = [ Id || person_nd(Id, Name1, Name2, Name3, _, _) ] :-
        !.
    calc(name4(Name1, Name2)) = [ Id || person_nd(Id, Name1, _, Name2, _, _) ] :-
        !.
    calc(family(Familiy)) = [ Id || person_nd(Id, _, _, _, _, Familiy) ] :-
        !.
    calc(union(Term1, Term2)) = list::union(X, Y) :-
        X = calc(Term1),
        Y = calc(Term2),
        !.
    calc(inters(Term1, Term2)) = list::intersection(X, Y) :-
        X = calc(Term1),
        Y = calc(Term2),
        !.
    calc(period("родился", Y1, Y2)) =
            [ Id ||
                birth_nd(Id, Y),
                Y >= Y1,
                Y <= Y2
            ] :-
        !.
    calc(period("умер", Y1, Y2)) =
            [ Id ||
                death_nd(Id, Y),
                Y >= Y1,
                Y <= Y2
            ] :-
        !.
    calc(period("жил", Y1, Y2)) =
            [ Id ||
                birth_nd(Id, B),
                death_nd(Id, D),
                B <= Y2,
                D >= Y1
                or
                birth_nd(Id, B),
                B <= Y2,
                not((death_nd(Id, D) and D < Y1))
                or
                death_nd(Id, D),
                D >= Y1
            ] :-
        !.
    calc(time("родился", "в", Y)) = [ Id || birth_nd(Id, Y) ] :-
        !.
    calc(time("умер", "в", Y)) = [ Id || death_nd(Id, Y) ] :-
        !.
    calc(time("жил", "в", Y)) =
            [ Id ||
                birth_nd(Id, B),
                Y >= B,
                death_nd(Id, D),
                Y <= D
                or
                birth_nd(Id, B),
                Y >= B,
                not((death_nd(Id, D) and Y < D))
                or
                death_nd(Id, Y)
            ] :-
        !.
    calc(time("родился", "до", Y)) =
            [ Id ||
                birth_nd(Id, B),
                B < Y
            ] :-
        !.
    calc(time("родился", "после", Y)) =
            [ Id ||
                birth_nd(Id, B),
                B > Y
            ] :-
        !.
    calc(time("умер", "до", Y)) =
            [ Id ||
                death_nd(Id, B),
                B < Y
            ] :-
        !.
    calc(time("умер", "после", Y)) =
            [ Id ||
                death_nd(Id, B),
                B > Y
            ] :-
        !.
    calc(time("жил", "до", Y)) =
            [ Id ||
                birth_nd(Id, B),
                B < Y
            ] :-
        !.
    calc(time("жил", "после", Y)) =
            [ Id ||
                person_nd(Id, _, _, _, _, _),
                not((death_nd(Id, D) and D < Y))
            ] :-
        !.
    calc(rel("родитель", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    parent_nd(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("ребенок", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    parent_nd(I, Id)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("супруг", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    (spouse_nd(Id, I) or spouse_nd(I, Id))
                ]) :-
        X = calc(Term),
        !.
    calc(rel("жена", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    spouse_nd(I, Id)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("муж", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    spouse_nd(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("отец", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    father(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("мать", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    mother(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("сын", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    son(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("дочь", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    daughter(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("сестра", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    sister(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("брат", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    brother(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("предок", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    ancestor(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("потомок", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    descendant(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("кузен", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    cousin_m(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("кузина", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    cousin_f(Id, I)
                ]) :-
        X = calc(Term),
        !.

    calc(rel("племянник", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    nephew_m(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("племянница", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    nephew_f(Id, I)
                ]) :-
        X = calc(Term),
        !.

    calc(rel("дядя", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    uncle(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("тётя", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    aunt(Id, I)
                ]) :-
        X = calc(Term),
        !.

    calc(rel("бабушка", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    grandmother(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("дедушка", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    grandfather(Id, I)
                ]) :-
        X = calc(Term),
        !.

    calc(rel("внучка", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    granddaughter(Id, I)
                ]) :-
        X = calc(Term),
        !.
    calc(rel("внук", Term)) =
            list::removeDuplicates(
                [ Id ||
                    I in X,
                    grandson(Id, I)
                ]) :-
        X = calc(Term),
        !.

%    calc(rel("род", Term)) =
%            list::removeDuplicates(
%                [ Id ||
%                    I in X,
%                    family1(Id, I)
%                ]) :-
%        X = calc(Term),
%        !.
class predicates
    getInfo : (unsigned Id) -> string.
    getYears : (unsigned Id) -> string.

clauses
    getInfo(Id) = string::format("%. % % % %", Id, Name, Name2, Name3, Years) :-
        person_nd(Id, Name, Name2, Name3, _, _),
        !,
        Years = getYears(Id).
    getInfo(_) = "".

    getYears(Id) = string::format("(% - %)", Y1, Y2) :-
        birth_nd(Id, Y1),
        death_nd(Id, Y2),
        !.
    getYears(Id) = string::format("(род. %)", Y1) :-
        birth_nd(Id, Y1),
        !.
    getYears(Id) = string::format("(ум. %)", Y2) :-
        death_nd(Id, Y2),
        !.
    getYears(_Id) = "".

end implement parser
