%
%


implement fe_Tests inherits fe_Connector
    open core, pfc\asynchronous, pfc\log%, vpiDomains
    open
        edf,
%        coreIdentifiers,
        dataExchangeIdentifiers,
%        frontEnd,
%        defaultDictionary,
        eventManager

clauses
    new(FrontEnd) :-
        fe_Connector::new(FrontEnd).

clauses
    mapPromise(Promise,be_testResponse_1_C,BeResponces):-
        !,
        _NewF=Promise:map(
        {(Data) = unit:-
                if Data=s(String) then
                    stdio::write(String,"\n")
                else
                    stdio::writef("WrongData [%]\n",Data)
                end if,
                _NewPromise=BeResponces:createResponseReciever_async(be_testResponse_1_C,2)
            }).
    mapPromise(_Any,_AnyRequestID,_BeResponces).

clauses
    onTimeOut(RequestId,TraceId):-
        ParentWindow=tryConvert(window,fe_AppWindow()),
        !,
        spbExceptionDialog::displayError(ParentWindow,TraceID,string::format("TimeOut Event. Context=[%]",RequestId)).
    onTimeOut(_RequestId,_TraceId).

clauses
    tryHandleRespondedData(be_TestError3_C,av("be_error",a(ErrorDescrList))):-
        av("short",s(ShortMessage)) in ErrorDescrList,
        av("detailed",s(DetailedData)) in ErrorDescrList,
        !,
        spbExceptionDialog::displayMsg(convert(window,fe_AppWindow()),ShortMessage,DetailedData).
    tryHandleRespondedData(ResponseID,EdfData):-
        stdio::writef("Response=[%] EdfData=[%]\n",ResponseID,EdfData).

/***** UserTasks **********/
clauses
    runTest(Command):-
        CommandID=fe_Command::tryExtractCommandSuffix(Command,"ribbon.cmd."),
        testCall(CommandID,Command),
        !.
    runTest(Command):-
        Msg=string::format("Unexpected Command [%]",Command:id),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

predicates
    testCall:(string CommandID,command Command) multi.

clauses
    testCall("test1",Command):-
        stdio::writef("commandCategory:[%]\n",Command:category),
        _Future=be_Responses():createResponseReciever_async(be_testResponse_1_C,2),
        request(methodChain,fe_testRequest_1_C,edf::a([edf::s("One"),edf::s("Two"),edf::s("Three")])),
        succeed(),
        stdio::write("==Done\n"),
        succeed().

    testCall("test2",Command):-
        stdio::writef("commandCategory:[%]\n",Command:category),
        Future=be_Responses():createResponseReciever_async(be_testResponse_2_C,2),
        request(methodRequest,fe_testRequest_2_C,edf::s("Hello FromFrontEnd!")),
        _NewF=Future:map(
        {(Data) = unit:-
                if Data=s(String) then
                    stdio::write(String,"\n")
                else
                    stdio::writef("WrongData [%]\n",Data)
                end if
            }).

    testCall("test3",Command):-
        stdio::writef("commandCategory:[%]\n",Command:category),
        request(methodRequest,fe_testRequest_3_C,s("Test to invoke Exception")).

    testCall("test5",Command):-
        stdio::writef("commandCategory:[%]\n",Command:category),
        if SleepTime=tryToTerm(editControlText_V) then
            request(methodRequest,fe_testRequest_5_C,edf::i(SleepTime))
        else
            vpiCommonDialogs::error(string::format("Value in the EditControl must be Integer in the Range 0..., instead of [%]",editControlText_V))
        end if.

    testCall("test4",Command):-
        stdio::writef("commandCategory:[%]\n",Command:category),
        request(methodRequest,fe_testRequest_4_C,edf::n).

    testCall("test7",Command):-
        stdio::writef("commandCategory:[%]\n",Command:category),
        timer_V:=cancelableInterval::new(),
        timer_V:interval_P:=10,
        timer_V:actor_P:=testActor,
        timer_V:run(),
        stdio::write("test7Complete\n").

    testCall("test8",Command):-
        timer_V:stop(),
        timer_V:=erroneous,
        stdio::writef("commandCategory:[%]\n",Command:category).

    testCall(TestID,_Command):-
        Msg=string::format("Unexpected TestID [%]",TestID),
        log::write(log::error,Msg),
        exception::raise_User(Msg).

clauses
    controlFactory("button-blockHandling")=
        {()=Control:-
            Control=button::new(),
            Control:setText("FALSE"),
            Control:setClickResponder(onButton1_Click)
        }:-!.
    controlFactory("button-blockEndofData")=
        {()=Control:-
            Control=button::new(),
            Control:setText("FALSE"),
            Control:setClickResponder(onButton2_Click)
        }:-!.
    controlFactory("edit-control")=
        {()=Control:-
            Control=editControl::new(),Control:setText(editControlText_V),
            Control:addModifiedListener(onModifiedEC)
        }:-!.
    controlFactory(_ControlName)={()=Control:-Control=textControl::new(),Control:setText("err_Default!")}.

facts
    button1_State_V:boolean:=false.
    button2_State_V:boolean:=false.
    editControlText_V:string:="0".

predicates
    onButton1_Click:button::clickResponder.
clauses
    onButton1_Click(Src)=button::defaultAction:-
        if button1_State_V=false then
            button1_State_V:=true,
            Src:setText("TRUE")
        else
            button1_State_V:=false,
            Src:setText("FALSE")
        end if,
        stdio::writef("commandCategory:[%]\n","Direct PushButton-1 reaction"),
        request(methodRequest,fe_testRequest_4_C,edf::bl(button1_State_V)).

predicates
    onButton2_Click:button::clickResponder.
clauses
    onButton2_Click(Src)=button::defaultAction:-
        if button2_State_V=false then
            button2_State_V:=true,
            Src:setText("TRUE")
        else
            button2_State_V:=false,
            Src:setText("FALSE")
        end if,
        stdio::writef("commandCategory:[%]\n","Direct PushButton-2 reaction"),
        request(methodRequest,fe_testRequest_6_C,edf::bl(button2_State_V)).

predicates
    onModifiedEC:editControl::modifiedListener.
clauses
    onModifiedEC(Src):-
        editControlText_V:=Src:getText(),
        stdio::write(Src:getText(),"\n").

facts
    timer_V:cancelableInterval:=erroneous.
predicates
    testActor:().
clauses
    testActor():-
        stdio::write("intervalComplete\n").

end implement fe_Tests
