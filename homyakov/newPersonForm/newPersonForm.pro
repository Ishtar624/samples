% Copyright

implement newPersonForm inherits formWindow
    open core, vpiDomains, famDB, relations

clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

clauses
    new(Parent) :-
        formWindow::new(Parent),
        generatedInitialize().

facts
    pictureList : string* := [].
    n : positive := 0. % число изображений
    k : positive := 0. % номер текущего изображения
    biographyFilename : string := "".

predicates
    setInfo : (unsigned Id).
clauses
    setInfo(_Id) :-
        Empty = " <...>",
        MaleList = getGenderPersonList("м"),
        fathername_ctl:clearAll(),
        fathername_ctl:addList([Empty | MaleList]),
        FemaleList = getGenderPersonList("ж"),
        mothername_ctl:clearAll(),
        mothername_ctl:addList([Empty | FemaleList]).

predicates
    getInfo : ().
clauses
    getInfo() :-
        Id = convert(unsigned, id_ctl:getInteger()),
        Name = string::trimInner(string::trim(name_ctl:getText())),
        Name <> "",
        Name2 = string::trimInner(string::trim(name2_ctl:getText())),
        Name2 <> "",
        Name3 = string::trimInner(string::trim(name3_ctl:getText())),
        Name3 <> "",
        Family = string::trimInner(string::trim(family_ctl:getText())),
        Family <> "",
        !,
        Gender = if radioButton::checked = male_ctl:getRadioState() then "м" else "ж" end if,
        BirthYear = birthyear_ctl:getInteger(),
        DeathYear = dearthyear_ctl:getInteger(),
        if FatherIndex = fathername_ctl:tryGetSelectedIndex() and FatherItem = fathername_ctl:getAt(FatherIndex)
            and string::frontToken(FatherItem, FatherToken, _) and FatherId = tryToTerm(unsigned, FatherToken)
        then
            FathernameID = FatherId
        else
            FathernameID = 0
        end if,
        if MotherIndex = mothername_ctl:tryGetSelectedIndex() and MotherItem = mothername_ctl:getAt(MotherIndex)
            and string::frontToken(MotherItem, MotherToken, _) and MotherId = tryToTerm(unsigned, MotherToken)
        then
            MothernameID = MotherId
        else
            MothernameID = 0
        end if,
        SpouseItemList = spouses_ctl:getSelectedItems(),
        SpouseIdList =
            [ SpouseId ||
                SpouseItem in SpouseItemList,
                string::frontToken(SpouseItem, SpouseToken, _),
                SpouseId = tryToTerm(unsigned, SpouseToken)
            ],
        addPerson(Id, Name, Name2, Name3, Gender, Family, BirthYear, DeathYear, FathernameID, MothernameID, SpouseIdList, biographyFilename,
            pictureList),
        close().
    getInfo().

clauses
    save() :-
        getInfo().

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        0 = selectedPersonId,
        !,
        setText("Добавление"),
        Id = getNewId(),
        IntegerId = convert(integer, Id),
        id_ctl:setInteger(IntegerId),
        setInfo(Id),
        FemaleList = getGenderPersonList("ж"),
        spouses_ctl:clearAll(),
        spouses_ctl:addList(FemaleList),
        imageControl_ctl:setImageFile(defaultImage).

    onShow(_Source, _Data) :-
        Id = selectedPersonId,
        Id > 0,
        person_nd(Id, Name, Name2, Name3, Gender, Family),
        !,
        setText("Редактирование"),
        Id1 = convert(integer, Id),
        id_ctl:setInteger(Id1),
        name_ctl:setText(Name),
        name2_ctl:setText(Name2),
        name3_ctl:setText(Name3),
        if "ж" = Gender then
            female_ctl:setRadioState(radioButton::checked)
        end if,
        family_ctl:setText(Family),
        setInfo(Id),
        SpouseGender = if "м" = Gender then "ж" else "м" end if,
        SpouseList = getGenderPersonList(SpouseGender),
        spouses_ctl:clearAll(),
        spouses_ctl:addList(SpouseList),
        if father(FatherId, Id) and FatherItem = getLabelId(FatherId) and MaleList = fathername_ctl:getAll()
            and FatherIndex = list::tryGetIndex(FatherItem, MaleList)
        then
            fathername_ctl:selectAt(FatherIndex, true)
        end if,
        if mother(MotherId, Id) and MotherItem = getLabelId(MotherId) and FemaleList = mothername_ctl:getAll()
            and MotherIndex = list::tryGetIndex(MotherItem, FemaleList)
        then
            mothername_ctl:selectAt(MotherIndex, true)
        end if,
        SpouseItemList = spouses_ctl:getAll(),
        foreach
            (spouse_nd(Id, SpouseId) or spouse_nd(SpouseId, Id)) and SpouseItem = getLabelId(SpouseId)
            and SpouseIndex = list::tryGetIndex(SpouseItem, SpouseItemList)
        do
            spouses_ctl:selectAt(SpouseIndex, true)
        end foreach,
        if biography_nd(Id, Filename) then
            Text = file::readString(Filename, _)
        else
            Text = getLabel(Id)
        end if,
        biography_ctl:setText(Text),
        if birth_nd(Id, BirthYear) then
            birthyear_ctl:setInteger(BirthYear)
        end if,
        if death_nd(Id, DeathYear) then
            dearthyear_ctl:setInteger(DeathYear)
        end if,
        pictureList := [ ImageFile || picture_nd(Id, ImageFile) ],
        n := list::length(pictureList),
        k := 0,
        if [ImageFileName | _] = pictureList then
            imageControl_ctl:setImageFile(ImageFileName)
        else
            imageControl_ctl:setImageFile(defaultImage)
        end if.

    onShow(_Source, _Data).

