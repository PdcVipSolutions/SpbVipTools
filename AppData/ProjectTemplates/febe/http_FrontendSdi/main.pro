% Copyright © Prolog Development Center SPb

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
            log::write(log::info, string::format("Start logging [%]",LogConfigName)),
            log::writef(log::debug, "Current directory: '%s'", directory::getCurrentDirectory())
        catch Err do
            exception::continue_User(Err, string::format("No LogConfig [%] Found",LogConfigName))
        end try.

clauses
    run():-
        initLog(),
		pzlPort::init(),
        vpi::init(),
        if not(file::existExactFile("PzlRegistry.pzr")) then
            file::writeString("PzlRegistry.pzr","clauses\n")
        end if,
        pzlPort::setComponentRegisterFileName("PzlRegistry.pzr"),
        Service=appHead::new(),
        Service:run().

end implement main

goal
    mainExe::run(main::run,exe_api::multiThread).