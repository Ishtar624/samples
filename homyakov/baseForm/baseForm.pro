% Copyright

implement baseForm inherits formWindow
    open core, vpiDomains, famDB

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

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        listbox_ctl:setTabStops([4, 16]),
        List = [ string::format("%3 \t%-25\t%-20\t%-15", Id, Name, Name2, Name3) || person_nd(Id, Name, Name2, Name3, _, _) ],
        listbox_ctl:addList(List),
        imageControl_ctl:setImageFile(defaultImage).

predicates
    onListboxSelectionChanged : listControl::selectionChangedListener.
clauses
    onListboxSelectionChanged(_Source) :-
        Index = listbox_ctl:tryGetSelectedIndex(),
        Item = listbox_ctl:getAt(Index),
        string::frontToken(Item, Token, _),
        Id = tryToTerm(unsigned, Token),
        person_nd(Id, Name, Name2, Name3, _, _),
        !,
        if picture_nd(Id, Filename) then
            imageControl_ctl:setImageFile(Filename)
        else
            imageControl_ctl:setImageFile(defaultImage)
        end if,
        if biography_nd(Id, BioFilename) then
            Text = file::readString(BioFilename, _)
        else
            Text = string::format("% % %", Name, Name2, Name3)
        end if,
        edit_ctl:setText(Text).

    onListboxSelectionChanged(_Source).

predicates
    onEditModified : editControl::modifiedListener.
clauses
    onEditModified(_Source).

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    imageControl_ctl : imageControl.
    listbox_ctl : listBox.
    edit_ctl : editControl.
    status_ctl : textControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setRect(vpiDomains::rct(50, 40, 423, 226)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(88, 166),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(152, 166),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(216, 166),
        help_ctl:setSize(56, 16),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::right, control::bottom]),
        imageControl_ctl := imageControl::new(This),
        imageControl_ctl:setRect(vpiDomains::rct(4, 6, 108, 152)),
        listbox_ctl := listBox::new(This),
        listbox_ctl:setRect(vpiDomains::rct(112, 6, 368, 82)),
        listbox_ctl:setUseTabStops(true),
        listbox_ctl:setTabStop(true),
        listbox_ctl:addSelectionChangedListener(onListboxSelectionChanged),
        edit_ctl := editControl::new(This),
        edit_ctl:setRect(vpiDomains::rct(112, 84, 368, 152)),
        edit_ctl:setTabStop(true),
        edit_ctl:setAutoHScroll(false),
        edit_ctl:setAutoVScroll(true),
        edit_ctl:setHorizontalScroll(false),
        edit_ctl:setHScroll(false),
        edit_ctl:setVerticalScroll(true),
        edit_ctl:setVScroll(true),
        edit_ctl:setMultiLine(true),
        edit_ctl:setWantReturn(true),
        edit_ctl:addModifiedListener(onEditModified),
        status_ctl := textControl::new(This),
        status_ctl:setRect(vpiDomains::rct(8, 154, 96, 166)).
% end of automatic code

end implement baseForm
