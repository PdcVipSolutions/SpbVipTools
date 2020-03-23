/*****************************************************************************
Copyright © Prolog Development Center SPB
******************************************************************************/
implement main
    open core, pfc\log

constants
    xmlFilename = @"$$(Project.Name)AppData\LogConfig.xml".

class predicates
    initLog:().
clauses
    initLog():-
        LogConfigName="Common",
        try
            logconfig::loadConfig(xmlFilename, LogConfigName),
            log::writef(log::info,"Start logging [%]",LogConfigName),
            log::writef(log::debug, "Current directory: [%]", directory::getCurrentDirectory())
        catch Err do
            exception::continue_User(Err, string::format("No LogConfig [%] Found",LogConfigName))
        end try.

clauses
    run():-
        initLog(),
		pzlPort::init(),
        if not(file::existExactFile("PzlRegistry.pzr")) then
            file::writeString("PzlRegistry.pzr","clauses\n")
        end if,
        pzlPort::setComponentRegisterFileName("PzlRegistry.pzr"),
        vpi::init(),
        Main=appHead::new(),
        Main:run(gui::getScreenWindow()),
        messageLoop::run().

end implement main

goal
    mainExe::run(main::run).