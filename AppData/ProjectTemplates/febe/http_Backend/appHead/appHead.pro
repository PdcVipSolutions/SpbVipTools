% Copyright (c) PDCSPB

implement appHead inherits jsonRpcServiceSupport
    open core, json, pfc\asynchronous\, pfc\log, string
    open coreIdentifiers, edf, http_Client, backEnd

facts
    backEnd_P:backEnd:=erroneous.
    be_CoreTasks_V:be_CoreTasks:=erroneous.

constants
    xmlFilename = @"$$(Project.Name)AppData\LogConfig.xml".

class predicates
    initLog:().
clauses
    initLog():-
        LogConfigName="Server",
        try
            logconfig::loadConfig(xmlFilename, LogConfigName),
            log::write(log::info, string::format("Start logging [%]",LogConfigName)),
            log::writef(log::debug, "Current directory: '%s'", directory::getCurrentDirectory())
        catch Err do
            exception::continue_User(Err, string::format("No LogConfig [%] Found",LogConfigName))
        end try.

clauses
    new() :-
        initLog(),
		pzlPort::init(),
        pzlPort::setComponentRegisterFileName("PzlRegistry.pzr"),
        EventManager = eventManager::new(),
        backEnd_P := backEnd::new(EventManager),
        setProc_name(methodDo_C, beDoIt),
        setProc_name(methodRequest_C, beRequest),
        setProc_name(methodChain_C, beInitChain),
        setProc_name(methodNext_C, beNext),
        Be_TasksObj=pzl::getObjectByName_nd(concat(toString(backEnd_P),be_CoreTasks_C)),
        be_CoreTasks_V:=tryConvert(be_CoreTasks,Be_TasksObj),
        !.
    new() :-
        exception::raise_User("Unexpected alternative").

predicates
    beDoIt : jsonProc_name.
clauses
    beDoIt(_Context, ArgMap)=json::o(Result):-
        invokePerformer(ArgMap)=tuple(Result,DataFormat,TransactionID,TaskQueue),
        tuple(ResponseEventID,ResponseParameters) = TaskQueue:dequeue(),
        if ResponseEventID=be_Error_C then
            setResult(Result,DataFormat,toString(ResponseEventID),ResponseParameters,TransactionID)
        end if,
        be_CoreTasks_V:getTaskQueues():tsRemoveKey(TransactionID),
        succeed().

predicates
    beRequest : jsonProc_name.
clauses
    beRequest(_Context, ArgMap) = json::o(Result) :-
        invokePerformer(ArgMap)=tuple(Result,DataFormat,TransactionID,TaskQueue),
        tuple(ResponseEventID,ResponseParameters) = TaskQueue:dequeue(),
        setResult(Result,DataFormat,toString(ResponseEventID),ResponseParameters,TransactionID),
        be_CoreTasks_V:getTaskQueues():tsRemoveKey(TransactionID).

predicates
    beInitChain : jsonProc_name.
clauses
    beInitChain(_Context, ArgMap)=json::o(Result):-
        invokePerformer(ArgMap)=tuple(Result,_DataFormat,_TransactionID,_TaskQueue),
        succeed().

predicates
    beNext : jsonProc_name.
clauses
    beNext(_Context, ArgMap) = json::o(Result) :-
        tuple(_EventID,TransactionID,DataFormat,Result)=getRequestAttributes(ArgMap),
        if
            try TaskQueue=be_CoreTasks_V:getTaskQueues():tsGet(TransactionID) catch _ do fail end try,
            tuple(EventIDnext,ResponseParameters) = TaskQueue:tryDequeue()
        then
            setResult(Result,DataFormat,toString(EventIDnext),ResponseParameters,TransactionID),
            if EventIDnext=be_EndOfChain_C then
                be_CoreTasks_V:getTaskQueues():tsRemoveKey(TransactionID)
            end if
        else
            setResult(Result,DataFormat,toString(be_WillFollow_C),edf::n,TransactionID)
        end if.

predicates
    getRequestAttributes:(jsonObject ArgMap)->tuple{integer EventID,integer TransactionID,string DataFormat,jsonObject JObject}.
clauses
    getRequestAttributes(ArgMap)=tuple(EventID,TransactionID,DataFormat,Result):-
        EventID = ArgMap:get_integer("eventID"),
        TransactionID = ArgMap:get_integer(transactionID_C),
        if DataFormat = ArgMap:tryGet_string(dataFormatID_C) then
        else
            DataFormat="edf"
        end if,
        Result = jsonObject::new().

predicates
    invokePerformer:(jsonObject ArgMap)->
        tuple{jsonObject Result,string DataFormat,integer TransactionID,monitorQueue{tuple{integer,edf::edf_D}}}.
clauses
    invokePerformer(ArgMap)=tuple(Result,DataFormat,TransactionID,TaskQueue):-
        tuple(EventID,TransactionID,DataFormat,Result)=getRequestAttributes(ArgMap),
        if DataFormat="edf" then
            EventParams = toTerm(edf::edf_D, ArgMap:get_string("evParams"))
        else
            JsonValue=ArgMap:map:get("evParams"),
            EventParams=edf::fromJson(JsonValue)
        end if,
        TaskQueue = monitorQueue{tuple{integer,edf::edf_D}}::new(),
        be_CoreTasks_V:getTaskQueues():tsSet(TransactionID, TaskQueue),
        _Thread=thread::start(
            {:-
                backEnd_P:eventManager_P:eventTaskCall_P:notify(EventID, EventParams,TaskQueue),
                be_CoreTasks_V:answerToClient(be_EndOfData_C, edf::i(EventID),TaskQueue)
            }
            ).

predicates
    setResult:(jsonObject ResultObj,string DataFormat,string EventIDstr, edf::edf_D ResponseData,integer TransactionID).
clauses
    setResult(ResultObj,DataFormat,EventIDstr,ResponseData,TransactionID):-
        if DataFormat="edf" then
            ResultObj:set_String(EventIDstr,toString(ResponseData))
        else
            edf::setValue(ResultObj,EventIDstr,ResponseData)
        end if,
        ResultObj:set_Integer(transactionID_C,TransactionID),
        ResultObj:set_String(dataFormatID_C,DataFormat).

end implement appHead