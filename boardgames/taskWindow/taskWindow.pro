% Copyright

implement taskWindow inherits applicationWindow
    open core, vpiDomains, ribbonControl

constants
    mdiProperty : boolean = true.

clauses
    new() :-
        applicationWindow::new(),
        generatedInitialize(),
        ribbon := ribbonControl::new(),
        addControl(ribbon),
        createCommands(),
        ribbon:layout := layout,
        navigationOverlay::initMDI(This, ribbon:getNavigationPoints),
        menuSet(dynMenu(mkMenu(layout))),
        MenuMap = mkMenuMap(layout),
        addMenuItemListener(
            { (_, MenuTag) :-
                Cmd = MenuMap:get(MenuTag),
                Cmd:run(Cmd)
            }),
        ribbon:colorBackground := ribbonCommand::vpi(color_azure),
        statusBar := statusBarControl::new(),
        addControl(statusBar),
        textStatusCell := statusBarCell::new(statusBar, 30),
        statusBar:cells := [textStatusCell],
        setText("Экспертная система").

facts
    ribbon : ribbonControl.
    statusBar : statusBarControl.
    textStatusCell : statusBarCell := erroneous.

predicates
    onShow : window::showListener.
clauses
    onShow(_, _CreationData) :-
        _MessageForm = messageForm::display(This).

predicates
    onDocumentNew : (command Cmd).
