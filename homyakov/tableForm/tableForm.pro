% Copyright

implement tableForm inherits formWindow
    open core, vpiDomains, famDB, listViewControl, resourceIdentifiers

clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

clauses
    new(Parent) :-
        formWindow::new(Parent),
        generatedInitialize(),
        ImageList = imageList::new(20, 21),
        maleIdx := ImageList:addResource(idb_male),
        femaleIdx := ImageList:addResource(idb_female),
        listViewControl_ctl:imageList := ImageList.

facts
    maleIdx : integer := 0.
    femaleIdx : integer := 1.

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        ColumnList =
            [
                column("Имя", 120, alignLeft),
                column("Отчество", 120, alignLeft),
                column("Фамилия", 150, alignLeft),
                column("Пол", 50, alignCenter),
                column("Год рождения", 90, alignRight),
                column("Год смерти", 80, alignRight),
                column("Род", 160, alignLeft),
                column("Отец", 120, alignLeft),
                column("Мать", 90, alignLeft),
                column("Супруги", 110, alignLeft)
            ],
        ItemList =
            [ item(uncheckedConvert(itemId, Id), Name, BitmapIdx, [],
                    [Name2, Name3, Gender, BirthYear, DeathYear, Status, FatherName, MotherName, SpousesNames])
            ||
                person_nd(Id, Name, Name2, Name3, Gender, Status),
                BitmapIdx = if "м" = Gender then maleIdx else femaleIdx end if,
                BirthYear = if birth_nd(Id, PersonBirthYear) then toString(PersonBirthYear) else "-" end if,
                DeathYear = if death_nd(Id, PersonDeathYear) then toString(PersonDeathYear) else "-" end if,
                FatherName = if parent_nd(FatherId, Id) and person_nd(FatherId, PersonFatherName, _, _, "м", _) then PersonFatherName else "-" end if,
                MotherName = if parent_nd(MotherId, Id) and person_nd(MotherId, PersonMotherName, _, _, "ж", _) then PersonMotherName else "-" end if,
                SpouseNameList =
                    [ SpouseName ||
                        (spouse_nd(Id, SpouseId) or spouse_nd(SpouseId, Id)),
                        person_nd(SpouseId, SpouseName, _, _, _, _)
                    ],
                SpousesNames = string::concatWithDelimiter(SpouseNameList, ", ")
            ],
        listViewControl_ctl:insertColumnList(1, ColumnList),
        listViewControl_ctl:insertItemList(ItemList),
        listViewControl_ctl:setLvType(lvs_report).

predicates
    onCalcClick : button::clickResponder.
clauses
    onCalcClick(_Source) = button::defaultAction :-
        Text = query_ctl:getText(),
        AnswerList = parser::query(Text),
        answer_ctl:clearAll(),
        answer_ctl:addList(AnswerList).

predicates
    onRelClick : button::clickResponder.
clauses
    onRelClick(_Source) = button::defaultAction :-
        ItemIdList = listViewControl_ctl:getSel(),
        [ItemId | _] = ItemIdList,
        Id = uncheckedConvert(unsigned, ItemId),
        person_nd(Id, Name, Name2, Name3, _, _),
        RelativeList =
            [
                "родитель",
                "ребенок",
                "отец",
                "мать",
                "дети",
                "сын",
                "дочь",
                "муж",
                "жена",
                "брат",
                "сестра",
                "предок",
                "потомок",
                "племянник",
                "тётя",
                "дядя",
                "бабушка",
                "дедушка",
                "внучка",
                "внук",
                "кузина",
                "кузен"
            ],
        _ = vpiCommonDialogs::listSelect("Выберите отношение", RelativeList, 0, Relation, _),
        !,
        QueryText = string::format("% для '% % %'", Relation, Name, Name2, Name3),
        query_ctl:setText(QueryText),
        AnswerList = parser::query(QueryText),
        answer_ctl:clearAll(),
        answer_ctl:addList(AnswerList).

    onRelClick(_Source) = button::defaultAction.

predicates
    onQueryModified : editControl::modifiedListener.
clauses
    onQueryModified(_Source) :-
        answer_ctl:clearAll().

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    listViewControl_ctl : listViewControl.
    query_ctl : editControl.
    calc_ctl : button.
    answer_ctl : listBox.
    rel_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setRect(vpiDomains::rct(50, 40, 701, 290)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(224, 226),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(288, 226),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(352, 226),
        help_ctl:setSize(56, 16),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::bottom]),
        listViewControl_ctl := listViewControl::new(This),
        listViewControl_ctl:setRect(vpiDomains::rct(4, 4, 648, 120)),
        listViewControl_ctl:setAnchors([control::left, control::top, control::right]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Введите запрос"),
        StaticText_ctl:setRect(vpiDomains::rct(4, 124, 64, 136)),
        query_ctl := editControl::new(This),
        query_ctl:setRect(vpiDomains::rct(4, 138, 596, 158)),
        query_ctl:setTabStop(true),
        query_ctl:setAnchors([control::left, control::top, control::right]),
        query_ctl:setAutoHScroll(false),
        query_ctl:setAutoVScroll(true),
        query_ctl:setHorizontalScroll(false),
        query_ctl:setHScroll(false),
        query_ctl:setMultiLine(true),
        query_ctl:setVerticalScroll(true),
        query_ctl:setVScroll(true),
        query_ctl:setWantReturn(true),
        query_ctl:addModifiedListener(onQueryModified),
        calc_ctl := button::new(This),
        calc_ctl:setText("Вычислить"),
        calc_ctl:setRect(vpiDomains::rct(600, 138, 648, 154)),
        calc_ctl:setAnchors([control::top, control::right]),
        calc_ctl:setClickResponder(onCalcClick),
        answer_ctl := listBox::new(This),
        answer_ctl:setRect(vpiDomains::rct(4, 160, 596, 222)),
        answer_ctl:setAnchors([control::left, control::top, control::right]),
        answer_ctl:setTabStop(true),
        answer_ctl:setUseTabStops(true),
        rel_ctl := button::new(This),
        rel_ctl:setText("Отношение"),
        rel_ctl:setRect(vpiDomains::rct(600, 168, 648, 212)),
        rel_ctl:setAnchors([control::top, control::right]),
        rel_ctl:setClickResponder(onRelClick).
% end of automatic code

end implement tableForm
