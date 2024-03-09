% Copyright

implement famDB
    open core, stdio, vpiDomains

%https://ru.rodovid.org/wk/%D0%A1%D0%BB%D1%83%D0%B6%D0%B5%D0%B1%D0%BD%D0%B0%D1%8F:Tree/349314?showfulltree=yes
%полное древо
class facts
    filename : string := "".
    maxId : unsigned := 0.
    selectedPersonId : unsigned := 0.
    defaultImage : string := "default.jpg".

class facts - dbrel
    person : (unsigned Id, string Name, string Name2, string Name3, string Gender, string Family).
    parent : (unsigned IdParent, unsigned IdChild).
    spouse : (unsigned IdHusband, unsigned IdWife).
    birth : (unsigned Id, integer).
    death : (unsigned Id, integer).
    picture : (unsigned Id, string Filename).
    biography : (unsigned Id, string Filename).

clauses
    person_nd(A, B, C, D, E, F) :-
        person(A, B, C, D, E, F).

    parent_nd(A, B) :-
        parent(A, B).

    spouse_nd(A, B) :-
        spouse(A, B).

    birth_nd(A, B) :-
        birth(A, B).

    death_nd(A, B) :-
        death(A, B).

    picture_nd(A, B) :-
        picture(A, B).

    biography_nd(A, B) :-
        biography(A, B).

    getLabel(Id) = string::format("% % %", Name, Name2, Name3) :-
        person(Id, Name, Name2, Name3, _, _),
        !.
    getLabel(_Id) = "".

    getLabelId(Id) = string::format("%2. %", Id, getLabel(Id)).

    getGenderPersonList(Gender) = [ string::format("%2. % % %", Id, Name, Name2, Name3) || person(Id, Name, Name2, Name3, Gender, _) ].

    clearAll() :-
        filename := "",
        selectedPersonId := 0,
        maxId := 0,
        retractFactDb(dbrel).

    load(Filename) :-
        try
            file::consult(Filename, dbrel)
        catch Error do
            writef("Error %. Unable to load a database from %\n", Error, Filename),
            fail
        end try,
        !,
        filename := Filename,
        L = [ I || person(I, _, _, _, _, _) ],
        if L <> [] then
            maxId := list::maximum(L)
        end if.
%    load(_).

    save("") :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.tx", ["Текстовый файл", "*.txt"], "Сохранить базу данных", [dlgfn_save], StartPath, _),
        !,
        file::save(Filename, dbrel),
        writef("База данных сохранена в файле %\n", Filename).
    save(_) :-
        save().

    save() :-
        filename <> "",
        !,
        file::save(filename, dbrel),
        writef("База данных сохранена в файле %\n", filename).
    save().

    getNewId() = maxId :-
        maxId := maxId + 1.

    addPerson(Id, _Name, _Name2, _Name3, _Gender, _Family, _Birth, _Death, _Father, _Mother, _SpouseIdList, _BiographyFilename, _PictureList) :-
        Id = selectedPersonId,
        deletePerson(Id),
        fail.
    addPerson(Id, Name, Name2, Name3, Gender, Family, Birth, Death, Father, Mother, SpouseIdList, BiographyFilename, PictureList) :-
        assert(person(Id, Name, Name2, Name3, Gender, Family)),
        if Birth <> 0 then
            assert(birth(Id, Birth))
        end if,
        if Death <> 0 then
            assert(death(Id, Death))
        end if,
        if Father > 0 then
            assert(parent(Father, Id))
        end if,
        if Mother > 0 then
            assert(parent(Mother, Id))
        end if,
        foreach SpouseId in SpouseIdList do
            if Gender = "м" then
                assert(spouse(Id, SpouseId))
            else
                assert(spouse(SpouseId, Id))
            end if
        end foreach,
        if "" <> BiographyFilename then
            assert(biography(Id, BiographyFilename))
        end if,
        foreach ImageFile in PictureList do
            assert(picture(Id, ImageFile))
        end foreach,
        save(filename).

    deletePerson(Id) :-
        retractAll(person(Id, _, _, _, _, _)),
        retractAll(parent(Id, _)),
        retractAll(parent(_, Id)),
        retractAll(spouse(Id, _)),
        retractAll(spouse(_, Id)),
        retractAll(birth(Id, _)),
        retractAll(death(Id, _)),
        retractAll(biography(Id, _)),
        retractAll(picture(Id, _)).
