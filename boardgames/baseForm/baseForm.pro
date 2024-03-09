% Copyright

implement baseForm inherits formWindow
    open core, vpiDomains

clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

clauses
    new(Parent) :-
        formWindow::new(Parent),
        generatedInitialize().

class facts
    filename : string := "".
    defaultImage : string := "default.jpg".

facts
    db : optional{dbBoardGames} := core::none().

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        db = some(Db),
        !,
        List = [ string::format("%2  %-40\t%", Id, Type, Value) || Db:rule_nd(Id, Type, Value) ],
        object_ctl:addList(List),
        if Db:pict_nd(_Id, Filename) then
            imageControl_ctl:setImageFile(Filename)
        else
            imageControl_ctl:setImageFile(defaultImage)
        end if,
        setText("Ассортимент").

    onShow(_Source, _Data).

predicates
    onObjectCloseUp : listControl::closeUpListener.
clauses
    onObjectCloseUp(_Source) :-
        db = some(Db),
        Index = object_ctl:tryGetSelectedIndex(),
        Item = object_ctl:getAt(Index),
        string::frontToken(Item, Str, _),
        Id = tryToTerm(positive, Str),
        Db:rule_nd(Id, _, _Name, List),
        !,
        listbox_ctl:clearAll(),
        listbox_ctl:setTabStops([38]),
        AttrList =
            [ string::format("%-20\t%", AttrName, Value) ||
                I in List,
                Db:attr_nd(I, AttrName, Value)
            ],
        listbox_ctl:addList(AttrList),
        imageControl_ctl:setVisible(true),
        if Db:pict_nd(Id, File) then
            imageControl_ctl:setImageFile(File)
        else
            imageControl_ctl:setImageFile(defaultImage)
        end if.

    onObjectCloseUp(_Source).

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    imageControl_ctl : imageControl.
    object_ctl : listButton.
    listbox_ctl : listBox.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("baseForm"),
        setRect(vpiDomains::rct(50, 40, 379, 258)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(96, 198),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(164, 198),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        imageControl_ctl := imageControl::new(This),
        imageControl_ctl:setRect(vpiDomains::rct(8, 34, 176, 190)),
        object_ctl := listButton::new(This),
        object_ctl:setRect(vpiDomains::rct(8, 10, 200, 26)),
        object_ctl:setEnabled(true),
        object_ctl:setVisible(true),
        object_ctl:setTabStop(true),
        object_ctl:setSort(true),
        object_ctl:setVerticalScroll(true),
        object_ctl:setVScroll(true),
        object_ctl:setStaticScrollbar(false),
        object_ctl:setAllowPartialRows(false),
        object_ctl:addCloseUpListener(onObjectCloseUp),
        object_ctl:setAlignBaseline(true),
        object_ctl:setHorizontalScroll(false),
        listbox_ctl := listBox::new(This),
        listbox_ctl:setRect(vpiDomains::rct(180, 34, 316, 190)),
        listbox_ctl:setTabStop(true),
        listbox_ctl:setHorizontalScroll(false),
        listbox_ctl:setHScroll(false),
        listbox_ctl:setMultiColumn(true),
        listbox_ctl:setVerticalScroll(true),
        listbox_ctl:setUseTabStops(true),
        listbox_ctl:setVScroll(true).
% end of automatic code

end implement baseForm