clauses
    onDocumentNew(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Создать базу данных", [], StartPath, _),
        Str = file::readString(Filename, _),
        string::isWhiteSpace(Str),
        !,
        Db = dbBoardGames::new(Filename),
        Db:save(Filename),
        Db:load(),
        Form = attrForm::new(This),
        Form:db := some(Db),
        Form:show().
    onDocumentNew(_Cmd).

class predicates
    onDocumentSave : (command Cmd).
clauses
    onDocumentSave(Cmd) :-
        logCommand(Cmd).

predicates
    onTree : (command Cmd).
clauses
    onTree(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть базу данных", [], StartPath, _),
        Db = dbBoardGames::new(Filename),
        Db:load(),
        treeform::db := some(Db),
        L = [ Value || Db:attr_nd(_, _, Value) ],
        1 = vpiCommonDialogs::listSelect("Выберите раздел", L, 0, AttrValue, _),
        Db:attr_nd(I, _, AttrValue),
        !,
        treeform::currentId := I,
        Form = treeForm::new(This),
        Form:show().

    onTree(_Cmd).

predicates
    onDocumentAssortment : (command Cmd).
clauses
    onDocumentAssortment(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть базу данных", [], StartPath, _),
        !,
        Db = dbBoardGames::new(Filename),
        Db:load(),
        Form = baseForm::new(This),
        Form:db := some(Db),
        Form:show().

    onDocumentAssortment(_Cmd).

predicates
    onDocumentObject : (command Cmd).
clauses
    onDocumentObject(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть базу данных", [], StartPath, _),
        !,
        Db = dbBoardGames::new(Filename),
        Db:load(),
        Form = objectForm::new(This),
        Form:db := some(Db),
        Form:show().

    onDocumentObject(_Cmd).

predicates
    onDocumentOpen : (command Cmd).
clauses
    onDocumentOpen(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть базы данных", [], StartPath, _),
        !,
        Db = dbBoardGames::new(Filename),
        Db:load(),
        Form = attrForm::new(This),
        Form:db := some(Db),
        Form:show().
    onDocumentOpen(_Cmd).

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

predicates
    onExpert : (command Cmd).
clauses
    onExpert(_Cmd) :-
        mainExe::getFilename(StartPath, _),
        Filename = vpiCommonDialogs::getFilename("*.txt", ["Текстовый файл", "*.txt"], "Открыть базу данных", [], StartPath, _),
        !,
        Db = dbBoardGames::new(Filename),
        Db:load(),
        Form = expertForm::new(This),
        Form:db := Db,
        Form:show().

    onExpert(_Cmd).

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
        if DesignerDlg:isOk() then
            ribbon:layout := DesignerDlg:designLayout
        end if.

constants
    itv : ribbonControl::cmdStyle = imageAndText(vertical).
    t : ribbonControl::cmdStyle = textOnly.
    layout : ribbonControl::layout =
        [
            section("document", "&Document", toolTip::noTip, core::none,
                [block([[cmd("document/new", itv), cmd("document/open", itv), cmd("document/assortment", itv), cmd("document/saveAs", itv)]])]),
            section("expert", "&Expert", toolTip::noTip, core::none, [block([[cmd("expert", itv)]])]),
            section("tree", "&Tree", toolTip::noTip, core::none, [block([[cmd("tree/tree", itv)]])]),
            /*section("clipboard", "&Clipboard", toolTip::noTip, core::none,
                [block([[cmd("clipboard/cut", itv)], [cmd("clipboard/copy", itv)], [cmd("clipboard/paste", itv)]])]),
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
        DocumentOpenCmd = command::new(This, "document/open"),
        DocumentOpenCmd:menuLabel := "&Open feature",
        DocumentOpenCmd:category := ["document/open"],
        DocumentOpenCmd:icon := some(icon::createFromBinary(#bininclude(@".\feature.ico"))),
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
        %%
        TreeCommand = command::new(This, "tree/tree"),
        TreeCommand:category := ["tree/tree"],
        TreeCommand:menuLabel := "&Trees",
        TreeCommand:tipTitle := tooltip::tip("Ancestor and Descendant Trees"),
        TreeCommand:icon := some(icon::createFromBinary(#bininclude(@".\tree.ico"))),
        TreeCommand:run := onTree,
        TreeCommand:mnemonics := [tuple(10, "D"), tuple(20, "D1")],
        % %
        DocumentObjCmd = command::new(This, "document/saveAs"),
        DocumentObjCmd:category := ["document/saveAs"],
        DocumentObjCmd:menuLabel := "Open object",
        DocumentObjCmd:ribbonLabel := "Open object",
        DocumentObjCmd:icon := some(icon::createFromBinary(#bininclude(@".\object.ico"))),
        DocumentObjCmd:run := onDocumentObject,
        DocumentObjCmd:mnemonics := [tuple(10, "A"), tuple(20, "A1")],
        DocumentObjCmd:enabled := true,
        %%%%%%%%%%%%
        DocumentAssCmd = command::new(This, "document/assortment"),
        DocumentAssCmd:category := ["document/assortment"],
        DocumentAssCmd:menuLabel := "&Open assortment",
        DocumentAssCmd:ribbonLabel := "Open assortment",
        DocumentAssCmd:icon := some(icon::createFromBinary(#bininclude(@".\assortment.ico"))),
        DocumentAssCmd:run := onDocumentAssortment,
        DocumentAssCmd:mnemonics := [tuple(10, "A"), tuple(20, "A1")],
        DocumentAssCmd:enabled := true,
        %%%%%%%%%%%%
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
        %
        ExpertCommand = command::new(This, "expert"),
        ExpertCommand:category := ["expert"],
        ExpertCommand:menuLabel := "&Expert",
        ExpertCommand:icon := some(icon::createFromBinary(#bininclude(@".\expert.ico"))),
        ExpertCommand:run := onExpert,
        ExpertCommand:mnemonics := [tuple(10, "D"), tuple(30, "D1")],
        %
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
        if AccKeyStr <> "" then
            Suffix = string::concat("\t", AccKeyStr)
        else
            Suffix = ""
        end if,
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
    onSizeChanged(_) :-
        vpiToolbar::resize(getVPIWindow()).

% This code is maintained automatically, do not update it manually.
predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("boardGames"),
        setDecoration(titlebar([frameDecoration::closeButton, frameDecoration::maximizeButton, frameDecoration::minimizeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings]),
        %whenCreated({  :- projectToolbar::create(getVpiWindow()) }),
        setMdiProperty(mdiProperty),
        menuSet(resMenu(resourceIdentifiers::id_TaskMenu)),
        addShowListener(onShow),
        addSizeListener(onSizeChanged),
        addDestroyListener(onDestroy),
        addMenuItemListener(resourceIdentifiers::id_help_about, onHelpAbout),
        addMenuItemListener(resourceIdentifiers::id_file_exit, onFileExit).
% end of automatic code

end implement taskWindow
