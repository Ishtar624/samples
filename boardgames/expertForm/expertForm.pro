% Copyright

implement expertForm inherits formWindow
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
    db : dbBoardGames := erroneous.

predicates
    onYesStateChanged : radioButton::stateChangedListener.
clauses
    onYesStateChanged(_Source, _OldState, radioButton::checked) :-
        !,
        explanation_ctl:setVisible(false),
        imageControl_ctl:setNoImage(),
        act(1).

    onYesStateChanged(_Source, _OldState, _NewState).

predicates
    onNoStateChanged : radioButton::stateChangedListener.
clauses
    onNoStateChanged(_Source, _OldState, radioButton::checked) :-
        !,
        explanation_ctl:setVisible(false),
        imageControl_ctl:setNoImage(),
        act(2).

    onNoStateChanged(_Source, _OldState, _NewState).

predicates
    onQuestionStateChanged : radioButton::stateChangedListener.
clauses
    onQuestionStateChanged(_Source, _OldState, radioButton::checked) :-
        !,
        act(3).
    onQuestionStateChanged(_Source, _OldState, _NewState).

facts - temp
    currentRule : (positive, string, string, positive*).
    currentAttr : (positive, string, string).
    rest : (positive*).

facts - dbAnswer
    yes : (positive Attr).
    no : (positive Attr).

predicates
    firstquestion : ().
clauses
    firstquestion() :-
        db:topic_nd(Topic),
        db:rule_nd(N, Topic, Object, L),
        L = [K | Rest],
        db:attr_nd(K, Sign, Value),
        !,
        Text = string::format("Верно ли, что % - %?\n", Sign, Value),
        edit_ctl:setText(Text),
        retractFactDb(temp),
        assert(currentRule(N, Topic, Object, L)),
        assert(currentAttr(K, Sign, Value)),
        assert(rest(Rest)).
    firstquestion().

predicates
    act : (integer).
    result : ().
    nextQuestion : ().
    newQuestion : ().

clauses
    act(1) :-
        currentAttr(N, _, _),
        retractAll(yes(N)),
        assert(yes(N)),
        rest(L),
        L = [K | Rest],
        retractAll(rest(L)),
        retractAll(currentAttr(_, _, _)),
        db:attr_nd(K, S, V),
        !,
        assert(currentAttr(K, S, V)),
        assert(rest(Rest)),
        yes_ctl:setRadioState(radioButton::unchecked),
        nextQuestion().
    act(1) :-
        !,
        result().
    act(2) :-
        currentAttr(N, _, _),
        !,
        retractAll(no(N)),
        assert(no(N)),
        no_ctl:setRadioState(radioButton::unchecked),
        newQuestion().
    act(3) :-
        currentRule(N, Topic, Object, L),
        !,
        explanation_ctl:setVisible(true),
        Str = outputStream_string::new(),
        Str:writef("Текущее предположение: % - %\n", Topic, Object),
        Str:write("Это так, если\n"),
        foreach K in L and db:attr_nd(K, S, V) do
            Str:writef("% - %\n", S, V)
        end foreach,
        if yes(_) then
            Str:write("\nИзвестно, что\n"),
            foreach yes(X) and db:attr_nd(X, S, V) do
                Str:writef("% - %\n", S, V)
            end foreach
        end if,
        ExplanationText = Str:getString(),
        explanation_ctl:setText(ExplanationText),
        if db:pict_nd(N, Filename) then
            imageControl_ctl:setImageFile(Filename)
        end if,
        question_ctl:setRadioState(radioButton::unchecked),
        nextQuestion().

    act(_).

    nextQuestion() :-
        currentAttr(K, _S, _V),
        yes(K),
        !,
        act(1).
    nextQuestion() :-
        currentAttr(K, _S, _V),
        no(K),
        !,
        newQuestion().
    nextQuestion() :-
        currentAttr(_, S, V),
        !,
        Text = string::format("Верно ли, что % - %?\n", S, V),
        edit_ctl:setText(Text).
    nextQuestion().

    newQuestion() :-
        currentRule(Old, _, _, _),
        N = Old + 1,
        retractFactDb(temp),
        db:rule_nd(N, Topic, Object, L),
        assert(currentRule(N, Topic, Object, L)),
        L = [K | Rest],
        db:attr_nd(K, S, V),
        !,
        assert(currentAttr(K, S, V)),
        assert(rest(Rest)),
        nextQuestion().
    newQuestion() :-
        result().

    result() :-
        YesL = list::sort([ N || yes(N) ]),
        NoL = list::sort([ K || no(K) ]),
        getResult(YesL, NoL).

