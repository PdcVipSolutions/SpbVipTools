%
%

implement be_Tests inherits be_Connector
    open core, pfc\log
    open dataExchangeIdentifiers, edf, coreIdentifiers

clauses
    new(BackEnd) :-
        be_Connector::new(BackEnd).

/*Test requests*/
clauses
    fe_Request(Fe_TestRequest_ID, _FromFrontEnd,_TaskQueue):-
        Fe_TestRequest_ID<fe_TestRequest_3_C,
        blockFlag_V=true,
        !.
    fe_Request(fe_TestRequest_1_C, FromFrontEnd,TaskQueue):- % methodChain
        !,
        testCall_1(FromFrontEnd,TaskQueue).
    fe_Request(fe_TestRequest_2_C, FromFrontEnd,TaskQueue):-
        !,
        testCall_2(FromFrontEnd,TaskQueue).
    fe_Request(fe_TestRequest_3_C, FromFrontEnd,TaskQueue):-
        !,
        testCall_3(FromFrontEnd,TaskQueue).
    fe_Request(fe_TestRequest_4_C, FromFrontEnd,TaskQueue):-
        !,
        testCall_4(FromFrontEnd,TaskQueue).
    fe_Request(fe_TestRequest_5_C, FromFrontEnd,TaskQueue):-
        !,
        testCall_5(FromFrontEnd,TaskQueue).
    fe_Request(fe_TestRequest_6_C, FromFrontEnd,TaskQueue):-
        !,
        testCall_6(FromFrontEnd,TaskQueue).
    fe_Request(_CmdCode,_EDF,_TaskQueue).

/**** Test Calls*/
facts
    blockFlag_V:boolean:=false.
    sleepTime_V:integer:=0.
    blockEndDataFlag_V:boolean:=false.

clauses
    testCall_1(a(MessageList),TaskQueueObj):-
        if sleepTime_V>0 then
            programcontrol::sleep(sleepTime_V)
        end if,
        foreach s(String) in MessageList do
            response(be_TestResponse_1_C, s(String),TaskQueueObj)
        end foreach,
%        if sleepTime_V>0 then
%            programcontrol::sleep(sleepTime_V)
%        end if,
        response(be_TestResponse_1_C, s("Completion!"),TaskQueueObj),
        if blockEndDataFlag_V=false then
            response(be_EndOfChain_C, i(be_TestResponse_1_C),TaskQueueObj)
        end if,
        !,
        succeed().
    testCall_1(EdfMsg,TaskQueueObj):-
        response(be_Error_C, av("be_error",a([av("short",s("Wrong TestCall1")),av("detailed",s(string::format("No ValueList sent.See [%]",EdfMsg)))])),TaskQueueObj),
        response(be_EndOfChain_C, i(be_TestResponse_1_C),TaskQueueObj).

    testCall_2(MessageToBE,TaskQueueObj):-
        if sleepTime_V>0 then
            programcontrol::sleep(sleepTime_V)
        end if,
        if MessageToBE=s(MsgToBE) then
        else
            MsgToBE="==empty=="
        end if,
        response(be_TestResponse_2_C, edf::s(string::concat(MsgToBE,"\n","Best wishes from Backend To FroneEnd!")),TaskQueueObj).

    testCall_3(MessageToBE,TaskQueueObj):-
        try
            exception::raise_User("TestError")
        catch TraceID do
            tuple(ShortInfo,DetailedInfo)=exceptionHandlingSupport::new():getExceptionInfo(TraceID),
            log::write(log::error,ShortInfo),
            response(be_TestError3_C, av("be_error",a([av("short",MessageToBE),av("detailed",s(DetailedInfo))])),TaskQueueObj)
        end try,
        succeed().

    testCall_4(bl(TrueOrFalse),TaskQueueObj):-
        blockFlag_V:=TrueOrFalse,
        !,
        response(be_TestResponse_4_C, edf::s(string::format("BlockFlag set to [%]\n",TrueOrFalse)),TaskQueueObj).
    testCall_4(EdfMsg,TaskQueueObj):-
        response(be_Error_C, av("be_error",a([av("short",s("Wrong TestCall4")),av("detailed",s(string::format("No Boolean value sent [%]",EdfMsg)))])),TaskQueueObj).

    testCall_6(bl(TrueOrFalse),TaskQueueObj):-
        blockEndDataFlag_V:=TrueOrFalse,
        !,
        response(be_TestResponse_6_C, edf::s(string::format("BlockEndDataFlag set to [%]\n",TrueOrFalse)),TaskQueueObj).
    testCall_6(EdfMsg,TaskQueueObj):-
        response(be_Error_C, av("be_error",a([av("short",s("Wrong TestCall6")),av("detailed",s(string::format("No Boolean value sent [%]",EdfMsg)))])),TaskQueueObj).

    testCall_5(i(SleepTime),TaskQueueObj):-
        sleepTime_V:=SleepTime,
        !,
        response(be_TestResponse_5_C, edf::s(string::format("Sleep Time set to [%]\n",SleepTime)),TaskQueueObj).
    testCall_5(EdfMsg,TaskQueueObj):-
            response(be_Error_C, av("be_error",a([av("short",s("Wrong TestCall5")),av("detailed",s(string::format("No Integer value sent [%]",EdfMsg)))])),TaskQueueObj).

end implement be_Tests
