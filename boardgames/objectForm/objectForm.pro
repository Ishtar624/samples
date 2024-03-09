% Copyright

implement objectForm inherits formWindow
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
    filename : string := "".
    defaultImage : string := "default.jpg".

predicates
    onOkClick : button::clickResponder.
clauses
    onOkClick(_Source) = button::defaultAction :-
        some(Db) = db,
        Name = string::trim(string::trimInner(name_ctl:getText())),
        Name <> "",
        AttrList = attr_ctl:getAll(),
        AttrList <> [],
        !,
        IdList =
            [ I ||
                Item in AttrList,
                string::frontToken(Item, Str, _),
                I = tryToTerm(positive, Str)
            ],
        Db:addRule(Name, IdList, filename),
        Db:save().

    onOkClick(_Source) = button::defaultAction.

predicates
    onAddClick : button::clickResponder.
clauses
    onAddClick(_Source) = button::defaultAction :-
        SelList = listattr_ctl:getSelectedItems(),
        ObjList = attr_ctl:getAll(),
        NewList = list::difference(SelList, ObjList),
        NewList <> [],
        !,
        attr_ctl:addList(NewList),
        Indices = listattr_ctl:getSelectedIndices(),
        list::forAll(Indices, { (X) :- listattr_ctl:selectAt(X, false) }),
        dublefeature_ctl:setText("").
    onAddClick(_Source) = button::defaultAction.

predicates
    onDelClick : button::clickResponder.
clauses
    onDelClick(_Source) = button::defaultAction :-
        Index = attr_ctl:tryGetSelectedIndex(),
        !,
        attr_ctl:delete(Index).

    onDelClick(_Source) = button::defaultAction.

predicates
    onUpClick : button::clickResponder.
clauses
    onUpClick(_Source) = button::defaultAction :-
        Index = attr_ctl:tryGetSelectedIndex(),
        Index > 0,
        !,
        Item = attr_ctl:getAt(Index),
        attr_ctl:delete(Index),
        attr_ctl:addAt(Index - 1, Item),
        attr_ctl:selectAt(Index - 1, true).

    onUpClick(_Source) = button::defaultAction.

predicates
    onDownClick : button::clickResponder.
clauses
    onDownClick(_Source) = button::defaultAction :-
        L = attr_ctl:getAll(),
        N = list::length(L),
        Index = attr_ctl:tryGetSelectedIndex(),
        Index < N - 1,
        !,
        Item = attr_ctl:getAt(Index),
        attr_ctl:delete(Index),
        attr_ctl:addAt(Index + 1, Item),
        attr_ctl:selectAt(Index + 1, true).

    onDownClick(_Source) = button::defaultAction.

predicates
    onBrowseClick : button::clickResponder.
clauses
    onBrowseClick(_Source) = button::defaultAction :-
        mainExe::getFilename(StartPath, _),
        Filename =
            vpiCommonDialogs::getFilename("*.jpg", ["Файл jpg", "*.png", "Файл jpeg", "*.jpeg", "Файл jpg", "*.jpg", "Файл bmp", "*.bmp"],
                "Открыть изображение", [], StartPath, _),
        !,
        Name = filename::getNameWithExtension(Filename),
        filename := Name,
        if not(file::existExactFile(Name)) then
            file::copy(Filename, Name)
        end if,
        imageControl_ctl:setImageFile(Name).

    onBrowseClick(_Source) = button::defaultAction.

predicates
    onDelpictClick : button::clickResponder.
clauses
    onDelpictClick(_Source) = button::defaultAction :-
        filename <> "",
        !,
        filename := "",
        imageControl_ctl:setNoImage().

    onDelpictClick(_Source) = button::defaultAction.

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        db = some(Db),
        !,
        List = [ string::format("%2. %", N, Name) || Db:rule_nd(N, _, Name, _) ],
        object_ctl:addList(List),
        listattr_ctl:setTabStops([38]),
        AttrList = [ string::format("%2  %-36\t%", Id, AttrName, Value) || Db:attr_nd(Id, AttrName, Value) ],
        listattr_ctl:addList(AttrList),
        if Db:topic_nd(Topic) then
            setText(Topic)
        end if,
        attr_ctl:setTabStops([38]).

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
        Db:rule_nd(Id, _, Name, List),
        !,
        name_ctl:setText(Name),
        attr_ctl:clearAll(),
        attr_ctl:setTabStops([38]),
        AttrList =
            [ string::format("%2  %-36\t%", I, AttrName, Value) ||
                I in List,
                Db:attr_nd(I, AttrName, Value)
            ],
        attr_ctl:addList(AttrList),
        if Db:pict_nd(Id, File) then
            imageControl_ctl:setImageFile(File)
        else
            imageControl_ctl:setImageFile(defaultImage)
        end if.

    onObjectCloseUp(_Source).

predicates
    onMinusClick : button::clickResponder.
