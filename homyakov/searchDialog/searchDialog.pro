% Copyright

implement searchDialog inherits dialog
    open core, vpiDomains

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize().

predicates
    onOkClick : button::clickResponder.
clauses
    onOkClick(_Source) = button::defaultAction :-
        Text = string::trim(edit_ctl:getText()),
        Length = string::length(Text),
        Length > 0,
        NameList =
            [ famDB::getLabelId(Id) ||
                famDB::person_nd(Id, _, _, _, _),
                _ = string::search(famDB::getLabel(Id), Text, string::caseInsensitive)
            ],
        NameList <> [],
        _ = vpiCommonDialogs::listSelect("Выберите человека из списка", NameList, 0, NameItem, _),
        string::frontToken(NameItem, NameToken, _),
        NameId = tryToTerm(unsigned, NameToken),
        !,
        famDB::selectedPersonId := NameId,
        _ = personForm::display(applicationWindow::get()).

    onOkClick(_Source) = button::defaultAction.

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    edit_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("Поиск"),
        setRect(vpiDomains::rct(50, 40, 396, 98)),
        setModal(true),
        setDecoration(titlebar([frameDecoration::closeButton])),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(36, 32),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        ok_ctl:setClickResponder(onOkClick),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(116, 32),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Введите имя или часть имени:"),
        StaticText_ctl:setRect(vpiDomains::rct(4, 4, 180, 26)),
        edit_ctl := editControl::new(This),
        edit_ctl:setRect(vpiDomains::rct(184, 2, 312, 24)).
% end of automatic code

end implement searchDialog
