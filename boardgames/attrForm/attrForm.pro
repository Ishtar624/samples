% Copyright

implement attrForm inherits formWindow
    open core, vpiDomains

clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

clauses
    new(Parent) :-
        formWindow::new(Parent),
        generatedInitialize().

facts
    db : optional{dbBoardGames} := core::none().

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        db = some(Db),
        !,
        if Db:topic_nd(Topic) then
            topic_ctl:setText(Topic)
        end if,
        attr_ctl:setTabStops([38]),
        List = [ string::format("%2  %-40\t %", Id, Name, Value) || Db:attr_nd(Id, Name, Value) ],
        attr_ctl:addList(List),
        setText("Редактирование признаков").

    onShow(_Source, _Data).

predicates
    onOkClick : button::clickResponder.
clauses
    onOkClick(_Source) = button::defaultAction :-
        db = some(Db),
        !,
        Db:save().

    onOkClick(_Source) = button::defaultAction.

predicates
    onAttrSelectionChanged : listControl::selectionChangedListener.
clauses
    onAttrSelectionChanged(_Source) :-
        db = some(Db),
        Index = attr_ctl:tryGetSelectedIndex(),
        Item = attr_ctl:getAt(Index),
        string::frontToken(Item, Str, _),
        Id = tryToTerm(positive, Str),
        Db:attr_nd(Id, _, FeatureValue),
        !,
        object_ctl:setTabStops([10]),
        List =
            [ string::format("%2\t%", N, Name) ||
                Db:rule_nd(N, _, Name, L),
                Id in L
            ],
        object_ctl:clearAll(),
        object_ctl:addList(List),
        dublefeature_ctl:setText(FeatureValue).

    onAttrSelectionChanged(_Source).

predicates
    onAddClick : button::clickResponder.
clauses
    onAddClick(_Source) = button::defaultAction :-
        db = some(Db),
        Name = string::trim(string::trimInner(name_ctl:getText())),
        Name <> "",
        Value = string::trim(string::trimInner(value_ctl:getText())),
        Value <> "",
        !,
        Id = Db:getNewAttrId(),
        Db:addAttr(Id, Name, Value),
        Item = string::format("%2  %-36\t%", Id, Name, Value),
        attr_ctl:addAt(-1, Item),
        name_ctl:setText(""),
        value_ctl:setText("").

    onAddClick(_Source) = button::defaultAction.

predicates
    onDelClick : button::clickResponder.
clauses
    onDelClick(_Source) = button::defaultAction :-
        db = some(Db),
        Index = attr_ctl:tryGetSelectedIndex(),
        Item = attr_ctl:getAt(Index),
        string::frontToken(Item, Str, _),
        Id = tryToTerm(positive, Str),
        0 = vpiCommonDialogs::ask("Свойство будет удалено из описания всех объектов. Вы подтверждаете удаление?", ["Да", "Нет"]),
        !,
        Db:deleteAttr(Id),
        attr_ctl:delete(Index),
        object_ctl:clearAll().

    onDelClick(_Source) = button::defaultAction.

predicates
    onReplaceClick : button::clickResponder.
clauses
    onReplaceClick(_Source) = button::defaultAction :-
        db = some(Db),
        Index = attr_ctl:tryGetSelectedIndex(),
        Item = attr_ctl:getAt(Index),
        string::frontToken(Item, Str, _),
        Id = tryToTerm(positive, Str),
        Name = string::trim(string::trimInner(name_ctl:getText())),
        Name <> "",
        Value = string::trim(string::trimInner(value_ctl:getText())),
        Value <> "",
        !,
        Db:replaceAttr(Id, Name, Value),
        attr_ctl:delete(Index),
        NewItem = string::format("%2  %-36\t%", Id, Name, Value),
        attr_ctl:addAt(-1, NewItem),
        name_ctl:setText(""),
        value_ctl:setText("").

    onReplaceClick(_Source) = button::defaultAction.

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    topic_ctl : editControl.
    attr_ctl : listBox.
    dublefeature_ctl : textControl.
    name_ctl : editControl.
    value_ctl : editControl.
    object_ctl : listBox.
    del_ctl : button.
    replace_ctl : button.
    add_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("attrForm"),
        setRect(vpiDomains::rct(50, 40, 393, 278)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(96, 218),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        ok_ctl:setClickResponder(onOkClick),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(164, 218),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Тема"),
        StaticText_ctl:setRect(vpiDomains::rct(4, 2, 60, 16)),
        topic_ctl := editControl::new(This),
        topic_ctl:setPosition(64, 2),
        topic_ctl:setSize(56, 14),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("Названия и значения признаков:"),
        StaticText1_ctl:setRect(vpiDomains::rct(4, 18, 128, 30)),
        attr_ctl := listBox::new(This),
        attr_ctl:setRect(vpiDomains::rct(4, 34, 228, 138)),
        attr_ctl:addSelectionChangedListener(onAttrSelectionChanged),
        dublefeature_ctl := textControl::new(This),
        dublefeature_ctl:setRect(vpiDomains::rct(4, 140, 228, 158)),
        StaticText3_ctl = textControl::new(This),
        StaticText3_ctl:setText("Введите название признака:"),
        StaticText3_ctl:setRect(vpiDomains::rct(4, 162, 76, 180)),
        StaticText4_ctl = textControl::new(This),
        StaticText4_ctl:setText("Введите значение признака:"),
        StaticText4_ctl:setRect(vpiDomains::rct(4, 184, 76, 202)),
        name_ctl := editControl::new(This),
        name_ctl:setRect(vpiDomains::rct(80, 162, 192, 180)),
        value_ctl := editControl::new(This),
        value_ctl:setRect(vpiDomains::rct(80, 184, 192, 202)),
        StaticText5_ctl = textControl::new(This),
        StaticText5_ctl:setText("Объекты:"),
        StaticText5_ctl:setRect(vpiDomains::rct(236, 16, 296, 30)),
        object_ctl := listBox::new(This),
        object_ctl:setRect(vpiDomains::rct(236, 34, 340, 136)),
        del_ctl := button::new(This),
        del_ctl:setText("Удалить"),
        del_ctl:setPosition(260, 140),
        del_ctl:setClickResponder(onDelClick),
        replace_ctl := button::new(This),
        replace_ctl:setText("Заменить"),
        replace_ctl:setRect(vpiDomains::rct(260, 160, 316, 176)),
        replace_ctl:setClickResponder(onReplaceClick),
        add_ctl := button::new(This),
        add_ctl:setText("Добавить"),
        add_ctl:setRect(vpiDomains::rct(260, 180, 316, 196)),
        add_ctl:setClickResponder(onAddClick).
% end of automatic code

end implement attrForm