predicates
    onLeftClick : button::clickResponder.
clauses
    onLeftClick(_Source) = button::defaultAction :-
        k := (k - 1 + n) mod n,
        ImageFile = list::nth(k, pictureList),
        imageControl_ctl:setImageFile(ImageFile).

predicates
    onRightClick : button::clickResponder.
clauses
    onRightClick(_Source) = button::defaultAction :-
        k := (k + 1 + n) mod n,
        ImageFile = list::nth(k, pictureList),
        imageControl_ctl:setImageFile(ImageFile).

predicates
    onFemaleStateChanged : radioButton::stateChangedListener.
clauses
    onFemaleStateChanged(_Source, _OldState, radioButton::checked) :-
        !,
        spouses_ctl:clearAll(),
        spouses_ctl:addList(getGenderPersonList("м")),
        Id = convert(unsigned, id_ctl:getInteger()),
        SpouseItemList = spouses_ctl:getAll(),
        foreach
            (spouse_nd(Id, SpouseId) or spouse_nd(SpouseId, Id)) and SpouseItem = getLabelId(SpouseId)
            and SpouseIndex = list::tryGetIndex(SpouseItem, SpouseItemList)
        do
            spouses_ctl:selectAt(SpouseIndex, true)
        end foreach.

    onFemaleStateChanged(_Source, _OldState, _NewState) :-
        spouses_ctl:clearAll(),
        spouses_ctl:addList(getGenderPersonList("ж")),
        Id = convert(unsigned, id_ctl:getInteger()),
        SpouseItemList = spouses_ctl:getAll(),
        foreach
            (spouse_nd(Id, SpouseId) or spouse_nd(SpouseId, Id)) and SpouseItem = getLabelId(SpouseId)
            and SpouseIndex = list::tryGetIndex(SpouseItem, SpouseItemList)
        do
            spouses_ctl:selectAt(SpouseIndex, true)
        end foreach.

predicates
    onOpenClick : button::clickResponder.
clauses
    onOpenClick(_Source) = button::defaultAction :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть файл", [], StartPath, _),
        Text = file::readString(Filename, _),
        not(string::isWhiteSpace(Text)),
        !,
        biography_ctl:setText(Text),
        biographyFilename := filename::getNameWithExtension(Filename),
        if not(file::existExactFile(biographyFilename)) then
            file::copy(Filename, biographyFilename)
        end if.

    onOpenClick(_Source) = button::defaultAction.

predicates
    onSaveClick : button::clickResponder.
clauses
    onSaveClick(_Source) = button::defaultAction :-
        Text = biography_ctl:getText(),
        not(string::isWhiteSpace(Text)),
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Сохранить файл", [dlgfn_save], StartPath, _),
        !,
        biographyFilename := filename::getNameWithExtension(Filename),
        file::writeString(biographyFilename, Text, true).

    onSaveClick(_Source) = button::defaultAction.

predicates
    onBrowseClick : button::clickResponder.
