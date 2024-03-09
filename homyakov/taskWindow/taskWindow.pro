% Copyright

implement taskWindow inherits applicationWindow
    open core, vpiDomains, ribbonControl

constants
    mdiProperty : boolean = true.

clauses
    new() :-
        applicationWindow::new(),
        generatedInitialize(),
        setState([wsf_maximized]),
        ribbon := ribbonControl::new(),
%        ribbon:colorRaisedFrom2 := ribbonCommand::vpi(0xC08000),
%        ribbon:colorRaisedTo2 := ribbonCommand::vpi(0xC08000),
        addControl(ribbon),
        createCommands(),
        ribbon:layout := layout,
        navigationOverlay::initMDI(This, ribbon:getNavigationPoints),
        menuSet(dynMenu(mkMenu(layout))),
        MenuMap = mkMenuMap(layout),
        addMenuItemListener(
            { (_, MenuTag) :-
                if Cmd = MenuMap:tryGet(MenuTag) then
                    Cmd:run(Cmd)
                end if
            }),
        ribbon:colorBackground := ribbonCommand::vpi(0x6FB6F7),
        statusBar := statusBarControl::new(),
        addControl(statusBar),
        textStatusCell := statusBarCell::new(statusBar, 30),
        statusBar:cells := [textStatusCell].

facts
    ribbon : ribbonControl [constant].
    statusBar : statusBarControl [constant].
    textStatusCell : statusBarCell := erroneous.

class facts
    newPersonForm : newPersonForm := erroneous.

clauses
    setNewPersonFormErroneous() :-
        newPersonForm := erroneous.

predicates
    onShow : window::showListener.
clauses
    onShow(_, _CreationData) :-
        _MessageForm = messageForm::display(This).

predicates
    onDocumentNew : (command Cmd).
clauses
    onDocumentNew(_Cmd) :-
        famDB::clearAll(),
        Form = newPersonForm::display(This),
        Form:setText("Добавление нового человека"),
        newPersonForm := Form.

class predicates
    onDocumentSave : (command Cmd).
clauses
    onDocumentSave(_Cmd) :-
        famDB::save(famDB::filename).

predicates
    onTable : (command Cmd).
