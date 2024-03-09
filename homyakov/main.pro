% Copyright

implement main

clauses
    run() :-
        GdiPlus = gdiPlus::startup(),
        TaskWindow = taskWindow::new(),
        TaskWindow:show(),
        gdiPlus::shutdown(GdiPlus).

end implement main

goal
    mainExe::run(main::run).