clauses
    onBrowseClick(_Source) = button::defaultAction :-
        mainExe::getFilename(StartPath, _),
        _ =
            vpiCommonDialogs::getFilename("*.jpg", ["Файл png", "*.png", "Файл jpg", "*.jpg", "Файл jpeg", "*.jpeg", "Файл bmp", "*.bmp"],
                "Открыть изображения", [dlgfn_multisel], StartPath, Filelist),
        !,
        FilenameList =
            [ Propertyname ||
                Fullfilename in Filelist,
                Propertyname = filename::getNameWithExtension(Fullfilename),
                if not(file::existExactFile(Propertyname)) then
                    file::copy(Fullfilename, Propertyname)
                end if
            ],
        pictureList := list::union(FilenameList, pictureList),
        n := list::length(pictureList),
        k := 0,
        if [Filename | _] = pictureList then
            imageControl_ctl:setImageFile(Filename)
        end if.
    onBrowseClick(_Source) = button::defaultAction.

predicates
    onDeleteClick : button::clickResponder.
clauses
    onDeleteClick(_Source) = button::defaultAction :-
        n > 0,
        !,
        Filename = list::nth(k, pictureList),
        pictureList := list::remove(pictureList, Filename),
        n := n - 1,
        if n > 0 then
            k := (k + n) mod n,
            NewFilename = list::nth(k, pictureList),
            imageControl_ctl:setImageFile(NewFilename)
        else
            imageControl_ctl:setImageFile(defaultImage)
        end if.

    onDeleteClick(_Source) = button::defaultAction.

predicates
    onDestroy : window::destroyListener.