predicates
    getResult : (positive* Yes, positive* No).
    best : (positive*, positive*, positive [out]).

clauses
    getResult(L, _) :-
        db:rule_nd(N, Topic, Object, L1),
        L = list::sort(L1),
        !,
        explanation_ctl:setVisible(true),
        Text = string::format("Результат: % - %", Topic, Object),
        explanation_ctl:setText(Text),
        if db:pict_nd(N, Filename) then
            imageControl_ctl:setImageFile(Filename)
        end if.
    getResult(YesL, NoL) :-
        best(YesL, NoL, K),
        db:rule_nd(K, Topic, Object, _),
        !,
        explanation_ctl:setVisible(true),
        Text = string::format("Наилучшее предположение: % - %", Topic, Object),
        explanation_ctl:setText(Text),
        if db:pict_nd(K, Filename) then
            imageControl_ctl:setImageFile(Filename)
        end if.
    getResult(_, _).

    best(L, _, K) :-
        L <> [],
        List =
            [ tuple(Count, N) ||
                db:rule_nd(N, _, _, CL),
                Count = list::length(list::intersection(L, CL))
            ],
        List <> [],
        !,
        tuple(_, K) = list::maximum(List).
    best(_, L, K) :-
        L <> [],
        List =
            [ tuple(Count, N) ||
                db:rule_nd(N, _, _, CL),
                Count = list::length(list::intersection(L, CL))
            ],
        List <> [],
        !,
        tuple(_, K) = list::minimum(List).
    best(_, _, 1).

predicates
    onShow : window::showListener.
clauses
    onShow(_Source, _Data) :-
        not(isErroneous(db)),
        db:topic_nd(Topic),
        !,
        setText(Topic),
        firstquestion().

    onShow(_Source, _Data).

% This code is maintained automatically, do not update it manually.
facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    edit_ctl : editControl.
    yes_ctl : radioButton.
    no_ctl : radioButton.
    question_ctl : radioButton.
    imageControl_ctl : imageControl.
    explanation_ctl : editControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("expertForm"),
        setRect(vpiDomains::rct(50, 40, 382, 288)),
        setDecoration(titlebar([frameDecoration::maximizeButton, frameDecoration::minimizeButton, frameDecoration::closeButton])),
        setBorder(frameDecoration::sizeBorder),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addShowListener(onShow),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(76, 230),
        ok_ctl:setSize(56, 16),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(140, 230),
        cancel_ctl:setSize(56, 16),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(204, 230),
        help_ctl:setSize(56, 16),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::right, control::bottom]),
        GroupBox_ctl = groupBox::new(This),
        GroupBox_ctl:setRect(vpiDomains::rct(4, 6, 328, 54)),
        edit_ctl := editControl::new(GroupBox_ctl),
        edit_ctl:setRect(vpiDomains::rct(35, 4, 287, 18)),
        yes_ctl := radioButton::new(GroupBox_ctl),
        yes_ctl:setText("Да"),
        yes_ctl:setRect(vpiDomains::rct(27, 24, 85, 36)),
        yes_ctl:addStateChangedListener(onYesStateChanged),
        no_ctl := radioButton::new(GroupBox_ctl),
        no_ctl:setText("Нет"),
        no_ctl:setRect(vpiDomains::rct(131, 24, 189, 36)),
        no_ctl:addStateChangedListener(onNoStateChanged),
        question_ctl := radioButton::new(GroupBox_ctl),
        question_ctl:setText("?"),
        question_ctl:setRect(vpiDomains::rct(239, 24, 297, 36)),
        question_ctl:addStateChangedListener(onQuestionStateChanged),
        imageControl_ctl := imageControl::new(This),
        imageControl_ctl:setRect(vpiDomains::rct(188, 62, 328, 224)),
        explanation_ctl := editControl::new(This),
        explanation_ctl:setRect(vpiDomains::rct(4, 60, 180, 222)),
        explanation_ctl:setAutoHScroll(false),
        explanation_ctl:setAutoVScroll(true),
        explanation_ctl:setHorizontalScroll(false),
        explanation_ctl:setHScroll(false),
        explanation_ctl:setMultiLine(true),
        explanation_ctl:setVerticalScroll(true),
        explanation_ctl:setVScroll(true),
        explanation_ctl:setWantReturn(true),
        explanation_ctl:setReadOnly(true).
% end of automatic code

end implement expertForm
