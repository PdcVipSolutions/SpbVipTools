%

implement backEnd
    open core, pfc\log, string
    open coreIdentifiers, edf

facts
    eventManager_P:eventManager:=erroneous.

clauses
    new(EventManager):-
        initComponents(EventManager).

predicates
    initComponents:(eventManager EventManager).
clauses
    initComponents(EventManager):-
        eventManager_P:=EventManager,
        pzl::register(concat(toString(This),be_CoreTasks_C),be_CoreTasks::new(This)),
        pzl::register(concat(toString(This),be_Tasks_C),be_Tasks::new(This)),
        pzl::register(concat(toString(This),be_Tests_C),be_Tests::new(This)),

        pzl::register(concat(toString(This),fe_Requests_C),fe_Requests::new(This)),
        BeOptions=be_Options::new(This),
        pzl::register(concat(toString(This),be_Options_C),BeOptions),
        DictionaryObj=be_Dictionary::new(This),
        pzl::register(concat(toString(This),be_Dictionary_C),DictionaryObj),
        BaseDict=defaultDictionary::new(),
        try
            OptionsList=BeOptions:getFrontEndOptions(a([s(refreshDictionary_C)])),
            if OptionsList=a([av("refresh-dictionary", s("yes"))]) then
                DictionaryObj:create_CoreDictionary(BaseDict:nameSpace_P,BaseDict:fileName_P,BaseDict:getItemList())
            end if,
            if DictionaryObj:tryAdd_DictionaryNameSpace(BaseDict:nameSpace_P,BaseDict:fileName_P) then
            else
                DictionaryObj:create_CoreDictionary(BaseDict:nameSpace_P,BaseDict:fileName_P,BaseDict:getItemList())
            end if
        catch TraceID do
            DescriptorList=[Descriptor||Descriptor=exception::getDescriptor_nd(TraceID)],
            ErrorMsg=string::format("Core Dictionary [%] can not be set. See details [%]",BaseDict:nameSpace_P,DescriptorList),
            log::write(log::error,ErrorMsg)
        end try,
        EventManager:appEvent_P:addListener(closeApplication),
        succeed().

predicates
    closeApplication:event1{integer EventID}::listener.
clauses
    closeApplication(_EventID):-
        eventManager_P:appEvent_P:removeListener(closeApplication),
        pzl::unRegisterAllByNamePrefix(toString(This)),
        eventManager_P:=erroneous.

clauses
    saveOptions():-
        if BeOptionsObj=pzl::getObjectByName_nd(concat(toString(This),be_Options_C)),! then
            Be_Options=convert(be_Options,(BeOptionsObj)),
            Be_Options:saveOptions()
        end if.

end implement backEnd