% Copyright

implement treeForm inherits formWindow
    open core, vpiDomains, resourceIdentifiers

clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

clauses
    new(Parent) :-
        formWindow::new(Parent),
        generatedInitialize(),
        ImageList = imageList::new(16, 16),
        closed := ImageList:addResource(idb_closed),
        closedsel := ImageList:addResource(idb_closedsel),
        terminal := ImageList:addResource(idb_terminal),
        terminalsel := ImageList:addResource(idb_terminalsel),
        ancestor_ctl:imageList := ImageList,
        descedant_ctl:imageList := ImageList,
        Root = treeNode_std::new(getLabel(currentId)),
        Root:bitmapIdx := closed,
        Root:selectedBitmapIdx := closedsel,
        getTree(Root, currentId, 0), % для предков
        Root1 = treeNode_std::new(getLabel(currentId)),
        Root1:bitmapIdx := closed,
        Root1:selectedBitmapIdx := closedsel,
        getTree(Root1, currentId, 1), % для потомков
        TreeModel = treeModel_std::new(),
        TreeModel:addTree(Root),
        ancestor_ctl:model := TreeModel,
        TreeModel1 = treeModel_std::new(),
        TreeModel1:addTree(Root1),
        descedant_ctl:model := TreeModel1,
        ancestor_ctl:nodeRenderer := TreeModel:nodeRenderer,
        descedant_ctl:nodeRenderer := TreeModel1:nodeRenderer.

facts
    closed : integer := 0.
    closedsel : integer := 0.
    terminal : integer := 0.
    terminalsel : integer := 0.

class facts
    db : optional{dbBoardGames} := core::none().

class facts
    currentId : positive := 1.

predicates
    getLabel : (positive) -> string.
clauses
    getLabel(0) = X :-
        db = some(Db),
        Db:topic_nd(X),
        !.
    getLabel(N) = X :-
        db = some(Db),
        Db:attr_nd(N, _, X),
        !.
    getLabel(_) = "".

predicates
    getTree : (treeNode_std, positive, positive TypeOfTree).
clauses
    getTree(ParentNode, Id, Type) :-
        db == some(Db),
        Children = if 0 = Type then [ I || Db:parent_nd(I, Id) ] else [ J || Db:parent_nd(Id, J) ] end if,
        Idx = if [] = Children then terminal else closed end if,
        SelIdx = if [] = Children then terminalsel else closedsel end if,
        if [] = Children and Id <> 0 then
            ParentNode:textColor := color_darkMagenta
        end if,
        ParentNode:bitmapIdx := Idx,
        ParentNode:selectedBitmapIdx := SelIdx,
        list::forAll(Children,
            { (Child) :-
                Node = treeNode_std::new(ParentNode, getLabel(Child)),
                getTree(Node, Child, Type)
            }).

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    ancestor_ctl : treeControl{treeNode_std}.
    descedant_ctl : treeControl{treeNode_std}.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("Деревья"),
        setRect(vpiDomains::rct(50, 40, 385, 244)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(108, 184),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(172, 184),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Предыдущие разделы"),
        StaticText_ctl:setRect(vpiDomains::rct(4, 2, 96, 18)),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("Последующие разделы"),
        StaticText1_ctl:setRect(vpiDomains::rct(188, 2, 280, 18)),
        ancestor_ctl := treeControl{treeNode_std}::new(This),
        ancestor_ctl:setRect(vpiDomains::rct(4, 22, 148, 180)),
        descedant_ctl := treeControl{treeNode_std}::new(This),
        descedant_ctl:setRect(vpiDomains::rct(188, 22, 332, 180)).
% end of automatic code

end implement treeForm