clauses
    onTable(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть базу данных", [], StartPath, _),
        if "" = famDB::filename then
            famDB::load(Filename)
        end if,
        !,
        _ = tableForm::display(This).

    onTable(_Cmd).

predicates
    onDocumentOpen : (command Cmd).
clauses
    onDocumentOpen(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть файл", [], StartPath, _),
        if "" = famDB::filename then
            famDB::load(Filename)
        end if,
        !,
        baseForm::filename := Filename,
        _ = baseForm::display(This).

    onDocumentOpen(_Cmd).

predicates
    onPersonView : (command Cmd).
clauses
    onPersonView(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть файл", [], StartPath, _),
        if "" = famDB::filename then
            famDB::load(Filename)
        end if,
        PersonList = [ string::format("%. % % %", Id, Name, Name2, Name3) || famDB::person_nd(Id, Name, Name2, Name3, _, _) ],
        _ = vpiCommonDialogs::listSelect("Выберите персону", PersonList, 0, PersonItem, _),
        string::frontToken(PersonItem, Token, _),
        Id = tryToTerm(unsigned, Token),
        !,
        famDB::selectedPersonId := Id,
        _ = personForm::display(This).

    onPersonView(_Cmd).

predicates
    onPersonNew : (command Cmd).
clauses
    onPersonNew(_Cmd) :-
        isErroneous(newPersonForm),
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть файл", [], StartPath, _),
        if "" = famDB::filename then
            famDB::load(Filename)
        end if,
        !,
        famDB::selectedPersonId := 0,
        newPersonForm := newPersonForm::display(This).

    onPersonNew(_Cmd).

predicates
    onPersonDelete : (command Cmd).
clauses
    onPersonDelete(_Cmd) :-
        not(isErroneous(newPersonForm)),
        0 = vpiCommonDialogs::ask("Вы действительно намерены удалить сведения об этом человеке из базы данных?", ["Да", "Нет"]),
        !,
        famDB::deletePerson(famDB::selectedPersonId),
        newPersonForm:close(),
        stdio::writef("Все сведения о % удалены из базы данных\n", famDB::selectedPersonId).
    onPersonDelete(_Cmd).

predicates
    onPersonEdit : (command Cmd).
clauses
    onPersonEdit(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть файл", [], StartPath, _),
        if "" = famDB::filename then
            famDB::load(Filename)
        end if,
        PersonList = [ string::format("%. % % %", Id, Name, Name2, Name3) || famDB::person_nd(Id, Name, Name2, Name3, _, _) ],
        _ = vpiCommonDialogs::listSelect("Выберите персону для редактирования сведений о ней", PersonList, 0, PersonItem, _),
        string::frontToken(PersonItem, Token, _),
        Id = tryToTerm(unsigned, Token),
        !,
        famDB::selectedPersonId := Id,
        newPersonForm := newPersonForm::display(This).

    onPersonEdit(_Cmd).

predicates
    onPersonSave : (command Cmd).
clauses
    onPersonSave(_Cmd) :-
        not(isErroneous(newPersonForm)),
        !,
        newPersonForm:save().

    onPersonSave(_Cmd).

predicates
    onPersonSearch : (command Cmd).
clauses
    onPersonSearch(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть файл", [], StartPath, _),
        if "" = famDB::filename then
            famDB::load(Filename)
        end if,
        !,
        _ = searchDialog::display(This).
    onPersonSearch(_Cmd).

predicates
    onAncestorTree : (command Cmd).
clauses
    onAncestorTree(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть файл", [], StartPath, _),
        if "" = famDB::filename then
            famDB::load(Filename)
        end if,
        PersonList = [ string::format("%. % % %", Id, Name, Name2, Name3) || famDB::person_nd(Id, Name, Name2, Name3, _, _) ],
        _ = vpiCommonDialogs::listSelect("Выберите персону для создания дерева предков", PersonList, 0, PersonItem, _),
        string::frontToken(PersonItem, Token, _),
        Id = tryToTerm(unsigned, Token),
        !,
        famDB::selectedPersonId := Id,
        treeForm::type := 0,
        Form = treeForm::display(This),
        Form:setText("Дерево предков").

    onAncestorTree(_Cmd).

predicates
    onDescendantTree : (command Cmd).
clauses
    onDescendantTree(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть файл", [], StartPath, _),
        if "" = famDB::filename then
            famDB::load(Filename)
        end if,
        PersonList = [ string::format("%. % % %", Id, Name, Name2, Name3) || famDB::person_nd(Id, Name, Name2, Name3, _, _) ],
        _ = vpiCommonDialogs::listSelect("Выберите персону для создания дерева потомков", PersonList, 0, PersonItem, _),
        string::frontToken(PersonItem, Token, _),
        Id = tryToTerm(unsigned, Token),
        !,
        famDB::selectedPersonId := Id,
        treeForm::type := 1,
        Form = treeForm::display(This),
        Form:setText("Дерево потомков").

    onDescendantTree(_Cmd).

class predicates
    onClipboardCut : (command Cmd).
clauses
    onClipboardCut(Cmd) :-
        logCommand(Cmd).

class predicates
    onClipboardCopy : (command Cmd).
clauses
    onClipboardCopy(Cmd) :-
        logCommand(Cmd).

class predicates
    onClipboardPaste : (command Cmd).
clauses
    onClipboardPaste(Cmd) :-
        logCommand(Cmd).

class predicates
    onEditDelete : (command Cmd).
clauses
    onEditDelete(Cmd) :-
        logCommand(Cmd).

class predicates
    onEditUndo : (command Cmd).
clauses
    onEditUndo(Cmd) :-
        logCommand(Cmd).

class predicates
    onEditRedo : (command Cmd).
clauses
    onEditRedo(Cmd) :-
        logCommand(Cmd).

class predicates
    onHelp : (command Cmd).
clauses
    onHelp(Cmd) :-
        logCommand(Cmd).

predicates
    onAbout : (command Cmd).
clauses
    onAbout(_Cmd) :-
        _ = aboutDialog::display(This).

class predicates
    logCommand : (command Cmd).
clauses
    logCommand(Cmd) :-
        stdio::writef("Command %\n", Cmd:id).

predicates
    onDesign : (command Cmd).
clauses
    onDesign(_Cmd) :-
        DesignerDlg = ribbonDesignerDlg::new(This),
        DesignerDlg:cmdHost := This,
        DesignerDlg:designLayout := ribbon:layout,
        DesignerDlg:predefinedSections := ribbon:layout,
        DesignerDlg:show(),
        if DesignerDlg:isOk() and ribbon:layout <> DesignerDlg:designLayout then
            ribbon:layout := DesignerDlg:designLayout
        end if.

constants
    itv : ribbonControl::cmdStyle = imageAndText(vertical).
    ith : ribbonControl::cmdStyle = imageAndText(horizontal).
    t : ribbonControl::cmdStyle = textOnly.
    layout : ribbonControl::layout =
        [
            section("document", "&Document", toolTip::noTip, core::none,
                [block([[cmd("document/new", itv), cmd("document/open", itv), cmd("document/save", itv), cmd("document/table", itv)]])]),
            section("person", "&Person", toolTip::noTip, core::none,
                [
                    block(
                        [
                            [cmd("person/view", ith), cmd("person/edit", ith), cmd("person/delete", ith)],
                            [cmd("person/new", ith), cmd("person/save", ith), cmd("person/search", ith)]
                        ])
                ]),
            section("trees", "&Trees", toolTip::noTip, core::none,
                [block([[cmd("trees/ancestortree", itv), cmd("trees/descendanttree", itv), cmd("document/save", itv)]])]),
            /*    section("edit", "&Edit", toolTip::noTip, core::none, [block([[cmd("edit/undo", ith)], [cmd("edit/redo", ith)]])]),
            section("clipboard", "&Clipboard", toolTip::noTip, core::none,
                [block([[cmd("clipboard/cut", ith)], [cmd("clipboard/copy", ith)], [cmd("clipboard/paste", ith)]])]),
       */
            section("design", "De&sign", toolTip::noTip, core::none, [block([[cmd("ribbon.design", itv)]])]),
            section("help", "&Help", toolTip::noTip, core::none, [block([[cmd("help.help", t)], [cmd("help.about", t)]])])
        ].

predicates
    createCommands : ().
clauses
    createCommands() :-
        DocumentNewCmd = command::new(This, "document/new"),
        DocumentNewCmd:category := ["document/new"],
        DocumentNewCmd:menuLabel := "&New",
        DocumentNewCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\document-new.ico"))),
        DocumentNewCmd:tipTitle := tooltip::tip("New"),
        DocumentNewCmd:run := onDocumentNew,
        DocumentNewCmd:mnemonics := [tuple(10, "N"), tuple(15, "N1"), tuple(20, "N2"), tuple(25, "N3"), tuple(30, "N4")],
        DocumentNewCmd:acceleratorKey := key(k_f7, c_Nothing),
        %
        DescendantCmd = command::new(This, "trees/descendanttree"),
        DescendantCmd:category := ["trees/descendanttree"],
        DescendantCmd:menuLabel := "&Descendant tree",
        DescendantCmd:icon := some(icon::createFromBinary(#bininclude(@".\descendanttree.ico"))),
        DescendantCmd:tipTitle := tooltip::tip("Построение дерева потомков"),
        DescendantCmd:run := onDescendantTree,
        DescendantCmd:mnemonics := [tuple(10, "TD"), tuple(15, "TD1"), tuple(20, "TD2"), tuple(25, "TD3"), tuple(30, "TD4")],
        %
        AncestorCmd = command::new(This, "trees/ancestortree"),
        AncestorCmd:category := ["trees/ancestortree"],
        AncestorCmd:menuLabel := "&Ancestor tree",
        AncestorCmd:icon := some(icon::createFromBinary(#bininclude(@".\ancestortree.ico"))),
        AncestorCmd:tipTitle := tooltip::tip("Построение дерева предков"),
        AncestorCmd:run := onAncestorTree,
        AncestorCmd:mnemonics := [tuple(10, "TA"), tuple(15, "TA1"), tuple(20, "TA2"), tuple(25, "TA3"), tuple(30, "TA4")],
        %
        DocumentOpenCmd = command::new(This, "document/open"),
        DocumentOpenCmd:menuLabel := "&Open",
        DocumentOpenCmd:category := ["document/open"],
        DocumentOpenCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\document-open.ico"))),
        DocumentOpenCmd:tipTitle := tooltip::tip("Open"),
        DocumentOpenCmd:run := onDocumentOpen,
        DocumentOpenCmd:mnemonics := [tuple(10, "O"), tuple(15, "O1"), tuple(20, "O2"), tuple(25, "O3"), tuple(30, "O4")],
        DocumentSaveCmd = command::new(This, "document/save"),
        DocumentSaveCmd:category := ["document/save"],
        DocumentSaveCmd:menuLabel := "&Save",
        DocumentSaveCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\document-save.ico"))),
        DocumentSaveCmd:run := onDocumentSave,
        DocumentSaveCmd:mnemonics := [tuple(10, "S"), tuple(20, "S1")],
        % DocumentSaveCmd:enabled := false,
        %
        PersonViewCmd = command::new(This, "person/view"),
        PersonViewCmd:category := ["person/view"],
        PersonViewCmd:menuLabel := "&View",
        PersonViewCmd:icon := some(icon::createFromBinary(#bininclude(@".\view.ico"))),
        PersonViewCmd:tipTitle := tooltip::tip("Просмотр сведений о персоне из базы данных"),
        PersonViewCmd:run := onPersonView,
        PersonViewCmd:mnemonics := [tuple(10, "PV"), tuple(20, "PV1")],
        %
        PersonNewCmd = command::new(This, "person/new"),
        PersonNewCmd:category := ["person/new"],
        PersonNewCmd:menuLabel := "&New",
        PersonNewCmd:icon := some(icon::createFromBinary(#bininclude(@".\new.ico"))),
        PersonNewCmd:tipTitle := tooltip::tip("Добавление сведений о персоне в базу данных"),
        PersonNewCmd:run := onPersonNew,
        PersonNewCmd:mnemonics := [tuple(10, "PN"), tuple(20, "PN1")],
        %
        PersonDeleteCmd = command::new(This, "person/delete"),
        PersonDeleteCmd:category := ["person/delete"],
        PersonDeleteCmd:menuLabel := "&Delete",
        PersonDeleteCmd:icon := some(icon::createFromBinary(#bininclude(@".\delete.ico"))),
        PersonDeleteCmd:tipTitle := tooltip::tip("Удаление сведений о персоне из базы данных"),
        PersonDeleteCmd:run := onPersonDelete,
        PersonDeleteCmd:mnemonics := [tuple(10, "PD"), tuple(20, "PD1")],
        %
        PersonEditCmd = command::new(This, "person/edit"),
        PersonEditCmd:category := ["person/edit"],
        PersonEditCmd:menuLabel := "&Edit",
        PersonEditCmd:icon := some(icon::createFromBinary(#bininclude(@".\edit.ico"))),
        PersonEditCmd:tipTitle := tooltip::tip("Редактирование сведений о персоне из базы данных"),
        PersonEditCmd:run := onPersonEdit,
        PersonEditCmd:mnemonics := [tuple(10, "PE"), tuple(20, "PE1")],
        %
        PersonSaveCmd = command::new(This, "person/save"),
        PersonSaveCmd:category := ["person/save"],
        PersonSaveCmd:menuLabel := "&Save",
        PersonSaveCmd:icon := some(icon::createFromBinary(#bininclude(@".\save.ico"))),
        PersonSaveCmd:tipTitle := tooltip::tip("Запись сведений о персоне в базу данных"),
        PersonSaveCmd:run := onPersonSave,
        PersonSaveCmd:mnemonics := [tuple(10, "PS"), tuple(20, "PS1")],
        %
        PersonSearchCmd = command::new(This, "person/search"),
        PersonSearchCmd:category := ["person/search"],
        PersonSearchCmd:menuLabel := "&Search",
        PersonSearchCmd:icon := some(icon::createFromBinary(#bininclude(@".\search.ico"))),
        PersonSearchCmd:tipTitle := tooltip::tip("Найти сведения о персоне в базе данных"),
        PersonSearchCmd:run := onPersonSearch,
        PersonSearchCmd:mnemonics := [tuple(10, "PC"), tuple(20, "PC1")],
        %
        DocumentTableCmd = command::new(This, "document/table"),
        DocumentTableCmd:category := ["document/table"],
        DocumentTableCmd:menuLabel := "&Table",
        DocumentTableCmd:tipTitle := tooltip::tip("Открыть данные в виде таблицы"),
        DocumentTableCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\table.ico"))),
        DocumentTableCmd:run := onTable,
        DocumentTableCmd:mnemonics := [tuple(10, "T"), tuple(20, "T1")],
        % DocumentTableCmd:enabled := false,
        %
        ClipboardCutCommand = command::new(This, "clipboard/cut"),
        ClipboardCutCommand:category := ["clipboard/cut"],
        ClipboardCutCommand:menuLabel := "&Cut",
        ClipboardCutCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-cut.ico"))),
        ClipboardCutCommand:run := onClipboardCut,
        ClipboardCutCommand:mnemonics := [tuple(15, "C"), tuple(20, "U"), tuple(30, "U1")],
        ClipboardCutCommand:enabled := false,
        ClipboardCutCommand:acceleratorKey := key(k_x, c_Control),
        ClipboardCopyCommand = command::new(This, "clipboard/copy"),
        ClipboardCopyCommand:category := ["clipboard/copy"],
        ClipboardCopyCommand:menuLabel := "&Copy",
        ClipboardCopyCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-copy.ico"))),
        ClipboardCopyCommand:run := onClipboardCopy,
        ClipboardCopyCommand:mnemonics := [tuple(10, "C"), tuple(30, "C1")],
        ClipboardCopyCommand:enabled := false,
        ClipboardCopyCommand:acceleratorKey := key(k_c, c_Control),
        ClipboardPasteCommand = command::new(This, "clipboard/paste"),
        ClipboardPasteCommand:category := ["clipboard/paste"],
        ClipboardPasteCommand:menuLabel := "&Paste",
        ClipboardPasteCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-paste.ico"))),
        ClipboardPasteCommand:run := onClipboardPaste,
        ClipboardPasteCommand:mnemonics := [tuple(10, "P"), tuple(30, "P1")],
        ClipboardPasteCommand:enabled := false,
        ClipboardPasteCommand:acceleratorKey := key(k_v, c_Control),
        EditDeleteCommand = command::new(This, "edit/delete"),
        EditDeleteCommand:category := ["edit/delete"],
        EditDeleteCommand:menuLabel := "&Delete",
        EditDeleteCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-delete.ico"))),
        EditDeleteCommand:run := onEditDelete,
        EditDeleteCommand:mnemonics := [tuple(10, "D"), tuple(30, "D1")],
        EditDeleteCommand:enabled := false,
        EditDeleteCommand:acceleratorKey := key(k_del, c_Nothing),
        EditUndoCommand = command::new(This, "edit/undo"),
        EditUndoCommand:category := ["edit/undo"],
        EditUndoCommand:menuLabel := "&Undo",
        EditUndoCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-undo.ico"))),
        EditUndoCommand:run := onEditUndo,
        EditUndoCommand:mnemonics := [tuple(10, "D"), tuple(30, "D1")],
        EditUndoCommand:enabled := false,
        EditUndoCommand:acceleratorKey := key(k_z, c_Control),
        EditRedoCommand = command::new(This, "edit/redo"),
        EditRedoCommand:category := ["edit/redo"],
        EditRedoCommand:menuLabel := "&Redo",
        EditRedoCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-redo.ico"))),
        EditRedoCommand:run := onEditRedo,
        EditRedoCommand:mnemonics := [tuple(10, "D"), tuple(30, "D1")],
        EditRedoCommand:enabled := false,
        EditRedoCommand:acceleratorKey := key(k_y, c_Control),
        DesignCmd = command::new(This, "ribbon.design"),
        DesignCmd:tipTitle := toolTip::tip("Design ribbon, sections and commands."),
        DesignCmd:menuLabel := "&Design",
        DesignCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\tools.ico"))),
        DesignCmd:run := onDesign,
        HelpCmd = command::new(This, "help.help"),
        HelpCmd:tipTitle := toolTip::tip("Help"),
        HelpCmd:menuLabel := "&Help",
        HelpCmd:run := onHelp,
        AboutCmd = command::new(This, "help.about"),
        AboutCmd:tipTitle := toolTip::tip("About"),
        AboutCmd:menuLabel := "&About",
        AboutCmd:run := onAbout.

class predicates
    mkMenu : (layout Layout) -> menuItem* Menu.
clauses
    mkMenu(Layout) = [ mkMenu_section(MenuTagVar, S) || S in Layout ] :-
        MenuTagVar = varM_integer::new(1).

class predicates
    mkMenu_section : (varM_integer MenuTagVar, section Section) -> menuItem SectionMenu.
clauses
    mkMenu_section(MenuTagVar, section(_Id, Label, _TipText, _IconOpt, BlockList)) =
        vpiDomains::txt(MenuTagVar:inc(), Label, vpiDomains::noAccelerator, b_true, vpiDomains::mis_none,
            [ M || M = getMenu_nd_blockList(BlockList) ]).

class predicates
    getMenu_nd_blockList : (block* BlockList) -> menuItem MenuItem nondeterm.
clauses
    getMenu_nd_blockList(BlockList) = MenuItem :-
        Block in BlockList,
        (ribbonControl::separator = Block and MenuItem = vpiDomains::separator
            or block(Rows) = Block and Row in Rows and Item in Row
            and (ribbonControl::separator = Item and MenuItem = vpiDomains::separator
                or cmd(CmdId, _) = Item and Cmd = applicationWindow::get():tryLookupCommand(CmdId)
                and MenuItem = vpiDomains::txt(Cmd:menuTag, formatMenuLabel(Cmd), Cmd:acceleratorKey, b_true, vpiDomains::mis_none, []))).

class predicates
    formatMenuLabel : (command Cmd) -> string MenuLabel.
clauses
    formatMenuLabel(Cmd) = Label :-
        AccKeyStr = command::formatAcceleratorKey(Cmd:acceleratorKey),
        Suffix = if AccKeyStr <> "" then string::concat("\t", AccKeyStr) else "" end if,
        Label = string::concat(Cmd:menuLabel, Suffix).

class predicates
    mkMenuMap : (layout Layout) -> map{menuTag MenuTag, command Cmd}.
clauses
    mkMenuMap(Layout) = Map :-
        Map = mapM_redBlack::new(),
        foreach
            section(_Id, _Label, _TipText, _IconOpt, BlockList) in Layout and block(Rows) in BlockList and Row in Rows and cmd(CmdId, _) in Row
            and Cmd = applicationWindow::get():tryLookupCommand(CmdId)
        do
            Map:set(Cmd:menuTag, Cmd)
        end foreach.

class predicates
    onDestroy : window::destroyListener.
clauses
    onDestroy(_).

class predicates
    onHelpAbout : window::menuItemListener.
clauses
    onHelpAbout(TaskWin, _MenuTag) :-
        _AboutDialog = aboutDialog::display(TaskWin).

predicates
    onFileExit : window::menuItemListener.
clauses
    onFileExit(_, _MenuTag) :-
        close().

predicates
    onSizeChanged : window::sizeListener.
clauses
    onSizeChanged(_).

% This code is maintained automatically, do not update it manually.
predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("homyakov_KS2023"),
        setDecoration(titlebar([frameDecoration::closeButton, frameDecoration::maximizeButton, frameDecoration::minimizeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings]),
        % whenCreated({  :- projectToolbar::create(getVpiWindow()) }),
        setMdiProperty(mdiProperty),
        menuSet(resMenu(resourceIdentifiers::id_TaskMenu)),
        addShowListener(onShow),
        addSizeListener(onSizeChanged),
        addDestroyListener(onDestroy),
        addMenuItemListener(resourceIdentifiers::id_help_about, onHelpAbout),
        addMenuItemListener(resourceIdentifiers::id_file_exit, onFileExit).
% end of automatic code

end implement taskWindow