clauses
    onDestroy(_Source) :-
        taskWindow::setNewPersonFormErroneous().

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    id_ctl : integerControl.
    name_ctl : editControl.
    name2_ctl : editControl.
    family_ctl : editControl.
    spouses_ctl : listBox.
    birthyear_ctl : integerControl.
    dearthyear_ctl : integerControl.
    gender_ctl : groupBox.
    male_ctl : radioButton.
    female_ctl : radioButton.
    imageControl_ctl : imageControl.
    left_ctl : button.
    right_ctl : button.
    biography_ctl : editControl.
    fathername_ctl : listButton.
    mothername_ctl : listButton.
    browse_ctl : button.
    delete_ctl : button.
    open_ctl : button.
    save_ctl : button.
    name3_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("newPersonForm"),
        setRect(vpiDomains::rct(50, 40, 402, 299)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        addDestroyListener(onDestroy),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(80, 240),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(144, 240),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(208, 240),
        help_ctl:setSize(56, 16),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::right, control::bottom]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Номер"),
        StaticText_ctl:setRect(vpiDomains::rct(4, 4, 48, 16)),
        Имя_ctl = textControl::new(This),
        Имя_ctl:setText("Имя"),
        Имя_ctl:setRect(vpiDomains::rct(0, 18, 44, 30)),
        Отчество_ctl = textControl::new(This),
        Отчество_ctl:setText("Отчество"),
        Отчество_ctl:setRect(vpiDomains::rct(4, 32, 48, 44)),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("Род"),
        StaticText1_ctl:setRect(vpiDomains::rct(4, 62, 48, 74)),
        StaticText2_ctl = textControl::new(This),
        StaticText2_ctl:setText("Имя отца"),
        StaticText2_ctl:setRect(vpiDomains::rct(4, 80, 48, 92)),
        StaticText3_ctl = textControl::new(This),
        StaticText3_ctl:setText("Имя матери"),
        StaticText3_ctl:setRect(vpiDomains::rct(4, 108, 48, 122)),
        StaticText4_ctl = textControl::new(This),
        StaticText4_ctl:setText("Супруги"),
        StaticText4_ctl:setRect(vpiDomains::rct(4, 138, 48, 152)),
        id_ctl := integerControl::new(This),
        id_ctl:setRect(vpiDomains::rct(52, 4, 84, 16)),
        id_ctl:setReadOnly(true),
        name_ctl := editControl::new(This),
        name_ctl:setPosition(52, 18),
        name_ctl:setReadOnly(false),
        name_ctl:setWidth(96),
        name2_ctl := editControl::new(This),
        name2_ctl:setPosition(52, 32),
        name2_ctl:setReadOnly(false),
        name2_ctl:setWidth(96),
        family_ctl := editControl::new(This),
        family_ctl:setPosition(52, 62),
        family_ctl:setReadOnly(false),
        family_ctl:setWidth(96),
        spouses_ctl := listBox::new(This),
        spouses_ctl:setRect(vpiDomains::rct(4, 154, 148, 230)),
        spouses_ctl:setMultiSelect(true),
        StaticText5_ctl = textControl::new(This),
        StaticText5_ctl:setText("Год рождения"),
        StaticText5_ctl:setRect(vpiDomains::rct(152, 18, 204, 30)),
        ГодРождения_ctl = textControl::new(This),
        ГодРождения_ctl:setText("Год смерти"),
        ГодРождения_ctl:setRect(vpiDomains::rct(152, 32, 204, 44)),
        birthyear_ctl := integerControl::new(This),
        birthyear_ctl:setRect(vpiDomains::rct(208, 18, 236, 30)),
        birthyear_ctl:setReadOnly(false),
        dearthyear_ctl := integerControl::new(This),
        dearthyear_ctl:setRect(vpiDomains::rct(208, 32, 236, 44)),
        dearthyear_ctl:setReadOnly(false),
        gender_ctl := groupBox::new(This),
        gender_ctl:setText("Пол"),
        gender_ctl:setRect(vpiDomains::rct(152, 46, 252, 72)),
        gender_ctl:setEnabled(true),
        male_ctl := radioButton::new(gender_ctl),
        male_ctl:setText("мужской"),
        male_ctl:setRect(vpiDomains::rct(3, 0, 47, 12)),
        male_ctl:setRadioState(radioButton::checked),
        female_ctl := radioButton::new(gender_ctl),
        female_ctl:setText("женский"),
        female_ctl:setRect(vpiDomains::rct(51, 0, 95, 12)),
        female_ctl:addStateChangedListener(onFemaleStateChanged),
        imageControl_ctl := imageControl::new(This),
        imageControl_ctl:setRect(vpiDomains::rct(152, 82, 236, 200)),
        left_ctl := button::new(This),
        left_ctl:setText("<"),
        left_ctl:setRect(vpiDomains::rct(164, 202, 188, 214)),
        left_ctl:setClickResponder(onLeftClick),
        right_ctl := button::new(This),
        right_ctl:setText(">"),
        right_ctl:setRect(vpiDomains::rct(200, 202, 224, 214)),
        right_ctl:setClickResponder(onRightClick),
        biography_ctl := editControl::new(This),
        biography_ctl:setRect(vpiDomains::rct(240, 82, 348, 200)),
        biography_ctl:setAutoHScroll(false),
        biography_ctl:setAutoVScroll(true),
        biography_ctl:setHorizontalScroll(false),
        biography_ctl:setHScroll(false),
        biography_ctl:setMultiLine(true),
        biography_ctl:setReadOnly(false),
        biography_ctl:setVerticalScroll(true),
        biography_ctl:setVScroll(true),
        biography_ctl:setWantReturn(true),
        fathername_ctl := listButton::new(This),
        fathername_ctl:setRect(vpiDomains::rct(4, 94, 148, 106)),
        mothername_ctl := listButton::new(This),
        mothername_ctl:setRect(vpiDomains::rct(4, 123, 148, 135)),
        browse_ctl := button::new(This),
        browse_ctl:setText("..."),
        browse_ctl:setRect(vpiDomains::rct(200, 218, 224, 230)),
        browse_ctl:setClickResponder(onBrowseClick),
        delete_ctl := button::new(This),
        delete_ctl:setText("-"),
        delete_ctl:setRect(vpiDomains::rct(164, 218, 188, 230)),
        delete_ctl:setClickResponder(onDeleteClick),
        open_ctl := button::new(This),
        open_ctl:setText("Открыть"),
        open_ctl:setRect(vpiDomains::rct(292, 200, 340, 214)),
        open_ctl:setClickResponder(onOpenClick),
        save_ctl := button::new(This),
        save_ctl:setText("Сохранить"),
        save_ctl:setRect(vpiDomains::rct(292, 216, 340, 230)),
        save_ctl:setClickResponder(onSaveClick),
        Фамилия_ctl = textControl::new(This),
        Фамилия_ctl:setText("Фамилия"),
        Фамилия_ctl:setRect(vpiDomains::rct(4, 46, 48, 58)),
        name3_ctl := editControl::new(This),
        name3_ctl:setPosition(52, 46),
        name3_ctl:setReadOnly(false),
        name3_ctl:setWidth(96).
% end of automatic code

end implement newPersonForm
