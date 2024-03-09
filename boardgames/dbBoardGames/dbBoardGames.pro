% Copyright

implement dbBoardGames
    open core, stdio

facts
    filename : string := "".
    maxAttr : positive := 0.
    maxRule : positive := 0.

facts - dbexp
    rule : (positive, string, string, positive*).
    attr : (positive, string, string).
    topic : (string).
    pict : (positive, string).

facts
    parent : (positive, positive).

clauses
    new(Filename) :-
        filename := Filename.

    getNewAttrId() = maxAttr :-
        maxAttr := maxAttr + 1.

    getNewRuleId() = maxRule :-
        maxRule := maxRule + 1.

    rule_nd(A, B, C, D) :-
        rule(A, B, C, D).

    attr_nd(A, B, C) :-
        attr(A, B, C).

    topic_nd(A) :-
        topic(A).

    pict_nd(A, B) :-
        pict(A, B).

    parent_nd(A, B) :-
        parent(A, B).

clauses
    load() :-
        %filename := Filename,
        try
            file::reconsult(filename, dbexp)
        catch Error do
            stdio::writef("Error %. Unable to load a database from %\n", Error, filename)
        end try,
        AttrList = [ I || attr(I, _, _) ],
        if Attrlist <> [] then
            maxAttr := list::maximum(AttrList)
        end if,
        RuleList = [ J || rule(J, _, _, _) ],
        if RuleList <> [] then
            maxRule := list::maximum(RuleList)
        end if,
        createParents(),
        DescendantTree = createDescendantTree(0),
        Tree = removeAllFromTree(DescendantTree),
        retractAll(parent(_, _)),
        restoreParents(Tree).

domains
    tree = t(positive, tree*).

predicates
    createParents : ().
    ancestorExists : (positive, positive) determ.
    ancestor : (positive, positive) nondeterm.
    compancestor : comparator{positive}.
    createDescendantTree : (positive) -> tree.
    restoreParents : (tree).

clauses
    createDescendantTree(N) = t(N, TreeList) :-
        ChildList = [ K || parent(N, K) ],
        TreeList = list::map(ChildList, { (Child) = createDescendantTree(Child) }).

    restoreParents(t(Root, TreeList)) :-
        foreach t(Head, _) in TreeList do
            if not(parent(Root, Head)) then
                assert(parent(Root, Head))
            end if
        end foreach,
        foreach Tree in TreeList do
            restoreParents(Tree)
        end foreach.

    compancestor(K, K) = equal() :-
        !.
    compancestor(N, K) = equal() :-
        (ancestorExists(N, K) or ancestorExists(K, N)),
        !.
    compancestor(N, K) = equal() :-
        (ancestor(N, K) or ancestor(K, N)),
        !.

    compancestor(N, K) = compare(N, K).

    ancestor(N, K) :-
        parent(N, K).
    ancestor(N, K) :-
        parent(M, K),
        ancestor(N, M).

    ancestorExists(N, K) :-
        ancestor(N, K),
        !.

    createParents() :-
        foreach attr(K, _, _) do
            ParentList =
                list::removeDuplicates(
                    list::removeDuplicatesBy(compancestor,
                        [ ParentNumber ||
                            rule(_, _, _, FeatureList),
                            Index = list::tryGetIndex(K, FeatureList),
                            (0 = Index and ParentNumber = 0 orelse ParentNumber = list::tryGetNth(Index - 1, FeatureList))
                        ])),
            foreach Parent in ParentList and not(ancestorExists(K, Parent)) do
                assert(parent(Parent, K))
            end foreach
        end foreach.

predicates
    member : (tree) -> positive multi.
    findAllTreeNodes : (tree) -> positive*.
    removeAllFromTree : (tree) -> tree.
    removeAllFromTreeList : (tree*, positive*, positive*, positive* [out]) -> tree*.

clauses
    member(t(Root, _)) = Root.
    member(t(_, TreeList)) = member(Tree) :-
        Tree in TreeList.

    findAllTreeNodes(Tree) = [ Node || Node = member(Tree) ].

    removeAllFromTree(Tree) = t(Root, RestTreeList) :-
        t(Root, TreeList) = Tree,
        NodeList = list::removeDuplicates(findAllTreeNodes(Tree)),
        RestTreeList = removeAllFromTreeList(TreeList, NodeList, [Root], _).

    removeAllFromTreeList([t(Root, _TreeList) | RestTreeList], NodeList, VisitedNodeList, NewVisitedNodeList) =
            removeAllFromTreeList(RestTreeList, NodeList, VisitedNodeList, NewVisitedNodeList) :-
        Root in VisitedNodeList,
        !.
    removeAllFromTreeList([t(Root, TreeList) | RestTreeList], NodeList, VisitedNodeList, NewVisitedNodeList) =
            [t(Root, NewTreeList) | removeAllFromTreeList(RestTreeList, NodeList, NewTreeVisitedNodeList, NewVisitedNodeList)] :-
        NewTreeList = removeAllFromTreeList(TreeList, NodeList, [Root | VisitedNodeList], NewTreeVisitedNodeList).
    removeAllFromTreeList([], _, VisitedNodeList, VisitedNodeList) = [].

clauses
    addAttr(I, Name, Value) :-
        retractAll(attr(I, _, _)),
        assert(attr(I, Name, Value)).

    replaceAttr(I, Name, Value) :-
        retractAll(attr(I, _, _)),
        assert(attr(I, Name, Value)).

    deleteAttr(I) :-
        RuleList =
            [ N ||
                rule(N, _, _, L),
                I in L
            ],
        foreach X in RuleList do
            if retract(rule(X, A, B, List)) then
                NewList = list::remove(List, I),
                assert(rule(X, A, B, NewList))
            end if
        end foreach,
        retractAll(attr(I, _, _)).

    deleteRule(Name) :-
        rule(_, _, Name1, _),
        string::equalIgnoreCase(Name, Name1),
        !,
        retractAll(rule(_, _, Name1, _)).

    deleteRule(_Name).

    addRule(Name, AttrList, Filename) :-
        rule(Id, Topic, Name1, _),
        string::equalIgnoreCase(Name, Name1),
        !,
        retractAll(rule(Id, _, Name1, _)),
        assert(rule(Id, Topic, Name, AttrList)),
        retractAll(pict(Id, _)),
        if Filename <> "" then
            assert(pict(Id, Filename))
        end if.
    addRule(Name, AttrList, Filename) :-
        topic(Topic),
        !,
        Id = getNewRuleId(),
        assert(rule(Id, Topic, Name, AttrList)),
        retractAll(pict(Id, _)),
        if Filename <> "" then
            assert(pict(Id, Filename))
        end if.
    addRule(_, _, _).

    save() :-
        file::save(filename, dbexp).
        %%%
        /* save() :-
        filename <> "",
        !,
        Time = time::now(),
        Date = Time:formatDate("yyyyMMdd"),
        Str = Time:formatTime("HHmmss"),
        String = string::concat(Date, Str),
        Filename = filename::getName(filename),
        NewFilename = string::concat(Filename, String),
        NewFilenameWithExtension = filename::setExtension(NewFilename, "bkp"),
        file::copy(filename, NewFilenameWithExtension),
        file::save(filename, dbexp).
    save().*/
        %%%

    save(Filename) :-
        file::save(Filename, dbexp).

end implement dbBoardGames
