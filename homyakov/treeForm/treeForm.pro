% Copyright

implement treeForm inherits formWindow
    open core, vpiDomains, resourceIdentifiers, treeControl{treeNode_std}

clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

clauses
    new(Parent) :-
        formWindow::new(Parent),
        generatedInitialize(),
        ImageList = imageList::new(20, 21),
        closed := ImageList:addResource(idb_closed),
        closedSelected := ImageList:addResource(idb_closedSelected),
        terminal := ImageList:addResource(idb_terminal),
        terminalSelected := ImageList:addResource(idb_terminalSelected),
        treeControl_ctl:imageList := ImageList,
        Id = famDB::selectedPersonId,
        Root = treeNode_std::new(famDB::getLabel(Id)),
        Root:bitmapIdx := closed,
        Root:selectedBitmapIdx := closedSelected,
        getTree(Root, Id, type),
        TreeModel = treeModel_std::new(),
        TreeModel:addTree(Root),
        treeControl_ctl:model := TreeModel,
        treeControl_ctl:nodeRenderer := TreeModel:nodeRenderer.

class facts
    type : positive := 0.

predicates
    getTree : (treeNode_std, unsigned Id, positive Type).
clauses
    getTree(Root, Id, Type) :-
        ChildList = if 0 = Type then [ I || famDB::parent_nd(I, Id) ] else [ J || famDB::parent_nd(Id, J) ] end if,
        Root:bitmapIdx := if [] = ChildList then terminal else closed end if,
        Root:selectedBitmapIdx := if [] = ChildList then terminalSelected else closedSelected end if,
        if [] = ChildList then
            Root:textColor := color_darkMagenta
        end if,
        list::forAll(ChildList,
            { (ChildId) :-
                Node = treeNode_std::new(Root, famDB::getLabel(ChildId)),
                getTree(Node, ChildId, Type)
            }).

facts
    closed : integer := 0.
    closedSelected : integer := 0.
    terminal : integer := 0.
    terminalSelected : integer := 0.

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    treeControl_ctl : treeControl{treeNode_std}.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("treeForm"),
        setRect(vpiDomains::rct(50, 40, 338, 233)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(48, 170),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(112, 170),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(176, 170),
        help_ctl:setSize(56, 16),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::right, control::bottom]),
        treeControl_ctl := treeControl{treeNode_std}::new(This),
        treeControl_ctl:setRect(vpiDomains::rct(4, 6, 284, 162)),
        treeControl_ctl:setAnchors([control::left, control::top, control::right, control::bottom]).
% end of automatic code

end implement treeForm