clauses
    onMinusClick(_Source) = button::defaultAction :-
        some(Db) = db,
        Name = string::trim(string::trimInner(name_ctl:getText())),
        Db:rule_nd(_, _, Name1, _),
        string::equalIgnoreCase(Name, Name1),
        Db:deleteRule(Name),
        Db:save(),
        name_ctl:setText(""),
        [Index] = object_ctl:getSelectedIndices(),
        !,
        object_ctl:delete(Index),
        attr_ctl:clearAll(),
        imageControl_ctl:setNoImage().

    onMinusClick(_Source) = button::defaultAction.

predicates
    onListAttrSelectionChanged : listControl::selectionChangedListener.
clauses
    onListAttrSelectionChanged(_Source) :-
        some(Db) = db,
        Index = listattr_ctl:tryGetSelectedIndex(),
        Item = listattr_ctl:getAt(Index),
        string::frontToken(Item, Token, _),
        Id = tryToTerm(positive, Token),
        Db:attr_nd(Id, _, FeatureValue),
        !,
        dublefeature_ctl:setText(FeatureValue).

    onListAttrSelectionChanged(_Source) :-
        dublefeature_ctl:setText("").

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    name_ctl : editControl.
    listattr_ctl : listBox.
    dublefeature_ctl : textControl.
    minus_ctl : button.
    add_ctl : button.
    del_ctl : button.
    up_ctl : button.
    down_ctl : button.
    object_ctl : listButton.
    attr_ctl : listBox.
    imageControl_ctl : imageControl.
    browse_ctl : button.
    delpict_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("objectForm"),
        setRect(vpiDomains::rct(50, 40, 458, 332)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(68, 272),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        ok_ctl:setClickResponder(onOkClick),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(132, 272),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Название:"),
        StaticText_ctl:setRect(vpiDomains::rct(4, 4, 68, 16)),
        name_ctl := editControl::new(This),
        name_ctl:setRect(vpiDomains::rct(72, 4, 164, 16)),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("Список всех свойств:"),
        StaticText1_ctl:setRect(vpiDomains::rct(4, 18, 108, 30)),
        listattr_ctl := listBox::new(This),
        listattr_ctl:setRect(vpiDomains::rct(4, 34, 208, 220)),
        listattr_ctl:addSelectionChangedListener(onListattrSelectionChanged),
        listattr_ctl:setMultiSelect(true),
        listattr_ctl:setStaticScrollbar(true),
        dublefeature_ctl := textControl::new(This),
        dublefeature_ctl:setRect(vpiDomains::rct(4, 222, 208, 238)),
        minus_ctl := button::new(This),
        minus_ctl:setText("Удалить объект"),
        minus_ctl:setRect(vpiDomains::rct(168, 2, 228, 28)),
        minus_ctl:setClickResponder(onMinusClick),
        add_ctl := button::new(This),
        add_ctl:setText("Добавить"),
        add_ctl:setRect(vpiDomains::rct(212, 34, 260, 54)),
        add_ctl:setClickResponder(onAddClick),
        del_ctl := button::new(This),
        del_ctl:setText("Удалить"),
        del_ctl:setRect(vpiDomains::rct(212, 58, 260, 78)),
        del_ctl:setClickResponder(onDelClick),
        up_ctl := button::new(This),
        up_ctl:setText("Вверх"),
        up_ctl:setRect(vpiDomains::rct(212, 82, 260, 102)),
        up_ctl:setClickResponder(onUpClick),
        down_ctl := button::new(This),
        down_ctl:setText("Вниз"),
        down_ctl:setRect(vpiDomains::rct(212, 106, 260, 126)),
        down_ctl:setClickResponder(onDownClick),
        object_ctl := listButton::new(This),
        object_ctl:setRect(vpiDomains::rct(264, 2, 388, 16)),
        object_ctl:addCloseUpListener(onObjectCloseUp),
        StaticText3_ctl = textControl::new(This),
        StaticText3_ctl:setText("Свойства объекта"),
        StaticText3_ctl:setRect(vpiDomains::rct(264, 18, 340, 32)),
        attr_ctl := listBox::new(This),
        attr_ctl:setRect(vpiDomains::rct(264, 34, 388, 126)),
        attr_ctl:setMultiSelect(true),
        attr_ctl:setStaticScrollbar(true),
        imageControl_ctl := imageControl::new(This),
        imageControl_ctl:setRect(vpiDomains::rct(264, 126, 404, 288)),
        StaticText2_ctl = textControl::new(This),
        StaticText2_ctl:setText("Открыть изображение:"),
        StaticText2_ctl:setRect(vpiDomains::rct(212, 154, 260, 176)),
        browse_ctl := button::new(This),
        browse_ctl:setText("<...>"),
        browse_ctl:setRect(vpiDomains::rct(212, 180, 260, 198)),
        browse_ctl:setClickResponder(onBrowseClick),
        delpict_ctl := button::new(This),
        delpict_ctl:setText("---"),
        delpict_ctl:setRect(vpiDomains::rct(212, 228, 260, 246)),
        delpict_ctl:setClickResponder(onDelpictClick),
        ОткрытьИзображение_ctl = textControl::new(This),
        ОткрытьИзображение_ctl:setText("Удалить изображение:"),
        ОткрытьИзображение_ctl:setRect(vpiDomains::rct(213, 202, 261, 224)).
% end of automatic code

end implement objectForm
