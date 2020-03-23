% Copyright

implement main
    open  core, httpServerApi\, pfc\asynchronous

class facts
    url_V : string := "http://localhost:5558/".
    test_V : string := "Readme.htm".
    threadPool_V : threadPool := threadPool::defaultThreadpool.
    cleanup_V : disposable := disposable::new(succeed).

clauses
    run():-
        if not(file::existExactFile("PzlRegistry.pzr")) then
            file::writeString("PzlRegistry.pzr","clauses\n")
        end if,
        CLP = commandLineParser::new(),
        CLP:acceptEmpty := true,
        CLP:addOption_help("-help"),
        CLP:addOption_1("-test", "The test <FILE> (default test.html) to launch", "FILE", { (File) :- test_V := File }),
        CLP:addOption_0("-notest", "Do not launch a test file", {  :- test_V := "" }),
        CLP:addOption_1("-url", "Run the server at <URL>", "URL", { (Url) :- url_V := Url }),
        CLP:addOption_1("-maxthread", "The maximum number threads <N> in the threadpool", "N",
            { (N) :-
                % We can only set the threadpool limits if we create our own threadpool
                threadpool_V := threadpool::new(),
                threadpool_V:threadMaximum := toTerm(unsigned, N)
            }),
        if some(M) = CLP:parse() then
            stdio::write(M)
        else
            runServer()
        end if.

class predicates
    runServer : ().
clauses
    runServer() :-
        % initialize httpServer_api and create a session
        httpServer_api::httpInitialize(httpServer_native::http_initialize_server),
        Session = session::new(),
        %
        % create the RPC url-group, request queue and service
        UrlGroup_rpc = urlGroup::new(Session),
        cleanup_V:alsoDispose(UrlGroup_rpc),
        UrlGroup_rpc:addUrl(string::format("%sjsonrpc/", url_V)),
        stdio::writef("URL = %sjsonrpc/\n", url_V),
        Service = appHead::new(),
        ReqQueue_rpc = requestQueue_rpc::new(threadpool_V, Service),
        UrlGroup_rpc:binding := ReqQueue_rpc,
        %
        % shutdown
        _ = stdio::readChar(),
        Service:backend_P:saveOptions(),
        pzl::unRegisterAllByNamePrefix(toString(Service:backend_P)),
        cleanup_V:dispose(),
        httpServer_api::httpTerminate(httpServer_native::http_initialize_server).

end implement main

goal
    console::run(main::run, stream::ansi(core::utf8), exe_api::multiThread).