%первое имя
    editName(Id, Name) :-
        person(Id, Name, _, _, _, _),
        !.
    editName(Id, Name) :-
        retract(person(Id, OldName, Name2, Name3, Gender, Family)),
        !,
        assert(person(Id, Name, Name2, Name3, Gender, Family)),
        writef("Имя % изменено с % на %\n", Id, OldName, Name).
    editName(_, _).
%второе имя
    editName2(Id, Name2) :-
        person(Id, _, Name2, _, _, _),
        !.
    editName2(Id, Name2) :-
        retract(person(Id, Name, OldName2, Name3, Gender, Family)),
        !,
        assert(person(Id, Name, Name2, Name3, Gender, Family)),
        writef("Отчество/второе имя % изменено с % на %\n", Id, OldName2, Name2).
    editName2(_, _).
%третье имя
    editName3(Id, Name3) :-
        person(Id, _, _, Name3, _, _),
        !.
    editName3(Id, Name3) :-
        retract(person(Id, Name, Name2, OldName3, Gender, Family)),
        !,
        assert(person(Id, Name, Name2, Name3, Gender, Family)),
        writef("Фамилия % изменена с % на %\n", Id, OldName3, Name3).
    editName3(_, _).
%пол не меняется! ИСПРАВлено
    editGender(Id, Gender) :-
        person(Id, _, _, _, Gender, _),
        !.
    editGender(Id, Gender) :-
        retract(person(Id, Name, Name2, Name3, OldGender, Family)),
        !,
        assert(person(Id, Name, Name2, Name3, Gender, Family)),
        writef("Пол % изменен с % на %\n", Id, OldGender, Gender).
    editGender(_, _).
%род
    editFamily(Id, Family) :-
        person(Id, _, _, _, _, Family),
        !.
    editFamily(Id, Family) :-
        retract(person(Id, Name, Name2, Name3, Gender, OldFamily)),
        !,
        assert(person(Id, Name, Name2, Name3, Gender, Family)),
        writef("Пол % изменен с % на %\n", Id, OldFamily, Family).
    editFamily(_, _).
%отец
    editFather(Id, FatherId) :-
        if parent(X, Id) and person(X, _, _, _, "м", _) then
            retractAll(parent(X, Id))
        end if,
        assert(parent(FatherId, Id)),
        writef("Запись об отце % - % добавлена (изменена)\n", FatherId, Id).
%мать
    editMother(Id, MotherId) :-
        if parent(X, Id) and person(X, _, _, _, "ж", _) then
            retractAll(parent(X, Id))
        end if,
        assert(parent(MotherId, Id)),
        writef("Запись о матери % - % добавлена (изменена)\n", MotherId, Id).
%рождение
    editBirth(Id, Year) :-
        retractAll(birth(Id, _)),
        assert(birth(Id, Year)),
        writef("Запись о годе рождения % - % добавлена (изменена)\n", Id, Year).
%смерть
    editDeath(Id, Year) :-
        retractAll(death(Id, _)),
        assert(death(Id, Year)),
        writef("Запись о годе смерти % - % добавлена (изменена)\n", Id, Year).
%удаление отца/матери
    deleteFather(Id, FatherId) :-
        retractAll(parent(FatherId, Id)),
        writef("Запись об отце % - % удалена\n", Id, FatherId). %чекнуть работоспособность

    deleteMother(Id, MotherId) :-
        retractAll(parent(MotherId, Id)),
        writef("Запись о матери % - % удалена\n", Id, MotherId).
%супруги
    addSpouse(Id, SpouseId) :-
        spouse(Id, SpouseId),
        !.
    addSpouse(Id, SpouseId) :-
        spouse(SpouseId, Id),
        !.
    addSpouse(Id, SpouseId) :-
        person(Id, _, _, _, "м", _),
        !,
        assert(spouse(Id, SpouseId)),
        writef("Запись о жене % - % добавлена\n", Id, SpouseId).
    addSpouse(Id, SpouseId) :-
        assert(spouse(SpouseId, Id)),
        writef("Запись о муже % - % добавлена\n", SpouseId, Id).

    deleteSpouse(Id, SpouseId) :-
        retractAll(spouse(Id, SpouseId)),
        retractAll(spouse(SpouseId, Id)),
        writef("Запись о супруге % - % удалена\n", Id, SpouseId).

    deleteBirth(Id, BirthYear) :-
        retractAll(birth(Id, BirthYear)),
        writef("Запись о годе рождения % - % удалена\n", Id, BirthYear).

    deleteDeath(Id, DeathYear) :-
        retractAll(death(Id, DeathYear)),
        writef("Запись о годе смерти % - % удалена\n", Id, DeathYear).

end implement famDB
