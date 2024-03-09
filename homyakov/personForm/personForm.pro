% Copyright

implement personForm inherits formWindow
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

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        Id = selectedPersonId,
        Id > 0,
        person_nd(Id, Name, Name2, Name3, Gender, Family),
        !,
        setText(getLabel(Id)),
        Id1 = convert(integer, Id),
        id_ctl:setInteger(Id1),
        name_ctl:setText(Name),
        name2_ctl:setText(Name2),
        name3_ctl:setText(Name3),
        if "ж" = Gender then
            female_ctl:setRadioState(radioButton::checked)
        end if,
        family_ctl:setText(Family),
        if father(FatherId, Id) then
            fathername_ctl:setText(getLabel(FatherId))
        end if,
        if mother(MotherId, Id) then
            mothername_ctl:setText(getLabel(MotherId))
        end if,
        SpouseList =
            [ getLabel(SpouseId) ||
                spouse_nd(Id, SpouseId)
                or
                spouse_nd(SpouseId, Id)
            ],
        spouses_ctl:clearAll(),
        spouses_ctl:addList(SpouseList),
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
        end if,
        if n < 2 then
            left_ctl:setEnabled(false),
            right_ctl:setEnabled(false)
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

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    id_ctl : integerControl.
    name_ctl : editControl.
    name2_ctl : editControl.
    family_ctl : editControl.
    fathername_ctl : editControl.
    mothername_ctl : editControl.
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
    name3_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("personForm"),
        setRect(vpiDomains::rct(50, 40, 402, 281)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(84, 218),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(148, 218),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(212, 218),
        help_ctl:setSize(56, 16),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::right, control::bottom]),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Номер"),
        StaticText_ctl:setRect(vpiDomains::rct(4, 4, 48, 16)),
        Номер_ctl = textControl::new(This),
        Номер_ctl:setText("Имя"),
        Номер_ctl:setRect(vpiDomains::rct(4, 18, 48, 30)),
        ПервоеИмя_ctl = textControl::new(This),
        ПервоеИмя_ctl:setText("Отчество"),
        ПервоеИмя_ctl:setRect(vpiDomains::rct(4, 32, 48, 44)),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("Род"),
        StaticText1_ctl:setRect(vpiDomains::rct(4, 66, 48, 78)),
        StaticText2_ctl = textControl::new(This),
        StaticText2_ctl:setText("Имя отца"),
        StaticText2_ctl:setRect(vpiDomains::rct(4, 82, 48, 94)),
        StaticText3_ctl = textControl::new(This),
        StaticText3_ctl:setText("Имя матери"),
        StaticText3_ctl:setRect(vpiDomains::rct(4, 110, 48, 124)),
        StaticText4_ctl = textControl::new(This),
        StaticText4_ctl:setText("Супруги"),
        StaticText4_ctl:setRect(vpiDomains::rct(4, 140, 48, 154)),
        id_ctl := integerControl::new(This),
        id_ctl:setRect(vpiDomains::rct(52, 4, 84, 16)),
        id_ctl:setReadOnly(true),
        name_ctl := editControl::new(This),
        name_ctl:setPosition(52, 18),
        name_ctl:setReadOnly(true),
        name_ctl:setWidth(96),
        name2_ctl := editControl::new(This),
        name2_ctl:setPosition(52, 32),
        name2_ctl:setReadOnly(true),
        name2_ctl:setWidth(96),
        family_ctl := editControl::new(This),
        family_ctl:setPosition(52, 66),
        family_ctl:setReadOnly(true),
        family_ctl:setWidth(96),
        fathername_ctl := editControl::new(This),
        fathername_ctl:setRect(vpiDomains::rct(4, 96, 128, 108)),
        fathername_ctl:setReadOnly(true),
        mothername_ctl := editControl::new(This),
        mothername_ctl:setRect(vpiDomains::rct(4, 126, 128, 138)),
        mothername_ctl:setReadOnly(true),
        spouses_ctl := listBox::new(This),
        spouses_ctl:setRect(vpiDomains::rct(4, 156, 128, 210)),
        spouses_ctl:setMultiSelect(true),
        StaticText5_ctl = textControl::new(This),
        StaticText5_ctl:setText("Год рождения"),
        StaticText5_ctl:setRect(vpiDomains::rct(152, 4, 204, 16)),
        ГодРождения_ctl = textControl::new(This),
        ГодРождения_ctl:setText("Год смерти"),
        ГодРождения_ctl:setRect(vpiDomains::rct(152, 18, 204, 30)),
        birthyear_ctl := integerControl::new(This),
        birthyear_ctl:setRect(vpiDomains::rct(208, 4, 236, 16)),
        birthyear_ctl:setReadOnly(true),
        dearthyear_ctl := integerControl::new(This),
        dearthyear_ctl:setRect(vpiDomains::rct(208, 18, 236, 30)),
        dearthyear_ctl:setReadOnly(true),
        gender_ctl := groupBox::new(This),
        gender_ctl:setText("Пол"),
        gender_ctl:setRect(vpiDomains::rct(152, 32, 252, 58)),
        gender_ctl:setEnabled(false),
        male_ctl := radioButton::new(gender_ctl),
        male_ctl:setText("мужской"),
        male_ctl:setRect(vpiDomains::rct(3, 0, 47, 12)),
        male_ctl:setRadioState(radioButton::checked),
        female_ctl := radioButton::new(gender_ctl),
        female_ctl:setText("женский"),
        female_ctl:setRect(vpiDomains::rct(51, 0, 95, 12)),
        imageControl_ctl := imageControl::new(This),
        imageControl_ctl:setRect(vpiDomains::rct(152, 64, 236, 182)),
        left_ctl := button::new(This),
        left_ctl:setText("<"),
        left_ctl:setRect(vpiDomains::rct(164, 190, 188, 202)),
        left_ctl:setClickResponder(onLeftClick),
        right_ctl := button::new(This),
        right_ctl:setText(">"),
        right_ctl:setRect(vpiDomains::rct(200, 190, 224, 202)),
        right_ctl:setClickResponder(onRightClick),
        biography_ctl := editControl::new(This),
        biography_ctl:setRect(vpiDomains::rct(240, 62, 348, 206)),
        biography_ctl:setAutoHScroll(false),
        biography_ctl:setAutoVScroll(true),
        biography_ctl:setHorizontalScroll(false),
        biography_ctl:setHScroll(false),
        biography_ctl:setMultiLine(true),
        biography_ctl:setReadOnly(true),
        biography_ctl:setVerticalScroll(true),
        biography_ctl:setVScroll(true),
        biography_ctl:setWantReturn(true),
        ВтороеИмя_ctl = textControl::new(This),
        ВтороеИмя_ctl:setText("Фамилия"),
        ВтороеИмя_ctl:setRect(vpiDomains::rct(4, 48, 48, 60)),
        name3_ctl := editControl::new(This),
        name3_ctl:setPosition(52, 48),
        name3_ctl:setReadOnly(true),
        name3_ctl:setWidth(96).
% end of automatic code

end implement personForm
